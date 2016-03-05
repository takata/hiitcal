#!/usr/bin/env bash
#  GoogleCalenter(ics) to
#   Twitter
#   WordPress
#   facebook

script_dir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"
cd ${script_dir}

# load rvm ruby
source /usr/local/rvm/environments/ruby-2.3.0

# load env
source .env

# ics download
test -f basic.ics.2 && mv basic.ics.2 basic.ics.3
test -f basic.ics.1 && mv basic.ics.1 basic.ics.2
test -f basic.ics   && mv basic.ics   basic.ics.1
wget --quiet --output-document=basic.ics ${ICS_URL}

test -s basic.ics || { echo "calendar-get-error" ; exit 1; }

# make list
test -f basic.tsv.2 && mv basic.tsv.2 basic.tsv.3
test -f basic.tsv.1 && mv basic.tsv.1 basic.tsv.2
test -f basic.tsv   && mv basic.tsv   basic.tsv.1

cat basic.ics | ./ics2tsv.rb | sed 's/\\\,/\,/' | sort > basic.tsv

diff basic.tsv.1 basic.tsv | egrep "^> " | cut -c3- > basic.tsv.diff

test -s basic.tsv.diff || { exit 0; }

# tweet
cat basic.tsv.diff | \
 awk -F"\t" '{print "[更新] "$1" "$3" "$5" '"${HASHTAG}"' '"${CALENDAR_URL}"'"}' \
 > tweet.lst

if test -s tweet.lst ; then
  cat tweet.lst | ./tweetline.rb
fi

# WordPress
cat basic.tsv.diff > wordpress.tsv

if test -s wordpress.tsv ; then
  cat wordpress.tsv | ./wpxmlrpcline.rb
fi

# Facebook
cat basic.tsv.diff > facebook.tsv

if test -s facebook.tsv ; then
  cat facebook.tsv | ./facebookline.rb
fi
