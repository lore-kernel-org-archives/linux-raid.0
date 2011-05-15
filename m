From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 reshape failure - restart?
Date: Mon, 16 May 2011 07:37:02 +1000
Message-ID: <20110516073702.6b6b9bb2@notabene.brown>
References: <BANLkTi=-QZaQD6itGGZeyFekb2Kq5=_1iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=-QZaQD6itGGZeyFekb2Kq5=_1iA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Glen Dragon <glen.dragon@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 15 May 2011 13:33:28 -0400 Glen Dragon <glen.dragon@gmail.com> wrote:

> In trying to reshape a raid5 array, I encountered some problems.
> I was trying to reshape from raid5 3->4 devices.  The reshape process
> started with seeming no problems, however i noticed in the kernel log
> a number of ata3.00: failed command: WRITE FPDMA QUEUED errors.
> In trying to determine if this was going to be bad for me, I disabled
> ncq on this device. Looking at the log, i notice around the same time
> /dev/sdd reported problems and took itself offline.
> At this point the reshape seemed to be continuing w/o issue, even
> though one of the drives was offline.. I wasn't sure that this made
> sense.
> 
> Shortly after, I noticed that the progress on the reshape had stalled.
>  I tried changing the stripe_cache_size from 256 to [1024|2048|4096],
> but the reshape did not resume.  top reported that the reshape process
> was using 100% of one core, and the load average was climbing into the
> 50's
> 
> At this point I rebooted.   The array does not start.
> 
> Can the reshape be restarted?  I cannot figure out where the backup
> file ended up.  It does not seem to be where I thought I saved it.

When a reshape is increasing the size of the array the backup file is only
needed for the first few stripes.  After that it is irrelevant and is removed.

You should be able to simply reassemble the array and it should continue the
reshape.

What happens when you  try:

 mdadm -S /dev/md_d2
 mdadm -A /dev/md_d2 /dev/sd[abc]5 -vv

Please report both the messsages from mdadm and any new message is "dmesg" at
the time.

NeilBrown



> 
> Can I assemble this array with only the 3 original devices? Is there a
> way to recover at least some of the data on the array?  I have various
> backups, but there are some stuff that was not "critical' but would
> still be handy to not loose.
> 
> Various logs that could be helpful:  md_d2 is the array in question.
> Thanks..
> --Glen
> 
> # mdadm --version
> mdadm - v3.1.4 - 31st August 2010
> 
>  # uname -a
> Linux palidor 2.6.36-gentoo-r5 #1 SMP Wed Mar 2 20:54:16 EST 2011
> x86_64 Intel(R) Core(TM)2 Quad CPU Q9450 @ 2.66GHz GenuineIntel
> GNU/Linux
> 
> current state:
> 
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [multipath] [raid1]
> md8 : active raid5 sdh1[0] sdg1[4] sdf1[1] sdi1[3] sde1[2]
>       5860542464 blocks level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
> 
> md_d2 : inactive sdb5[1](S) sda5[0](S) sdd5[2](S) sdc5[3](S)
>       2799357952 blocks super 0.91
> 
> md1 : active raid5 sdd3[2] sdb3[1] sda3[0]
>       62926336 blocks level 5, 256k chunk, algorithm 2 [3/3] [UUU]
> 
> md0 : active raid1 sdb1[1] sda1[0] sdd1[2]
>       208704 blocks [3/3] [UUU]
> 
> 
> # mdadm -E /dev/sdb5   ([abc]) are all similiar.
> /dev/sdb5:
>           Magic : a92b4efc
>         Version : 0.91.00
>            UUID : 2803efc9:c5d2ec1e:9894605d:35c5ea6f
>   Creation Time : Sat Oct  3 11:01:02 2009
>      Raid Level : raid5
>   Used Dev Size : 699839488 (667.42 GiB 716.64 GB)
>      Array Size : 2099518464 (2002.26 GiB 2149.91 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 2
> 
>   Reshape pos'n : 62731776 (59.83 GiB 64.24 GB)
>   Delta Devices : 1 (3->4)
> 
>     Update Time : Sun May 15 11:25:21 2011
>           State : active
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 2f2eac3a - correct
>          Events : 114069
> 
>          Layout : left-symmetric
>      Chunk Size : 256K
> 
>       Number   Major   Minor   RaidDevice State
> this     1       8       21        1      active sync   /dev/sdb5
> 
>    0     0       8        5        0      active sync   /dev/sda5
>    1     1       8       21        1      active sync   /dev/sdb5
>    2     2       0        0        2      faulty removed
>    3     3       8       37        3      active sync   /dev/sdc5
> 
> # mdadm -E /dev/sdd5
> /dev/sdd5:
>           Magic : a92b4efc
>         Version : 0.91.00
>            UUID : 2803efc9:c5d2ec1e:9894605d:35c5ea6f
>   Creation Time : Sat Oct  3 11:01:02 2009
>      Raid Level : raid5
>   Used Dev Size : 699839488 (667.42 GiB 716.64 GB)
>      Array Size : 2099518464 (2002.26 GiB 2149.91 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 2
> 
>   Reshape pos'n : 18048768 (17.21 GiB 18.48 GB)
>   Delta Devices : 1 (3->4)
> 
>     Update Time : Sun May 15 10:51:41 2011
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 29dcc275 - correct
>          Events : 113870
> 
>          Layout : left-symmetric
>      Chunk Size : 256K
> 
>       Number   Major   Minor   RaidDevice State
> this     2       8       53        2      active sync   /dev/sdd5
> 
>    0     0       8        5        0      active sync   /dev/sda5
>    1     1       8       21        1      active sync   /dev/sdb5
>    2     2       8       53        2      active sync   /dev/sdd5
>    3     3       8       37        3      active sync   /dev/sdc5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

