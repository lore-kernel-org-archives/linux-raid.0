From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Broken harddisk
Date: Sat, 29 Jan 2005 11:19:11 -0500
Message-ID: <200501291617.j0TGHG918839@www.watkins-home.com>
References: <Pine.LNX.4.56.0501291538270.25299@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0501291538270.25299@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Gordon Henderson' <gordon@drogon.net>, "'T. Ermlich'" <pelegrine@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

For future reference:

Everyone should do a nightly disk test to prevent bad blocks from hiding
undetected.  smartd, badblocks or dd can be used.  Example:
dd if=/dev/sda of=/dev/null bs=64k

Just create a nice little script that emails you the output.  Put this
script in a nighty cron to run while the system is idle.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Gordon Henderson
Sent: Saturday, January 29, 2005 10:56 AM
To: T. Ermlich
Cc: linux-raid@vger.kernel.org
Subject: Re: Broken harddisk

On Sat, 29 Jan 2005, T. Ermlich wrote:

> That's right: each harddisk is partitioned absolutly identically, like:
>      0 - 19456 - /dev/sda1 - extended partition
>      1 - 6528  - /dev/sda5 - /dev/md0
>   6529 - 9138  - /dev/sda6 - /dev/md1
>   9139 - 16970 - /dev/sda7 - /dev/md2
> 16971 - 19456 - /dev/sda8 - /dev/md3
> And after doing those partitionings I 'combined' them to act as raid1.

> I have two additional IDE drives in that system.
> /dev/hda contains some data, and is the boot drive, /dev/hdb contains
> some less important data.

Just as a point of note - if the boot disk goes down it will be harder to
recover the data... Consider making the boot disk mirrored too!

> >   mdadm --add /dev/md0 /dev/sda1
> >   mdadm --add /dev/md1 /dev/sda2
> >   mdadm --add /dev/md2 /dev/sda3
> >   mdadm --add /dev/md3 /dev/sda4
>
> Now some new trouble starts ...?
> 'mdadm --add /dev/md0 /dev/sda1' started just fine - but exactly at 50%
> it started giving tons of errors, like:

You should ve using:

  mdadm --add /dev/md0 /dev/sda5

> [quote]
> Jan 29 16:10:24 suse92 kernel: Additional sense: Unrecovered read error
> - auto reallocate failed
> Jan 29 16:10:24 suse92 kernel: end_request: I/O error, dev sdb, sector
> 52460420

The is a read error from /dev/sdb. What it's saying is that sdb has bad
sectors which can't be recoverd.

You have 2 bad drives in a RAID-1 - and thats really bad )-:

> Personalities : [raid1]
> md3 : active raid1 sdb8[1]
>        19960640 blocks [2/1] [_U]
>
> md2 : active raid1 sdb7[1]
>        62910400 blocks [2/1] [_U]
>
> md1 : active raid1 sdb6[1]
>        20964672 blocks [2/1] [_U]
>
> md0 : active raid1 sdb5[1] sda5[2]
>        52436032 blocks [2/1] [_U]
>        [==========>..........]  recovery = 50.0% (26230016/52436032)
> finish=121.7min speed=1050K/sec
> unused devices: <none>
> [/quote]
>
> Can I stop that process for /dev/md0, and start with /dev/md1 (just to
> compare if its a problem with that partition only, or an general problem
> (so that eg. the second drive has problens, too)?

Yes - just fail & remove the drive partition:

  mdadm --fail   /dev/md0 /dev/sda5
  mdadm --remove /dev/md0 /dev/sda5

At this point, I'd run a badblocks on the other partitions before doing
the resync:

  badblocks -s -c 256 /dev/sdb6
  badblocks -s -c 256 /dev/sdb7
  badblocks -s -c 256 /dev/sdb8

if these pass, you can do the hot-add, however, it looks like the sdb disk
is also faulty.

At this point, I'd be looking to replace both disks and restore from
backup, but if you can re-sync the other 3 partitions, then remove the
also-faulty sdb, and replace it with a new one, and you can re-sync the 3
good partitions, and you only have to restore the '5' partition (md0) from
backup.

You could try mkfs'ing the new partition sda5, mounting it, and copying
the data on md0 over to it - theres a chance the bad sectors on sdb lie
outside the filing system... This would save you having to restore from
backup, however, it then becomes trickier as you then have to re-create
the raid set on a new disk with a missing drive, and copy it again.

> btw: does mdadm also format the partitions?

No... You don't need to format/mkfs the partitions, as the raid resync
will take care of making it a mirror of the existing working disk.

Gordon
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

