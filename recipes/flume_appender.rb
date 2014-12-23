log4j_appender_path  = "#{node[:flume][:path][:dir]}/lib/log4j-flume-appender.jar"
common_appender_path = "#{node[:flume][:path][:dir]}/lib/common-flume-appender.jar"

remote_file log4j_appender_path do
  source node[:flume][:logging][:flume_appender_log4j][:url]
  owner node.flume[:user]
  group node.flume[:user]
  action :create
end

remote_file common_appender_path do
  source node[:flume][:logging][:flume_appender_common][:url]
  owner node.flume[:user]
  group node.flume[:user]
  action :create
end
