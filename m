From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: AW: Stupid Question?
Date: Tue, 25 May 2004 09:40:16 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16562.34784.39714.28379@cse.unsw.edu.au>
References: <16562.32290.124423.951804@cse.unsw.edu.au>
	<S264409AbUEXXLR/20040524231117Z+335@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from robin-lists@robinbowes.com on Tuesday May 25
To: robin-lists@robinbowes.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 25, robin-lists@robinbowes.com wrote:
> Neil Brown wrote:
> > 
> > I often RAID1 a pair of whole devices, partition them into
> > root/swap/rest and boot off them (this is using md partitioning code
> > which isn't in 2.4, but is in 2.6).  There is a problem here that lilo
> > thinks it knows all about md arrays.  However I figured out how to
> > trick it into not realising they are md arrays and it works fine (I
> > create a symlink from /dev/MD* -> /dev/md* and only tell lilo about
> > /dev/MD*).
> 
> Neil,
> 
> Would you care to elaborate?
> 
> I'm about to build a box with 6 x 250GB SATA disks and am currently
> designing the partitioning scheme.
> 
> Could I potentially put in a small IDE disk onto which to install just
> enough system to boot and mount a RAID5 array built from the 6 whole disks?
> 
> Presumably you then partition the RAID array, create the filesystems and
> mount the partitions as you would a single disk?

In this configuration I wouldn't raid whole drives.
I would partition each drive into
 6 gig root
 2 gig swap
 N-8 gig extra

I would raid1 2 or 3 root partitions together and add the rest as hot
spares.
I would raid1 2 or 3 swap partitions together and add the rest as hot
spares. 
I would raid5 the extra partitions together and put the bulk storage
there.

If you want a single large root and no extra partitions, I would then
make a 1 gig boot and an N-1 gig root on each device,
raid1 the boot devices together and put kernels there.
raid5 the root devices together and put everything there.
swap to a file on the root filesystem.

The two situations where I raid together whole devices are:

1/ computers with only two drives - then I mirror and partition.
2/ fileservers where the main storage drives are physically separate
in some way, either in a different cage, or in the same cage but a
different size (2 smaller drives for boot/root/etc, several larger
drives for storage).  Then I raid5 all the storage devices together.

In between these two (just two drives, and lots of drives) is the
several-drives-in-one-case situation, where partitioning and then
RAIDing works well.

NeilBrown
