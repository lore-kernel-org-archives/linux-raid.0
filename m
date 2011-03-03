From: Ken Drummond <linuxraid@kendrummond.com>
Subject: RE: Impact of missing parameter during mdadm create
Date: Thu, 03 Mar 2011 21:06:50 +1000
Message-ID: <1299150410.10282.14.camel@tankquad>
References: <BAY148-w11FE2CD7493A098E62E08DEFC10@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w11FE2CD7493A098E62E08DEFC10@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2011-03-01 at 13:38 -0500, Mike Viau wrote:
> > On Tue, 1 Mar 2011 17:13:09 +1000  wrote:
> >
> >> Any ideas or tips? I am considering this might be a bug, but I have only
> >> had this problem in my Debian Squeeze system.
> >>
> >
> > What do cat /proc/mdstat and mdadm -D /dev/md0 show you? Also have you
> > updated your mdadm.conf (and the mdadm.conf in the initramfs if you use
> > one)?
> >
> 
> After a reboot I see
> 
> cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sda1[0] sdb1[1]
>       1953517568 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [UU_]
> 
> unused devices: 
> 
> 
> But sometimes I see
> 
> cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active (auto-read-only) raid5 sda1[0] sdb1[1]
>       1953517568 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [UU_]
> 
> unused devices: 
> 
> 
> QUESTION: What does '(auto-read-only)' mean?

auto-read-only means the array is read-only until the first write is
attempted at which point it will become read-write.

> 
> In either case --detail output is the same for both cases.
> 
> mdadm -D /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Mon Dec 20 09:48:07 2010
>      Raid Level : raid5
>      Array Size : 1953517568 (1863.02 GiB 2000.40 GB)
>   Used Dev Size : 976758784 (931.51 GiB 1000.20 GB)
>    Raid Devices : 3
>   Total Devices : 2
>     Persistence : Superblock is persistent
> 
>     Update Time : Tue Mar  1 13:50:53 2011
>           State : clean, degraded
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 512K
> 
>            Name : XEN-HOST:0  (local to host XEN-HOST)
>            UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
>          Events : 33422
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync   /dev/sda1
>        1       8       17        1      active sync   /dev/sdb1
>        2       0        0        2      removed
> 
> 
> Hmm, so the array is aware that it is missing drive number/RaidDevice of 2, I am not sure what implication of having a major/minor of 0.
> QUESTION: Must the Major/Minor information exactly match what the system detect vs the meta data on the array (I presume)?
> 
> If that is the case it looks like I need to make drive number/RaidDevice 2 have a major/minor 8/49.
> 
> ls -l /dev/sda1
> brw-rw---- 1 root disk 8, 1 Mar  1 14:17 /dev/sda1
> 
> ls -l /dev/sdb1
> brw-rw---- 1 root disk 8, 17 Mar  1 14:17 /dev/sdb1
> 
> ls -l /dev/sdd1
> brw-rw---- 1 root floppy 8, 49 Mar  1 14:17 /dev/sdd1
> 
> 
> Until I find a solution I am manually running:
> 
> mdadm --re-add /dev/md0 /dev/sdd1 -vvv
> mdadm: re-added /dev/sdd1
> 
> or
> 
> mdadm --add /dev/md0 /dev/sdd1 -vvv
> mdadm: re-added /dev/sdd1
> 
> 
> Which then gives me:
> 
> cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdd1[3] sda1[0] sdb1[1]
>       1953517568 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [UU_]
>       [>....................]  recovery =  0.1% (1222156/976758784) finish=622.3min speed=26126K/sec
> 
> unused devices: 
> 

So has the array ever completed a sync?

If it has, and still comes up as degraded on reboot it may pay to add a
bitmap; to make resyncs much quicker while working this out.

> QUESTION: Here is seems sdd1 is given drive number 3 not 2, is that a problem? (e.g: sdd1[2] vs sdd1[3])
> 
> I am also certain my mdadm.conf on my file system is in sync/updated with the one in my initramfs for all kernels actually.
> 
> 
> cat /etc/mdadm/mdadm.conf
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
> 
> # by default, scan all partitions (/proc/partitions) for MD superblocks.
> # alternatively, specify devices to scan, using wildcards if desired.
> DEVICE partitions containers
> 
> # auto-create devices with Debian standard permissions
> CREATE owner=root group=disk mode=0660 auto=yes
> 
> # automatically tag new arrays as belonging to the local system
> HOMEHOST 
> 
> # definitions of existing MD arrays
> ARRAY /dev/md/0 metadata=1.2 UUID=7d8a7c68:95a230d0:0a8f6e74:4c8f81e9 name=XEN-HOST:0
> 

I'm not sure if specifying /dev/md/0 is the same as /dev/md0, but I use
the /dev/mdX format and things seem to work for me.

> 
> 
> In trying to fix the problem I attempted to change the preferred minor of an MD array (RAID) by follow these instructions.
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     # you need to manually assemble the array to change the preferred minor
>     # if you manually assemble, the superblock will be updated to reflect
>     # the preferred minor as you indicate with the assembly.
>     # for example, to set the preferred minor to 4:
>     mdadm --assemble /dev/md4 /dev/sd[abc]1
> 
>     # this only works on 2.6 kernels, and only for RAID levels of 1 and above.
> 
> 
> mdadm --assemble /dev/md0 /dev/sd{a,b,d}1 -vvv
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
> mdadm: added /dev/sdb1 to /dev/md0 as 1
> mdadm: added /dev/sdd1 to /dev/md0 as 2
> mdadm: added /dev/sda1 to /dev/md0 as 0
> mdadm: /dev/md0 has been started with 2 drives (out of 3) and 1 rebuilding.
> 
> 
> So because I specified all the drives, I assume this is the same things as assembling the RAID degraded and then manually re-adding the last one (/dev/sdd1).
> 

So if you wait for the resync to complete, what happens if you:

mdadm -S /dev/md0
mdadm -Av /dev/md0

--
Ken.

