#!/bin/bash
# get hiitcal & tweet URL http://j.mp/hiitcal

script_dir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"
cd $script_dir

test -f basic.ics.2 && mv basic.ics.2 basic.ics.3
test -f basic.ics.1 && mv basic.ics.1 basic.ics.2
test -f basic.ics   && mv basic.ics   basic.ics.1
wget --quiet --output-document=basic.ics https://www.google.com/calendar/ical/5udlp7brhcnbuv0mq7t0jcmh04%40group.calendar.google.com/public/basic.ics

test -s basic.ics || { echo "calendar-get-error" ; exit 1; }

test -f basic.lst.2 && mv basic.lst.2 basic.lst.3
test -f basic.lst.1 && mv basic.lst.1 basic.lst.2
test -f basic.lst   && mv basic.lst   basic.lst.1

cat basic.ics | ./ics2lst.rb | sort > basic.lst

diff basic.lst.1 basic.lst | egrep "^> " | cut -c3- > basic.lst.diff

test -s basic.lst.diff || { exit 0; }

cat basic.lst.diff | \
 awk '{print "[更新] "$0" #hiitcal http://j.mp/hiitcal"}' \
 > tweet.lst

if test -s tweet.lst ; then
  cat tweet.lst | ./tweetline.rb
fi
