#!/usr/bin/env ruby
# GoogleCalenter(ics) to TSV

require 'time'

dtnow = Time.now

if ARGV.count == 1 then
  dtnow = Time.parse(ARGV[0])
end

dtlocal = dtnow

dtstart = ""
dtend = ""
description = ""
location = ""
summary = ""

STDIN.each do |line|
  str = line.chomp
  case str
  when /^DTSTART:20/
    dtstarttmp = str.gsub(/DTSTART:/,"")
    year  = dtstarttmp[0..3]
    month = dtstarttmp[4..5]
    day   = dtstarttmp[6..7]
    hour  = dtstarttmp[9..10]
    min   = dtstarttmp[11..12]
    sec   = dtstarttmp[13..14]
    dtgm = Time.gm(year, month, day, hour, min, sec)
    dtlocal = dtgm + 60 * 60 * 9
    dtstart = dtlocal.strftime("%Y-%m-%d %H:%M")
  when /^DTEND:20/
    dtstarttmp = str.gsub(/DTEND:/,"")
    year  = dtstarttmp[0..3]
    month = dtstarttmp[4..5]
    day   = dtstarttmp[6..7]
    hour  = dtstarttmp[9..10]
    min   = dtstarttmp[11..12]
    sec   = dtstarttmp[13..14]
    dtgm = Time.gm(year, month, day, hour, min, sec)
    dtlocal = dtgm + 60 * 60 * 9
    dtend = dtlocal.strftime("%Y-%m-%d %H:%M")
  when /^DESCRIPTION:/
    description = str.gsub(/DESCRIPTION:/,"")
  when /^LOCATION:/
    location = str.gsub(/LOCATION:/,"")
  when /^ /
    description = description + str.gsub(/^ /,"")
  when /^SUMMARY:/
    summary = str.gsub(/SUMMARY:/,"")
  when /END:VEVENT/
    if dtlocal > dtnow then
      print dtstart,"\t",dtend,"\t",summary,"\t",location,"\t",description,"\n"
      dtlocal = dtnow
    end
  end
end
