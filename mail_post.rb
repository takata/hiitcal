#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require 'dotenv'
require 'csv'
require 'mail'
require 'mail-iso-2022-jp'

Dotenv.load

sleeptime = ENV["SLEEPTIME"].to_i

def post(title , description)
  mail_from = ARGV[0]
  mail_to = ARGV[1]

  mail = Mail.new(:charset => 'ISO-2022-JP')

  mail.from    = mail_from
  mail.to      = mail_to
  mail.subject = title
  mail.body    = description
  mail.deliver
end

CSV(STDIN, :col_sep => "\t").each do |row|
  title = row[0].split(/ /)[0] << " " << row[2]
  placeenc = URI.encode(row[3].split(/ /)[0])
  description = <<"EOS"
#{row[2]}
開始 #{row[0]}
終了 #{row[1]}
場所 #{row[3]}
URL  #{row[4]}
地図 https://www.google.co.jp/maps/place/#{placeenc}
EOS
  post(title , description)
  sleep(sleeptime)
end
