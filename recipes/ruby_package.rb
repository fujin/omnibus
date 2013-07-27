case node['platform']
when 'ubuntu'
  apt_repository 'brightboxuk' do
    uri 'http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu'
    distribution node['lsb']['codename']
    components %w(main)
    keyserver 'keyserver.ubuntu.com'
    key 'C3173AA6'
  end

  %w(ruby rubygems ruby1.9.3 ruby-switch).each do |ruby_package|
    package ruby_package
  end

  execute 'ruby-switch --set ruby1.9.1'
end
