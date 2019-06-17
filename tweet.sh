#!/bin/bash -l
cd ~/FixmeBot
bundle exec ruby -e "load 'fixme_bot.rb'; FixmeBot.new.tweet_something" &>> cron.log
