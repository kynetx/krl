require 'json'
module KRL_CMD
  class Stats
    def self.interface
      user = KRL_CMD::User.new
      begin
        p_interface = user.stats_interface
        puts "-- Dimensions --"
        p_interface["dims"].each {|s| puts "\t" + s}
        puts
        puts "-- KPIS --"
        p_interface["kpis"].each {|s| puts "\t" + s}
        puts
        puts "-- Ranges --"
        p_interface["ranges"].each {|s| puts "\t" + s}
      rescue 
        raise "There was an error trying to retrieve the stats interface"
      end
    end

    def self.kpis(options)
      app = KRL_COMMON::get_app
      begin
        data = app.kpis(options["range"])
        display_stats(data, %w(DAY RSE BRSE CALLBACKS RULES RULES_FIRED ACTIONS), options["format"]) 
      rescue => e
        ap e.message if $DEBUG
        ap e.backtrace if $DEBUG
        raise "Unable to retrieve the stats."
      end
      
    end

    def self.account_kpis(options)
      user = KRL_CMD::User.new
      begin
        data = user.kpis([], options["range"])
        display_stats(data, %w(RULESET DAY RSE BRSE CALLBACKS RULES RULES_FIRED ACTIONS), options["format"]) 
      rescue => e
        ap e.message if $DEBUG
        ap e.backtrace if $DEBUG
        raise "Unable to retrieve the stats."
      end 
    end

    def self.logging(options)
      app = KRL_COMMON::get_app
      begin
        data = app.logging(options["range"])
        display_stats(data, [], "json")
      rescue => e
        ap e.message if $DEBUG
        ap e.backtrace if $DEBUG
        raise "Unable to retrieve logging."
      end 
    end

    def self.query(options)
      user = KRL_CMD::User.new
      if options["conditions"]
        conditions = []
        options["conditions"].each {|k,v| conditions << {:field => k, :value => v}}
      else
        conditions = nil
      end
      begin
        data = user.api.get_stats_query(
          options["kpis"].join(","),
          options["dims"].join(","),
          conditions,
          options["range"]
        )
        fields = []
        (options["dims"] + options["kpis"]).each {|v| fields << v.upcase}
        display_stats(data, fields, options["format"])

      rescue => e
        ap e.message   #if $DEBUG
        ap e.backtrace #if $DEBUG
        raise "Unable to retrieve query results. #{e.message}"
      end 
    end


    private


    def self.display_stats(data, fields, format)
      field_opts = []
      fields.each do |field|
        field_opts << {:field => field, :value => lambda { |r| r[field].to_s }}
      end
      if data["valid"] == true
        if format == "table"
          KRL_COMMON.pretty_table(data["data"], field_opts)
        elsif format == "json"
          puts JSON.pretty_generate(data["data"])
        else
          raise "Unknown format (#{format})"
        end

      else
        raise data["error"]
      end

      
    end
      
  end
end
