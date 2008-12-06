From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: time limited error recovery and md raid
Date: Sat, 6 Dec 2008 05:53:05 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812060552370.4696@p34.internal.lan>
References: <1228510646.16555.73.camel@localhost>  <alpine.DEB.1.10.0812051600410.17806@p34.internal.lan> <1228511266.16555.81.camel@localhost> <alpine.DEB.1.10.0812051609070.17806@p34.internal.lan> <493A54B7.7070805@ziu.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <493A54B7.7070805@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: Redeeman <redeeman@metanurb.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 6 Dec 2008, Michal Soltys wrote:

> Justin Piszcz wrote:
>> 
>>> when tler is on, why does linux not attempt to remap the sector?
>> See my earlier posts on this question from last week.  It would need a 
>> metadata section on each HDD to keep track of the bad sectors before it 
>> writes to the drives, a 3ware card will do this for you-- however, 
>> typically, (having run md/linux) for a number of years is not 
>> super-necessary if you run checks on your disks once a week *AND* you have 
>> good drives that don't have problems.
>> 
>
> From what I know, md does attempt to repair read errors (but not other ones 
> though) with rewrite, and only if it fails, it will kick the drive out of the 
> array. In case of 1.x superblocks, the count of repaired (+ ones not causing 
> drive to be kicked off) sectors will be preserved across reboots as well 
> (check Documentation/md.txt). Peeking over the code seems to confirm it as 
> well.
It appears so:

[ 1215.654712] raid5:md3: read error not correctable (sector 213000256 on sde1).
[ 1215.654765] raid5: Disk failure on sde1, disabling device.
[ 1215.654766] raid5: Operation continuing on 8 devices.
[ 1215.655412] raid5:md3: read error not correctable (sector 213000264 on sde1).
[ 1215.655473] raid5:md3: read error not correctable (sector 213000272 on sde1).
[ 1215.655533] raid5:md3: read error not correctable (sector 213000280 on sde1).
[ 1215.655592] raid5:md3: read error not correctable (sector 213000288 on sde1).
[ 1215.655644] raid5:md3: read error not correctable (sector 213000296 on sde1).
[ 1215.655694] raid5:md3: read error not correctable (sector 213000304 on sde1).
[ 1215.655746] raid5:md3: read error not correctable (sector 213000312 on sde1).
[ 1215.655800] raid5:md3: read error not correctable (sector 213000320 on sde1).
[ 1215.655852] raid5:md3: read error not correctable (sector 213000328 on sde1).

Justin.

