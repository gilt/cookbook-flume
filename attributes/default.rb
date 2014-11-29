# Load settings from data bag 'flume/settings'
#
settings = Chef::DataBagItem.load('flume', 'settings')[node.chef_environment] rescue {}
Chef::Log.debug "Loaded settings: #{settings.inspect}"

# Initialize the node attributes with node attributes merged with data bag attributes
#
node.default[:flume] ||= {}
node.normal[:flume]  ||= {}

node.normal[:flume]    = DeepMerge.merge(node.default[:flume].to_hash, node.normal[:flume].to_hash)
node.normal[:flume]    = DeepMerge.merge(node.normal[:flume].to_hash, settings.to_hash)


# === VERSION AND LOCATION
#
default.flume[:version]       = "1.5.2"
default.flume[:host]          = "http://apache.mirrors.lucidnetworks.net"
default.flume[:repository]    = "flume/#{node.flume[:version]}"
default.flume[:filename]      = nil
default.flume[:download_url]  = nil


# === USER & PATHS
#
default.flume[:dir]       = "/usr/local"
default.flume[:user]      = "flume"
default.flume[:uid]       = nil
default.flume[:gid]       = nil

default.flume[:path][:conf] = "/etc/flume"
default.flume[:path][:dir] = "#{node.flume[:dir]}/flume"
default.flume[:path][:logs] = "/var/log/flume"

default.flume[:pid_path]  = "/var/run/flume"
default.flume[:pid_file]  = "#{node.flume[:pid_path]}/flume.pid"

default.flume[:templates][:flume_conf]  = "flume.conf.erb"
default.flume[:templates][:log4j_properties] = "log4j.properties.erb"
default.flume[:templates][:flume_env] = "flume-env.sh.erb"

# === MEMORY
#
# Maximum amount of memory to use is automatically computed as one half of total available memory on the machine.
# You may choose to set it in your node/role configuration instead.
#
allocated_memory = "#{(node.memory.total.to_i * 0.8 ).floor / 1024}m"
default.flume[:allocated_memory] = allocated_memory
default.flume[:env] = [
  %Q[JAVA_OPTS=" -Xmx#{allocated_memory} -Xms#{allocated_memory} -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+HeapDumpOnOutOfMemoryError "]
]

default.flume[:agent_config] = [
  "# Licensed to the Apache Software Foundation (ASF) under one",
  "# or more contributor license agreements.  See the NOTICE file",
  "# distributed with this work for additional information",
  "# regarding copyright ownership.  The ASF licenses this file",
  "# to you under the Apache License, Version 2.0 (the",
  "# 'License'); you may not use this file except in compliance",
  "# with the License.  You may obtain a copy of the License at",
  "#",
  "#  http://www.apache.org/licenses/LICENSE-2.0",
  "#",
  "# Unless required by applicable law or agreed to in writing,",
  "# software distributed under the License is distributed on an",
  "# 'AS IS' BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY",
  "# KIND, either express or implied.  See the License for the",
  "# specific language governing permissions and limitations",
  "# under the License.",
  "",
  "",
  "# The configuration file needs to define the sources,",
  "# the channels and the sinks.",
  "# Sources, channels and sinks are defined per agent,",
  "# in this case called 'agent'",
  "",
  "agent.sources = avro",
  "agent.channels = memoryChannel",
  "agent.sinks = loggerSink",
  "",
  "# For each one of the sources, the type is defined",
  "agent.sources.avro.type = avro",
  "agent.sources.avro.bind = 0.0.0.0",
  "agent.sources.avro.port = 5000",
  "",
  "# The channel can be defined as follows.",
  "agent.sources.avro.channels = memoryChannel",
  "",
  "# Each sink's type must be defined",
  "agent.sinks.loggerSink.type = logger",
  "",
  "#Specify the channel the sink should use",
  "agent.sinks.loggerSink.channel = memoryChannel",
  "",
  "# Each channel's type is defined.",
  "agent.channels.memoryChannel.type = memory",
  "",
  "# Other config values specific to each type of channel(sink or source)",
  "# can be defined as well",
  "# In this case, it specifies the capacity of the memory channel",
  "agent.channels.memoryChannel.capacity = 100"
]

# === LIMITS
#
default.flume[:limits][:memlock] = 'unlimited'
default.flume[:limits][:nofile]  = '64000'

# === PRODUCTION SETTINGS
#
default.flume[:env_options] = ""

# === OTHER SETTINGS
#
default.flume[:skip_restart] = false
default.flume[:skip_start] = false

# === CUSTOM CONFIGURATION
#
default.flume[:custom_config] = {}

# === LOGGING
#
# See `attributes/logging.rb`
#
default.flume[:logging] = {}
