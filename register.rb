#!/usr/bin/env ruby
require 'pp'

Bundler.require

#hostname = "5e1631757e42"
hostname = ENV.fetch("HOSTNAME") do
  require 'socket'
  Socket.hostname
end
rancher_url = ENV.fetch("RANCHER_URL", "http://rancher.stag.avvo.com:8080/v1/")
rancher_access_key = ENV["RANCHER_ACCESS_KEY"]
rancher_secret_key = ENV["RANCHER_SECRET_KEY"]
jenkins_host = ENV.fetch("JENKINS_HOST", "10.3.48.66")
jenkins_user = ENV["JENKINS_USER"]
jenkins_pass = ENV["JENKINS_PASS"]

Rancher::Api.configure do |config|
  config.url = rancher_url
  config.access_key = rancher_access_key
  config.secret_key = rancher_secret_key
end
JENKINS = JenkinsApi::Client.new({
  server_ip: jenkins_host,
  username: jenkins_user,
  password: jenkins_pass
})

def update_config(jenkins, instance, json, failures = 0)
  return false if failures > 2
  # update with the real config
  jenkins.api_post_request("/computer/doCreateItem", {name: instance.name, type: "hudson.slaves.DumbSlave$DescriptorImpl", json: json.to_json})
rescue => e
  pp e.message
  update_config(jenkins, instance, json, failures + 1)
end

def update_hostname(hostname)
  service = nil
  instance = nil

  env = Rancher::Api::Environment.all.detect do |env|
    service = env.services.where(name: "jenkins").detect do |service|
      instance = service.instances.detect{|instance| instance.externalId.match(hostname)}
    end
  end

  unless instance
    puts "Error: couldn't find a container matching hostname: #{hostname}"
    exit(1)
  end

  puts "service:"
  pp service.name
  endpoint = service.publicEndpoints.detect{|e| e["instanceId"] == instance.id}
  pp endpoint

  puts "instance:"
  pp instance.id
  pp instance.externalId
  pp instance.name

  puts "should ssh to #{endpoint["ipAddress"]}:#{endpoint["port"]}"

  json = {
    "name" => instance.name,
    "description" => "Jenkins slave running on docker",
    "remoteFS" => "/tmp",
    "numExecutors" => 1,
    "mode" => "NORMAL",
    "type" => "hudson.slaves.DumbSlave$DescriptorImpl",
    "launcher" => {
      "stapler-class" => "hudson.plugins.sshslaves.SSHLauncher",
      "host" => endpoint["ipAddress"],
      "port" => endpoint["port"],
      "credentialsId" => "923cbcc1-9e48-495b-a675-d3749131cd4a"
    },
    "labelString" => "docker phantomjs nodejs wkhtmltopdf launchable mysqlcommandline libgeos",
    "nodeProperties" => {
      "stapler-class-bag" => true,
      "hudson-slaves-EnvironmentVariablesNodeProperty" => {
        "env" => [
          {"key" => "DB_HOST", "value" => "mysql"},
          {"key" => "DB_PASS", "value" => "root"},
          {"key" => "DB_PORT", "value" => "3306"},
          {"key" => "DB_USER", "value" => "root"},
          {"key" => "HOME", "value" => "/home/jenkins"},
          {"key" => "MEMCACHED_HOSTS", "value" => "memcached:11211"},
          {"key" => "PATH", "value" => "/usr/local/rvm/bin:$PATH"},
          {"key" => "REDIS_HOST", "value" => "redis"},
          {"key" => "REDIS_PORT", "value" => "6379"}
        ]
      },
      "org-jenkinsci-plugins-envinject-EnvInjectNodeProperty" => {
        "unsetSystemVariables" => true,
        "propertiesFilePath" => "/home/jenkins/environment.properties"
      }
    }
  }

  begin
    JENKINS.node.get_config(instance.name)
  rescue JenkinsApi::Exceptions::NotFound
    update_config(JENKINS, instance, json)
  end
end

update_hostname(hostname)
