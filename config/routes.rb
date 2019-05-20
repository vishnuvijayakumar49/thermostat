Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope :api, module: :api do
    scope :v1, module: :v1 do
      post 'post_readings' => 'thermostats#post_readings'
      get 'fetch_reading' => 'thermostats#fetch_reading'
      get 'fetch_stats' => 'thermostats#fetch_stats'
    end
  end 
end
