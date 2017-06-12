require "vg_api/version"
require "httparty"
require "yaml"

require_relative "vg_api/client"
require_relative "vg_api/match"

module VgApi
  attr_reader :config, :access_token, :client

  def self.config
    @config ||= YAML::load_file('config/vg_api_config.yml')
  end

  def self.access_token
    @access_token ||= config['VG_ACCESS_TOKEN']
  end

  def self.client
    @client ||= Client.new
  end
end
