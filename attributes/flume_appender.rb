
default.flume[:logging][:flume_appender_common][:version]       = "0.1.4"
default.flume[:logging][:flume_appender_common][:url]           = "http://jcenter.bintray.com/com/gilt/flume/logging-flume-commons/#{node.flume[:logging][:flume_appender_common][:version]}/logging-flume-commons-#{node.flume[:logging][:flume_appender_common][:version]}.jar"

default.flume[:logging][:flume_appender_log4j][:version]        = "0.1.4"
default.flume[:logging][:flume_appender_log4j][:url]            = "http://jcenter.bintray.com/com/gilt/flume/log4j-flume-appender/#{node.flume[:logging][:flume_appender_log4j][:version]}/log4j-flume-appender-#{node.flume[:logging][:flume_appender_log4j][:version]}.jar"

default.flume[:logging][:flume_agents] = "localhost:5000"
default.flume[:logging][:properties] = "client.type=default_failover"
