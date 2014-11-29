newrelic_jar_path="#{node[:flume][:newrelic][:dir]}/newrelic.jar"
newrelic_conf_path="#{node[:flume][:newrelic][:dir]}/newrelic.yml"

directory node[:flume][:newrelic][:dir] do
  owner node.flume[:user]
  group node.flume[:user]
  action :create
end

remote_file newrelic_jar_path do
  source node[:flume][:newrelic][:url]
  owner node.flume[:user]
  group node.flume[:user]
  action :create
end

template "newrelic.yml" do
  path   newrelic_conf_path
  source node.flume[:newrelic][:templates][:yml]
  owner  node.flume[:user] and group node.flume[:user] and mode 0644

  notifies :restart, 'service[flume]' unless node.flume[:skip_restart]
end

execute %Q|echo 'JAVA_OPTS="\$JAVA_OPTS -javaagent:#{newrelic_jar_path} -Dnewrelic.config.file=#{newrelic_conf_path} -Dnewrelic.logfile=#{node[:flume][:path][:logs]}/newrelic_agent.log "' >> #{node.flume[:path][:conf]}/flume-env.sh|
