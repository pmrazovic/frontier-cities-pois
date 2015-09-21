require 'alchemyapi'

namespace :alchemyapi do
  desc "Calling AlchemyAPI..."
  task load_resources: :environment do
  	Keyword.delete_all
  	PoiKeyword.delete_all
  	Concept.delete_all
  	PoiConcept.delete_all
  	Entity.delete_all
  	PoiEntity.delete_all

  	pois = Poi.joins(:categories).where("categories.name in ('Museums','Architecture', 'Art', 'Leisure', 'Shopping')").first
  	alchemyapi = AlchemyAPI.new()

  	pois.each do |poi|
  		response = alchemyapi.combined('text', poi.description, { 'extract'=>'keyword,entity,concept' })
  			# Keywords
				if response.key?('keywords')
					for keyword in response['keywords']
						new_keyword = Keyword.find_or_create_by(:text => keyword['text'])
						new_poi_keyword = PoiKeyword.create(:keyword => new_keyword, :poi => poi, :relevance => keyword['relevance'])
					end
				end

				# Entities
				if response.key?('entities')
					for entity in response['entities']
						new_entity = Entity.find_or_create_by(:name => entity['text'], :entity_type => entity['type'])
						new_poi_entity = PoiEntity.create(:entity => new_entity, :poi => poi, :relevance => entity['relevance'])
					end
				end

				# Concepts
				if response.key?('concepts')
					for concept in response['concepts']
						new_concept = Concept.find_or_create_by(:name => concept['text'], :dbpedia_link => concept['dbpedia'])
						new_poi_concept = PoiConcept.create(:concept => new_concept, :poi => poi, :relevance => concept['relevance'])
					end
				end				

  	end

  end

end
