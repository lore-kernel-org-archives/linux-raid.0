From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Raid check didn't fix Current_Pending_Sector, but badblocks -nsv
 did
Date: Tue, 7 Jun 2016 15:56:40 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1606071551080.28955@uplift.swm.pp.se>
References: <20160606174113.GI12382@merlins.org> <5755CA9F.6090807@prgmr.com> <20160606224401.GA6672@merlins.org> <57561B38.1070402@turmel.org> <20160607045122.GL12382@merlins.org> <5756C67A.2040109@turmel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5756C67A.2040109@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 7 Jun 2016, Phil Turmel wrote:

> Or just ignore them.  You aren't using them, so they can't hurt you. 
> However, do look at the sector numbers in the SMART reports to make sure 
> they aren't in the data area.  (If you aren't using the whole disk for 
> mdadm, be sure to adjust for the partition start sector.)  If they *are* 
> in the data area, watch dmesg while scrubbing to see what's really 
> happening.

I had a similar problem a few years back.

I seem to remember that there was a problem that the pending blocks were 
in the superblock area, and these weren't written out when I did "check" 
or "repair". I might be misremembering though, but I seem to remember I 
had some kind of problem that when I tried to add the dive back in again, 
it got a read error when trying to read the superblock.

They might have also been in the offset area. What I did was that I did a 
--replace to another drive, then I dd:ed /dev/zero to the first gigabyte 
of the drive, which removed the pending blocks. I then added the drive 
back in.

Could someone confirm whether the entire (actually valuable portion) of 
the superblock area is written out at any kind of frequency, or when a 
check/repair is issued? If not, I think that would be a valuable thing to 
do?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
