#!/usr/bin/env sh
#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---

echo "** Installing OS Dependencies **"

# lita needs redis
apt-get install redis-server -qy

# your daemon script needs this
apt-get install make -qy

echo "** Installing Lita and starting it! **"
make run

echo "** Scheduling Lita to Rebuild from Docker Hub Hourly **"
crontab ./lita_crontab

echo "** Done! Waiting 5 seconds then showing docker logs. **"

sleep 5
make log
