# Monkey patch Webby to have nicer URLs.
# Generate each html pages in a <page_name>/index.html file.
# So the URL will look like /<page_name>
# Credits to Marc-André Cournoyer.
module Webby::Resources
  class Page < Resource
    def destination
      dest = super
      if prettify?
        File.join(File.dirname(dest),
                  File.basename(dest, ".*"),
                  "index.html")
      else
        dest
      end
    end

    def url
      if prettify?
        super.gsub(/index\.html$/, "")
      else
        super
      end
    end

    private
      def prettify?
        filename != "index" && extension == "html"
      end
  end
end
