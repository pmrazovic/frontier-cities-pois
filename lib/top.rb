# Class implements points of interest

class PoiTop
	# Unique identifier
	attr_accessor :id
	# Coordinates (latitude and longitude)
	attr_accessor :x_coordinate, :y_coordinate
	# Score, i.e. relevance to user's interests
	attr_accessor :score
	# Time (budget) need for visit
	attr_accessor :consuming_budget
	# Assigned route
	attr_accessor :route
	# Distance from start and finish position
	attr_accessor :distance

	def initialize(id, x_coordinate, y_coordinate, score, consuming_budget)
		@id = id
		@x_coordinate = x_coordinate
		@y_coordinate = y_coordinate
		@score = score
		@consuming_budget = consuming_budget
	end

	public

		# Method computes distance from another POI
		def distance_from(x_coordinate, y_coordinate, walking_speed)
			return distance_in_meters(@x_coordinate, @y_coordinate, x_coordinate, y_coordinate)/walking_speed
		end

	private

    def to_radians(degrees)
      degrees * (Math::PI / 180)
    end

	  def distance_in_meters(lat_1, lon_1, lat_2, lon_2)
	    dlon = to_radians(lon_2) - to_radians(lon_1)
	    dlat = to_radians(lat_2) - to_radians(lat_1)
	    a = (Math.sin(dlat/2))**2 + Math.cos(to_radians(lat_1)) * Math.cos(to_radians(lat_2)) * (Math.sin(dlon/2))**2
	    c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a) )
	    d = 6373 * c * 1000
	  end

		# Method computes Euclidian distance between two points
		def euclidian_distance(x1, y1, x2, y2)
			return Math.sqrt((x2-x1)**2 + (y2-y1)**2)
		end

end

# Class implements recommended tourist route, i.e. tourist itinerary

