module KRL_CMD
  class Versions
    def self.go(options)
      limit = options["limit"]
      app = KRL_COMMON::get_app
      p_version = app.production_version.to_i
      KRL_COMMON::pretty_table(app.versions.reverse, [
        {:field => "Version", :value => lambda { |r| r["version"] }},
        {:field => "User", :value => lambda { |r| r["name"] }},
        {:field => "Date", :value => lambda { |r| r["created"].to_s }},
        {:field => "Note", :value => lambda { |r| r["note"].to_s }},
        {:field => "Production", :value => lambda { |r| r["version"] == p_version ? "Yes" : "No" }}
      ], limit, ! limit.nil?)
    end
  end
end
