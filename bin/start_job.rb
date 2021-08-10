#!/usr/bin/env ruby

require 'dotenv/load'
require 'clockwork'
require 'slack-notifier'
require 'active_support/time'
require_relative '../bot'

include Clockwork

def run
  Bot.site_login
  Bot.find_available_slots
end

every(5.minutes, 'check_available_slot.job') { run }
