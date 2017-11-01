class IframeMailInterceptor
  class << self
    def delivering_email(message)
      # Replace iframes with corresponding links.
      message.body = message.body.decoded.gsub(%r{<iframe.*?src=['"](.*?)['"].*?</iframe>}) do
        # Handle YT and GMaps differently by converting embedded URLs into normal ones.
        url = $1.gsub(%r{(?<=www.youtube.com/)embed/}, "watch?v=")
                .gsub(%r{(?<=www.google.com/maps/)embed/v1/place\?key=.*?q=}, "search/")
        "<a href=\"#{url}\">#{url}</a>"
      end
    end

    alias_method :previewing_email, :delivering_email
  end
end

ActionMailer::Base.register_interceptor(IframeMailInterceptor)
ActionMailer::Base.register_preview_interceptor(IframeMailInterceptor)
