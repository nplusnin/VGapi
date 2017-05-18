require "vg_api/version"
require "httparty"
require "yaml"

require_relative "vg_api/client"
require_relative "vg_api/resources/player"

module VgApi
  attr_reader :config, :access_token

  def self.config
    @config ||= YAML::load_file(File.join(__dir__, '../config/vg_api_config.yml'))
  end

  def self.access_token
    @access_token ||= config['VG_ACCESS_TOKEN']
  end
end
