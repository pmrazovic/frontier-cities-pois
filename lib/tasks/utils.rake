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

end
