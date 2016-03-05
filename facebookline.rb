#!/usr/bin/env ruby

require 'rubygems'
require 'koala'
require 'dotenv'
require 'csv'

Dotenv.load

sleeptime = ENV["SLEEPTIME"].to_i

facebook_admin_access_token=ENV["FACEBOOK_ADMIN_ACCESS_TOKEN"]
facebook_page_id=ENV["FACEBOOK_PAGE_ID"]

@user_graph = Koala::Facebook::API.new(facebook_admin_access_token)
accounts = @user_graph.get_connections('me', 'accounts')
page = accounts.find{|a| a['id'] == facebook_page_id}

@page_graph = Koala::Facebook::API.new(page['access_token'])

CSV(STDIN, :col_sep => "\t").each do |row|
  placeenc = URI.encode(row[3].split(/ /)[0])

  post_message =  <<"EOS"
#{row[2]}
開始 #{row[0]}
終了 #{row[1]}
場所 #{row[3]}
URL  #{row[4]}
EOS
  post_name   = row[2]
  post_link   = row[4]
  @page_graph.put_object(page['id'], 'feed',{:message => post_message,:name => post_name, :link => post_link})

  sleep(sleeptime)

end
