#!/usr/bin/env ruby
# GoogleCalenter(ics) to Textlist

require 'rubygems'
require 'icalendar'

cals = Icalendar.parse($stdin)
cal = cals.first

now = Time.new

cal.events
  .select { |e| e.dtstart > now }
  .sort_by(&:dtstart)
  .each { |e|
    start = e.dtstart.to_time.localtime.strftime('%Y-%m-%d %H:%M')
    puts [start,e.summary,e.description].join(' ')
  }
