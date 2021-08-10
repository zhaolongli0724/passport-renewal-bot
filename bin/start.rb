#!/usr/bin/env ruby

require 'dotenv/load'
require_relative '../bot'
require 'slack-notifier'

def run
  Bot.site_login
  Bot.find_available_slots
end

run