class Route
	# Unique identifier
	attr_accessor :id
	# Total score
	attr_accessor :score
	# Total consumed budget, i.e. consumed time
	attr_accessor :consumed_budget
	# List of included POIs
	attr_accessor :pois
	# Class needs distance hash to perform budget computation
	attr_accessor :distance_hash

	def initialize(id, start_poi, finish_poi, distance_hash)
		@id = id
		@pois = [start_poi, finish_poi]
		@distance_hash = distance_hash
		compute_total_score
		@consumed_budget = compute_total_consumed_budget(@pois)
	end

	public

		# Methods inserts new POI in the route at the specified position
		# The cost attribute is used if it is known, otherwise get_insertion_cost is called
		def insert_poi(insert_poi, position, cost = nil)
			 	cost = get_insertion_cost(@pois, insert_poi, position) if cost.nil?
				@pois.insert(position, insert_poi)
				@consumed_budget += cost
				@score += insert_poi.score
				insert_poi.route = self
		end

		# Methods removes POI from the route
		# The cost attribute is used if it is known, otherwise get_insertion_cost is called
		def remove_poi(remove_poi, gain = nil)
			 	gain = get_deletion_gain(remove_poi) if gain.nil?
				@pois.delete(remove_poi)
				@consumed_budget -= gain
				@score -= remove_poi.score
				remove_poi.route = nil
		end

		# Method finds cheapest position for inserting new POI,
		# and returns insert position and cost
		def find_cheapest_insertion(insert_poi, pois = @pois)
			insert_cost = nil
			insert_position = nil
			
			pois.each_with_index do |route_poi, position|
				next if position == 0 # It's not allowed to replace start POI
				new_cost = get_insertion_cost(pois, insert_poi, position)
				if insert_cost.nil? || new_cost < insert_cost
					insert_cost = new_cost
					insert_position = position
				end
			end

			return [insert_cost, insert_position]
		end

		def find_cheapest_replace(remove_poi, insert_poi)
			remove_gain = get_deletion_gain(remove_poi)
			remove_position = @pois.index(remove_poi)
			insert_cost, insert_position = find_cheapest_insertion(insert_poi, @pois[0..remove_position-1] + @pois[remove_position+1..-1])
			return [remove_gain, insert_cost, insert_position]
		end

		# Method computes extra budget gain by removing POI from the route
		def get_deletion_gain(remove_poi)
			position = @pois.index(remove_poi)
			gain = @distance_hash[@pois[position-1]][remove_poi] +
						 @distance_hash[remove_poi][@pois[position+1]] +
						 remove_poi.consuming_budget -
						 @distance_hash[@pois[position-1]][@pois[position+1]]
		end

		# A 2-opt heuristic for traveling salesman problem
		# https://en.wikipedia.org/wiki/2-opt
		def tsp
			@consumed_budget = compute_total_consumed_budget(@pois)
			temp_route = Array.new
			@pois.each{ |p| temp_route << p }
			edge_swapped = true
			while edge_swapped
				edge_swapped = false
				for i in 1..temp_route.length-2
					for k in i+1..temp_route.length-2
						old_distance = distance_hash[temp_route[i-1]][temp_route[i]] +
													 distance_hash[temp_route[k]][temp_route[k+1]]
						new_distance = distance_hash[temp_route[i-1]][temp_route[k]] +
													 distance_hash[temp_route[i]][temp_route[k+1]]

						if (new_distance < old_distance)
							two_opt(temp_route, i, k)
							edge_swapped = true
						end
					end
				end
			end

			temp_route_length = compute_total_consumed_budget(temp_route)
			if temp_route_length < @consumed_budget
				@pois = Array.new
				temp_route.each{ |p| @pois << p }
			end 

		end

		# Method computes weighted center of gravity
		def compute_route_cog
			x_cog = 0.0
			y_cog = 0.0

			@pois.each do |poi|
				x_cog += poi.score*poi.x_coordinate
				y_cog += poi.score*poi.y_coordinate
			end
			if @score == 0.0
				return [0, 0]
			else
				return [x_cog/@score, y_cog/@score]
			end
		end

		# Method removes a percentage of POIs from beginning or end of route
		def disturb(percentage, delete_from_end = true)
			if delete_from_end
				remove_position = ((@pois.length-2)*percentage).to_i
				removed_pois = @pois[-remove_position-1..-2]
				@pois -= removed_pois
			else
				remove_position = ((@pois.length-2)*percentage).to_i
				removed_pois = @pois[1..remove_position]
				@pois -= removed_pois
			end
			@score = 0.0
			compute_total_score
			@consumed_budget = compute_total_consumed_budget(@pois)
			return removed_pois
		end

	private

		# Method computes total consumed budget using distance hashmap
		def compute_total_consumed_budget(pois)
			consumed_budget = 0.0
			pois.each_with_index do |route_poi, position|
				if pois[position+1].nil?
					consumed_budget += route_poi.consuming_budget
					break
				end
				consumed_budget += @distance_hash[route_poi][pois[position+1]] + route_poi.consuming_budget
			end
			return consumed_budget
		end

		# Method computes route's total score
		def compute_total_score
			@score = 0.0
			@pois.each do |poi|
				@score += poi.score
			end
		end

		# Compute insertion cost at the given position
		def get_insertion_cost(pois, insert_poi, position)
			new_cost = @distance_hash[pois[position-1]][insert_poi] + 
			 				   @distance_hash[insert_poi][pois[position]] -
			 					 @distance_hash[pois[position-1]][pois[position]] +
			 					 insert_poi.consuming_budget
			return new_cost
		end

		# 2-opt operation
		# https://en.wikipedia.org/wiki/2-opt
		def two_opt(pois, i, k)
			l = k
			limit = i + ((k-i)/2)
			for j in i..limit
				temp = pois[j]
				pois[j] = pois[l]
				pois[l] = temp
				l -= 1
			end
		end

end

# The class implements TOP local search algorithm

