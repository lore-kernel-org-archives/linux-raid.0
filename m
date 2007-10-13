From: Neil Brown <neilb@suse.de>
Subject: Re: Software RAID when it works and when it doesn't
Date: Sun, 14 Oct 2007 08:50:10 +1000
Message-ID: <18193.19362.170894.944922@notabene.brown>
References: <1192300851.16416.265.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alberto Alonso on Saturday October 13
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday October 13, alberto@ggsys.net wrote:
> Over the past several months I have encountered 3
> cases where the software RAID didn't work in keeping
> the servers up and running.
> 
> In all cases, the failure has been on a single drive,
> yet the whole md device and server become unresponsive.
> 
> (usb-storage)
> In one situation a RAID 0 across 2 USB drives failed
> when one of the drives accidentally got turned off.

RAID0 is not true RAID - there is no redundancy.  If one device in a
RAID0 fails, the whole array will fail.  This is expected.

> 
> (sata)
> A second case a disk started generating reports like:
> end_request: I/O error, dev sdb, sector 42644555

So the drive had errors - not uncommon.  What happened to the array?


> 
> (sata)
> The third case (which I'm living right now) is a disk
> that I can see during the boot process but that I can't
> get operations on it to come back (ie. fdisk -l /dev/sdc). 

You mean "fdisk -l /dev/sdc" just hangs?  That sounds like a SATA
driver error.  You should report it to the SATA developers
   linux-ide@vger.kernel.org

md/RAID cannot compensate for problems in the driver code.  It expects
every request that it sends down to either succeed or fail in a
reasonable amount of time.

> 
> (pata)
> I have had at least 4 situations on old servers based
> on pata disks where disk failures where successful in
> being flagged and arrays where degraded automatically.

Good!

> 
> So, this is all making me wonder under what circumstances
> software RAID may have problems detecting disk failures.

RAID1, RAID10, RAID4, RAID5, RAID6 will handle errors that are
correctly reported by the underlying device.

> 
> I need to come up with a best practices solution and also
> need to understand more as I move into raid over local
> network (ie. iscsi, AoE or NBD). Could a disk failure in
> one of the servers or a server going offline bring the
> whole array down?

It shouldn't, providing the low level driver is functioning correctly,
and providing you are using true RAID (not RAID0 or LINEAR).

NeilBrown
