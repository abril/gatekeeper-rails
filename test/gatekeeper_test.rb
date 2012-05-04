# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

module PostControllerTestHelper
  def define_post_controller_with(string_block)
    class_eval %{
      class PostController < ApplicationController
        include Gatekeeper

        def index
          fake_action_result('Index HTML')
        end

        def edit
          fake_action_result('Edit HTML')
        end

        #{string_block}
      end
    }
  end

  def define_post_controller
    define_post_controller_with ''
  end
end

module RequestAssertsHelper
  def assert_request_successfully(body)
    assert_equal body, @response.body.strip
    assert_equal '200', @response.code
  end

  def assert_request_not_authorized(body = "Access not authorized.", status_code = '403')
    assert_equal body, @response.body.strip
    assert_equal status_code, @response.code
  end
end

class PostControllerWithoutDefinedRulesTest < ActionController::TestCase
  extend PostControllerTestHelper
  include RequestAssertsHelper

  define_post_controller
  tests PostController

  def test_index_action_has_access_denied
    get :index
    assert_request_not_authorized
  end
end

class PostControllerWithSatisfiedRuleTest < ActionController::TestCase
  extend PostControllerTestHelper
  include RequestAssertsHelper

  define_post_controller_with %{
    allow :index do
      true
    end
  }
  tests PostController

  def test_index_action_has_success
    get :index
    assert_request_successfully("Index HTML")
  end
end

class PostControllerWithInsatisfiedRuleTest < ActionController::TestCase
  extend PostControllerTestHelper
  include RequestAssertsHelper

  define_post_controller_with %{
    allow :index do
      false
    end
  }
  tests PostController

  def test_index_action_has_access_denied
    get :index
    assert_request_not_authorized
  end
end

class PostControllerWithRuleThatAccessMethodsTest < ActionController::TestCase
  extend PostControllerTestHelper
  include RequestAssertsHelper

  define_post_controller_with %{
    allow :index do
      authorized_request?
    end

    def authorized_request?
      true
    end
  }
  tests PostController

  def test_method_was_executed_in_correct_scope
    assert_nothing_raised do
      get :index
    end
  end

  def test_index_action_has_success
    get :index
    assert_request_successfully("Index HTML")
  end
end

class PostControllerWithRuleWithouBlockTest < ActionController::TestCase
  extend PostControllerTestHelper
  include RequestAssertsHelper

  define_post_controller_with %{
    allow :index
  }
  tests PostController

  def test_index_action_has_success
    get :index
    assert_request_successfully("Index HTML")
  end
end

class PostControllerWithMultipleRulesWithouBlockTest < ActionController::TestCase
  extend PostControllerTestHelper
  include RequestAssertsHelper

  define_post_controller_with %{
    allow :index, :edit
  }
  tests PostController

  def test_index_action_has_success
    get :index
    assert_request_successfully("Index HTML")
  end

  def test_edit_action_has_success
    get :edit
    assert_request_successfully("Edit HTML")
  end
end

class PostControllerWithInsatisfiedMultipleRulesTest < ActionController::TestCase
  extend PostControllerTestHelper
  include RequestAssertsHelper

  define_post_controller_with %{
    allow :index, :edit do
      false
    end
  }
  tests PostController

  def test_index_action_has_access_denied
    get :index
    assert_request_not_authorized
  end

  def test_edit_action_has_access_denied
    get :edit
    assert_request_not_authorized
  end
end

class PostControllerWithSatisfiedRulesForAllActionsTest < ActionController::TestCase
  extend PostControllerTestHelper
  include RequestAssertsHelper

  define_post_controller_with %{
    allow :all do
      true
    end
  }
  tests PostController

  def test_index_action_has_success
    get :index
    assert_request_successfully("Index HTML")
  end

  def test_edit_action_has_success
    get :edit
    assert_request_successfully("Edit HTML")
  end
end

class PostControllerWithRulesForAllActionsWithoutBlockTest < ActionController::TestCase
  extend PostControllerTestHelper
  include RequestAssertsHelper

  define_post_controller_with %{
    allow :all
  }
  tests PostController

  def test_index_action_has_success
    get :index
    assert_request_successfully("Index HTML")
  end

  def test_edit_action_has_success
    get :edit
    assert_request_successfully("Edit HTML")
  end
end

class PostControllerWithRulesForAllActionsAndOneActionTest < ActionController::TestCase
  extend PostControllerTestHelper
  include RequestAssertsHelper

  define_post_controller_with %{
    allow :all

    allow :edit do
      false
    end
  }
  tests PostController

  def test_index_action_has_success
    get :index
    assert_request_successfully("Index HTML")
  end

  def test_edit_action_has_access_denied
    get :edit
    assert_request_not_authorized
  end
end

class PostControllerWithRuleForAccessDeniedResponse < ActionController::TestCase
  extend PostControllerTestHelper
  include RequestAssertsHelper

  define_post_controller_with %{
    when_access_denied do
      fake_action_result("No donuts for you!!!", 401)
    end
  }
  tests PostController

  def test_index_action_has_access_denied
    get :index
    assert_request_not_authorized("No donuts for you!!!", '401')
  end
end

