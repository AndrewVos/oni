Oni
===
A small but powerful web framework

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
