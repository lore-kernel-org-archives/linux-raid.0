From: "David Lethe" <david@santools.com>
Subject: RE: Mapping physical disk block to logical block to selectively repair w/o forcing rescan
Date: Tue, 15 Apr 2008 21:47:37 -0500
Message-ID: <A49AB75A717185448F69082E969E536B03C264CC@34093-EVS1C2.exchange.rackspace.com>
References: <A49AB75A717185448F69082E969E536B03C2647E@34093-EVS1C2.exchange.rackspace.com> <e9c3a7c20804151735n6793339dl764c0d57aedabc57@mail.gmail.com> <e9c3a7c20804151737k44b09572x484c7c41ff90e09d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <e9c3a7c20804151737k44b09572x484c7c41ff90e09d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have the physical disk sector/drive, so I will have to go backwards.
That means using compute_blocknr, factoring the chunk size, stripe size,
look at the raid5_private_data to get everything else, including whether
or not it is in a rebuild, what position the disk has in the stripe,
among
other things .. and repeat for RAID6.  Still all scriptable .. as long
as I keep the block calculations in 64-bits when on 32-bit kernel. 

I can parse mdadm -Q -D  to get health and configuration, or get it from
sysfs, haven't decided.

Now for recovery ... a change was made in 2.6.15 that affects how the
/dev/md recalculates & corrects the error, but I don't think I have to
worry about it. Just directly read the /dev/md block that corresponds to
the faulty physical disk/sector.  This should just repair the bad block
w/o enticing the md system to fail over the entire disk.  Exception
would be if the disk with bad block can remap due to a catastrophic
failure, or lack of spare sectors.  

Even if the bad physical block lands on a parity block in the /dev/md
space, it should get rebuilt because it has to read the entire stripe to
figure out if there is a parity error, which there will be because one
disk will return the sense data indicating an unrecoverable read error,
so the md will repair the stripe to keep parity consistent for me.




-----Original Message-----
From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On
Behalf Of Dan Williams
Sent: Tuesday, April 15, 2008 7:37 PM
To: David Lethe
Cc: linux-raid@vger.kernel.org
Subject: Re: Mapping physical disk block to logical block to selectively
repair w/o forcing rescan

>  >
>  >  Any advice, comments, code will be appreciated.
>  >
>
>  raid5_compute_sector() in drivers/md/raid5.c maps the logical RAID
>  block to the physical block.  Is that what you are looking for?
>

...and compute_blocknr() goes the other way.

--
Dan


