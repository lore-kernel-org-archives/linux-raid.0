From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: RAID5 in strange state
Date: Wed, 08 Apr 2009 23:59:23 +0200
Message-ID: <878wmag62s.fsf@frosties.localdomain>
References: <49DD1730.4070108@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49DD1730.4070108@gmx.net> (Frank Baumgart's message of "Wed, 08
	Apr 2009 23:29:20 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Frank Baumgart <frank.baumgart@gmx.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Frank Baumgart <frank.baumgart@gmx.net> writes:

> Dear List,
>
> I use MD RAID 5 since some years and so far had to recover from single
> disk failures a few times which was always successful.
> Now though, I am puzzled.
>
> Setup:
> Some PC with 3x WD 1 TB SATA disk drives set up as RAID 5 using kernel
> 2.6.27.21 (now); the array ran fine for at least 6 months now.
>
> I check the state of the RAID every few days with looking at
> /proc/mdstat manually.
> Apparently one drive had been kicked out of the array 4 days ago without
> me noticing it.
> Root cause seemed to be bad cabling but is not confirmed yet.
> Anyway, the disc in question ("sde") reports 23 UDMA_CRC errors,
> compared to 0 about 2 weeks ago.
> Reading the complete device just now via DD still reports those 23
> errors but no new ones.
>
> Well, RAID 5 should survive a single disc failure (again) but after a
> reboot (due to non-RAID related reasons) the RAID came up as "md0 stopped".
>
> cat /proc/mdstat
>
> Personalities :
> md0 : inactive sdc1[1](S) sdd1[2](S) sde1[0](S)
>       2930279424 blocks
>
> unused devices: <none>
>
>
>
> What's that?
> First, documentation on the web is rather outdated and/or incomplete.
> Second, my guess that "(S)" represents a spare is backuped up by the
> kernel source.
>
>
> mdadm --examine [devices] gives consistent reports about the RAID 5
> structure as:
>
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : ec4fdb7b:e57733c0:4dc42c07:36d99219
>   Creation Time : Wed Dec 24 11:40:29 2008
>      Raid Level : raid5
>   Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
>      Array Size : 1953519616 (1863.02 GiB 2000.40 GB)
>    Raid Devices : 3
>   Total Devices : 3
> Preferred Minor : 0
> ...
>          Layout : left-symmetric
>      Chunk Size : 256K
>
>
>
> The state though differs:
>
> sdc1:
>     Update Time : Tue Apr  7 20:51:33 2009
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : ccff6a15 - correct
>          Events : 177920
> ...
>       Number   Major   Minor   RaidDevice State
> this     1       8       33        1      active sync   /dev/sdc1
>
>    0     0       0        0        0      removed
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8       49        2      active sync   /dev/sdd1
>
>
>
> sdd1:
>     Update Time : Tue Apr  7 20:51:33 2009
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : ccff6a27 - correct
>          Events : 177920
>
>          Layout : left-symmetric
>      Chunk Size : 256K
>
>       Number   Major   Minor   RaidDevice State
> this     2       8       49        2      active sync   /dev/sdd1
>
>    0     0       0        0        0      removed
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8       49        2      active sync   /dev/sdd1
>
>
>
> sde1:
>     Update Time : Fri Apr  3 15:00:31 2009
>           State : active
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : ccf463ec - correct
>          Events : 7
>
>          Layout : left-symmetric
>      Chunk Size : 256K
>
>       Number   Major   Minor   RaidDevice State
> this     0       8       65        0      active sync   /dev/sde1
>
>    0     0       8       65        0      active sync   /dev/sde1
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8       49        2      active sync   /dev/sdd1
>
>
>
> sde is the device that failed once and was kicked out of the array.
> The update time reflects that if I interprete that right.
> But how can sde1 status claim 3 active and working devices? IMO that's
> way off.

Sde gave too many errors and failed. It was kicked out. Now how is md
supposed to update its meta data after it was kicked out?

> Now, my assumption:
> I think I should be able to either remove sde temporarily and just
> restart the degraded array from sdc1/sdd1.
> correct?

Stop the raid and assemble it with just the two reliable disks. For me
that always works automatically. After that add the flaky disk again.

If you fear the disk might flake out again I suggest you add a bitmap
to the raid by runing (works any time the raid is not resyncing)

mdadm --grow --bitmap internal /dev/md0

This will cost you some performance but when a disk fails and you
readd it it will only have to sync regions that have changed and not
the full disk.

You can also remove the bitmap again with

mdadm --grow --bitmap none /dev/md0

at any later time. So I really would do that till you have figured out
if the cable is falky or not.

> My backup is a few days old and I would really like to keep the work on
> the RAID done in the meantime.
>
> If the answer is just 2 or 3 mdadm command lines, I am yours :-)
>
> Best regards
>
> Frank Baumgart

MfG
        Goswin
