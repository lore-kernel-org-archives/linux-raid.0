From: Rory Jaffe <rsjaffe@gmail.com>
Subject: Resync intermittently writes to spare drives, waking them up
Date: Wed, 13 Apr 2011 14:10:46 -0700
Message-ID: <BANLkTikqAaS91n06Xw7SwWcMKik_8E0iHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a RAID5 array with 4 active devices and two spares. The spares
are normally in sleep mode. I ran a resync with:

echo repair > /sys/devices/virtual/block/md0/md/sync_action

About 20 times (evenly spaced apart) during the resync, the spares
were written to, waking them up. Is that behavior desired? It seems to
me that it's a waste--I don't know why the resync would bother with
the spares.

--Rory
