# encoding: UTF-8

module Gatekeeper
  autoload :VERSION, 'gatekeeper/version.rb'

  module ClassMethods

    def allow(*actions, &block)
      permission = block || :permission_not_required

      actions.each do |action|
        actions_access_rules[action] = permission
      end
    end

    def when_access_denied(&block)
      self.access_denied_response = block
    end
  end

  def self.included(receiver)
    receiver.extend ClassMethods
    receiver.instance_eval do
      before_action :authorize

      class << self
        attr_accessor :actions_access_rules, :access_denied_response
      end

      self.actions_access_rules = {}
    end
  end

  private

  def authorize
    actions_access_rules = self.class.actions_access_rules

    permission_defined_for_action = actions_access_rules[action_name.to_sym] || actions_access_rules[:all]
    if permission_defined_for_action
      unless permission_defined_for_action == :permission_not_required
        unless self.instance_eval &permission_defined_for_action
          return access_denied
        end
      end
    else
      return access_denied
    end
  end

  def access_denied
    if self.class.access_denied_response
      self.instance_eval &self.class.access_denied_response
    else
      render :text => "Access not authorized.", :status => 403
    end
  end

end
