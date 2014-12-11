logstash_sink_jar_path="#{node[:flume][:path][:dir]}/lib/flume-logstash-sink.jar"

remote_file logstash_sink_jar_path do
  source node[:flume][:logstash_sink][:url]
  owner node.flume[:user]
  group node.flume[:user]
  action :create
end
