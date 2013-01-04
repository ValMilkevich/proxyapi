class Api::CountriesController < ApiController
	expose(:country)
	expose(:countries)

	def index
		render json: countries
	end

	def show
		render json: country
	end
end
