From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Disk I/O error while rebuilding an md raid-5 array
Date: Tue, 9 Feb 2010 20:28:45 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002092027350.31777@uplift.swm.pp.se>
References: <adf93d751002081523y1b9de656kdbba276b3dbc6af4@mail.gmail.com>  <87f94c371002081604g37984161h2ba65bd193714780@mail.gmail.com>  <4B714D92.2090802@anonymous.org.uk> <adf93d751002090943x697cb222x3b80b53bae0a0f0a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-225144756-1265743725=:31777"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <adf93d751002090943x697cb222x3b80b53bae0a0f0a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dawning Sky <the.dawning.sky@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-225144756-1265743725=:31777
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 9 Feb 2010, Dawning Sky wrote:

> 2. Quite a few people talked about "scrubbing" the raid, can someone 
> point me to somewhere I can read more about it?  I'm new to the list. I 
> tried googling and reading the list wiki and had a hard time finding a 
> tutorial for setting this up.

My debian/ubuntu boxes do this every sunday night via:

swmike@ub:/etc/cron.d$ cat mdadm
#
# cron.d/mdadm -- schedules periodic redundancy checks of MD devices
#
# Copyright © martin f. krafft <madduck@madduck.net>
# distributed under the terms of the Artistic Licence 2.0
#

# By default, run at 00:57 on every Sunday, but do nothing unless the day of
# the month is less than or equal to 7. Thus, only run on the first Sunday of
# each month. crontab(5) sucks, unfortunately, in this regard; therefore this
# hack (see #380425).
57 0 * * 0 root [ -x /usr/share/mdadm/checkarray ] && [ $(date +\%d) -le 7 ] && /usr/share/mdadm/checkarray --cron --all --quiet



-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-225144756-1265743725=:31777--
