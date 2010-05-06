module KRL_CMD
  class Note
    def self.go(args)
      raise "Please supply a version and a note. (note must be enclosed in quotes)" unless args.length == 2
      version = args.first.to_i
      note = args.last.to_s
      require LIB_DIR + 'common'
      app = KRL_COMMON::get_app
      app.set_version_note(version, note)
      puts "Done."      
    end
  end
end