require 'fileutils'
module KRL_CMD
  class Test
    def self.go(args)
      type = args[0] || "bookmarklet"
      args.shift if args
      
      require LIB_DIR + 'generate'
      if type == "bookmarklet"
        KRL_CMD::Generate.gen_bookmarklet(args, "dev")
      elsif type == "infocard"
        KRL_CMD::Generate.gen_infocard(args, "dev")
      else
        puts "Unknown test endpoint (#{type})"
      end
      
    end
    

  end
end