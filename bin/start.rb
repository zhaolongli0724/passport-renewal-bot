#!/usr/bin/env ruby

require 'dotenv/load'
require 'slack-notifier'
require_relative '../bot'


def run
  Bot.site_login
  Bot.find_available_slots
end

run