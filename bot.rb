# frozen_string_literal: true

require 'selenium-webdriver'
require 'watir'

class Bot
  class << self
    def notify(message)
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK'] do
        defaults channel: '#secrete', username: "Devil's Notifier"
      end

      notifier.ping("@here #{message}")
    end

    def site_login
      browser.goto('https://ppt.mfa.gov.cn/appo/index.html')

      browser.element(xpath: "//button/span[text()='我已知晓']/..").click

      browser.element(xpath: "//a/span[@id='continueReservation']/..").click

      browser.element(xpath: "//input[@id='recordNumberHuifu']").send_keys(ENV['RECORD_NUMBER'])

      question_dropdown = browser.select(id: 'questionIDHuifu')

      question_dropdown.select(/#{ENV["QUESTION"]}/)

      browser.element(xpath: "//input[@id='answerHuifu']").send_keys(ENV['ANSWER'])

      browser.element(xpath: "//button/span[text()='提交']/..").click

      browser.element(xpath: "//input[@value='进入预约']").click

      browser.element(xpath: "//button/span[text()='确认']/..").click

      address_dropdown = browser.select(id: 'address')

      address_dropdown.select(/多伦多不见面办理/)
    end

    def find_available_slots
      elemenmts = browser.elements(xpath: "//span[@class='fc-event-title']")
      available = 0
      elemenmts.each do |element|
        booked, total = element.text.strip.split('/').map(&:to_i)
        puts "Checking slot #{element.text} ..."
        available = available + total - booked if booked < total
      end

      if available > 0
        notify "Found #{available} slot!!"
      else
        notify 'No slot found'
      end
    end

    def browser
      @driver ||= create_driver
    end

    def load_cookies(file)
      browser.cookies.load(file)
    end

    def create_driver
      if ENV['REMOTE_SELENIUM'] == 'true'
        Watir::Browser.new(:chrome,
                           { timeout: 2000, url: ENV['REMOTE_SELENIUM_URL'],
                             use_capabilities: { unexpected_alert_behaviour: 'accept' } })
      else
        Watir::Browser.new(:chrome, headless: true)
      end
    end
  end
end
