
default.flume[:logstash_sink][:version]       = "0.0.1"
default.flume[:logstash_sink][:url]           = "http://jcenter.bintray.com/com/gilt/flume/flume-logstash-sink/#{node.flume[:logstash_sink][:version]}/flume-logstash-sink-#{node.flume[:logstash_sink][:version]}.jar"
