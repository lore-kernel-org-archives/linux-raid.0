From: "Ian Brown" <ianbrn@gmail.com>
Subject: Re: Stopping and starting a RAID1 :Invalid argument
Date: Wed, 11 Oct 2006 15:00:42 +0200
Message-ID: <d0383f90610110600g78ade775j144a4deae7b3eb10@mail.gmail.com>
References: <d0383f90610080305x4d06d307yfc497f39761f073c@mail.gmail.com>
	 <Pine.LNX.4.56.0610081115440.20412@lion.drogon.net>
	 <d0383f90610080608x77fbfb80qb1e89fa8840f9d0a@mail.gmail.com>
	 <20061008132537.M34804@contactbda.com>
	 <d0383f90610090040v2d0ab905ka5d4607037dd6e17@mail.gmail.com>
	 <17706.65300.747341.601657@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17706.65300.747341.601657@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: jim@contactbda.com, Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

  First, I just want to emphasize that the message "raid array is not
clean" from the kernel log
appeared after running "mdadm create". (and not "mdadm stop" or "mdadm
assemble")
I don't know if it is normal behavior. (Is it ? this is in fact my question).

one little think: I ran here also mkfs -t ext3... but also
tried without it and it was teh same.

Second, here is exactly what I did and the  kernel log :

My actions:

dd if=/dev/zero of=/dev/sda bs=1M count=64
===
create 2 linux raid partitions equal in size:

afterwards:
fdisk -l /dev/sda shows:

Disk /dev/sda: 65 MB, 65470464 bytes
3 heads, 42 sectors/track, 1014 cylinders
Units = cylinders of 126 * 512 = 64512 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1         256       16107   fd  Linux raid autodetect
/dev/sda2             257         513       16191   fd  Linux raid autodetect

===
modprobe raid1
mdadm --create /dev/md0 --level=raid1 --raid-devices=2 /dev/sda1 /dev/sda2

mdadm: array /dev/md0 started.

cat /proc/mdstat

cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sda2[1] sda1[0]
      16000 blocks [2/2] [UU]

unused devices: <none>
===

mkfs -t ext3 /dev/md0
mdadm --stop /dev/md0

cat /proc/mdstat
Personalities : [raid1]
unused devices: <none>
---

mdadm --assemble /dev/md0 /dev/sda1 /dev/sda2
mdadm: /dev/md0 has been started with 2 drives.


The kernel log
============
Oct 11 14:43:53  kernel: md: bind<sda1>
Oct 11 14:43:53  kernel: md0: WARNING: sda2 appears to be on the same
physical disk as sda1. True
Oct 11 14:43:53  kernel:      protection against single-disk failure
might be compromised.
Oct 11 14:43:53  kernel: md: bind<sda2>
Oct 11 14:43:53  kernel: md: md0: raid array is not clean -- starting
background reconstruction
Oct 11 14:43:53  kernel: raid1: raid set md0 active with 2 out of 2 mirrors
Oct 11 14:43:53  kernel: md: syncing RAID array md0
Oct 11 14:43:53 : md: minimum _guaranteed_ reconstruction speed: 1000
KB/sec/disc.
Oct 11 14:43:53 : md: using maximum available idle IO bandwidth (but
not more than 200000 KB/sec) for reconstruction.
Oct 11 14:43:53 : md: using 128k window, over a total of 16000 blocks.
Oct 11 14:44:29 : md: md0: sync done.
Oct 11 14:44:34 : RAID1 conf printout:
Oct 11 14:44:34 :  --- wd:2 rd:2
Oct 11 14:44:34 :  disk 0, wo:0, o:1, dev:sda1
Oct 11 14:44:34 :  disk 1, wo:0, o:1, dev:sda2
===

after mdadm stop:
---
Oct 11 14:46:53 : md: md0 stopped.
Oct 11 14:46:53 : md: unbind<sda2>
Oct 11 14:46:53 : md: export_rdev(sda2)
Oct 11 14:46:53 : md: unbind<sda1>
Oct 11 14:46:53 : md: export_rdev(sda1)
====

after mdadm assemble:
---
Oct 11 14:48:15 : md: md0 stopped.
Oct 11 14:48:15 : md: bind<sda2>
Oct 11 14:48:15 : md0: WARNING: sda1 appears to be on the same
physical disk as sda2. True
Oct 11 14:48:15 :      protection against single-disk failure might be
compromised.
Oct 11 14:48:15 : md: bind<sda1>
Oct 11 14:48:15 : raid1: raid set md0 active with 2 out of 2 mirrors


Regards,
Ian



On 10/10/06, Neil Brown <neilb@suse.de> wrote:
> On Monday October 9, ianbrn@gmail.com wrote:
> >
> > In the kernel log I see:
> > "md0: raid array is not clean -- starting background reconstruction"
> >
> >
> > What is the meaning of "raid array is not clean" ?
>
> It means md believe there could be an inconsistency in the array.
> This typically happens due to an unclean shutdown.
> Can you post more complete logs ?  100 lines either side should be
> plenty.
>
> NeilBrown
>
