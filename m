From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID Configuration For New Home Server
Date: Wed, 2 Jun 2010 09:24:22 -0500
Message-ID: <A9.B1.01646.899660C4@cdptpa-omtalb.mail.rr.com>
References: <476c45239528b5580f83a826f1cbb766.squirrel@mail.monkii.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <476c45239528b5580f83a826f1cbb766.squirrel@mail.monkii.net>
Sender: linux-raid-owner@vger.kernel.org
To: tron@monkii.net
Cc: 'Simon Matthews' <simon.d.matthews@gmail.com>, 'Mdadm' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> There are about as many answers to this as there are people using your
> setup

	Times two.

> so let's all agree that there's no "one way" of doing things.

	I think that's pretty evident.

> drives to spare since I upgraded my main fileserver, since mdadm works on
> partition level

	Mdadm does not "work on the partition level".  It should work with
any valid block device.  My data arrays do not have partitioned members.
They are built entirely from raw disks with no partitions either underneath
or above the md layer.  My boot arrays are built from a pair of disks with
three partitions - /, /boot, and swap.

> I started with creating my root (/) partition on one drive
> and setting it to 20gb (/dev/sda1), then a partition for storage
> (/dev/sda2 -> /var/storage) with the remaining diskspace. I preceded to
> copy the partition table over to my other drives using sfdisk (sfdisk-d
> /dev/sda|sfdisk /dev/sdX). Next I created a raid1 using all the /dev/sdX1
> partitions (mdadm -C /dev/md0 -l 1 -n 5 /dev/sd[a,b,c,d,e]1) and after
> that created the raid5 (mdadm -C /dev/md1 -l 5 -n 5 -x 0
> /dev/sd[a,b,c,d,e]2) with no spares that's what the -x 0 is for.

	I prefer to use separate boot drives.  I do have the boot drives set
up as arrays, but only as RAID1 pairs.  The boot drives are set up as RAID1
merely to eliminate down time, not so much to prevent data loss, since the
boot drives can in the event of catastrophic failure be fairly easily
reconstructed from scratch.

> This has the benefit of having a rock solid raid1 configuration for your /
> and also benefiting from having a relatively safe storage using raid5.
> Also it's real easy to setup and if you want to add more storage you can
> just pop another drive in, copy the partition table using sfdisk and add
> the new partitions to the existing raid-devices using mdadm.

	True, but after the 4th drive is added to the array, the level of
redundancy for / starts to get rather silly, and the waste of space may
start to add up to quite a bit.

