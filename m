From: Adam Radford <aradford@3WARE.com>
Subject: RE: 3ware 7500-12, bad write speed
Date: Wed, 25 Sep 2002 14:12:17 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A1964EDB64C8094DA12D2271C04B812672C6FC@tabby>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Mikael Abrahamsson' <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is because of the vmlayer and your bdflush settings and the fact that
you are
running a journalling filesystem.  Our raid 5 caching strategy gives the
best results when
given sequential writes.  Doing journaling fs and caching writes in the
vmlayer causes the firmware caching strategy to perform 'sub optimal' since
the lba's accessed aren't actually
sequential.  Thus your 15 MB/s.  We do do elevator seek in the FW, but this
can only help
you so much.

What you are benchmarking is VM layer performance+filesystem
performance+3ware device
performance.

Try some other settings or use a benchmark that issues raw asynchronous IO
(not filesystem benchmark) (Iometer for Linux?)

-Adam

-----Original Message-----
From: Mikael Abrahamsson [mailto:swmike@swm.pp.se]
Sent: Wednesday, September 25, 2002 1:43 PM
To: linux-raid@vger.kernel.org
Subject: 3ware 7500-12, bad write speed



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

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
