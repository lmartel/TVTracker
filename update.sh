#!/bin/sh

echo "Show.order('random()').each do |show| Episode.pull_episodes(show, false) end" | heroku run console 
