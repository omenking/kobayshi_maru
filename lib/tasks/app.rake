require Rails.root.join('lib', 'templating')

namespace :app do
  namespace :templates do
    desc 'Compile Haml Templates for Javascript'
    task :compile => :environment do
      Templating.compile
    end
  end
end
