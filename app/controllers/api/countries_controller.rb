class Api::CountriesController < ApiController
	expose(:country)
	expose(:countries)

	def index
		render json: countries.limit(100)
	end

	def show
		render json: country
	end
end
