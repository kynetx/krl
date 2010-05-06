module KRL_CMD
  class Create
    def self.go(args)
      raise "An application name must be specified" if args.to_s.empty?
      name = args.first
      desc = args.last # if description wasn't specified, set it to the name
      require LIB_DIR + 'user'
      require LIB_DIR + 'checkout'      
      user = KRL_CMD::User.new
      new_app = user.create_application(name, desc)
      KRL_CMD::Checkout.go(new_app.application_id)
      
    end
  end
end