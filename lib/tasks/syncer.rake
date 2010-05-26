namespace :syncer do
  desc "Run the syncer"
  task :run => [:environment] do
    loop do
      puts "hi"
      User.all.each { |u| SiteBuilder.run(u) }
      sleep 15
    end
  end
end
