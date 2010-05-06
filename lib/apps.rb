module KRL_CMD
  class Apps
    def self.go
      require LIB_DIR + 'user'
      require LIB_DIR + 'common'
      user = User.new
      KRL_COMMON::pretty_table(user.applications["apps"], [
        {:field => "Ruleset ID", :value => lambda { |r| r["appid"] }},
        {:field => "Name", :value => lambda { |r| r["name"].to_s }},
        {:field => "Role", :value => lambda { |r| r["role"] }}        
      ])
    end
  end
end