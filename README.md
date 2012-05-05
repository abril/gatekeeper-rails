# Gatekeeper

gatekeeper-rails provides a simple DSL to do authorization checks in rails controllers.

It's independent of any authencation/authorization lib.
Feel free within a block!

## Simple example

```ruby
class PostsController < ApplicationController
  
  # Gatekeeper will close the doors
  # to all actions
  #
  include Gatekeeper
  
  # Tell to Gatekeeper allow access
  # to action index when the signed user
  # is admin or guest
  #
  allow :index do
    signed_user.is_admin? ||
    signed_user.is_guest?
  end
  
  # Tell to Gatekeeper allow access
  # to action new, create, update and destroy
  # only when the signed user is admin!
  #
  allow :new, :create, :update do
    signed_user.is_admin?
  end
  
  # Tell to Gatekeeper allow access
  # to action destroy only when the signed user
  # is admin, is older than 21 and it's before
  # 10 pm :)
  #
  allow :destroy do
    signed_user.is_admin? &&
    signed_user.age >= 21 &&
    Time.now.hour < 22
  end
  
  # Tell to Gatekeeper what it should do when
  # the access is denied
  #
  when_access_denied do
    render :text => "No donuts for you!!!", :status => '403'
  end
  
  # Controller actions
  #
  def index
    render :text => 'Index post action'
  end
  
  def new
    render :text => 'New post action'
  end
  
  def create
    render :text => 'Create post action'
  end
  
  def update
    render :text => 'Update post action'
  end
  
  def destroy
    render :text => 'Destroy post action'
  end
  
end
```

## More examples

You can allow some actions without a block:

```ruby
allow :index, :new

allow :create, :update, :destroy do
  # your condition here
end
```

You can allow all actions and restrict a specific one:

```ruby
allow :all

allow :create do
  # your condition here
end
```
## Using

Add gatekeeper-rails to your Gemfile:

```ruby
gem 'gatekeeper-rails', :require => 'gatekeeper'
```

## Autors

* [Eric Fer](https://github.com/ericfer)  
* [Lucas Fais](https://github.com/lucasfais)
