namespace :thing do
    desc "it does a thing"
    task :work, [:option, :foo, :bar] do |task, args|
      p args.var.inspect
      p args[:option].class
      p args[:foo].class
      p args[:bar].class
    end
end