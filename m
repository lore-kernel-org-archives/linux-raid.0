From: "bo" <bo@sosnetwork.net>
Subject: Re: couple of seemingly dumb questions
Date: Fri, 19 Apr 2002 08:49:18 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <01b501c1e7b9$c3c9e8c0$6501a8c0@bomoon>
References: <Pine.LNX.4.30.0204190802560.4405-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Danilo Godec <danci@agenda.si>, Maurice Hilarius <maurice@harddata.com>
Cc: Linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Danilo,

If I have a h/w support for IDE hot swap then what do you recommand for
the same as you suggested for scsi below?

Thansk,

Bo
----- Original Message -----
From: "Danilo Godec" <danci@agenda.si>
To: "Maurice Hilarius" <maurice@harddata.com>
Cc: "Linux-raid" <linux-raid@vger.kernel.org>
Sent: Thursday, April 18, 2002 11:20 PM
Subject: Re: couple of seemingly dumb questions


> On Thu, 18 Apr 2002, Maurice Hilarius wrote:
>
> > On software RAID/raidtools how does one change the rebuild priority on a
> > replacement disk or resync?
> > I don't mind giving higher CPU priority, since in many cases the boxes I
am
> > using have lots more CPU than is being used most of the time.
>
> With 2.2 kernels, you can simply use 'cat /proc/sys/dev/md/speed-limit',
> to see the *minimum* rebuild rate. You can change it using
> 'echo 200000 > /proc/sys/dev/md/speed-limit'.
>
> With 2.4 kernels, there are two files in '/proc/sys/dev/raid/', called
> 'speed_limit_max' and 'speed_limit_min'. I think the rest is pretty
> obvious.
>
> > Secondly:
> > With a software RAID5 setup, with disks in removable hot-swap trays, I
want
> > to be able to pull a failed disk and replace it and have it then
rebuild.
> > Problem is, when I pull the disk I get lots of error messages, and then
> > when I replace it there is nothing happening to redetect that the disk
is
> > changed, and allow me to rebuild. If I reboot then the machine does
resync
> > with the new drive, but surely there must be a way without a reboot?
>
> I suppose you have SCSI disks (I think hot-swap IDE is just not that far
> along).
>
> First you have to make sure, that the failed disk is not in use anymore.
> This means using 'raidhotremove' for every partition of that disk, that
> may be in use (also check for non-RAID partition, if they exist). When
> you're sure the disk is not used anymore, make the kernel 'release' the
> disk from SCSI bus using:
>
> echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi
>
> Check 'cat /proc/scsi/scsi' to check if the failed disk is still listed.
> If it is, it's probably still in use and can't yet be removed. Re-check
> the first step... Else, you can pull the disk out and install a new one.
>
> Before you can use the new disk, you have to make the kernel accept it to
> SCSI. Use:
>
> echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
>
> Check 'cat /proc/scsi/scsi' if the new disk has appeared. If it has,
> you're all set to partition the disk and use it at will.
>
>    D.
>
> PS: See /usr/src/linux/drivers/scsi/scsi.c for more about this
> /proc/scsi/scsi commands.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

