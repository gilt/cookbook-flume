
# === VERSION AND LOCATION
#
default.elasticsearch[:version]       = "1.4.0"
default.elasticsearch[:host]          = "http://download.elasticsearch.org"
default.elasticsearch[:repository]    = "elasticsearch/elasticsearch"
default.elasticsearch[:filename]      = nil
default.elasticsearch[:download_url]  = nil
default.elasticsearch[:dir]           = "#{node.flume[:dir]}/elasticsearch"
