From: Danilo Godec <danci@agenda.si>
Subject: Re: couple of seemingly dumb questions
Date: Fri, 19 Apr 2002 08:20:25 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0204190802560.4405-100000@duplo.agenda.si>
References: <5.1.0.14.2.20020418224457.03d73910@mail.harddata.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.0.14.2.20020418224457.03d73910@mail.harddata.com>
To: Maurice Hilarius <maurice@harddata.com>
Cc: Linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 18 Apr 2002, Maurice Hilarius wrote:

> On software RAID/raidtools how does one change the rebuild priority on a
> replacement disk or resync?
> I don't mind giving higher CPU priority, since in many cases the boxes I am
> using have lots more CPU than is being used most of the time.

With 2.2 kernels, you can simply use 'cat /proc/sys/dev/md/speed-limit',
to see the *minimum* rebuild rate. You can change it using
'echo 200000 > /proc/sys/dev/md/speed-limit'.

With 2.4 kernels, there are two files in '/proc/sys/dev/raid/', called
'speed_limit_max' and 'speed_limit_min'. I think the rest is pretty
obvious.

> Secondly:
> With a software RAID5 setup, with disks in removable hot-swap trays, I want
> to be able to pull a failed disk and replace it and have it then rebuild.
> Problem is, when I pull the disk I get lots of error messages, and then
> when I replace it there is nothing happening to redetect that the disk is
> changed, and allow me to rebuild. If I reboot then the machine does resync
> with the new drive, but surely there must be a way without a reboot?

I suppose you have SCSI disks (I think hot-swap IDE is just not that far
along).

First you have to make sure, that the failed disk is not in use anymore.
This means using 'raidhotremove' for every partition of that disk, that
may be in use (also check for non-RAID partition, if they exist). When
you're sure the disk is not used anymore, make the kernel 'release' the
disk from SCSI bus using:

echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi

Check 'cat /proc/scsi/scsi' to check if the failed disk is still listed.
If it is, it's probably still in use and can't yet be removed. Re-check
the first step... Else, you can pull the disk out and install a new one.

Before you can use the new disk, you have to make the kernel accept it to
SCSI. Use:

echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi

Check 'cat /proc/scsi/scsi' if the new disk has appeared. If it has,
you're all set to partition the disk and use it at will.

   D.

PS: See /usr/src/linux/drivers/scsi/scsi.c for more about this
/proc/scsi/scsi commands.

