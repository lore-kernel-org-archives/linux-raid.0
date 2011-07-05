From: NeilBrown <neilb@suse.de>
Subject: Re: Help with recovering resized raid where machine crashed while
 PENDING
Date: Tue, 5 Jul 2011 10:49:23 +1000
Message-ID: <20110705104923.4779e295@notabene.brown>
References: <2flfwmpdpw2.fsf@login1.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2flfwmpdpw2.fsf@login1.uio.no>
Sender: linux-raid-owner@vger.kernel.org
To: Petter Reinholdtsen <pere@hungry.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 02 Jul 2011 10:54:05 +0200 Petter Reinholdtsen <pere@hungry.com>
wrote:

> 
> I could use some help with recovering a raid5.  I had two RAID5 using
> three disks.  The 1T disks were partitioned into two halves and each
> raid5 used one partition from each disk (created this way to be able
> to add my 500G disks into the raids).
> 
> Then I added two more disks to the setup, partitioned the same way,
> and added their partitions to the two raids and asked the raids to
> grow.  The first raid started growing and got around 60% out before
> the machine crashed and had to be rebooted.  The second raid did not
> start growing and was PENDING.  As far as I know, it was still PENDING
> when the machine crashed.  When I ran mdadm to start the second
> growing, the mdadm command hung waiting for the other grow operation
> to finish.  I ended up killing it after a few hours, hoping to
> continue the grow operation when the first raid was done growing after
> 15 days.
> 
> After the crash and first reboot , the first raid5 is activated and
> show up as auto-read-only, and the second raid fail to assemble.  I
> did not specify a backup file when growing, as the recipe I found did
> not mention that it was smart to do.  Now I wish I had.

I probably wouldn't have helped.  It is supposed to write backup stuff to the
spares and if it didn't do that, it probably wouldn't have written it to a
file either.

The easiest fix for now is to recreate the array.

mdadm -CR /dev/md3 --metadata=0.90 -n3 -l5 -c64 /dev/sdb2 /dev/sdc2 /dev/sdf2 --assume-clean

should do it.

Then if that looks good, add the extra devices and grow the array again.

NeilBrown



