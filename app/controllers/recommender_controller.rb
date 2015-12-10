require 'top.rb'

class RecommenderController < ApplicationController
	def show
	end

	def rank
		preferences = { 3 => params[:architecture_pref].to_f/100.0,
										2 => params[:museums_pref].to_f/100.0, 
										4 => params[:art_pref].to_f/100.0,
										5 => params[:leisure_pref].to_f/100.0 ,
										8 => params[:shopping_pref].to_f/100.0 }
		trip_budget = params[:trip_budget].to_f
		walking_speed = params[:walking_speed].to_f
		number_of_routes = params[:number_of_routes].to_i
		start_position_lat = params[:start_position_lat].to_f
		start_position_lng = params[:start_position_lng].to_f
		finish_position_lat = params[:finish_position_lat].to_f
		finish_position_lng = params[:finish_position_lng].to_f
		
		pois = Poi.joins(:categories).where("categories.id IN (2, 3, 4, 5, 8)")
		@poi_scores = Hash.new

		pois.each do |poi|
			total_score = 0
			poi.poi_category_relevances.each do |pcr|
				# next if pcr.category_id == 8
				total_score += pcr.normalized_relevance * preferences[pcr.category_id]
			end
			@poi_scores[poi] = total_score
		end
		
		@poi_scores = @poi_scores.sort_by{|k,v| v}.reverse.to_h
		top_pois = Array.new
		@poi_scores.take(70).each do |poi, score|
			next if poi.latitude_decimal.nil? || poi.longitude_decimal.nil?
			top_pois << PoiTop.new(poi.id, poi.latitude_decimal, poi.longitude_decimal, score, 45)
		end

		top_start_poi = PoiTop.new(0, start_position_lat, start_position_lng, 0, 0)
		top_finish_poi = PoiTop.new(0, finish_position_lat, finish_position_lng, 0, 0)
		top_pois << top_start_poi
		top_pois << top_finish_poi

		@start_position = [start_position_lat, start_position_lng]
		@finish_position = [finish_position_lat, finish_position_lng]
		top_solver = TopSolver.new(number_of_routes, trip_budget, walking_speed, top_pois, top_start_poi, top_finish_poi)
		@routes = Array.new

		top_solver.run(10,10).each do |route|
			fetched_pois = Array.new
			route.each do |p_id| 
				tmp_p = Poi.where(:id => p_id).first 
				fetched_pois << tmp_p unless tmp_p.nil?
			end
			@routes << fetched_pois
		end


	end
end
