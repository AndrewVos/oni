Oni
===
A small but powerful web framework

[![Build Status](https://secure.travis-ci.org/AndrewVos/oni.png)](http://travis-ci.org/AndrewVos/oni)

Example
=======
```ruby
class HomeController < Oni::Controller
  def get
    render :index
  end
end

Oni::Routes.route "/", HomeController
```

Controllers
===========
Oni controllers must inherit from the Oni::Controller class.

Controller Helpers
------------------
### content_type
To set the content type header call ```content_type``` with either a file extension or the actual content type.

```ruby
content_type ".css"
```

```ruby
content_type "text/css"
```

Templates
=========
Templates can be in any format supported by [Tilt](https://github.com/rtomayko/tilt). Template type is worked out by the file name.

The following code will attempt to render the template "templates/index".

```ruby
def get
  render :index
end
```

The first layout file found will be used. In the example below, if there is a template named "layout.haml" then it will be used.

```ruby
render :index
```

To turn off layout rendering just set the layout option to false.

```ruby
render :index, :layout => false
```

If you want to render another layout, then just pass its name through.

```ruby
render :index, :layout => :another_layout
```

The controller scope is passed through to the template being rendered, so if you want to access methods on the controller that is fine.
In the following two code samples you can see that the method ```get_some_data``` is available to the haml view.

```ruby
class HomeController < Oni::Controller
  def get_some_data
    "some data!"
  end
  def get
    render :index
  end
end
```

```haml
%p= get_some_data
```