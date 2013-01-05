Prxapi::Application.config.secret_token = '1bff5d599518032a1127c9faasfawljkrbwe7qw80d8dfeb502e22d423834dac7420647b0444068e21d7fd65ed2c4d8b6df3862d0a4839e4b4f2095d0dc84c'
Prxapi::Application.config.session_store = :cookie_store

Prxapi::Application.config.middleware.use ActionDispatch::Session::CookieStore
Prxapi::Application.config.middleware.use ActionDispatch::Cookies
Prxapi::Application.config.middleware.use ActionDispatch::Flash
Prxapi::Application.config.middleware.use Prxapi::Application.config.session_store, Prxapi::Application.config.session_options
