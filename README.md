# Herbes (ERB Email Generator for Ruby Lambda)

![herbes](https://github.com/haydenmcfarland/assets/blob/master/images/herbes.png?raw=true)
![herbes_template](https://github.com/haydenmcfarland/assets/blob/master/images/herbes_template.png?raw=true)

# What?

A gem for generating HTML with inlined css from ERB templates for email rendering purposes.

# How to use
Add `herbes` to your gem file:

```ruby
gem 'herbes', github: 'haydenmcfarland/herbes'
```

Run `bundle install`

# Example usage

#### using default template
```ruby
require 'herbes'

github = 'https://github.com/haydenmcfarland'
img_path = "#{github}/assets/blob/master/images/herbes.png?raw=true"
params = {
  title: 'Test Email',
  preheader: 'This is what is used as an example in client',
  p_greetings: 'Hey there john_cena,',
  p_body: 'Please press the following button to confirm your account:',
  p_end: 'You will be forwarded to a confirmation screen.',
  p_regards: 'Thank you!',
  footer_address: '8650 Del Monte Court, Taylors, SC 29687',
  footer_extra: 'Questions? Issues? Call: 867-5309',
  powered_by: "<a href=\"#{github}/herbes\">Herbes</a>",
  img_absolute_path: img_path,
  call_to_action: "<a href=\"#{github}/herbes\" "\
                  'target="_blank">Confirm</a></td>'
}
    
Herbes::Email.render(params)

"<!DOCTYPE html>\n<html>\n  <head>\n    <meta name=\"viewport\" content=\"width=device-width\">\n...
```

#### providing custom template path and style path

```ruby
# parameters are tied to what is expected in template
params = { 
  new_param1: 'test', 
  new_param2: 'cool',
}

Herbes::Email.render(params, template_path: 'template.html.erb', style_path: 'style.css')
```

#### providing style string

```ruby

Herbes::Email.render(params, style_string: custom_css)

```
