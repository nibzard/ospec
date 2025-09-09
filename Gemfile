source "https://rubygems.org"

# Core Jekyll
gem "jekyll", "~> 4.3.0"
gem "webrick", "~> 1.8"  # Required for Ruby 3.0+

# Jekyll plugins
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.17"
  gem "jekyll-sitemap", "~> 1.4"
  gem "jekyll-github-metadata", "~> 2.16"
  gem "jekyll-seo-tag", "~> 2.8"
  gem "jekyll-relative-links", "~> 0.6"
  gem "jekyll-include-cache", "~> 0.2"
  gem "jekyll-redirect-from", "~> 0.16"
  gem "jekyll-archives", "~> 2.2"
end

# Development tools
group :development do
  gem "html-proofer", "~> 5.0"
  gem "rake", "~> 13.0"
  gem "json-schema", "~> 4.0"
  gem "colorize", "~> 0.8"
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds since newer versions of the gem
# do not have a Java counterpart.
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]