From: Mike Berger <lists@mike01.com>
Subject: RAID 5 Recovery Help Needed
Date: Fri, 16 Jan 2009 13:35:40 -0600
Message-ID: <4970E18C.2000100@mike01.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm looking for some assistance in recovering a filesystem (if possible)
on a recently created RAID 5 array.

To summarize:  I created the array from 3x 1.5TB drives, each having a
GPT partition table and one non-fs data partition (0xDA), following the
instructions located here:
http://linux-raid.osdl.org/index.php/RAID_setup#RAID-5  After creating
the array, I formatted md0 with an ext4 (perhaps my first mistake) 
partition and used it without issue for a few days.  After I rebooted, I
found the array did not assemble at boot, and I was unable to manually
assemble it getting errors of no md superblocks on the partitions. 
After a lot of reading online, I tried recreating the array using the
original parameters and the addition of '--assume-clean' to prevent a
resync or rebuild (under the assumption this will keep the data
intact).  The array was recreated, and as far as I could tell no data
was touched (no noticable hard drive activity).  Upon trying to mount
md0 with the newly created array I get missing/bad superblock errors.

Now, the more verbose details:

I am running a vanilla 2.6.28 kernel (on Debian).
e2fslibs and e2fsprogs are both version 1.41.3
mdadm version 2.6.7.1


The steps I followed are as follows (exact commands pulled from bash
history where possible):

Created GPT partition tables on sdb,sdc,sdd

Created the partitions:
# parted /dev/sdb mkpart non-fs 0% 100%
# parted /dev/sdc mkpart non-fs 0% 100%
# parted /dev/sdd mkpart non-fs 0% 100%


Created the array:
# mdadm --create --verbose /dev/md0 --level=5 --chunk=128
--raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1

