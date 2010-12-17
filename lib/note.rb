module KRL_CMD
  class Note
    def self.go(options)
      app = KRL_COMMON::get_app
      version = options["version"] ? options["version"] : app.version
      note = options["note"]
      app.set_version_note(version, note)
      puts "Done."      
    end
  end
end
