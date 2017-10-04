require "vg_api/version"
require "httparty"
require "yaml"
require 'active_support'
require 'active_support/core_ext'

require "vg_api/version"
require "vg_api/client"
require "vg_api/player"
require "vg_api/matches/record"
require "vg_api/matches/collection"
require "vg_api/matches/match"
require "vg_api/matches/participant"
require "vg_api/matches/player"
require "vg_api/matches/roster"

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
