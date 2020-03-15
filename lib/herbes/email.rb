# frozen_string_literal: true

require 'erb'
require 'ostruct'
require 'premailer'

module Herbes
  # renders them emails
  class Email < OpenStruct
    def render_style(path = Herbes::Constants::DEFAULT_EMAIL_STYLE_PATH)
      File.read(path)
    end

    def resolve_style(params)
      return render_style(params[:style_path]) if params.key?(:style_path)
      return style_string if params.key?(:style_string)

      render_style
    end

    def initialize(hash)
      params = hash.transform_keys(&:to_sym)
      params[:style] = resolve_style(params)
      super(params)
    end

    def render_html(template)
      ERB.new(template).result(binding)
    end

    def render_template(path = nil)
      path ||= Herbes::Constants::DEFAULT_EMAIL_TEMPLATE_PATH
      render_html(File.read(path))
    end

    def render_inline_template(path = nil, premailer_options = {})
      path ||= Herbes::Constants::DEFAULT_EMAIL_TEMPLATE_PATH
      Premailer.new(
        render_template(path),
        [
          { warn_level: Premailer::Warnings::SAFE },
          premailer_options,
          { css_string: style, with_html_string: true }
        ].reduce(&:merge)
      ).to_inline_css
    end

    class << self
      def render(params)
        path = params.delete(:template_path)
        Herbes::Email.new(params).render_inline_template(path)
      end
    end
  end
end
