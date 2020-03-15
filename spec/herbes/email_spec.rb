# frozen_string_literal: true

require 'spec_helper'
require 'pathname'

FIXTURES = Pathname.new("#{File.dirname(__FILE__)}/fixtures/")
CUSTOM_CSS_HTML = FIXTURES.join('custom_css_test.html')
CUSTOM_ERB_HTML = FIXTURES.join('custom_erb_test.html')
CUSTOM_ERB_TEMPLATE = FIXTURES.join('custom.html.erb')
DEFAULT_HTML = FIXTURES.join('test.html')

describe Herbes::Email do
  let(:default_params) do
    github = 'https://github.com/haydenmcfarland'
    img_path = "#{github}/assets/blob/master/images/herbes.png?raw=true"
    {
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
  end

  let(:default_params_with_new_path) do
    default_params.merge(style_path: FIXTURES.join('test.css'))
  end

  it 'can inline css into html erb template' do
    result = Herbes::Email.render(default_params)

    DEFAULT_HTML.open('w+') { |f| f.write(result) } if ENV['REGEN'] == 'true'
    expect(result).to eq(DEFAULT_HTML.read)
  end

  it 'allows css path to determine styling in email' do
    result = Herbes::Email.render(default_params_with_new_path)
    CUSTOM_CSS_HTML.open('w+') { |f| f.write(result) } if ENV['REGEN'] == 'true'

    custom = CUSTOM_CSS_HTML.read
    expect(result).to eq(custom)

    default = DEFAULT_HTML.read
    expect(custom).to_not eq(default)
    expect(custom.gsub('200px', '100px')).to eq(default)
  end

  it 'allows use of custom erb template' do
    result = Herbes::Email.render(
      title: 'hello',
      p_test: 'test',
      template_path: CUSTOM_ERB_TEMPLATE
    )

    CUSTOM_ERB_HTML.open('w+') { |f| f.write(result) } if ENV['REGEN'] == 'true'

    custom = CUSTOM_ERB_HTML.read
    expect(result).to eq(custom)
  end
end
