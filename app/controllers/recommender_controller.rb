class RecommenderController < ApplicationController
	def show
	end

	def rank
		preferences = { 3 => params[:architecture_pref].to_f/100.0,
										2 => params[:museums_pref].to_f/100.0, 
										4 => params[:art_pref].to_f/100.0,
										5 => params[:leisure_pref].to_f/100.0,
										8 => params[:shopping_pref].to_f/100.0 }
		
		pois = Poi.joins(:categories).where("categories.id IN (2, 3, 4, 5, 8)")
		@poi_scores = Hash.new

		pois.each do |poi|
			total_score = 0
			poi.poi_category_relevances.each do |pcr|
				total_score += pcr.normalized_relevance * preferences[pcr.category_id]
			end
			# if poi.top_20
			# 	@poi_scores[poi] = total_score*1.5	
			# else
				@poi_scores[poi] = total_score
			# end
		end
		
		@poi_scores = @poi_scores.sort_by{|k,v| v}.reverse.to_h
	end
end
