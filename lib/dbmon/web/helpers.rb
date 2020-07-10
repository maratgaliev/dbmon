# frozen_string_literal: true

require "uri"
require "set"
require "yaml"
require "cgi"

module Dbmon

  module WebHelpers
    def strings(lang)
      @strings ||= {}
      @strings[lang] ||= begin
        settings.locales.each_with_object({}) do |path, global|
          find_locale_files(lang).each do |file|
            strs = YAML.load(File.open(file))
            global.merge!(strs[lang])
          end
        end
      end
    end

    def clear_caches
      @strings = nil
      @locale_files = nil
      @available_locales = nil
    end

    def locale_files
      @locale_files ||= settings.locales.flat_map { |path|
        Dir["#{path}/*.yml"]
      }
    end

    def available_locales
      @available_locales ||= locale_files.map { |path| File.basename(path, ".yml") }.uniq
    end

    def find_locale_files(lang)
      locale_files.select { |file| file =~ /\/#{lang}\.yml$/ }
    end

    def add_to_head
      @head_html ||= []
      @head_html << yield.dup if block_given?
    end

    def display_custom_head
      @head_html.join if defined?(@head_html)
    end

    def user_preferred_languages
      languages = env["HTTP_ACCEPT_LANGUAGE"]
      languages.to_s.downcase.gsub(/\s+/, "").split(",").map { |language|
        locale, quality = language.split(";q=", 2)
        locale = nil if locale == "*" # Ignore wildcards
        quality = quality ? quality.to_f : 1.0
        [locale, quality]
      }.sort { |(_, left), (_, right)|
        right <=> left
      }.map(&:first).compact
    end

    def locale
      @locale ||= begin
        matched_locale = user_preferred_languages.map { |preferred|
          preferred_language = preferred.split("-", 2).first

          lang_group = available_locales.select { |available|
            preferred_language == available.split("-", 2).first
          }

          lang_group.find { |lang| lang == preferred } || lang_group.min_by(&:length)
        }.compact.first

        matched_locale || "en"
      end
    end

    def get_locale
      strings(locale)
    end

    def t(msg, options = {})
      string = get_locale[msg] || strings("en")[msg] || msg
      if options.empty?
        string
      else
        string % options
      end
    end

    def sort_direction_label
      params[:direction] == "asc" ? "&uarr;" : "&darr;"
    end

    def root_path
      env["SCRIPT_NAME"]
    end

    def current_path
      @current_path ||= request.path_info.gsub(/^\//, "")
    end

    def app_name
      "DBMON"
    end

    def relative_time(time)
      stamp = time.getutc.iso8601
      %(<time class="ltr" dir="ltr" title="#{stamp}" datetime="#{stamp}">#{time}</time>)
    end

    def job_params(job, score)
      "#{score}-#{job["jid"]}"
    end

    def parse_params(params)
      score, jid = params.split("-", 2)
      [score.to_f, jid]
    end

    SAFE_QPARAMS = %w[page direction]

    def qparams(options)
      stringified_options = options.transform_keys(&:to_s)

      to_query_string(params.merge(stringified_options))
    end

    def to_query_string(params)
      params.map { |key, value|
        SAFE_QPARAMS.include?(key) ? "#{key}=#{CGI.escape(value.to_s)}" : next
      }.compact.join("&")
    end

    def truncate(text, truncate_after_chars = 2000)
      truncate_after_chars && text.size > truncate_after_chars ? "#{text[0..truncate_after_chars]}..." : text
    end

    def csrf_tag
      "<input type='hidden' name='authenticity_token' value='#{env[:csrf_token]}'/>"
    end

    def to_display(arg)
      arg.inspect
    rescue
      begin
        arg.to_s
      rescue => ex
        "Cannot display argument: [#{ex.class.name}] #{ex.message}"
      end
    end

    def retry_extra_items(retry_job)
      @retry_extra_items ||= {}.tap do |extra|
        retry_job.item.each do |key, value|
          extra[key] = value unless RETRY_JOB_KEYS.include?(key)
        end
      end
    end

    def number_with_delimiter(number)
      begin
        Float(number)
      rescue ArgumentError, TypeError
        return number
      end

      options = {delimiter: ",", separator: "."}
      parts = number.to_s.to_str.split(".")
      parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")
      parts.join(options[:separator])
    end

    def h(text)
      ::Rack::Utils.escape_html(text)
    rescue ArgumentError => e
      raise unless e.message.eql?("invalid byte sequence in UTF-8")
      text.encode!("UTF-16", "UTF-8", invalid: :replace, replace: "").encode!("UTF-8", "UTF-16")
      retry
    end

    def redirect_with_query(url)
      r = request.referer
      if r && r =~ /\?/
        ref = URI(r)
        redirect("#{url}?#{ref.query}")
      else
        redirect url
      end
    end

    def environment_title_prefix
      environment = "development"

      "[#{environment.upcase}] " unless environment == "production"
    end

    def product_version
      "DBMON v#{Dbmon::VERSION}"
    end

    def server_utc_time
      Time.now.utc.strftime("%H:%M:%S UTC")
    end
  end
end
