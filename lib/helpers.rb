module Helpers
  def code(lang, &block)
    uv(:lang => lang, :theme => "twilight", &block)
  end
end

Webby::Helpers.register(Helpers)
