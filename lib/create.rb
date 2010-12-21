module KRL_CMD
  class Create
    def self.go(name, options)
      desc = options["description"] ? options["description"] : name
      user = KRL_CMD::User.new
      new_app = user.create_application(name, desc)
      checkout_opts = {
        "title" => options["title"]
      }
      KRL_CMD::Checkout.go(new_app.application_id, checkout_opts)
      
    end
  end
end
