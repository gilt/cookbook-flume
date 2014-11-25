[Chef::Recipe, Chef::Resource].each { |l| l.send :include }

Erubis::Context.send(:include)

flume = "flume-#{node.flume[:version]}"

include_recipe "ark"

# Create user and group
#
group node.flume[:user] do
  gid node.flume[:gid]
  action :create
  system true
end

user node.flume[:user] do
  comment "Flume User"
  home    "#{node.flume[:path][:dir]}/flume"
  shell   "/bin/bash"
  uid     node.flume[:uid]
  gid     node.flume[:user]
  supports :manage_home => false
  action  :create
  system true
end

# FIX: Work around the fact that Chef creates the directory even for `manage_home: false`
bash "remove the flume user home" do
  user    'root'
  code    "rm -rf  #{node.flume[:dir]}/flume"
  not_if  { ::File.symlink?("#{node.flume[:dir]}/flume") }
  only_if { ::File.directory?("#{node.flume[:dir]}/flume") }
end

# Create ES directories
#
[ node.flume[:path][:conf], node.flume[:path][:logs] ].each do |path|
  directory path do
    owner node.flume[:user] and group node.flume[:user] and mode 0755
    recursive true
    action :create
  end
end

directory node.flume[:pid_path] do
  mode '0755'
  recursive true
end

# Create service
#
template "/etc/init.d/flume" do
  source "flume.init.erb"
  owner 'root' and mode 0755
end

service "flume" do
  supports :status => true, :restart => true
  action [ :enable ]
end

# Download, extract, symlink the flume libraries and binaries
#
ark_prefix_root = node.flume[:dir] || node.ark[:prefix_root]
ark_prefix_home = node.flume[:dir] || node.ark[:prefix_home]

filename = node.flume[:filename] || "apache-flume-#{node.flume[:version]}-bin.tar.gz"
download_url = node.flume[:download_url] || [node.flume[:host],
node.flume[:repository], filename].join('/')

ark "flume" do
  url   download_url
  owner node.flume[:user]
  group node.flume[:user]
  version node.flume[:version]
  has_binaries ['bin/flume-ng']
  checksum node.flume[:checksum]
  prefix_root   ark_prefix_root
  prefix_home   ark_prefix_home

  notifies :start,   'service[flume]' unless node.flume[:skip_start]
  notifies :restart, 'service[flume]' unless node.flume[:skip_restart]

  not_if do
    link   = "#{node.flume[:dir]}/flume"
    target = "#{node.flume[:dir]}/flume-#{node.flume[:version]}"
    binary = "#{target}/bin/flume"

    ::File.directory?(link) && ::File.symlink?(link) && ::File.readlink(link) == target && ::File.exists?(binary)
  end
end

# Increase open file and memory limits
#
bash "enable user limits" do
  user 'root'

  code <<-END.gsub(/^    /, '')
  echo 'session    required   pam_limits.so' >> /etc/pam.d/su
  END

  not_if { ::File.read("/etc/pam.d/su").match(/^session    required   pam_limits\.so/) }
end

log "increase limits for the flume user"

file "/etc/security/limits.d/10-flume.conf" do
  content <<-END.gsub(/^    /, '')
  #{node.flume.fetch(:user, "flume")}     -    nofile    #{node.flume[:limits][:nofile]}
  #{node.flume.fetch(:user, "flume")}     -    memlock   #{node.flume[:limits][:memlock]}
  END
end

# Create flume config file
#
template "flume.conf" do
  path   "#{node.flume[:path][:conf]}/flume.conf"
  source node.flume[:templates][:flume_conf]
  owner  node.flume[:user] and group node.flume[:user] and mode 0755

  notifies :restart, 'service[flume]' unless node.flume[:skip_restart]
end

# Create ES logging file
#
template "logging.yml" do
  path   "#{node.flume[:path][:conf]}/log4j.properties"
  source node.flume[:templates][:log4j_properties]
  owner  node.flume[:user] and group node.flume[:user] and mode 0755

  notifies :restart, 'service[flume]' unless node.flume[:skip_restart]
end
