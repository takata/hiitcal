#!/usr/bin/env ruby
# coding: utf-8

require 'time'
require 'xmlrpc/client'
require 'uri'
require 'dotenv'
require 'csv'

Dotenv.load

sleeptime = ENV["SLEEPTIME"].to_i

def post(title , description)
wordpress_host = ENV["WORDPRESS_HOST"]
wordpress_userid = ENV["WORDPRESS_USERID"]
wordpress_password = ENV["WORDPRESS_PASSWORD"]
wordpress_categories = ENV["WORDPRESS_CATEGORIES"]

  post = 'post'
  date = Time.now
  publish = 1 # 0:draft,1:publich

  server = XMLRPC::Client.new(wordpress_host, '/xmlrpc.php')

  struct = {
    'title' => title,
    'categories' => [wordpress_categories],
    'description' => description,
    'dateCreated' => date
  }

  id = server.call("metaWeblog.newPost",1,wordpress_userid,wordpress_password,struct,publish)
end

CSV(STDIN, :col_sep => "\t").each do |row|
  title = row[0].split(/ /)[0] << " " << row[2]
  placeenc = URI.encode(row[3].split(/ /)[0])
  description = <<"EOS"
開始 #{row[0]}
終了 #{row[1]}
場所 <a href="https://www.google.co.jp/maps/place/#{placeenc}">#{row[3]}</a>
URL  <a href="#{row[4]}">#{row[4]}</a>
EOS
  post(title , description)
  sleep(sleeptime)
end
