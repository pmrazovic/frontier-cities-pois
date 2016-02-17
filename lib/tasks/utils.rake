namespace :utils do
  desc "TODO"
  task convert_coords: :environment do
  	Poi.all.each do |poi|
 			if !poi.latitude.nil? && !poi.longitude.nil?
	  		lat = poi.latitude.delete("°").delete("'").delete('"').delete("N").split(" ")
	  		latitude_degrees = lat[0].to_f
	  		latitude_minutes = lat[1].to_f
	  		latitude_seconds = lat[2].to_f

	  		lng = poi.longitude.delete("°").delete("'").delete('"').delete("E").split(" ")
	  		longitude_degrees = lng[0].to_f
	  		longitude_minutes = lng[1].to_f
	  		longitude_seconds = lng[2].to_f

	  		poi.latitude_decimal = latitude_degrees + latitude_minutes/60.0 + latitude_seconds/3600.0
	  		poi.longitude_decimal = longitude_degrees + longitude_minutes/60.0 + longitude_seconds/3600.0
	  		poi.save!
	  	end
  	end
  end

  # Removing unwanted POIs and exporting relevance scores in CSV
  task remove_unwanted_pois: :environment do
  	barcelona_top = [41.444436,2.105443]
  	barcelona_bottom = [41.341800,2.255990]
  	print_pois = Array.new
  	pois = Poi.joins(:categories).where("categories.id IN (2, 3, 4, 5, 8)")
  	pois.each do |poi|
  		next if poi.longitude_decimal.nil? || poi.latitude_decimal.nil?
  		if (poi.latitude_decimal <= barcelona_top[0]) && (poi.latitude_decimal >= barcelona_bottom[0]) &&
  			 (poi.longitude_decimal >= barcelona_top[1]) && (poi.longitude_decimal <= barcelona_bottom[1]) &&
  			 (!poi.subcategories.collect{|s| s.id}.include?(161)) && (!poi.subcategories.collect{|s| s.id}.include?(170)) &&
  			 poi.festival_date.nil?

  			 print_pois << poi

  		end
  	end

  	File.open("poi_cat_rel.csv", "w") do |file|  
  		file.puts "poi_id,category_id,score"
  		print_pois.each do |poi|
  			poi.poi_category_relevances.each do |rel|
  				file.puts "#{poi.id},#{rel.category_id},#{rel.normalized_relevance}"
  			end
  		end
  	end


  end

  task create_problem_instance_file: :environment do 

    def to_radians(degrees)
      degrees * (Math::PI / 180)
    end

    def distance_in_meters(lat_1, lon_1, lat_2, lon_2, walking_speed)
      dlon = to_radians(lon_2) - to_radians(lon_1)
      dlat = to_radians(lat_2) - to_radians(lat_1)
      a = (Math.sin(dlat/2))**2 + Math.cos(to_radians(lat_1)) * Math.cos(to_radians(lat_2)) * (Math.sin(dlon/2))**2
      c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a) )
      d = (6373 * c * 1000)/walking_speed
    end

    PoiPrintObj = Struct.new(:id, :title, :latitude_decimal, :longitude_decimal, :score, :cost)

    nodes_sizes = [8, 18, 28, 38, 48, 58, 68, 78, 88, 98]
    lengths = [180, 240, 300, 360, 420, 480, 540, 600]
    instances = [1,2,3,4,5,6,7,8,9,10]

    cnt = 1;
    nodes_sizes.each do |pois_count|
      lengths.each do |trip_budget|
        instances.each do |instance|
          cnt += 1;
          print "\r#{cnt}/800"

          preferences = { 3 => rand * 0.2 + 0.6, # Architecure
                          2 => rand * 0.2 + 0.6, # Museums 
                          4 => rand * 0.7, # Art
                          5 => rand * 0.3, # Leisure
                          8 => rand * 0.0 } # Shopping
          walking_speed = 65 # m/min
          start_position_lat = 41.374834
          start_position_lng = 2.170055
          finish_position_lat = 41.374834
          finish_position_lng = 2.170055

          max_count_edge = 3
          
          pois = Poi.joins(:categories).where("categories.id IN (2, 3, 4, 5, 8)")
          poi_scores = Hash.new

          pois.each do |poi|
            total_score = 0
            poi.poi_category_relevances.each do |pcr|
              total_score += pcr.normalized_relevance * preferences[pcr.category_id]
            end
            poi_scores[poi] = total_score
          end
          
          max_value = poi_scores.values.max
          pois.each do |poi|
            poi_scores[poi] = ((poi_scores[poi]/max_value)*100.0).round(2)
          end

          pois_to_print = Array.new
          pois_to_print << PoiPrintObj.new(0,"START",start_position_lat,start_position_lng,0.0,0.0)
          poi_scores = poi_scores.sort_by{|k,v| v}.reverse.to_h
          poi_scores = poi_scores.select{|k,v| !k.latitude_decimal.nil? && !k.longitude_decimal.nil? && 
                          k.latitude_decimal < 41.444436 && k.longitude_decimal > 2.105443 &&
                          k.latitude_decimal > 41.341800 && k.longitude_decimal < 2.255990 &&
                          !k.subcategories.collect{|s| s.id}.include?(161) && !k.subcategories.collect{|s| s.id}.include?(170)}
                                                  
          poi_scores = poi_scores.take(pois_count)
          poi_scores.each_with_index do |(poi, score), idx|
            pois_to_print << PoiPrintObj.new(idx+1,poi.title,poi.latitude_decimal,poi.longitude_decimal,score,45.0)
          end
          pois_to_print << PoiPrintObj.new(pois_to_print.length,"FINISH",start_position_lat,start_position_lng,0.0,0.0)



          File.open("/Users/pero/Desktop/MOP_Barcelona_Dataset_V2/#{pois_count+2}_#{trip_budget}_#{instance}.txt", "w") do |file|  
            file.puts "VERTEX_COUNT #{poi_scores.length+2}"
            file.puts "PATH_COUNT 1"
            file.puts "BUDGET #{trip_budget}"
          
            # List of vertices
            file.puts "<------------ VERTICES ------------>"
            pois_to_print.each do |poi|
              title = poi.title
              title.gsub!("",'')
              title.gsub!("  ",'')

              file.puts("#{poi.id};#{title};#{poi.latitude_decimal.round(6)};#{poi.longitude_decimal.round(6)};#{poi.cost};#{poi.score}")
            end

            # List of edges
            file.puts "<------------- EDGES -------------->"
            edge_cnt = 0;
            pois_to_print.each_with_index do |poi1, idx1|
              pois_to_print.each_with_index do |poi2, idx2|
                if idx2 > idx1
                  dist = distance_in_meters(poi1.latitude_decimal, poi1.longitude_decimal, poi2.latitude_decimal, poi2.longitude_decimal, walking_speed)
                  file.puts("#{edge_cnt};#{poi1.id};#{poi2.id};#{dist.round(3)};#{(rand()*25).round(2)}")
                  edge_cnt += 1;

                  # creating random edges between i and j
                  extra_edges = rand(max_count_edge)
                  extra_edges.times do
                    random_score = (rand()*25).round(2)
                    random_cost = rand * (dist*1.25-dist*0.75) + dist*0.75
                    file.puts "#{edge_cnt};#{poi1.id};#{poi2.id};#{random_cost.round(3)};#{random_score.to_f}"
                    edge_cnt += 1
                  end



                end
              end
            end
          end


        end
      end
    end



  end

end
