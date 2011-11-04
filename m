From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Impending failure?
Date: Fri, 4 Nov 2011 15:33:42 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1111041529150.19721@uplift.swm.pp.se>
References: <CAB1R3sh8=9imi41OTXRjf2ScoB=9WLZLHqL-WECOSyDuixVzrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-221118457-1320417222=:19721"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sh8=9imi41OTXRjf2ScoB=9WLZLHqL-WECOSyDuixVzrg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-221118457-1320417222=:19721
Content-Type: TEXT/PLAIN; format=flowed; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Fri, 4 Nov 2011, Alex wrote:

> Can you point me to instructions on the best way to replace a disk?

First run "repair" on the array, hopefully it'll notice the unreadable 
blocks and re-write them.

echo repair >> /sys/block/md0/md/sync_action

Also make sure your OS does regular scrubs of the raid, usually this is 
done by monthly runs of checkarray, this is an example from Ubuntu:

:/etc/cron.d$ cat mdadm
#
# cron.d/mdadm -- schedules periodic redundancy checks of MD devices
#
# Copyright © martin f. krafft <madduck@madduck.net>
# distributed under the terms of the Artistic Licence 2.0
#

# By default, run at 00:57 on every Sunday, but do nothing unless the day 
of
# the month is less than or equal to 7. Thus, only run on the first Sunday 
of
# each month. crontab(5) sucks, unfortunately, in this regard; therefore 
this
# hack (see #380425).
57 0 * * 0 root if [ -x /usr/share/mdadm/checkarray ] && [ $(date +\%d) -le 7 ]; then /usr/share/mdadm/checkarray --cron --all --idle --quiet; fi

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-221118457-1320417222=:19721--
