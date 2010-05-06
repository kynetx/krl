module KRL_CMD
  class Versions
    def self.go(args)
      require LIB_DIR + 'common'
      limit = args.to_s.to_i
      app = KRL_COMMON::get_app
      p_version = app.production_version.to_i
      KRL_COMMON::pretty_table(app.versions, [
        {:field => "Version", :value => lambda { |r| r["version"] }},
        {:field => "User", :value => lambda { |r| r["name"] }},
        {:field => "Date", :value => lambda { |r| r["created"].to_s }},
        {:field => "Note", :value => lambda { |r| r["note"].to_s }},
        {:field => "Production", :value => lambda { |r| r["version"] == p_version ? "Yes" : "No" }}
      ], limit)
    end
  end
end