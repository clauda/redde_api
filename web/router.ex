defmodule ReddeApi.Router do
  use ReddeApi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", ReddeApi do
    pipe_through :browser
    resources "/sessions", SessionController, only: [:new]
  end

  pipeline :api_auth do  
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash

    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", ReddeApi do
    pipe_through :api
    get "/", ContactController, :index

    resources "/users", UserController, only: [:create]
    resources "/contacts", ContactController, except: [:new, :edit]
    resources "/meetings", MeetingController, except: [:new, :edit]
    resources "/comments", CommentController, except: [:new, :edit]
    
    get "/profile", UserController, :profile
    resources "/sessions", SessionController, only: [:create]
  end
end
