From: dean gaudet <dean@arctic.org>
Subject: Re: Is my RAID broken?
Date: Mon, 6 Nov 2006 00:17:50 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0611060015180.20361@twinlark.arctic.org>
References: <e50d039c0611042329m29046e6fjf56a8f52a82294ad@mail.gmail.com>
 <17742.25624.469667.437194@cse.unsw.edu.au> <Pine.LNX.4.64.0611060858260.5535@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="131011217-260578305-1162801070=:20361"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0611060858260.5535@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--131011217-260578305-1162801070=:20361
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 6 Nov 2006, Mikael Abrahamsson wrote:

> On Mon, 6 Nov 2006, Neil Brown wrote:
> 
> > So it looks like you machine recently crashed (power failure?) and it is
> > restarting.
> 
> Or upgrade some part of the OS and now it'll do resync every week or so (I
> think this is debian default nowadays, don't know the interval though).

it should be only once a month... and it's just a "check" -- it reads 
everything and corrects errors.

i think it's a great thing actually... way more useful than smart long 
self-tests because md can reconstruct read errors immediately -- before 
you lose redundancy in that stripe.

-dean

% cat /etc/cron.d/mdadm
#
# cron.d/mdadm -- schedules periodic redundancy checks of MD devices
#
# Copyright © martin f. krafft <madduck@madduck.net>
# distributed under the terms of the Artistic Licence 2.0
#
# $Id: mdadm.cron.d 147 2006-08-30 09:26:11Z madduck $
#

# By default, run at 01:06 on every Sunday, but do nothing unless the day of
# the month is less than or equal to 7. Thus, only run on the first Sunday of
# each month. crontab(5) sucks, unfortunately, in this regard; therefore this
# hack (see #380425).
6 1 * * 0 root [ -x /usr/share/mdadm/checkarray ] && [ $(date +\%d) -le 7 ] && /usr/share/mdadm/checkarray --cron --all --quiet
--131011217-260578305-1162801070=:20361--
