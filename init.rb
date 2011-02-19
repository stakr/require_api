require 'stakr/require_api/controller'

::ActionController::Base.class_eval do
  include ::Stakr::RequireApi::Controller
end
