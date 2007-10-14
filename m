From: Alberto Alonso <alberto@ggsys.net>
Subject: Re: Software RAID when it works and when it doesn't
Date: Sun, 14 Oct 2007 00:57:58 -0500
Message-ID: <1192341478.16416.298.camel@w100>
References: <1192300851.16416.265.camel@w100>
	 <18193.19362.170894.944922@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18193.19362.170894.944922@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 2007-10-14 at 08:50 +1000, Neil Brown wrote:
> On Saturday October 13, alberto@ggsys.net wrote:
> > Over the past several months I have encountered 3
> > cases where the software RAID didn't work in keeping
> > the servers up and running.
> > 
> > In all cases, the failure has been on a single drive,
> > yet the whole md device and server become unresponsive.
> > 
> > (usb-storage)
> > In one situation a RAID 0 across 2 USB drives failed
> > when one of the drives accidentally got turned off.
> 
> RAID0 is not true RAID - there is no redundancy.  If one device in a
> RAID0 fails, the whole array will fail.  This is expected.

Sorry, I meant RAID 1. Currently, we only use RAID 1 and RAID 5 on all
our systems.

> 
> > 
> > (sata)
> > A second case a disk started generating reports like:
> > end_request: I/O error, dev sdb, sector 42644555
> 
> So the drive had errors - not uncommon.  What happened to the array?

The array never became degraded, it just made the system
hang. I reported it back in May, but couldn't get it
resolved. I replaced the system and unfortunately went
to a non-RAID solution for that server.

> > 
> > (sata)
> > The third case (which I'm living right now) is a disk
> > that I can see during the boot process but that I can't
> > get operations on it to come back (ie. fdisk -l /dev/sdc). 
> 
> You mean "fdisk -l /dev/sdc" just hangs?  That sounds like a SATA
> driver error.  You should report it to the SATA developers
>    linux-ide@vger.kernel.org
> 
> md/RAID cannot compensate for problems in the driver code.  It expects
> every request that it sends down to either succeed or fail in a
> reasonable amount of time.

Yes, that's exactly what happens. fdisk, dd or any other disk
operation just hanged.

I will report it there, thanks for the pointer.

> 
> > 
> > (pata)
> > I have had at least 4 situations on old servers based
> > on pata disks where disk failures where successful in
> > being flagged and arrays where degraded automatically.
> 
> Good!

Yep, after these results I stopped using hardware RAID. I
went 100% software RAID on all systems other than a few
SCSI hardware RAID systems that we bought as a set. Until this
year that is, when I switched back to hardware RAID for our new
critical systems due to the problems I saw back in May.
> 
> > 
> > So, this is all making me wonder under what circumstances
> > software RAID may have problems detecting disk failures.
> 
> RAID1, RAID10, RAID4, RAID5, RAID6 will handle errors that are
> correctly reported by the underlying device.

Yep, that's what I always thought, I'm just surprised
I had so many problems this year. It makes me wonder the
reliability of the whole thing though.

Even if it is an underlying layer, can the md code implement
its own timeouts?
> 
> > 
> > I need to come up with a best practices solution and also
> > need to understand more as I move into raid over local
> > network (ie. iscsi, AoE or NBD). Could a disk failure in
> > one of the servers or a server going offline bring the
> > whole array down?
> 
> It shouldn't, providing the low level driver is functioning correctly,
> and providing you are using true RAID (not RAID0 or LINEAR).
> NeilBrown
> -

Sorry again for the RAID 0 mistake, I really did mean RAID 1.

I guess that since I had 3 distinct servers crash this year on me 
I am getting paranoid. Is there a test suite or procedure that I can 
do to test for everything that can go wrong?

You mentioned that the md code can not compensate for problems in
the driver code. Couldn't some internal timeout mechanisms help?
I can't no longer use software RAID on SATA for new production 
systems. I've switched to 3ware cards, but they are pricey and we
really don't need them for most of our systems.

I really would like to move to server clusters and RAID on the
network devices for our larger arrays, but I need a way to properly
test every scenario, as those are our critical servers and can not
go down. I would like to figure out a "best practices procedure" that
will ensure the correct degrading of the array upon a single failure,
regardless of the underlying driver (ie. SATA, iSCSI, NBD, etc.) Am
I thinking too much?

Thanks,

Alberto


