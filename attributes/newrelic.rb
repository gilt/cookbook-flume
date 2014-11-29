
default.flume[:newrelic][:dir]           = "#{node.flume[:dir]}/newrelic"
default.flume[:newrelic][:version]       = "3.12.0"
default.flume[:newrelic][:url]           = "https://repo1.maven.org/maven2/com/newrelic/agent/java/newrelic-agent/#{node.flume[:newrelic][:version]}/newrelic-agent-#{node.flume[:newrelic][:version]}.jar"
default.flume[:newrelic][:send_attrs]    = "true"
default.flume[:newrelic][:tracing]       = "false"
default.flume[:newrelic][:license]       = nil

default.flume[:newrelic][:templates][:yml] = "newrelic.yml.erb"