/dev/md0:
        Version : 00.90
  Creation Time : Sun Jan 11 19:00:43 2009
     Raid Level : raid5
     Array Size : 2930276864 (2794.53 GiB 3000.60 GB)
  Used Dev Size : 1465138432 (1397.26 GiB 1500.30 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Jan 11 19:18:13 2009
          State : clean, degraded, recovering
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 128K

 Rebuild Status : 2% complete

           UUID : 3128da32:c5e4ff31:b43fc0e6:226924cf (local to host 4400x2)
         Events : 0.4

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       3       8       49        2      spare rebuilding   /dev/sdd1


At this point, this could be seen in /var/log/messages:

kernel: md: bind<sdb1>
kernel: md: bind<sdc1>
kernel: md: bind<sdd1>
kernel: xor: automatically using best checksumming function: pIII_sse
kernel:    pIII_sse  : 11536.000 MB/sec
kernel: xor: using function: pIII_sse (11536.000 MB/sec)
kernel: async_tx: api initialized (sync-only)
kernel: raid6: int32x1   1210 MB/s
kernel: raid6: int32x2   1195 MB/s
kernel: raid6: int32x4    898 MB/s
kernel: raid6: int32x8    816 MB/s
kernel: raid6: mmxx1     3835 MB/s
kernel: raid6: mmxx2     4207 MB/s
kernel: raid6: sse1x1    2640 MB/s
kernel: raid6: sse1x2    3277 MB/s
kernel: raid6: sse2x1    4988 MB/s
kernel: raid6: sse2x2    5394 MB/s
kernel: raid6: using algorithm sse2x2 (5394 MB/s)
kernel: md: raid6 personality registered for level 6
kernel: md: raid5 personality registered for level 5
kernel: md: raid4 personality registered for level 4
kernel: raid5: device sdc1 operational as raid disk 1
kernel: raid5: device sdb1 operational as raid disk 0
kernel: raid5: allocated 3172kB for md0
kernel: RAID5 conf printout:
kernel:  --- rd:3 wd:2
kernel:  disk 0, o:1, dev:sdb1
kernel:  disk 1, o:1, dev:sdc1
kernel:  md0:RAID5 conf printout:
kernel:  --- rd:3 wd:2
kernel:  disk 0, o:1, dev:sdb1
kernel:  disk 1, o:1, dev:sdc1
kernel:  disk 2, o:1, dev:sdd1
kernel: md: recovery of RAID array md0

kernel: md: md0: recovery done.
kernel: RAID5 conf printout:
kernel:  --- rd:3 wd:3
kernel:  disk 0, o:1, dev:sdb1
kernel:  disk 1, o:1, dev:sdc1
kernel:  disk 2, o:1, dev:sdd1


Once the recovery was done I created the ext4 filesystem on md0:

# mkfs.ext4 -b 4096 -m 0 -O extents,uninit_bg -E
stride=32,stripe-width=64 /dev/md0

mke2fs 1.41.3 (12-Oct-2008)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
183148544 inodes, 732569216 blocks
0 blocks (0.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=0
22357 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632,
2654208,
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
        102400000, 214990848, 512000000, 550731776, 644972544

Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

At this point I used the newly created array for a few days without any
issues at all.

Then, I edited /etc/fstab to contain mount entry for /dev/md0 and
rebooted.  I should note that before brining the system back up I
removed a drive (formerly sde) that was no longer being used).

After the reboot, md0 was not assembled and I see this in messages (note
that I have the raid modules compiled in statically).

kernel:    pIII_sse  : 11536.000 MB/sec
kernel: xor: using function: pIII_sse (11536.000 MB/sec)
kernel: async_tx: api initialized (sync-only)
kernel: raid6: int32x1   1218 MB/s
kernel: raid6: int32x2   1199 MB/s
kernel: raid6: int32x4    898 MB/s
kernel: raid6: int32x8    816 MB/s
kernel: raid6: mmxx1     3863 MB/s
kernel: raid6: mmxx2     4273 MB/s
kernel: raid6: sse1x1    2640 MB/s
kernel: raid6: sse1x2    3285 MB/s
kernel: raid6: sse2x1    5007 MB/s
kernel: raid6: sse2x2    5402 MB/s
kernel: raid6: using algorithm sse2x2 (5402 MB/s)
kernel: md: raid6 personality registered for level 6
kernel: md: raid5 personality registered for level 5
kernel: md: raid4 personality registered for level 4
kernel: device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:
dm-devel@redhat.com
kernel: md: md0 stopped.

Now I tried to assemble the array manually using the following commands,
all of which failed (note that I had never edited mdadm.conf).

# mdadm --assemble --scan
# mdadm --assemble --scan --uuid=3128da32:c5e4ff31:b43fc0e6:226924cf
# mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1
# mdadm --assemble -f /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1
# mdadm --assemble --uuid=3128da32:c5e4ff31:b43fc0e6:226924cf /dev/md0
/dev/sdb1 /dev/sdc1 /dev/sdd1

The contents of mdadm.conf while executing the above were:

DEVICE partitions
CREATE owner=root group=disk mode=0660 auto=yes
HOMEHOST <system>
MAILADDR root

While attempting to assemble using the above, I received the output:

no devices found for /dev/md0
or
no recogniseable superblock on sdb1


After some googling, I read that recreating the array using the same
parameters and --assume-clean should keep the data intact.
So, I did the following (this may be my biggest mistake):

# mdadm --create --verbose /dev/md0 --level=5 --chunk=128 --assume-clean
--raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1

The recreation happened immediately with no rebuilding or other
noticable data movement.  I got the following output:

/dev/md0:
        Version : 00.90
  Creation Time : Thu Jan 15 21:45:26 2009
     Raid Level : raid5
     Array Size : 2930276864 (2794.53 GiB 3000.60 GB)
  Used Dev Size : 1465138432 (1397.26 GiB 1500.30 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jan 15 21:45:26 2009
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           UUID : 78902c67:a59cf188:b43fc0e6:226924cf (local to host 4400x2)
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1


And the following was seen in messages:

kernel: md: bind<sdb1>
kernel: md: bind<sdc1>
kernel: md: bind<sdd1>
kernel: raid5: device sdd1 operational as raid disk 2
kernel: raid5: device sdc1 operational as raid disk 1
kernel: raid5: device sdb1 operational as raid disk 0
kernel: raid5: allocated 3172kB for md0
kernel: raid5: raid level 5 set md0 active with 3 out of 3 devices,
algorithm 2
kernel: RAID5 conf printout:
kernel:  --- rd:3 wd:3
kernel:  disk 0, o:1, dev:sdb1
kernel:  disk 1, o:1, dev:sdc1
kernel:  disk 2, o:1, dev:sdd1
kernel:  md0: unknown partition table


Upon trying to with:
# mount -t ext4 /dev/md0 /media/archive

I get the following:

mount: wrong fs type, bad option, bad superblock on /dev/md0

When I try to run fsck with

# fsck.ext4 -n /dev/md0

I get:

fsck.ext4: Superblock invalid, trying backup blocks...
fsck.ext4: Bad magic number in super-block while trying to open /dev/md0

I've tried specifying the blocksize and specifying the superblock
manually using  the backup superblocks from when I ran mkfs.ext4, but
get the same result.  I haven't dared to run fsck without -n until I
hear from someone more knowledged.

So, if anyone has any suggestions on how I can get md0 mounted or
recover my data it would be much appreciated.

Thanks,
Mike Berger

