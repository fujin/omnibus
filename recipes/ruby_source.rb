ruby_version  = '1.9.3-p392'
ruby_filename = "ruby-#{ruby_version}.tar.gz"
ruby_checksum = '8861ddadb2cd30fb30e42122741130d12f6543c3d62d05906cd41076db70975f'

remote_file ::File.join(Chef::Config[:file_cache_path], ruby_filename) do
  source "http://ftp.ruby-lang.org/pub/ruby/1.9/#{ruby_filename}"
  checksum ruby_checksum
  not_if { ::File.exists?("/opt/ruby1.9/bin/ruby") }
end

execute "install ruby-1.9.3" do
  cwd Chef::Config[:file_cache_path]
  command <<-EOH
tar zxf #{ruby_filename}
cd ruby-#{ruby_version}
./configure --prefix=/opt/ruby1.9
make
make install
EOH
  environment(
    'CFLAGS' => '-L/usr/lib -I/usr/include',
    'LDFLAGS' => '-L/usr/lib -I/usr/include'
  )
  not_if { ::File.exists?("/opt/ruby1.9/bin/ruby") }
end

gem_package "bundler" do
  version "1.3.5"
  gem_binary "/opt/ruby1.9/bin/gem"
end

%w(bundle fpm gem omnibus rake ruby).each do |bin|
  link "/usr/local/bin/#{bin}" do
    to "/opt/ruby1.9/bin/#{bin}"
  end
end
