From: Gordon Henderson <gordon@drogon.net>
Subject: Re: How to replace faulty disk in RAID5 setup?
Date: Sun, 8 Aug 2004 09:46:58 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0408080923360.805@lion.drogon.net>
References: <1142.212.134.28.56.1091952396.squirrel@212.134.28.56>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1142.212.134.28.56.1091952396.squirrel@212.134.28.56>
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 8 Aug 2004, Robin Bowes wrote:

> Hi,
>
> This question came up in another thread, but buried at the end so I
> thought it would be worth pulling out and asking explicitly.
>
> I have a 6-disk RAID5 array made up of 6 x 250GB Maxtor SATA drives (5 +
> 1 hot spare)
>
> Suppose one fails. What is the process I need to follow to replace the
> faulty disk?

This is what I did recently on a server with 4 disks on 2 SCSI busses
(Dell 24xx box IIRC)

/dev/sda failed. Each of the 4 disks is partitioned identially into 6
partitions, each partition being a slice of a RAID array.

Removed failed device from arrays:

  raid-hot-remove /dev/md0 /dev/sda1
  raid-hot-remove /dev/md1 /dev/sda2
  raid-hot-remove /dev/md2 /dev/sda3
  raid-hot-remove /dev/md3 /dev/sda5
  raid-hot-remove /dev/md4 /dev/sda6
  raid-hot-remove /dev/md5 /dev/sda7

Only one md device had actually failed, but it was neccessary to degrade
all arrays the replce the drive.

Remove failed device from kernel:

  echo "scsi remove-single-device 0 0 ? 0" > /proc/scsi/scsi

The ? was 0 in this case.

Physically unplug the drive from the system. Note: The system was live and
running and serving files during this entire process... The Dell has
80pin SCA style connectors, so I guessed it would be OK. Dell has some
weird active backplance that appears as a SCSI device that I'm sure you
can do "stuff" with, but this is a stock 2.4.26 kernel and Debian Woody.

Plug the new drive in.

Tell the kernel about it:

  echo "scsi add-single-device 0 0 ? 0" > /proc/scsi/scsi

Use cfdisk to partition it using one of the other disks as a reference.

Add it back into the raid arrays:

  raid-hot-add /dev/md0 /dev/sda1
  raid-hot-add /dev/md1 /dev/sda2
  raid-hot-add /dev/md2 /dev/sda3
  raid-hot-add /dev/md3 /dev/sda5
  raid-hot-add /dev/md4 /dev/sda6
  raid-hot-add /dev/md5 /dev/sda7

which starts the rebuild on each partition in-turn.

Finally, re-run Lilo to put the boot blocks back on (/dev/sda is one of
the boot disks)

Later, at a quiet time, reboot the server to make sure it will boot OK!

> Here's my best guess so far:
>
> (assume /dev/sdc has failed).
>
> Shutdown server.
> Pull dead drive
> Insert new drive
> Boot up server
> Create partition table on new drive (all my drives are partitioned identically):
>   # sfdisk -d /dev/sda | sfdisk /dev/sdc

Hm. Never heard of sfdisk - thats handy to copy a partition table!

> (Is it necessary to explicitly "remove" the failed device from the
> arrays (before shutting down?) and to add it back in after replacing the
> disk?)
>
> For example, would this work?:
>
> # mdadm /dev/md5 -f /dev/sdc2 -r /dev/sdc2 -a /dev/sdc2

Hm. madm. One of these days I'll get round to reading its man page ...

Gordon
