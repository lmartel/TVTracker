namespace :shows do
    task :update => :environment do
        Show.order('random()').each do |show|
            Episode.pull_episodes(show, false)
        end
    end
end
