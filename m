From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: 3ware 7500-12, bad write speed
Date: Wed, 25 Sep 2002 22:43:11 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209252237100.23239-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I have a 6 drive (120 gig drives) RAID5 using a 3ware 7500-12. I have the
latest firmware (7.5.1), latest driver etc, everything looks up to spec. I
get great read speeds (60-80 megabyte/s), but I get very erratic write
speeds (average 15 megabyte/s or so).

Using "iostat -x 5" I see that writes are sometimes done at 25 meg/s to
the raid5, some intervals at 5 meg/s, etc, with an average of approx 12-15
megabyte/s. Writes seem very jerky.

Anyone seen this and solved it? I currently get better write speeds to a
single IBM 7200rpm 75 gig drive (~25-30 meg/s) than to the 6 drive RAID5
volume (I use the 3ware card to create the volume, no software raid).

3ware support seems at a loss as to what causes this. I see it both with 
my SMP system and another UP system (both using Redhat 7.3 supplied 
kernels and the latest firmware/drivers for each card). I use ext3 in all 
all these cases.

They suggested changing the bdflush values but I have already done that, 
and in my mind if it was a bdflush problem I would see the same problem to 
the single drive as well?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

