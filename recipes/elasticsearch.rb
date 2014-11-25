# Download, extract, symlink the elasticsearch libraries and binaries
#

ark_prefix_root = node.elasticsearch[:dir] || node.ark[:prefix_root]
ark_prefix_home = node.elasticsearch[:dir] || node.ark[:prefix_home]

filename = node.elasticsearch[:filename] || "elasticsearch-#{node.elasticsearch[:version]}.tar.gz"
download_url = node.elasticsearch[:download_url] || [node.elasticsearch[:host],
node.elasticsearch[:repository], filename].join('/')

ark "elasticsearch" do
  url   download_url
  owner node.flume[:user]
  group node.flume[:user]
  version node.elasticsearch[:version]
  checksum node.elasticsearch[:checksum]
  prefix_root   ark_prefix_root
  prefix_home   ark_prefix_home
  action :put

  notifies :start,   'service[flume]' unless node.flume[:skip_start]
  notifies :restart, 'service[flume]' unless node.flume[:skip_restart]
end

ruby_block "Copy elasticseach jars to flume lib" do
  block do
    ::FileUtils.cp "#{ark_prefix_root}/lib/elasticsearch-#{node.elasticsearch[:version]}.jar", "#{node[:flume][:path][:dir]}/lib/"
    ::FileUtils.cp Dir.glob("#{ark_prefix_root}/lib/lucene-core-*.jar"), "#{node[:flume][:path][:dir]}/lib/"
  end
end
