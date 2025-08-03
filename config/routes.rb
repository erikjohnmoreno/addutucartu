Rails.application.routes.draw do
  
  namespace :api do
    resources :products, only: [:index]
    resources :carts, only: [:create, :index] do
      collection do
        post :add_item
        delete :remove_item
      end
    end
  end

  get '*path', to: proc { [200, {}, [File.read(Rails.root.join('public', 'index.html'))]] }
end