> 
> Any ideas how I can recover my raid? After reading
> <URL: https://raid.wiki.kernel.org/index.php/RAID_Recovery >, I
> suspect creating it again is the solution, but am unsure if I should
> recreate it with 3 or 5 partitions.  Trying to assembly result in this:
> 
> meta:~# mdadm --assemble /dev/md3 /dev/sdd2 /dev/sde2 /dev/sdh2 /dev/sda2 /dev/sdb2
> mdadm: Failed to restore critical section for reshape, sorry.
>       Possibly you needed to specify the --backup-file
> meta:~#  
> 
> How can I know which disks to use when recreating if I want to
> recreate using only three disks?  Is it the three with the active
> state?
> 
> This is the content of /proc/mdstat.  The md0 and md1 RAIDs can be
> ignored as they are on two different disks:
> 
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md2 : active (auto-read-only) raid5 sdd1[0] sda1[4] sdb1[3] sde1[2] sdh1[1]
>       976558976 blocks super 0.91 level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
> 
> md1 : active raid1 sdc2[0] sdf2[1]
>       976510912 blocks [2/2] [UU]
> 
> md0 : active raid1 sdc1[0] sdf1[1]
>       248896 blocks [2/2] [UU]
> 
> unused devices: <none>
> 
> Based on the disks used by md2, I ran "mdadm --examine
> /dev/sd[dabeh]2" to get the status of the problematic partitions:
> 
> /dev/sda2:
>           Magic : a92b4efc
>         Version : 00.91.00
>            UUID : 6dcd10c1:39d083f9:e49659ac:48e50bf6
>   Creation Time : Sun Oct 26 17:29:27 2008
>      Raid Level : raid5
>   Used Dev Size : 488279488 (465.66 GiB 500.00 GB)
>      Array Size : 1953117952 (1862.64 GiB 1999.99 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 3
> 
>   Reshape pos'n : 0
>   Delta Devices : 2 (3->5)
> 
>     Update Time : Thu Jun 30 11:00:18 2011
>           State : active
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 3274a54b - correct
>          Events : 193913
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     4       8       98        4      active sync
> 
>    0     0       8       18        0      active sync   /dev/sdb2
>    1     1       8       34        1      active sync   /dev/sdc2
>    2     2       8       82        2      active sync   /dev/sdf2
>    3     3       8      114        3      active sync   /dev/sdh2
>    4     4       8       98        4      active sync
> /dev/sdb2:
>           Magic : a92b4efc
>         Version : 00.91.00
>            UUID : 6dcd10c1:39d083f9:e49659ac:48e50bf6
>   Creation Time : Sun Oct 26 17:29:27 2008
>      Raid Level : raid5
>   Used Dev Size : 488279488 (465.66 GiB 500.00 GB)
>      Array Size : 1953117952 (1862.64 GiB 1999.99 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 3
> 
>   Reshape pos'n : 0
>   Delta Devices : 2 (3->5)
> 
>     Update Time : Thu Jun 30 11:00:18 2011
>           State : active
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 3274a559 - correct
>          Events : 193913
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     3       8      114        3      active sync   /dev/sdh2
> 
>    0     0       8       18        0      active sync   /dev/sdb2
>    1     1       8       34        1      active sync   /dev/sdc2
>    2     2       8       82        2      active sync   /dev/sdf2
>    3     3       8      114        3      active sync   /dev/sdh2
>    4     4       8       98        4      active sync
> /dev/sdd2:
>           Magic : a92b4efc
>         Version : 00.91.00
>            UUID : 6dcd10c1:39d083f9:e49659ac:48e50bf6
>   Creation Time : Sun Oct 26 17:29:27 2008
>      Raid Level : raid5
>   Used Dev Size : 488279488 (465.66 GiB 500.00 GB)
>      Array Size : 1953117952 (1862.64 GiB 1999.99 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 3
> 
>   Reshape pos'n : 0
>   Delta Devices : 2 (3->5)
> 
>     Update Time : Thu Jun 30 10:59:48 2011
>           State : clean
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 32779a4d - correct
>          Events : 193912
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     0       8       18        0      active sync   /dev/sdb2
> 
>    0     0       8       18        0      active sync   /dev/sdb2
>    1     1       8       34        1      active sync   /dev/sdc2
>    2     2       8       82        2      active sync   /dev/sdf2
>    3     3       8      114        3      active sync   /dev/sdh2
>    4     4       8       98        4      active sync
> /dev/sde2:
>           Magic : a92b4efc
>         Version : 00.91.00
>            UUID : 6dcd10c1:39d083f9:e49659ac:48e50bf6
>   Creation Time : Sun Oct 26 17:29:27 2008
>      Raid Level : raid5
>   Used Dev Size : 488279488 (465.66 GiB 500.00 GB)
>      Array Size : 1953117952 (1862.64 GiB 1999.99 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 3
> 
>   Reshape pos'n : 0
>   Delta Devices : 2 (3->5)
> 
>     Update Time : Thu Jun 30 11:00:18 2011
>           State : active
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 3274a505 - correct
>          Events : 193913
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     1       8       34        1      active sync   /dev/sdc2
> 
>    0     0       8       18        0      active sync   /dev/sdb2
>    1     1       8       34        1      active sync   /dev/sdc2
>    2     2       8       82        2      active sync   /dev/sdf2
>    3     3       8      114        3      active sync   /dev/sdh2
>    4     4       8       98        4      active sync
> /dev/sdh2:
>           Magic : a92b4efc
>         Version : 00.91.00
>            UUID : 6dcd10c1:39d083f9:e49659ac:48e50bf6
>   Creation Time : Sun Oct 26 17:29:27 2008
>      Raid Level : raid5
>   Used Dev Size : 488279488 (465.66 GiB 500.00 GB)
>      Array Size : 1953117952 (1862.64 GiB 1999.99 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 3
> 
>   Reshape pos'n : 0
>   Delta Devices : 2 (3->5)
> 
>     Update Time : Thu Jun 30 10:59:48 2011
>           State : clean
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 32779a91 - correct
>          Events : 193912
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     2       8       82        2      active sync   /dev/sdf2
> 
>    0     0       8       18        0      active sync   /dev/sdb2
>    1     1       8       34        1      active sync   /dev/sdc2
>    2     2       8       82        2      active sync   /dev/sdf2
>    3     3       8      114        3      active sync   /dev/sdh2
>    4     4       8       98        4      active sync
> 
> Happy hacking,

