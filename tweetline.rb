#!/usr/bin/env ruby
# stdin to twitter

require 'rubygems'
require 'twitter'
require 'pp'
require 'dotenv'

Dotenv.load

sleeptime = ENV["SLEEPTIME"].to_i

@client = Twitter::REST::Client.new(
    :consumer_key        => ENV["TWITTER_CONSUMER_KEY"],
    :consumer_secret     => ENV["TWITTER_CONSUMER_SECRET"],
    :access_token        => ENV["TWITTER_ACCESS_TOKEN"],
    :access_token_secret => ENV["TWITTER_ACCESS_TOKEN_SECRET"]
)

STDIN.each do |line|
  @client.update(line.chomp)
  sleep(sleeptime)
end
