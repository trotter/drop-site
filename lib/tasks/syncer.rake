namespace :syncer do
  desc "Run the syncer"
  task :run => [:environment] do
    loop do
      User.all.each { |u| SiteBuilder.run(u) }
      sleep 15
    end
  end
end
