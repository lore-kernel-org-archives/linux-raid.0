From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Advice requested
Date: Sat, 31 Oct 2015 06:55:25 -0500
Message-ID: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings

I had a raid 10 array where one drive threw an error (seemingly in a
superblock) and since I have not been able to get the array readable.
It was suggested to me that I remove 2 of the drives leaving the two
that were striped together.

So what I have is really a raid 0 array at present.

Info following from queries to system for system information.

mdadm --detail /dev/md0
/dev/md0:
       Version : 1.2
    Raid Level : raid0
 Total Devices : 2
   Persistence : Superblock is persistent

         State : inactive

          Name : debianbase:0  (local to host debianbase)
          UUID : 79baaa2f:0aa2b9fa:18e2ea6b:6e2846b3
        Events : 47341

   Number   Major   Minor   RaidDevice

      -       8       17        -        /dev/sdb1
      -       8       49        -        /dev/sdd1
root@debianbase:/media/darald# echo $UUID

root@debianbase:/media/xxxxxx# cd /
root@debianbase:/# mdadm --examine /dev/sdb1
/dev/sdb1:
         Magic : a92b4efc
       Version : 1.2
   Feature Map : 0x0
    Array UUID : 79baaa2f:0aa2b9fa:18e2ea6b:6e2846b3
          Name : debianbase:0  (local to host debianbase)
 Creation Time : Mon Mar  5 08:26:28 2012
    Raid Level : raid10
  Raid Devices : 4

Avail Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
    Array Size : 1953518592 (1863.02 GiB 2000.40 GB)
 Used Dev Size : 1953518592 (931.51 GiB 1000.20 GB)
   Data Offset : 2048 sectors
  Super Offset : 8 sectors
  Unused Space : before=1968 sectors, after=1024 sectors
         State : clean
   Device UUID : a80c76db:eaea61af:bcb9cbbb:ac99e467

   Update Time : Fri Aug 28 10:38:32 2015
      Checksum : 29a4fa98 - correct
        Events : 47341

        Layout : near=2
    Chunk Size : 512K

  Device Role : Active device 3
  Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
root@debianbase:/# mdadm --examine /dev/sdd1
/dev/sdd1:
         Magic : a92b4efc
       Version : 1.2
   Feature Map : 0x0
    Array UUID : 79baaa2f:0aa2b9fa:18e2ea6b:6e2846b3
          Name : debianbase:0  (local to host debianbase)
 Creation Time : Mon Mar  5 08:26:28 2012
    Raid Level : raid10
  Raid Devices : 4

Avail Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
    Array Size : 1953518592 (1863.02 GiB 2000.40 GB)
 Used Dev Size : 1953518592 (931.51 GiB 1000.20 GB)
   Data Offset : 2048 sectors
  Super Offset : 8 sectors
  Unused Space : before=1968 sectors, after=1024 sectors
         State : clean
   Device UUID : 9e749fa9:a0efe791:ea09d2e2:72b99f6c

   Update Time : Fri Aug 28 10:38:32 2015
      Checksum : 615d736 - correct
        Events : 47341

        Layout : near=2
    Chunk Size : 512K

  Device Role : Active device 1
  Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
root@debianbase:/#

Tried the following:

fsck.ext4 -N -b /dev/md0
e2fsck 1.42.13 (17-May-2015)
fsck.ext4: Invalid argument while trying to open /dev/md0

The superblock could not be read or does not describe a valid ext2/ext3/ext4
filesystem.  If the device is valid and it really contains an ext2/ext3/ext4
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
   e2fsck -b 8193 <device>
or
   e2fsck -b 32768 <device>

root@debianbase:/# dump2fs /dev/md0 | grep superblock
bash: dump2fs: command not found
root@debianbase:/# dumpe2fs /dev/md0 | grep superblock
dumpe2fs 1.42.13 (17-May-2015)
dumpe2fs: Invalid argument while trying to open /dev/md0
Couldn't find valid filesystem superblock.
root@debianbase:/# mdadm -A --force /dev/md0 /dev/sd[b1d1]2
mdadm: cannot open device /dev/sd[b1d1]2: No such file or directory
mdadm: /dev/sd[b1d1]2 has no superblock - assembly aborted
root@debianbase:/# mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdd1
mdadm: /dev/sdb1 is busy - skipping
mdadm: /dev/sdd1 is busy - skipping
root@debianbase:/# mdadm --stop /dev/md0
mdadm: stopped /dev/md0
root@debianbase:/# mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdd1
mdadm: /dev/md0 assembled from 2 drives - need all 4 to start it (use
--run to insist).
root@debianbase:/# mdadm --assemble --run /dev/md0 /dev/sdb1 /dev/sdd1
mdadm: /dev/sdb1 is busy - skipping
mdadm: /dev/sdd1 is busy - skipping


drives were all ext4 when the array was setup.


Is there some way to take the 2 drives and convince mdadm that they
are a raid 0?

How do I get the superblock issue to go away?

TIA

Dee