class TopSolver
	def initialize(route_count, budget, walking_speed, pois, start_poi, finish_poi)
		@route_count = route_count
		@available_budget = budget
		@walking_speed = walking_speed
		@pois = pois
		@start_poi = start_poi
		@finish_poi = finish_poi
		@distance_hash = compute_distance_hash(@pois)
		@routes = Array.new
		@assigned_pois = Array.new
		@available_pois = Array.new
	end

	public

		# Method implements main algorithm loop
		def run(max_alg_loop, max_ls_loop)
			construct
			alg_loop = 0
			solution_best = 0.0
			solution_best_routes = Array.new
			disturb_performed = 0
			
			while alg_loop < max_alg_loop
				alg_loop += 1
				ls_loop = 0
				solution_score = 0.0
				solution_routes = Array.new
				solution_improved = true
				while solution_improved && ls_loop < max_ls_loop
					ls_loop += 1
					solution_improved = false
					
					swap
					tsp
					swap
					move
					insert
					replace

					total_score = compute_total_score
					if total_score > solution_score
						solution_score = total_score
						solution_routes = Array.new
						@routes.each do |r|
							r = r.pois.collect{|p| p.id}
							solution_routes << r
						end
						solution_improved = true
					end
				end

				if solution_score > solution_best
					solution_best_routes = Array.new
					@routes.each do |r|
						r = r.pois.collect{|p| p.id}
						solution_best_routes << r
					end
					solution_best = solution_score
				elsif solution_score == solution_best
					if disturb_performed == 0
						disturb(0.7)
						disturb_performed += 1
					elsif disturb_performed == 1
						disturb(0.7, false)
						disturb_performed += 1
					else
						return solution_best_routes
					end
				end
				
				if alg_loop == max_alg_loop / 2
					disturb(0.7)
					disturb_performed = true
				end

			end

			return solution_best_routes
		end

	private

		# Greedy construction heuristic creates initial solution
		def construct
			# Compute distances to start and finish POI and filter reachable POIs
			reachable_pois = Array.new
			@pois.each do |poi|
				next if poi == @start_poi || poi == @finish_poi
				poi.distance = @distance_hash[@start_poi][poi] + @distance_hash[@finish_poi][poi]
				if poi.distance <= @available_budget
					@available_pois << poi
					reachable_pois << poi
				end
			end

			# Sort available POIs by distances to start and end POI, and take first @route_count POIs to intialize routes
			route_init_pois = @available_pois.sort_by(&:distance).reverse.take(@route_count)
			route_init_pois.each_with_index do |init_poi, idx|
				new_route = Route.new(idx, @start_poi, @finish_poi, @distance_hash)
				new_route.insert_poi(init_poi, 1) # Add init POI between start and finish POIs, i.e. at the position 1
				@available_pois.delete(init_poi)
				@routes << new_route
			end

			# For each of available POIs find cheapest insertion position among all newly created routes
			@available_pois.each do |insert_poi|
				cheapest_cost = nil
				cheapest_route = nil
				insert_position = nil

				@routes.each do |route|
					route_insert_cost, route_insert_position = route.find_cheapest_insertion(insert_poi)
					if route.consumed_budget + route_insert_cost <= @available_budget
						if cheapest_cost.nil? || route_insert_cost < cheapest_cost
							cheapest_cost = route_insert_cost
							cheapest_route = route
							insert_position = route_insert_position
						end
					end
				end

				# If cheapest cost found is in the budget
				unless cheapest_route.nil?
					cheapest_route.insert_poi(insert_poi, insert_position, cheapest_cost)
					@available_pois.delete(insert_poi)
				end
			end

			# Construct new routes from the remaining available POIs until all points are assigned to routes
			while @available_pois.length > 0
				# Initialize new route with most distant available POI
				init_poi = @available_pois.sort_by(&:distance).reverse.first
				new_route = Route.new(@routes.length, @start_poi, @finish_poi, @distance_hash)
				new_route.insert_poi(init_poi, 1) # Add init POI between start and finish POIs, i.e. at the position 1
				@available_pois.delete(init_poi)
				@routes << new_route

				# Go through all the available POIs and find the cheapest place for insertion
				@available_pois.each do |insert_poi|
					insert_cost, insert_position = new_route.find_cheapest_insertion(insert_poi)
					if new_route.consumed_budget + insert_cost <= @available_budget
						new_route.insert_poi(insert_poi, insert_position, insert_cost)
						@available_pois.delete(insert_poi)					
					end
				end
			end

			# Take the best route_count routes
			@routes = @routes.sort_by(&:score).reverse.take(@route_count)
			# Assigned pois are all the pois from chosen routes without start and finish poi
			@assigned_pois = @routes.collect{|r| r.pois }.flatten.uniq - [@start_poi, @finish_poi]
			# Available pois are reachable pois which are not assigned in any route
			@available_pois = reachable_pois - @assigned_pois
			@available_pois.each{|ap| ap.route = nil}
		end

		# Method swaps a location between two tours
		# This heuristic endeavours to exchange two locations between two tours
		def swap
			no_swap = true
			begin
				no_swap = true
				@assigned_pois.each do |poi_i|
					@assigned_pois.each do |poi_j|
						route_i = poi_i.route
						route_j = poi_j.route
						next if route_i == route_j

						gain_i, cost_i, insert_position_i = route_i.find_cheapest_replace(poi_i, poi_j)
						gain_j, cost_j, insert_position_j = route_j.find_cheapest_replace(poi_j, poi_i)

						if (route_i.consumed_budget - gain_i + cost_i <= @available_budget) &&
							 (route_j.consumed_budget - gain_j + cost_j <= @available_budget)
							# If the travel time can be reduced in each tour, or if the time saved in one tour 
							# is longer than the extra time needed in the other tour, the swap is carried out
							if (gain_i > cost_i && gain_j > cost_j) || (gain_i - cost_i > cost_j - gain_j) || (gain_j - cost_j > cost_i - gain_i)
								 route_i.remove_poi(poi_i, gain_i)
								 route_j.remove_poi(poi_j, gain_j)
								 route_i.insert_poi(poi_j, insert_position_i, cost_i)
								 route_j.insert_poi(poi_i, insert_position_j, cost_j)
								 no_swap = false
							end					
						end

					end
				end
			end until no_swap 
		end

		# A 2-opt heuristic for traveling salesman problem
		# https://en.wikipedia.org/wiki/2-opt
		def tsp
			@routes.each do |route|
				route.tsp
			end
		end

		# Move a location from one tour to another
		# Methods tries to group together the available time left.
		def move
			shortened_routes = Array.new
			no_move_made = true
			
			begin
				no_move_made = true
				@assigned_pois.each do |moving_poi|
					@routes.each do |new_route|
						old_route = moving_poi.route
						next if new_route == old_route || shortened_routes.include?(new_route)
						insert_cost, insert_position = new_route.find_cheapest_insertion(moving_poi)
						if new_route.consumed_budget + insert_cost <= @available_budget
							old_route.remove_poi(moving_poi)
							new_route.insert_poi(moving_poi, insert_position, insert_cost)
							shortened_routes << old_route unless shortened_routes.include?(old_route)
							no_move_made = false
							break
						end
					end
					break if no_move_made == false
				end
			end until no_move_made
		end

		# Method attempts to insert new locations in the tours in
		# the position where the location consumes the least travel time.
		def insert
			@routes.each do |route|
				no_insertion = true
				begin
					no_insertion = true
					sort_by_appropriateness(route).each do |insert_poi|
						insert_cost, insert_position = route.find_cheapest_insertion(insert_poi)
						if route.consumed_budget + insert_cost <= @available_budget
							route.insert_poi(insert_poi, insert_position, insert_cost)
							@available_pois.delete(insert_poi)
							@assigned_pois << insert_poi
							no_insertion = false
							break
						end
					end
				end until no_insertion
			end
		end

		# Method seeks to replace an included location by a non-included location with a higher score.
		def replace
			@routes.each do |route|
				no_replacement = true
				begin # Repeat until replacement can't be made for this route
					no_replacement = true
					sort_by_appropriateness(route).each do |insert_poi|
						
						# First check if there is enough budget to insert POI
						insert_cost, insert_position = route.find_cheapest_insertion(insert_poi)
						if route.consumed_budget + insert_cost <= @available_budget
							route.insert_poi(insert_poi, insert_position, insert_cost)
							@available_pois.delete(insert_poi)
							@assigned_pois << insert_poi
							no_replacement = false
							break
						end

						# If no avialable budget, try to find it by removing pois with lower scores
						route.pois[1..-2].sort_by(&:score).each do |remove_poi|
							break if remove_poi.score >= insert_poi.score
							remove_gain, insert_cost, insert_position = route.find_cheapest_replace(remove_poi, insert_poi)
							if route.consumed_budget - remove_gain + insert_cost <= @available_budget
								route.remove_poi(remove_poi, remove_gain)
								@available_pois << remove_poi
								@assigned_pois.delete(remove_poi)
								route.insert_poi(insert_poi, insert_position, insert_cost)
								@available_pois.delete(insert_poi)
								@assigned_pois << insert_poi
								no_replacement = false
								break
							end
						end

						break if no_replacement == false
						
					end
				end until no_replacement
			end
		end

		# Method removes a percentage of POIs from beginning or end of each routes
		def disturb(percentage, delete_from_end = true)
			@routes.each do |route|
				route.disturb(percentage, delete_from_end).each do |removed_poi|
					removed_poi.route = nil
					@available_pois << removed_poi
					@assigned_pois.delete(removed_poi)
				end
			end
		end

		# Method computes total score of the solution
		def compute_total_score
			total_score = 0.0
			@routes.each{|route| total_score += route.score }
			return total_score
		end

		def sort_by_appropriateness(route)
			cog = route.compute_route_cog
			appr_hash = Hash.new
			@available_pois.each do |poi|
				appr_hash[poi] = (poi.score / (poi.distance_from(cog[0], cog[1], @walking_speed) + poi.consuming_budget))**4
			end
			appr_hash.keys.sort{|poi_a,poi_b| appr_hash[poi_b] <=> appr_hash[poi_a]}
		end

		# Method compute distances between POIs and store them in nested hash map
		# (Lookup is significantly faster in hash than 2-dim matrix)
		def compute_distance_hash(pois)
			distance_hash = Hash.new
			pois.each do |poi_i|
				distance_hash[poi_i] = Hash.new
				pois.each do |poi_j|
					distance_hash[poi_i][poi_j] = poi_i.distance_from(poi_j.x_coordinate, poi_j.y_coordinate, @walking_speed)
				end
			end
			return distance_hash		
		end

end