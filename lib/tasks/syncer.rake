namespace :syncer do
  desc "Run the syncer"
  task :run => [:environment] do
    loop do
      User.all.each { |u| SiteFinder.new(u).update; sleep 1 }
      sleep 3600
    end
  end
end
