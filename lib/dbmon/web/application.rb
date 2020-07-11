# frozen_string_literal: true
require "ruby-pg-extras"

module Dbmon
  class WebApplication
    extend WebRouter

    CONTENT_LENGTH = "Content-Length"
    CSP_HEADER = [
      "default-src 'self' https: http:",
      "child-src 'self'",
      "connect-src 'self' https: http: wss: ws:",
      "font-src 'self' https: http:",
      "frame-src 'self'",
      "img-src 'self' https: http: data:",
      "manifest-src 'self'",
      "media-src 'self'",
      "object-src 'none'",
      "script-src 'self' https: http: 'unsafe-inline'",
      "style-src 'self' https: http: 'unsafe-inline'",
      "worker-src 'self'",
      "base-uri 'self'"
    ].join("; ").freeze

    def initialize(klass)
      @klass = klass
      RubyPGExtras.database_url = ENV["MON_DATABASE_URL"]
    end

    def settings
      @klass.settings
    end

    def self.settings
    end

    def self.tabs
      { 
        'Dashboard' => '' , 'Tables' => 'tables', 'Indexes' => 'indexes', 'Hits' => 'hits',
        'Locks' => 'locks', 'Hits' => 'hits', 'Performance' => 'performance'
      }
    end

    get "/" do
      @total_table_size = ::RubyPGExtras.total_table_size(in_format: :hash)
      @total_index_size = ::RubyPGExtras.total_index_size(in_format: :hash)
      @table_indexes_size = ::RubyPGExtras.table_indexes_size(in_format: :hash)

      @data = [
        { api: @total_table_size, message: 'Table size' }, 
        { api: @total_index_size, message: 'Total index size' }, 
        { api: @table_indexes_size, message: 'Table indexes size' }, 
      ]
      
      erb(:dashboard)
    end

    get "/tables" do
      @table_size = ::RubyPGExtras.table_size(in_format: :hash)
      @total_table_size = ::RubyPGExtras.total_table_size(in_format: :hash)
      @table_indexes_size = ::RubyPGExtras.table_indexes_size(in_format: :hash)
      @data = [
        { api: @table_size, message: 'Table size' }, 
        { api: @total_table_size, message: 'Total table size' }, 
        { api: @table_indexes_size, message: 'Table indexes size' }, 
      ]
      erb(:tables)
    end

    get "/indexes" do
      @index_size = ::RubyPGExtras.index_size(in_format: :hash)
      @total_index_size = ::RubyPGExtras.total_index_size(in_format: :hash)
      @unused_indexes = ::RubyPGExtras.unused_indexes(in_format: :hash)

      @data = [
        { api: @index_size, message: 'Index size' }, 
        { api: @total_index_size, message: 'Total index size' }, 
        { api: @unused_indexes, message: 'Unused indexes' }, 
      ]
      erb(:indexes)
    end

    get "/hits" do
      @cache_hit = ::RubyPGExtras.cache_hit(in_format: :hash)
      @index_cache_hit = ::RubyPGExtras.index_cache_hit(in_format: :hash)
      @table_cache_hit = ::RubyPGExtras.table_cache_hit(in_format: :hash)

      @data = [
        { api: @cache_hit, message: 'Index size' },
        { api: @index_cache_hit, message: 'Total index size' },
        { api: @table_cache_hit, message: 'Unused indexes' },
      ]

      erb(:hits)
    end
    
    get "/locks" do
      @blocking = ::RubyPGExtras.blocking(in_format: :hash)
      @locks = ::RubyPGExtras.locks(in_format: :hash)
      @all_locks = ::RubyPGExtras.all_locks(in_format: :hash)

      @data = [
        { api: @blocking, message: 'Current blocking' }, 
        { api: @locks, message: 'Exclusive locks' }, 
        { api: @all_locks, message: 'Current locks' }, 
      ]

      erb(:locks)
    end
    
    get "/performance" do
      @long_running_queries = ::RubyPGExtras.long_running_queries(in_format: :hash)
      @vacuum_stats = ::RubyPGExtras.vacuum_stats(in_format: :hash)
      @bloat = ::RubyPGExtras.bloat(in_format: :hash)

      @data = [
        { api: @long_running_queries, message: 'Long running queries' }, 
        { api: @vacuum_stats, message: 'Vacuum statistics' }, 
        { api: @bloat, message: 'Tables bloat data' }, 
      ]
      erb(:performance)
    end

    get "/about" do
      erb(:about)
    end

    def call(env)
      action = self.class.match(env)
      return [404, {"Content-Type" => "text/plain", "X-Cascade" => "pass"}, ["Not Found"]] unless action

      app = @klass
      resp = catch(:halt) do
        self.class.run_befores(app, action)
        action.instance_exec env, &action.block
      ensure
        self.class.run_afters(app, action)
      end

      resp = case resp
      when Array
        resp
      else
        headers = {
          "Content-Type" => "text/html",
          "Cache-Control" => "no-cache",
          "Content-Language" => action.locale,
          "Content-Security-Policy" => CSP_HEADER
        }
        [200, headers, [resp]]
      end

      resp
    end

    def self.helpers(mod = nil, &block)
      if block_given?
        WebAction.class_eval(&block)
      else
        WebAction.send(:include, mod)
      end
    end

    def self.before(path = nil, &block)
      befores << [path && Regexp.new("\\A#{path.gsub("*", ".*")}\\z"), block]
    end

    def self.after(path = nil, &block)
      afters << [path && Regexp.new("\\A#{path.gsub("*", ".*")}\\z"), block]
    end

    def self.run_befores(app, action)
      run_hooks(befores, app, action)
    end

    def self.run_afters(app, action)
      run_hooks(afters, app, action)
    end

    def self.run_hooks(hooks, app, action)
      hooks.select { |p, _| !p || p =~ action.env[WebRouter::PATH_INFO] }
        .each { |_, b| action.instance_exec(action.env, app, &b) }
    end

    def self.befores
      @befores ||= []
    end

    def self.afters
      @afters ||= []
    end
  end
end
