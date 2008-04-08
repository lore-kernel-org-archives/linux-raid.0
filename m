From: "Sean H." <silverwraithii@gmail.com>
Subject: Re: Re-assembling a software RAID in which device names have changed.
Date: Tue, 8 Apr 2008 15:06:04 -0400
Message-ID: <fa037c550804081206w6aa4db7r9b9f22202c4cca38@mail.gmail.com>
References: <fa037c550804072134w59f0f280g3d86ed76a99a271e@mail.gmail.com>
	 <47FBAA76.20008@msgid.tls.msk.ru>
	 <fa037c550804081055p2d2550ccs8dfab22d2edb6920@mail.gmail.com>
	 <47FBBB6E.8040307@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47FBBB6E.8040307@msgid.tls.msk.ru>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: mjt@tls.msk.ru
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Apr 8, 2008 at 2:37 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
> [Please respect the Reply-To header]
>
>  Sean H. wrote:
>  []
>
>
> > My mdadm.conf is configured with UUIDs:
> >
>
>  Ok.
>
>
> > DEVICE partitions
> >
>
>  Ok.
>
>
> > ARRAY /dev/md0 level=raid5 num-devices=5
> > uuid=58dcdaf3:bdf3f176:f2dd1b6b:f095c127
> >
>
>
>
> > Tried the following: 'mdadm --assemble /dev/md0 --uuid
> > 58dcdaf3:bdf3f176:f2dd1b6b:f095c127'
> > ... and got this: mdadm: /dev/md0 assembled from 2 drives - not enough
> > to start the array.
> > (Which is what I've been getting for a while, now.)
> >
>
>  Ok.  So it's a different problem you have.  What's the
>  reason you think it's due to re-numbering/naming of the
>  disks?
>
>  When you unplugged 3 your disks, I suspect linux noticed
>  that fact and md layer marked them as "failed" in the
>  array, with the 2 still here.  Now, when you have all 5
>  of them again, 2 of them (the ones which were left in
>  the system) are "fresh", and 3 (the ones which were
>  removed) are "old".  So you really don't have enough
>  fresh drives to start the array.
>
>  Now take a look at verbose output of mdadm (see -v option).
>  If my guess is right, use --force option.  And take a look
>  at the Fine Manual, after all -- at the section describing
>  assemble mode.
>
>
>
> > It's possible to correct this issue by unplugging the three drives and
> > plugging them back in and rebooting, so the drives get their original
> > /dev/sd* locations, is it not? (Even if it it possible, I'd like to
> > learn how to fix problems like this at the software level over the
> > hardware level.)
> >
>
>  Please answer this question.  Why do you think that the array
>  does not start because of disk renumbering?
>
>  /mjt
>
>

Apologies. As I said, I'm new to mdadm / RAID.

I forced it to assemble, and it did. I was then able to mount the
array manually. /dev/sdf happens to be my OS drive, so for the
purposes of mdadm it's irrelevant. It appears you were correct in that
the drives were marked faulty - But the fact that the array was
started with four devices is troublesome because I lose any safety
gained from RAID 5.

Below the first command, and separated by ten hyphens is --detail
/dev/md0 which shows that the remaining device is marked "removed" and
not "failed".

I thank you for your help thusfar - You've allowed me to mount the
array and access my data. However, I would very much like to get my
RAID 5 back to non-degraded status ASAP.

[root@localhost ~]# mdadm --assemble /dev/md0 -v --force
mdadm: looking for devices for /dev/md0
mdadm: cannot open device /dev/sdf3: Device or resource busy
mdadm: /dev/sdf3 has wrong uuid.
mdadm: cannot open device /dev/sdf2: Device or resource busy
mdadm: /dev/sdf2 has wrong uuid.
mdadm: cannot open device /dev/sdf1: Device or resource busy
mdadm: /dev/sdf1 has wrong uuid.
mdadm: cannot open device /dev/sdf: Device or resource busy
mdadm: /dev/sdf has wrong uuid.
mdadm: /dev/sde has wrong uuid.
mdadm: /dev/sdd has wrong uuid.
mdadm: /dev/sdc has wrong uuid.
mdadm: /dev/sdb has wrong uuid.
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
mdadm: forcing event count in /dev/sdd1(3) from 2588 upto 2596
mdadm: forcing event count in /dev/sdb1(1) from 2559 upto 2596
mdadm: clearing FAULTY flag for device 2 in /dev/md0 for /dev/sdb1
mdadm: clearing FAULTY flag for device 0 in /dev/md0 for /dev/sdd1
mdadm: added /dev/sdb1 to /dev/md0 as 1
mdadm: added /dev/sdc1 to /dev/md0 as 2
mdadm: added /dev/sdd1 to /dev/md0 as 3
mdadm: no uptodate device for slot 4 of /dev/md0
mdadm: added /dev/sda1 to /dev/md0 as 0
mdadm: /dev/md0 has been started with 4 drives (out of 5).

----------

[root@localhost ~]# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Wed Mar  5 15:55:52 2008
     Raid Level : raid5
     Array Size : 2930287616 (2794.54 GiB 3000.61 GB)
  Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Apr  8 14:58:02 2008
          State : clean, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 58dcdaf3:bdf3f176:f2dd1b6b:f095c127
         Events : 0.2612

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       0        0        4      removed
