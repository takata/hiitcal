#!/usr/bin/ruby
# tweet line

require 'rubygems'
require 'twitter'
require 'pp'

sleeptime = 10

@client = Twitter::REST::Client.new(
    :consumer_key        => "[consumer_key]",
    :consumer_secret     => "[consumer_secret]",
    :access_token        => "[access_token]",
    :access_token_secret => "[access_token_secret]"
)

for line in STDIN
  twstr = line.chomp
  @client.update(twstr)
  sleep(sleeptime)
end
