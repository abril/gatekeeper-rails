require 'rubygems'
require 'test/unit'

LIB_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

$LOAD_PATH.unshift(LIB_PATH)
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'gatekeeper'

# Simulating a rails app for tests
#
require 'action_controller'
require 'rails'
require 'rails/test_help'

module MyTestApplication 
  class Application < Rails::Application
  end
end

Rails.application.routes.draw do
  match '/:controller(/:action(/:id))'
end

class ApplicationController < ActionController::Base
  include Rails.application.routes.url_helpers
  
  protected
  def fake_action_result(view_content = nil, status = 200)
    view_content ||= "any view content"
    render :text => view_content, :status => status
  end
end
