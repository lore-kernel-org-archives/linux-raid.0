From: TomK <tk@mdevsys.com>
Subject: Re: [ LR] Kernel 4.8.4: INFO: task kworker/u16:8:289 blocked for more
 than 120 seconds.
Date: Sun, 30 Oct 2016 15:16:13 -0400
Message-ID: <cf4dedf2-93d1-2cf9-80e4-85c4caaf167e@mdevsys.com>
References: <20161030021614.asws67j34ji64qle@merlins.org>
 <20161030093337.GA3627@metamorpher.de> <20161030153857.GB28648@merlins.org>
 <20161030161929.GA5582@metamorpher.de>
 <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org>
 <73e35e17-80aa-c7e6-535c-3665d9789e16@mdevsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e35e17-80aa-c7e6-535c-3665d9789e16@mdevsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/30/2016 2:56 PM, TomK wrote:
> Hey Guy's,
>
> We recently saw a situation where smartctl -A errored out eventually in
> a short time of a few days the disk cascaded into bad blocks eventually
> becoming a completely unrecognizable SATA disk.  It apparently was
> limping along for 6 months causing random timeout and slowdowns
> accessing the array.  But the RAID array did not pull it out or and did
> not mark it as bad.  The RAID 6 we have has been running for 6 years,
> however we did have alot of disk replacements in it yet it was always
> very very reliable.  Disks started as all 1TB Seagates but are now 2 WD
> 2TB, 1 2TB Seagate with 2 left as 1TB Seagates and the last one as
> 1.5TB.  Has a mix of green, red, blue etc.  Yet very rock solid.
>
> We did not do a thorough R/W test to see how the error and bad disk
> affected the data stored on the array but did notice pauses and
> slowdowns on the CIFS share presented from it with pauses and generally
> difficulty in reading data, however no data errors that we could see.
> Since then we replaced the 2TB Seagate with a new 2TB WD and everything
> is fine even if the array is degraded.  But as soon as we put in this
> bad disk, it degraded to it's previous behaviour.  Yet the array didn't
> catch it as a failed disk until the disk was nearly completely
> inaccessible.
>
> So the question is how come the mdadm RAID did not catch this disk as a
> failed disk and pull it out of the array?  Seams this disk was going bad
> for a while now but as long as the array reported all 6 healthy, there
> was no cause for alarm.  Also how does the array not detect the disk
> failure while issues in applications using the array show up?  Removing
> the disk and leaving the array in a degraded state also solved the
> accessibility issue on the array.  So appears the disk was generating
> some sort of errors (Possibly bad PCB) that were not caught before.
>
> Looking at the changelogs, has a similar case been addressed?
>
> On a separate topic, if I eventually expand the array to 6 2TB disks,
> will the array be smart enough to allow me to expand it to the new size?
>  Have not tried that yet and wanted to ask first.
>
> Cheers,
> Tom
>
>
> [root@mbpc-pc modprobe.d]# rpm -qf /sbin/mdadm
> mdadm-3.3.2-5.el6.x86_64
> [root@mbpc-pc modprobe.d]#
>
>
> (The 100% util lasts roughly 30 seconds)
> 10/23/2016 10:18:20 PM
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.00    0.00    0.25   25.19    0.00   74.56
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdb               0.00     0.00    0.00    1.00     0.00     2.50 5.00
> 0.03   27.00  27.00   2.70
> sdc               0.00     0.00    0.00    1.00     0.00     2.50 5.00
> 0.01   15.00  15.00   1.50
> sdd               0.00     0.00    0.00    1.00     0.00     2.50 5.00
> 0.02   18.00  18.00   1.80
> sde               0.00     0.00    0.00    1.00     0.00     2.50 5.00
> 0.02   23.00  23.00   2.30
> sdf               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 1.15    0.00   0.00 100.00
> sdg               0.00     2.00    1.00    4.00     4.00   172.00 70.40
>    0.04    8.40   2.80   1.40
> sda               0.00     0.00    0.00    1.00     0.00     2.50 5.00
> 0.04   37.00  37.00   3.70
> sdh               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> sdj               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> sdk               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> sdi               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> fd0               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> dm-0              0.00     0.00    1.00    6.00     4.00   172.00 50.29
>    0.05    7.29   2.00   1.40
> dm-1              0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> dm-2              0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> md0               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> dm-3              0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> dm-4              0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> dm-5              0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> dm-6              0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 1.00    0.00   0.00 100.00
>
> 10/23/2016 10:18:21 PM
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.00    0.00    0.25   24.81    0.00   74.94
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdb               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> sdc               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> sdd               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> sde               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> sdf               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 2.00    0.00   0.00 100.00
> sdg               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> sda               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> sdh               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> sdj               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> sdk               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> sdi               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> fd0               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> dm-0              0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> dm-1              0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> dm-2              0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> md0               0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> dm-3              0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> dm-4              0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> dm-5              0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 0.00    0.00   0.00   0.00
> dm-6              0.00     0.00    0.00    0.00     0.00     0.00 0.00
> 1.00    0.00   0.00 100.00
>
>
> We can see that /dev/sdf ramps up to 100% starting at around (10/23/2016
> 10:18:18 PM) and stays that way till about the (10/23/2016 10:18:42 PM)
> mark when something occurs and it drops down to below 100% numbers.
>
> So I checked the array which shows all clean, even across reboots:
>
> [root@mbpc-pc ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdb[7] sdf[6] sdd[3] sda[5] sdc[1] sde[8]
>       3907045632 blocks super 1.2 level 6, 64k chunk, algorithm 2 [6/6]
> [UUUUUU]
>       bitmap: 1/8 pages [4KB], 65536KB chunk
>
> unused devices: <none>
> [root@mbpc-pc ~]#
>
>
> Then I run smartctl across all disks and sure enough /dev/sdf prints this:
>
> [root@mbpc-pc ~]# smartctl -A /dev/sdf
> smartctl 5.43 2012-06-30 r3573 [x86_64-linux-4.8.4] (local build)
> Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net
>
> Error SMART Values Read failed: scsi error badly formed scsi parameters
> Smartctl: SMART Read Values failed.
>
> === START OF READ SMART DATA SECTION ===
> [root@mbpc-pc ~]#
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Bit trigger happy.  Here's a better version of the first sentence.  :)

We recently saw a situation where smartctl -A errored out but mdadm 
didn't pick this up. Eventually, in a short time of a few days, the disk 
cascaded into bad blocks then became a completely unrecognizable SATA disk.

-- 
Cheers,
Tom K.
-------------------------------------------------------------------------------------

Living on earth is expensive, but it includes a free trip around the sun.

