From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: How do I tell which disk failed?
Date: Mon, 07 Jan 2013 23:49:46 -0800
Message-ID: <1357631387.16366.131.camel@corn.betterworld.us>
References: <1357610701.16366.13.camel@corn.betterworld.us>
	 <50EBAC5D.8080000@hardwarefreak.com>
	 <1357628351.16366.86.camel@corn.betterworld.us>
	 <02B6762C-3755-4CE3-9AB1-A48D3384CACB@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02B6762C-3755-4CE3-9AB1-A48D3384CACB@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: ross@biostat.ucsf.edu, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2013-01-08 at 00:17 -0700, Chris Murphy wrote:
> On Jan 7, 2013, at 11:59 PM, Ross Boylan <ross@biostat.ucsf.edu> wrote:
> >> 
> > Isn't it possible there's a hardware problem, e.g., leading to a
> > failure/retry cycle?
> 
> smartctl -a /dev/sda
> smartctl -a /dev/sdb
> smartctl -a /dev/sdc
> 
> Compare them. If there was a write failure reported by the drive, md would have marked the device faulty.
SMART seems to think they are all OK, though my understanding of it is
limited (e.g., the logs showed SMART reporting Temperature_Celsius of
110, but I think that's a normalized value for a raw of 42, meaning the
temp is 42 degrees celsius).  Do I need to manually run a test before
the report reflects current conditions?  At any rate, I did (just a
short one), and the drives passed.

The raw value (last column) for one of the parameters seems to be
changing extremely rapidly, and perhaps is overflowing:
# date; smartctl -a /dev/sda | grep 195
Mon Jan  7 23:11:03 PST 2013
195 Hardware_ECC_Recovered  0x001a   059   024   000    Old_age   Always       -       241377818
# date; smartctl -a /dev/sda | grep 195
Mon Jan  7 23:12:26 PST 2013
195 Hardware_ECC_Recovered  0x001a   056   024   000    Old_age   Always       -       3600778
Perhaps someone on this list can interpret that better than I.


My thought was disk failure (not necessarily complete failure) -> system
lockup.  Continued disk flakiness leads to continued slowness after
restart as, e.g., the disk keeps retrying operations that fail.

I infer you have a different scenario in mind: the system freaks out for
a reason unrelated to the disk.  The resulting shutdown (which was a
manual power off) leaves the arrays and their components in a funky
state.  When the system comes back, it fixes things up.

Even if this did happen, in RAID 1 wouldn't some of the componnents
(partitions in my case) be deemed good and others bad, with the latter
resynced to match the former?  And if that is happening, why can't I
tell which partition(s) are master (considered good) and which are not
(being overwritten with contents of the master)?

The sync just completed, so I can no longer poke around while the
rebuild is in process.  Bad for learning and diagnosis, but good for
almost every other purpose.

Ross

