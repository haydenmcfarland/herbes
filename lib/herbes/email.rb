# frozen_string_literal: true

require 'erb'
require 'ostruct'
require 'premailer'

module Herbes
  class Email < OpenStruct
    def render_style(path = Herbes::Constants::DEFAULT_EMAIL_STYLE_PATH)
      File.read(path)
    end

    def resolve_style(params)
      s = params[:style_string] ||
          (params.key?(:style_path) ? render_style(params[:style_path]) : nil)
      return s if s && params[:extend_default_style] != true

      [render_style, s].join("\n")
    end

    def initialize(template_params, options = {})
      style = resolve_style(options)
      params = template_params.transform_keys(&:to_sym)
      super(params.merge(style: style))
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
      def render(params, options = {})
        path = options[:template_path]
        premailer = options[:premailer] || {}

        # remove unicode space as it fails aws cognito regex
        Herbes::Email.new(params, options)
                     .render_inline_template(path, premailer)
                     .gsub("\u00A0", '')
      end
    end
  end
end
