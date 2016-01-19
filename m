From: Tommy Wang <lists@august8.net>
Subject: Help with RAID data recovery.
Date: Tue, 19 Jan 2016 04:17:34 -0600
Message-ID: <76F26671-FFF1-473D-BDCE-51BA20DCBB2C@august8.net>
Mime-Version: 1.0 (Mac OS X Mail 9.0 \(3094\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I need some help recovering the data on a Synology NAS.  There are no backups of
the data (but, you can bet there will be if I recover the data!).

The situation:

7 drives in the NAS: 3x2TB, 2x3TB, 2x4TB.  Using Synology Hyrbid Raid (md+lvm2).

I started with 4x2TB, then expanded 1 disk at a time (3TB, 3TB, 4TB, 4TB).
While expanding with the 2nd 4TB, I experienced a failure (I was messing with
the Synology software and it fork bombed itself) and was forced to reboot.
Lesson: leave your system alone during any reshape.

The raid layout prior to expansion of second 4TB disk:

             sda  sdb  sdc       sde  sdf  sdg
             2TB  4TB  3TB       3TB  2TB  2TB
md0 (raid1): sda1 sdb1 sdc1      sde1 sdf1 sdg1 (2550 MB/partition)
md1 (raid1): sda2 sdb2 sdc2      sde2 sdf2 sdg2 (2147 MB/partition)
md2 (raid5): sda5 sdb5 sdc5      sde5 sdf5 sdg5 (1995 GB/partition)
md3 (raid5):      sdb6 sdc6      sde6           (1000 GB/partition)

Note, that sdb has 1 TB of unpartitioned space.

The raid layout after expansion of second 4TB disk:

             sda  sdb  sdc  sdd  sde  sdf  sdg
             2TB  4TB  3TB  4TB  3TB  2TB  2TB
md0 (raid1): sda1 sdb1 sdc1 sdd1 sde1 sdf1 sdg1 (2550 MB/partition)
md1 (raid1): sda2 sdb2 sdc2 sdd2 sde2 sdf2 sdg2 (2147 MB/partition)
md2 (raid5): sda5 sdb5 sdc5 sdd5 sde5 sdf5 sdg5 (1995 GB/partition)
md3 (raid5):      sdb6 sdc6 sdd6 sde6           (1000 GB/partition)
md4 (raid1):      sdb7      sdd7                (1000 GB/partition)

Synology uses md0 as the system partition and md1 as swap.  md2, md3, and m4 are
added to a single volume group (vg1000) and creates a single logical volume
(named lv).

After rebooting, I checked mdstat:

/proc/mdstat:

    Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
    md2 : active raid5 sda5[0] sdd5[6] sdb5[5] sde5[4] sdc5[3] sdg5[2] sdf5[1]
        11692100736 blocks super 1.2 level 5, 64k chunk, algorithm 2 [7/7] [UUUUUUU]
        [===========>.........]  resync = 55.2% (1076399232/1948683456) finish=208.5min speed=69700K/sec

    md4 : active raid1 sdb7[0] sdd7[1]
        976742912 blocks super 1.2 [2/2] [UU]

    md1 : active raid1 sda2[0] sdb2[1] sdc2[2] sdd2[3] sde2[4] sdf2[5] sdg2[6]
        2097088 blocks [12/7] [UUUUUUU_____]

    md0 : active raid1 sda1[0] sdb1[5] sdc1[3] sdd1[6] sde1[4] sdf1[1] sdg1[2]
        2490176 blocks [12/7] [UUUUUUU_____]

    unused devices: <none>

The above log was taken later, but I had actually rebooted it during reshape.
It appears that md2 automatically assembled and resumed reshape and resync.  It
also appears that md4 was successfully created.  But, where was md3?

Logs from mdadm --detail and --examine are included at the bottom of this email.
I have also included logs from parted -l, as well as /var/log/messages, and
pertinent files from /etc/lvm/backup and /etc/lvm/archive.

I let md2 complete and then left the system alone.  Unfortunately, last night I
experienced a power failure and I have not powered it on since.

In order to better understand what was going on, I created a VirtualBox VM to
simulate the failure.  I added 3x8GB, 2x10GB, and 2x12GB disks in some random
order to the IDE and a SATA controller on the virtual machine.

After installing Synology, I expanded the disks in the same order I did for the
NAS (8G/8G/8G + 10G + 10G + 12G + 12G), and killed power to the VM during the
expansion of the last 12GB disk.

Here is /proc/mdstat prior to expanding the last disk:

    Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
    md3 : active raid5 sdf6[2] sdd6[1] sda6[0]
        4174720 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]

    md2 : active raid5 sdg5[5] sdf5[4] sde5[3] sdd5[2] sdb5[1] sda5[0]
        17786560 blocks super 1.2 level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]

    md1 : active raid1 sda2[0] sdb2[1] sdc2[2] sdd2[3] sde2[4] sdf2[5] sdg2[6]
        2097088 blocks [12/7] [UUUUUUU_____]

    md0 : active raid1 sda1[0] sdb1[1] sdc1[2] sdd1[3] sde1[4] sdf1[5] sdg1[6]
        2490176 blocks [12/7] [UUUUUUU_____]

    unused devices: <none>

For the VM, sdc was the new disk (it was present when the NAS was installed, so
it is a member of md0 and md1; but, was not included in the initial build of the
md2 array).  I put a watch -n 1 'cat /proc/mdstat' and started the last
expansion:

    Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
    md4 : active raid1 sdc7[1] sda7[0]
        2087360 blocks super 1.2 [2/2] [UU]

    md3 : active raid5 sda6[0] sdf6[2] sdd6[1]
        4174720 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]

    md2 : active raid5 sdc5[6] sda5[0] sdg5[5] sdf5[4] sde5[3] sdd5[2] sdb5[1]
        17786560 blocks super 1.2 level 5, 64k chunk, algorithm 2 [7/7] [UUUUUUU]
        [>....................]  reshape =  0.6% (24320/3557312) finish=4.8min speed=12160K/sec

    md1 : active raid1 sda2[0] sdb2[1] sdc2[2] sdd2[3] sde2[4] sdf2[5] sdg2[6]
        2097088 blocks [12/7] [UUUUUUU_____]

    md0 : active raid1 sda1[0] sdb1[1] sdc1[2] sdd1[3] sde1[4] sdf1[5] sdg1[6]
        2490176 blocks [12/7] [UUUUUUU_____]

    unused devices: <none>

    Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
    md4 : active raid1 sdc7[1] sda7[0]
        2087360 blocks super 1.2 [2/2] [UU]

    md3 : active raid5 sdc6[3] sda6[0] sdf6[2] sdd6[1]
        4174720 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
            resync=DELAYED

    md2 : active raid5 sdc5[6] sda5[0] sdg5[5] sdf5[4] sde5[3] sdd5[2] sdb5[1]
        17786560 blocks super 1.2 level 5, 64k chunk, algorithm 2 [7/7] [UUUUUUU]
        [>....................]  reshape =  0.8% (30080/3557312) finish=5.8min speed=10026K/sec

    md1 : active raid1 sda2[0] sdb2[1] sdc2[2] sdd2[3] sde2[4] sdf2[5] sdg2[6]
        2097088 blocks [12/7] [UUUUUUU_____]

    md0 : active raid1 sda1[0] sdb1[1] sdc1[2] sdd1[3] sde1[4] sdf1[5] sdg1[6]
        2490176 blocks [12/7] [UUUUUUU_____]

    unused devices: <none>

Notice that:

* md4 was created from sdc7 and sda7
* md3 was converted to a 4-disk raid5, but resync=DELAYED
* md2 was converted to a 7-disk raid5 and is currently performing a reshape

My guess is that Synology performed all actions against the RAID devices, but
allowed mdadm to perform reshape/resync one device at a time.  I assume that
Synology next continuously polls mdstat, and when finished, will perform the
vgextend/lvextend actions.

Upon powering on the VM again, I inspected mdstat again:

    Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
    md4 : active raid1 sda7[0] sdc7[1]
        2087360 blocks super 1.2 [2/2] [UU]

    md2 : active raid5 sda5[0] sdc5[6] sdg5[5] sdf5[4] sde5[3] sdd5[2] sdb5[1]
        17786560 blocks super 1.2 level 5, 64k chunk, algorithm 2 [7/7] [UUUUUUU]
        [==>..................]  reshape = 13.7% (489056/3557312) finish=3.9min speed=13013K/sec

    md1 : active raid1 sda2[0] sdb2[1] sdc2[2] sdd2[3] sde2[4] sdf2[5] sdg2[6]
        2097088 blocks [12/7] [UUUUUUU_____]

    md0 : active raid1 sda1[0] sdb1[1] sdc1[2] sdd1[3] sde1[4] sdf1[5] sdg1[6]
        2490176 blocks [12/7] [UUUUUUU_____]

    unused devices: <none>

Much like my real NAS, md2 resumed reshape/resync, md3 disappeared, and md4 was
created and is clean.

At this point, I tried to reassemble md3, but got stuck because I didn't have a
backup-file (even though the Reshape pos'n was 0).  It would just say:

    mdadm: Failed to restore critical section for reshape, sorry.
          Possibly you needed to specify the --backup-file

Assuming md3 was not touched at all other than perhaps metadata for the raid
configuration, I reasoned that I should be able to just recreate the array in
the configuration prior to expansion.  The output mdadm -A --scan --verbose
shows me that /dev/sd[adfc] were slots 0-3 for md3.  Assuming that the new
partition is slot 3, I tried to re-create the array with the first 3 devices:

    size=$(( $(mdadm --examine /dev/sda6 | grep Used | tr -s ' ' | cut -d' ' -f6) / 2 ))
    mdadm --create --assume-clean --level=5 --raid-devices=3 --size=$size /dev/md3 /dev/sd[adf]6
    vgchange -a y
    mount /dev/vg1000/lv /mnt

And, voila!  My data is there.  I ran some quick CRC-32 and SHA-1 sums on my
test data and they all match.

UPDATE:

I tried re-creating the array with all four disks as well:

    size=$(( $(mdadm --examine /dev/sda6 | grep Used | tr -s ' ' | cut -d' ' -f6) / 2 ))
    mdadm --create --assume-clean --level=5 --raid-devices=4 --size=$size /dev/md3 /dev/sd[adfc]6
    vgchange -a y
    mount /dev/vg1000/lv /mnt

This also appears to work.

The main questions are:

1. Can I expect to follow the same procedure to recover my data on my NAS?
2. Is there a safer way to recover the data than re-creating the array?
   The linux-raid wiki says that recreating the array should be the *last*
   resort.  I have read other people ask for help with data recovery, and a
   common response is to STOP and email this list.
3. Does the order of the devices matter (/dev/sd[adfc]6) matter in the mdadm
   --create command?  I am infering the order from mdadm -A --scan --verbose but
   it appears that the array is successfully created in the right order
   regardless of the order I pass in my arguments.
4. Should I recover with 3-disks or 4-disks?  Both seemed to work, and the
   4-disk variant did not list the last disk as "spare" -- it was active.

I did try the other advice on the wiki (as well as other Internet sources), but
the version of mdadm does not support --invalid-backup, nor does it support
--update=revert-reshape.  I could not get an overlay working, as anytime I tried
to add a disk to use as an overlay, it would completely rename the devices
(which I read is a no-no).  I also tried booting with a rescue CD to try to get
a newer version of mdadm, but that also renamed everything (my md devices showed
up as /dev/md126, /dev/md127, etc).

Thanks in advance!

Below are logs:

[parted -l]

Model: ATA WDC WD20EARX-00P (scsi)
Disk /dev/hda: 2000GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End     Size    Type      File system  Flags
 1      1049kB  2551MB  2550MB  primary                raid
 2      2551MB  4699MB  2147MB  primary                raid
 3      4832MB  2000GB  1996GB  extended               lba
 5      4840MB  2000GB  1995GB  logical                raid


Model: WDC WD20EARX-00PASB0 (scsi)
Disk /dev/sda: 2000GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End     Size    Type      File system  Flags
 1      1049kB  2551MB  2550MB  primary                raid
 2      2551MB  4699MB  2147MB  primary                raid
 3      4832MB  2000GB  1996GB  extended               lba
 5      4840MB  2000GB  1995GB  logical                raid


Model: ATA ST4000DM000-1F21 (scsi)
Disk /dev/sdb: 4001GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size    File system     Name  Flags
 1      1049kB  2551MB  2550MB  ext4                  raid
 2      2551MB  4699MB  2147MB  linux-swap(v1)        raid
 5      4840MB  2000GB  1995GB                        raid
 6      2000GB  3000GB  1000GB                        raid
 7      3000GB  4001GB  1000GB                        raid


Model: ATA ST3000DM001-1ER1 (scsi)
Disk /dev/sdc: 3001GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size    File system     Name  Flags
 1      1049kB  2551MB  2550MB  ext4                  raid
 2      2551MB  4699MB  2147MB  linux-swap(v1)        raid
 5      4840MB  2000GB  1995GB                        raid
 6      2000GB  3000GB  1000GB                        raid


Model: ATA ST4000DM000-1F21 (scsi)
Disk /dev/sdd: 4001GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size    File system     Name  Flags
 1      1049kB  2551MB  2550MB  ext4                  raid
 2      2551MB  4699MB  2147MB  linux-swap(v1)        raid
 5      4840MB  2000GB  1995GB                        raid
 6      2000GB  3000GB  1000GB                        raid
 7      3000GB  4001GB  1000GB                        raid


Model: ATA ST3000DM001-1CH1 (scsi)
Disk /dev/sde: 3001GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size    File system     Name  Flags
 1      1049kB  2551MB  2550MB  ext4                  raid
 2      2551MB  4699MB  2147MB  linux-swap(v1)        raid
 5      4840MB  2000GB  1995GB                        raid
 6      2000GB  3000GB  1000GB                        raid


Model: WDC WD20EARS-00S8B1 (scsi)
Disk /dev/sdf: 2000GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End     Size    Type      File system  Flags
 1      1049kB  2551MB  2550MB  primary                raid
 2      2551MB  4699MB  2147MB  primary                raid
 3      4832MB  2000GB  1996GB  extended               lba
 5      4840MB  2000GB  1995GB  logical                raid


Model: Linux Software RAID Array (md)
Disk /dev/md0: 2550MB
Sector size (logical/physical): 512B/512B
Partition Table: loop
Disk Flags: 

Number  Start  End     Size    File system  Flags
 1      0.00B  2550MB  2550MB  ext4


Model: Linux Software RAID Array (md)
Disk /dev/md1: 2147MB
Sector size (logical/physical): 512B/512B
Partition Table: loop
Disk Flags: 

Number  Start  End     Size    File system     Flags
 1      0.00B  2147MB  2147MB  linux-swap(v1)

Model: Linux Software RAID Array (md)
Disk /dev/md2: 12.0TB
Sector size (logical/physical): 512B/512B
Partition Table: unknown
Disk Flags: 


Model: Linux Software RAID Array (md)
Disk /dev/md4: 1000GB
Sector size (logical/physical): 512B/512B
Partition Table: unknown
Disk Flags: 

Model: WDC WD20EARS-00MVWB0 (scsi)
Disk /dev/sdg: 2000GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End     Size    Type      File system  Flags
 1      1049kB  2551MB  2550MB  primary                raid
 2      2551MB  4699MB  2147MB  primary                raid
 3      4832MB  2000GB  1996GB  extended               lba
 5      4840MB  2000GB  1995GB  logical                raid

[madm --examine /dev/sd?1]

/dev/sda1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ed28b380:6ad04214:3017a5a8:c86610be
  Creation Time : Thu Dec 31 09:42:30 2015
     Raid Level : raid1
  Used Dev Size : 2490176 (2.37 GiB 2.55 GB)
     Array Size : 2490176 (2.37 GiB 2.55 GB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 0

    Update Time : Sun Jan 17 13:11:30 2016
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 5
  Spare Devices : 0
       Checksum : a6f58618 - correct
         Events : 404046


      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       17        5      active sync   /dev/sdb1
   6     6       8       49        6      active sync   /dev/sdd1
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9       0        0        9      faulty removed
  10    10       0        0       10      faulty removed
  11    11       0        0       11      faulty removed
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ed28b380:6ad04214:3017a5a8:c86610be
  Creation Time : Thu Dec 31 09:42:30 2015
     Raid Level : raid1
  Used Dev Size : 2490176 (2.37 GiB 2.55 GB)
     Array Size : 2490176 (2.37 GiB 2.55 GB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 0

    Update Time : Sun Jan 17 13:11:30 2016
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 5
  Spare Devices : 0
       Checksum : a6f58632 - correct
         Events : 404046


      Number   Major   Minor   RaidDevice State
this     5       8       17        5      active sync   /dev/sdb1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       17        5      active sync   /dev/sdb1
   6     6       8       49        6      active sync   /dev/sdd1
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9       0        0        9      faulty removed
  10    10       0        0       10      faulty removed
  11    11       0        0       11      faulty removed
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ed28b380:6ad04214:3017a5a8:c86610be
  Creation Time : Thu Dec 31 09:42:30 2015
     Raid Level : raid1
  Used Dev Size : 2490176 (2.37 GiB 2.55 GB)
     Array Size : 2490176 (2.37 GiB 2.55 GB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 0

    Update Time : Sun Jan 17 13:11:30 2016
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 5
  Spare Devices : 0
       Checksum : a6f5863e - correct
         Events : 404046


      Number   Major   Minor   RaidDevice State
this     3       8       33        3      active sync   /dev/sdc1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       17        5      active sync   /dev/sdb1
   6     6       8       49        6      active sync   /dev/sdd1
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9       0        0        9      faulty removed
  10    10       0        0       10      faulty removed
  11    11       0        0       11      faulty removed
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ed28b380:6ad04214:3017a5a8:c86610be
  Creation Time : Thu Dec 31 09:42:30 2015
     Raid Level : raid1
  Used Dev Size : 2490176 (2.37 GiB 2.55 GB)
     Array Size : 2490176 (2.37 GiB 2.55 GB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 0

    Update Time : Sun Jan 17 13:11:30 2016
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 5
  Spare Devices : 0
       Checksum : a6f58654 - correct
         Events : 404046


      Number   Major   Minor   RaidDevice State
this     6       8       49        6      active sync   /dev/sdd1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       17        5      active sync   /dev/sdb1
   6     6       8       49        6      active sync   /dev/sdd1
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9       0        0        9      faulty removed
  10    10       0        0       10      faulty removed
  11    11       0        0       11      faulty removed
/dev/sde1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ed28b380:6ad04214:3017a5a8:c86610be
  Creation Time : Thu Dec 31 09:42:30 2015
     Raid Level : raid1
  Used Dev Size : 2490176 (2.37 GiB 2.55 GB)
     Array Size : 2490176 (2.37 GiB 2.55 GB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 0

    Update Time : Sun Jan 17 13:11:30 2016
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 5
  Spare Devices : 0
       Checksum : a6f58660 - correct
         Events : 404046


      Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       17        5      active sync   /dev/sdb1
   6     6       8       49        6      active sync   /dev/sdd1
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9       0        0        9      faulty removed
  10    10       0        0       10      faulty removed
  11    11       0        0       11      faulty removed
/dev/sdf1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ed28b380:6ad04214:3017a5a8:c86610be
  Creation Time : Thu Dec 31 09:42:30 2015
     Raid Level : raid1
  Used Dev Size : 2490176 (2.37 GiB 2.55 GB)
     Array Size : 2490176 (2.37 GiB 2.55 GB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 0

    Update Time : Sun Jan 17 13:11:30 2016
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 5
  Spare Devices : 0
       Checksum : a6f5866a - correct
         Events : 404046


      Number   Major   Minor   RaidDevice State
this     1       8       81        1      active sync   /dev/sdf1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       17        5      active sync   /dev/sdb1
   6     6       8       49        6      active sync   /dev/sdd1
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9       0        0        9      faulty removed
  10    10       0        0       10      faulty removed
  11    11       0        0       11      faulty removed
/dev/sdg1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ed28b380:6ad04214:3017a5a8:c86610be
  Creation Time : Thu Dec 31 09:42:30 2015
     Raid Level : raid1
  Used Dev Size : 2490176 (2.37 GiB 2.55 GB)
     Array Size : 2490176 (2.37 GiB 2.55 GB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 0

    Update Time : Sun Jan 17 13:11:30 2016
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 5
  Spare Devices : 0
       Checksum : a6f5867c - correct
         Events : 404046


      Number   Major   Minor   RaidDevice State
this     2       8       97        2      active sync   /dev/sdg1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       17        5      active sync   /dev/sdb1
   6     6       8       49        6      active sync   /dev/sdd1
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9       0        0        9      faulty removed
  10    10       0        0       10      faulty removed
  11    11       0        0       11      faulty removed

[mdadm --examine /dev/sd?2]

/dev/sda2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d74ec230:ea7269c6:0d6fa14f:d3c5b4e4 (local to host G530)
  Creation Time : Mon Jan 11 18:23:11 2016
     Raid Level : raid1
  Used Dev Size : 2097088 (2048.28 MiB 2147.42 MB)
     Array Size : 2097088 (2048.28 MiB 2147.42 MB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 1

    Update Time : Sun Jan 17 13:12:28 2016
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 5
  Spare Devices : 0
       Checksum : f9720367 - correct
         Events : 56


      Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2
   4     4       8       66        4      active sync   /dev/sde2
   5     5       8       82        5      active sync   /dev/sdf2
   6     6       8       98        6      active sync   /dev/sdg2
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9       0        0        9      faulty removed
  10    10       0        0       10      faulty removed
  11    11       0        0       11      faulty removed
/dev/sdb2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d74ec230:ea7269c6:0d6fa14f:d3c5b4e4 (local to host G530)
  Creation Time : Mon Jan 11 18:23:11 2016
     Raid Level : raid1
  Used Dev Size : 2097088 (2048.28 MiB 2147.42 MB)
     Array Size : 2097088 (2048.28 MiB 2147.42 MB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 1

    Update Time : Sun Jan 17 13:12:28 2016
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 5
  Spare Devices : 0
       Checksum : f9720379 - correct
         Events : 56


      Number   Major   Minor   RaidDevice State
this     1       8       18        1      active sync   /dev/sdb2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2
   4     4       8       66        4      active sync   /dev/sde2
   5     5       8       82        5      active sync   /dev/sdf2
   6     6       8       98        6      active sync   /dev/sdg2
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9       0        0        9      faulty removed
  10    10       0        0       10      faulty removed
  11    11       0        0       11      faulty removed
/dev/sdc2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d74ec230:ea7269c6:0d6fa14f:d3c5b4e4 (local to host G530)
  Creation Time : Mon Jan 11 18:23:11 2016
     Raid Level : raid1
  Used Dev Size : 2097088 (2048.28 MiB 2147.42 MB)
     Array Size : 2097088 (2048.28 MiB 2147.42 MB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 1

    Update Time : Sun Jan 17 13:12:28 2016
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 5
  Spare Devices : 0
       Checksum : f972038b - correct
         Events : 56


      Number   Major   Minor   RaidDevice State
this     2       8       34        2      active sync   /dev/sdc2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2
   4     4       8       66        4      active sync   /dev/sde2
   5     5       8       82        5      active sync   /dev/sdf2
   6     6       8       98        6      active sync   /dev/sdg2
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9       0        0        9      faulty removed
  10    10       0        0       10      faulty removed
  11    11       0        0       11      faulty removed
/dev/sdd2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d74ec230:ea7269c6:0d6fa14f:d3c5b4e4 (local to host G530)
  Creation Time : Mon Jan 11 18:23:11 2016
     Raid Level : raid1
  Used Dev Size : 2097088 (2048.28 MiB 2147.42 MB)
     Array Size : 2097088 (2048.28 MiB 2147.42 MB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 1

    Update Time : Sun Jan 17 13:12:28 2016
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 5
  Spare Devices : 0
       Checksum : f972039d - correct
         Events : 56


      Number   Major   Minor   RaidDevice State
this     3       8       50        3      active sync   /dev/sdd2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2
   4     4       8       66        4      active sync   /dev/sde2
   5     5       8       82        5      active sync   /dev/sdf2
   6     6       8       98        6      active sync   /dev/sdg2
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9       0        0        9      faulty removed
  10    10       0        0       10      faulty removed
  11    11       0        0       11      faulty removed
/dev/sde2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d74ec230:ea7269c6:0d6fa14f:d3c5b4e4 (local to host G530)
  Creation Time : Mon Jan 11 18:23:11 2016
     Raid Level : raid1
  Used Dev Size : 2097088 (2048.28 MiB 2147.42 MB)
     Array Size : 2097088 (2048.28 MiB 2147.42 MB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 1

    Update Time : Sun Jan 17 13:12:28 2016
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 5
  Spare Devices : 0
       Checksum : f97203af - correct
         Events : 56


      Number   Major   Minor   RaidDevice State
this     4       8       66        4      active sync   /dev/sde2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2
   4     4       8       66        4      active sync   /dev/sde2
   5     5       8       82        5      active sync   /dev/sdf2
   6     6       8       98        6      active sync   /dev/sdg2
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9       0        0        9      faulty removed
  10    10       0        0       10      faulty removed
  11    11       0        0       11      faulty removed
/dev/sdf2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d74ec230:ea7269c6:0d6fa14f:d3c5b4e4 (local to host G530)
  Creation Time : Mon Jan 11 18:23:11 2016
     Raid Level : raid1
  Used Dev Size : 2097088 (2048.28 MiB 2147.42 MB)
     Array Size : 2097088 (2048.28 MiB 2147.42 MB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 1

    Update Time : Sun Jan 17 13:12:28 2016
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 5
  Spare Devices : 0
       Checksum : f97203c1 - correct
         Events : 56


      Number   Major   Minor   RaidDevice State
this     5       8       82        5      active sync   /dev/sdf2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2
   4     4       8       66        4      active sync   /dev/sde2
   5     5       8       82        5      active sync   /dev/sdf2
   6     6       8       98        6      active sync   /dev/sdg2
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9       0        0        9      faulty removed
  10    10       0        0       10      faulty removed
  11    11       0        0       11      faulty removed
/dev/sdg2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d74ec230:ea7269c6:0d6fa14f:d3c5b4e4 (local to host G530)
  Creation Time : Mon Jan 11 18:23:11 2016
     Raid Level : raid1
  Used Dev Size : 2097088 (2048.28 MiB 2147.42 MB)
     Array Size : 2097088 (2048.28 MiB 2147.42 MB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 1

    Update Time : Sun Jan 17 13:12:28 2016
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 5
  Spare Devices : 0
       Checksum : f97203d3 - correct
         Events : 56


      Number   Major   Minor   RaidDevice State
this     6       8       98        6      active sync   /dev/sdg2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2
   4     4       8       66        4      active sync   /dev/sde2
   5     5       8       82        5      active sync   /dev/sdf2
   6     6       8       98        6      active sync   /dev/sdg2
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9       0        0        9      faulty removed
  10    10       0        0       10      faulty removed
  11    11       0        0       11      faulty removed

[mdadm --examine /dev/sd?5]

/dev/sda5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ea9a241d:1482b49d:5ea11c87:e689bdf0
           Name : G530:2  (local to host G530)
  Creation Time : Thu Dec 31 09:58:51 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3897366912 (1858.41 GiB 1995.45 GB)
     Array Size : 23384201472 (11150.46 GiB 11972.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 48540530:5319c3ff:053851e3:4ae0a358

    Update Time : Sun Jan 17 13:11:02 2016
       Checksum : 66a27c76 - correct
         Events : 39119

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAAAAAA ('A' == active, '.' == missing)
/dev/sdb5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ea9a241d:1482b49d:5ea11c87:e689bdf0
           Name : G530:2  (local to host G530)
  Creation Time : Thu Dec 31 09:58:51 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3897366912 (1858.41 GiB 1995.45 GB)
     Array Size : 23384201472 (11150.46 GiB 11972.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : ef97a20f:01900be1:552d9a54:d7bf0662

    Update Time : Sun Jan 17 13:11:02 2016
       Checksum : a2340bac - correct
         Events : 39119

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 5
   Array State : AAAAAAA ('A' == active, '.' == missing)
/dev/sdc5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ea9a241d:1482b49d:5ea11c87:e689bdf0
           Name : G530:2  (local to host G530)
  Creation Time : Thu Dec 31 09:58:51 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3897366912 (1858.41 GiB 1995.45 GB)
     Array Size : 23384201472 (11150.46 GiB 11972.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : e60d53a3:e106cc0b:1435aa89:10876e49

    Update Time : Sun Jan 17 13:11:02 2016
       Checksum : 7d1cc779 - correct
         Events : 39119

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : AAAAAAA ('A' == active, '.' == missing)
/dev/sdd5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ea9a241d:1482b49d:5ea11c87:e689bdf0
           Name : G530:2  (local to host G530)
  Creation Time : Thu Dec 31 09:58:51 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3897366912 (1858.41 GiB 1995.45 GB)
     Array Size : 23384201472 (11150.46 GiB 11972.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 22d4e109:a3c1e226:9a7ebfe6:005d9ca3

    Update Time : Sun Jan 17 13:11:02 2016
       Checksum : b60567f0 - correct
         Events : 39119

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 6
   Array State : AAAAAAA ('A' == active, '.' == missing)
/dev/sde5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ea9a241d:1482b49d:5ea11c87:e689bdf0
           Name : G530:2  (local to host G530)
  Creation Time : Thu Dec 31 09:58:51 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3897366912 (1858.41 GiB 1995.45 GB)
     Array Size : 23384201472 (11150.46 GiB 11972.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : a08b2485:0f2efd4e:645a20f8:16dcde68

    Update Time : Sun Jan 17 13:11:02 2016
       Checksum : 3005e6b9 - correct
         Events : 39119

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 4
   Array State : AAAAAAA ('A' == active, '.' == missing)
/dev/sdf5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ea9a241d:1482b49d:5ea11c87:e689bdf0
           Name : G530:2  (local to host G530)
  Creation Time : Thu Dec 31 09:58:51 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3897366912 (1858.41 GiB 1995.45 GB)
     Array Size : 23384201472 (11150.46 GiB 11972.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 5d021082:54485b2c:4644bd82:454656fa

    Update Time : Sun Jan 17 13:11:02 2016
       Checksum : 2663cbc9 - correct
         Events : 39119

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AAAAAAA ('A' == active, '.' == missing)
/dev/sdg5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ea9a241d:1482b49d:5ea11c87:e689bdf0
           Name : G530:2  (local to host G530)
  Creation Time : Thu Dec 31 09:58:51 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3897366912 (1858.41 GiB 1995.45 GB)
     Array Size : 23384201472 (11150.46 GiB 11972.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 53c65dfd:49e8d483:c0fb21a3:7ccf5336

    Update Time : Sun Jan 17 13:11:02 2016
       Checksum : 558d7066 - correct
         Events : 39119

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : AAAAAAA ('A' == active, '.' == missing)

[mdadm --examine /dev/sd?6]

/dev/sdb6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 7a711117:6923feb5:189dd236:a4588ccb
           Name : G530:3  (local to host G530)
  Creation Time : Sun Jan 10 14:42:24 2016
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953485856 (931.49 GiB 1000.18 GB)
     Array Size : 5860457472 (2794.48 GiB 3000.55 GB)
  Used Dev Size : 1953485824 (931.49 GiB 1000.18 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : cf7de3ce:9870bc53:10996640:fecad7fe

  Reshape pos'n : 0
  Delta Devices : 1 (3->4)

    Update Time : Sat Jan 16 04:00:42 2016
       Checksum : 9ffe27fd - correct
         Events : 2662

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdc6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 7a711117:6923feb5:189dd236:a4588ccb
           Name : G530:3  (local to host G530)
  Creation Time : Sun Jan 10 14:42:24 2016
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953485856 (931.49 GiB 1000.18 GB)
     Array Size : 5860457472 (2794.48 GiB 3000.55 GB)
  Used Dev Size : 1953485824 (931.49 GiB 1000.18 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 689fe836:76c74e90:fb6af582:1fc460b9

  Reshape pos'n : 0
  Delta Devices : 1 (3->4)

    Update Time : Sat Jan 16 04:00:42 2016
       Checksum : 41ad6b7e - correct
         Events : 2662

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdd6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 7a711117:6923feb5:189dd236:a4588ccb
           Name : G530:3  (local to host G530)
  Creation Time : Sun Jan 10 14:42:24 2016
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953485856 (931.49 GiB 1000.18 GB)
     Array Size : 5860457472 (2794.48 GiB 3000.55 GB)
  Used Dev Size : 1953485824 (931.49 GiB 1000.18 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : bed228eb:31257f54:c2aa00d7:063375f1

  Reshape pos'n : 0
  Delta Devices : 1 (3->4)

    Update Time : Sat Jan 16 04:00:42 2016
       Checksum : 463dab41 - correct
         Events : 2662

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sde6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 7a711117:6923feb5:189dd236:a4588ccb
           Name : G530:3  (local to host G530)
  Creation Time : Sun Jan 10 14:42:24 2016
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953485856 (931.49 GiB 1000.18 GB)
     Array Size : 5860457472 (2794.48 GiB 3000.55 GB)
  Used Dev Size : 1953485824 (931.49 GiB 1000.18 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 6a627079:cfb96d7c:4ab53bf4:c92ca522

  Reshape pos'n : 0
  Delta Devices : 1 (3->4)

    Update Time : Sat Jan 16 04:00:42 2016
       Checksum : 4aded3d3 - correct
         Events : 2662

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing)

[mdadm --examine /dev/sd?7]

/dev/sdb7:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 80224e42:05546401:c3cc4e39:177c3cb1
           Name : G530:4  (local to host G530)
  Creation Time : Sat Jan 16 04:00:36 2016
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1953485856 (931.49 GiB 1000.18 GB)
     Array Size : 1953485824 (931.49 GiB 1000.18 GB)
  Used Dev Size : 1953485824 (931.49 GiB 1000.18 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 914b86e5:34498dc9:4319a930:c8ce2e06

    Update Time : Sun Jan 17 02:57:27 2016
       Checksum : 82df11db - correct
         Events : 2


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)
/dev/sdd7:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 80224e42:05546401:c3cc4e39:177c3cb1
           Name : G530:4  (local to host G530)
  Creation Time : Sat Jan 16 04:00:36 2016
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1953485856 (931.49 GiB 1000.18 GB)
     Array Size : 1953485824 (931.49 GiB 1000.18 GB)
  Used Dev Size : 1953485824 (931.49 GiB 1000.18 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 075d1bd6:f89b5714:41c9b39a:9a8fe9a2

    Update Time : Sun Jan 17 02:57:27 2016
       Checksum : c503e6e6 - correct
         Events : 2


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)

[mdadm --detail /dev/md[0124]

/dev/md0:
        Version : 0.90
  Creation Time : Thu Dec 31 09:42:30 2015
     Raid Level : raid1
     Array Size : 2490176 (2.37 GiB 2.55 GB)
  Used Dev Size : 2490176 (2.37 GiB 2.55 GB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Jan 17 13:16:37 2016
          State : clean, degraded
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

           UUID : ed28b380:6ad04214:3017a5a8:c86610be
         Events : 0.404128

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       81        1      active sync   /dev/sdf1
       2       8       97        2      active sync   /dev/sdg1
       3       8       33        3      active sync   /dev/sdc1
       4       8       65        4      active sync   /dev/sde1
       5       8       17        5      active sync   /dev/sdb1
       6       8       49        6      active sync   /dev/sdd1
       7       0        0        7      removed
       8       0        0        8      removed
       9       0        0        9      removed
      10       0        0       10      removed
      11       0        0       11      removed
/dev/md1:
        Version : 0.90
  Creation Time : Mon Jan 11 18:23:11 2016
     Raid Level : raid1
     Array Size : 2097088 (2048.28 MiB 2147.42 MB)
  Used Dev Size : 2097088 (2048.28 MiB 2147.42 MB)
   Raid Devices : 12
  Total Devices : 7
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Sun Jan 17 13:12:28 2016
          State : clean, degraded
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

           UUID : d74ec230:ea7269c6:0d6fa14f:d3c5b4e4 (local to host G530)
         Events : 0.56

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       8       34        2      active sync   /dev/sdc2
       3       8       50        3      active sync   /dev/sdd2
       4       8       66        4      active sync   /dev/sde2
       5       8       82        5      active sync   /dev/sdf2
       6       8       98        6      active sync   /dev/sdg2
       7       0        0        7      removed
       8       0        0        8      removed
       9       0        0        9      removed
      10       0        0       10      removed
      11       0        0       11      removed
/dev/md2:
        Version : 1.2
  Creation Time : Thu Dec 31 09:58:51 2015
     Raid Level : raid5
     Array Size : 11692100736 (11150.46 GiB 11972.71 GB)
  Used Dev Size : 1948683456 (1858.41 GiB 1995.45 GB)
   Raid Devices : 7
  Total Devices : 7
    Persistence : Superblock is persistent

    Update Time : Sun Jan 17 13:16:02 2016
          State : active, resyncing
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 54% complete

           Name : G530:2  (local to host G530)
           UUID : ea9a241d:1482b49d:5ea11c87:e689bdf0
         Events : 39120

    Number   Major   Minor   RaidDevice State
       0       8        5        0      active sync   /dev/sda5
       1       8       85        1      active sync   /dev/sdf5
       2       8      101        2      active sync   /dev/sdg5
       3       8       37        3      active sync   /dev/sdc5
       4       8       69        4      active sync   /dev/sde5
       5       8       21        5      active sync   /dev/sdb5
       6       8       53        6      active sync   /dev/sdd5
/dev/md4:
        Version : 1.2
  Creation Time : Sat Jan 16 04:00:36 2016
     Raid Level : raid1
     Array Size : 976742912 (931.49 GiB 1000.18 GB)
  Used Dev Size : 976742912 (931.49 GiB 1000.18 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Sun Jan 17 02:57:27 2016
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : G530:4  (local to host G530)
           UUID : 80224e42:05546401:c3cc4e39:177c3cb1
         Events : 2

    Number   Major   Minor   RaidDevice State
       0       8       23        0      active sync   /dev/sdb7
       1       8       55        1      active sync   /dev/sdd7

[mdadm -A --scan --verbose]

mdadm: looking for devices for further assembly
mdadm: no recogniseable superblock on 135:241
mdadm: no recogniseable superblock on /dev/synoboot
mdadm: no recogniseable superblock on /dev/md2
mdadm: no recogniseable superblock on /dev/md4
mdadm: cannot open device /dev/zram1: Device or resource busy
mdadm: cannot open device /dev/zram0: Device or resource busy
mdadm: cannot open device /dev/md1: Device or resource busy
mdadm: cannot open device /dev/md0: Device or resource busy
mdadm: cannot open device /dev/sda5: Device or resource busy
mdadm: no recogniseable superblock on /dev/sda3
mdadm: cannot open device /dev/sda2: Device or resource busy
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: cannot open device /dev/sdb7: Device or resource busy
mdadm: cannot open device /dev/sdb5: Device or resource busy
mdadm: cannot open device /dev/sdb2: Device or resource busy
mdadm: cannot open device /dev/sdb1: Device or resource busy
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: cannot open device /dev/sdd7: Device or resource busy
mdadm: cannot open device /dev/sdd5: Device or resource busy
mdadm: cannot open device /dev/sdd2: Device or resource busy
mdadm: cannot open device /dev/sdd1: Device or resource busy
mdadm: cannot open device /dev/sdd: Device or resource busy
mdadm: cannot open device /dev/sde5: Device or resource busy
mdadm: cannot open device /dev/sde2: Device or resource busy
mdadm: cannot open device /dev/sde1: Device or resource busy
mdadm: cannot open device /dev/sde: Device or resource busy
mdadm: cannot open device /dev/sdc5: Device or resource busy
mdadm: cannot open device /dev/sdc2: Device or resource busy
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: cannot open device /dev/sdg5: Device or resource busy
mdadm: no RAID superblock on /dev/sdg3
mdadm: cannot open device /dev/sdg2: Device or resource busy
mdadm: cannot open device /dev/sdg1: Device or resource busy
mdadm: cannot open device /dev/sdg: Device or resource busy
mdadm: cannot open device /dev/sdf5: Device or resource busy
mdadm: no RAID superblock on /dev/sdf3
mdadm: cannot open device /dev/sdf2: Device or resource busy
mdadm: cannot open device /dev/sdf1: Device or resource busy
mdadm: cannot open device /dev/sdf: Device or resource busy
mdadm: /dev/md/3 exists - ignoring
mdadm: /dev/sdb6 is identified as a member of /dev/md3, slot 2.
mdadm: /dev/sdd6 is identified as a member of /dev/md3, slot 3.
mdadm: /dev/sde6 is identified as a member of /dev/md3, slot 1.
mdadm: /dev/sdc6 is identified as a member of /dev/md3, slot 0.
mdadm:/dev/md3 has an active reshape - checking if critical section needs to be restored
mdadm: No backup metadata on device-3
mdadm: Failed to find backup of critical section
mdadm: Failed to restore critical section for reshape, sorry.
      Possibly you needed to specify the --backup-file
mdadm: looking for devices for further assembly
mdadm: no recogniseable superblock on /dev/sdg3
mdadm: no recogniseable superblock on /dev/sdf3
mdadm: No arrays found in config file or automatically

[/var/log/messages - after reboot]

Jan 16 21:10:30 G530 kernel: [   11.998218] 3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
Jan 16 21:10:30 G530 kernel: [   12.110889] md: invalid raid superblock magic on sda5
Jan 16 21:10:30 G530 kernel: [   12.110894] md: sda5 does not have a valid v0.90 superblock, not importing!
Jan 16 21:10:30 G530 kernel: [   12.161769] md: invalid raid superblock magic on sdb5
Jan 16 21:10:30 G530 kernel: [   12.161774] md: sdb5 does not have a valid v0.90 superblock, not importing!
Jan 16 21:10:30 G530 kernel: [   12.181722] md: invalid raid superblock magic on sdb6
Jan 16 21:10:30 G530 kernel: [   12.181727] md: sdb6 does not have a valid v0.90 superblock, not importing!
Jan 16 21:10:30 G530 kernel: [   12.200509] md: invalid raid superblock magic on sdb7
Jan 16 21:10:30 G530 kernel: [   12.200513] md: sdb7 does not have a valid v0.90 superblock, not importing!
Jan 16 21:10:30 G530 kernel: [   12.244320] md: invalid raid superblock magic on sdc5
Jan 16 21:10:30 G530 kernel: [   12.244325] md: sdc5 does not have a valid v0.90 superblock, not importing!
Jan 16 21:10:30 G530 kernel: [   12.264668] md: invalid raid superblock magic on sdc6
Jan 16 21:10:30 G530 kernel: [   12.264673] md: sdc6 does not have a valid v0.90 superblock, not importing!
Jan 16 21:10:30 G530 kernel: [   12.312386] md: invalid raid superblock magic on sdd5
Jan 16 21:10:30 G530 kernel: [   12.312391] md: sdd5 does not have a valid v0.90 superblock, not importing!
Jan 16 21:10:30 G530 kernel: [   12.331066] md: invalid raid superblock magic on sdd6
Jan 16 21:10:30 G530 kernel: [   12.331070] md: sdd6 does not have a valid v0.90 superblock, not importing!
Jan 16 21:10:30 G530 kernel: [   12.347779] md: invalid raid superblock magic on sdd7
Jan 16 21:10:30 G530 kernel: [   12.347783] md: sdd7 does not have a valid v0.90 superblock, not importing!
Jan 16 21:10:30 G530 kernel: [   12.381133] md: invalid raid superblock magic on sde5
Jan 16 21:10:30 G530 kernel: [   12.381138] md: sde5 does not have a valid v0.90 superblock, not importing!
Jan 16 21:10:30 G530 kernel: [   12.400495] md: invalid raid superblock magic on sde6
Jan 16 21:10:30 G530 kernel: [   12.400499] md: sde6 does not have a valid v0.90 superblock, not importing!
Jan 16 21:10:30 G530 kernel: [   12.456511] md: invalid raid superblock magic on sdf5
Jan 16 21:10:30 G530 kernel: [   12.456515] md: sdf5 does not have a valid v0.90 superblock, not importing!
Jan 16 21:10:30 G530 kernel: [   12.504338] md: invalid raid superblock magic on sdg5
Jan 16 21:10:30 G530 kernel: [   12.504342] md: sdg5 does not have a valid v0.90 superblock, not importing!
Jan 16 21:10:30 G530 kernel: [   12.504371] md: sda2 has different UUID to sda1
Jan 16 21:10:30 G530 kernel: [   12.504375] md: sdb2 has different UUID to sda1
Jan 16 21:10:30 G530 kernel: [   12.504379] md: sdc2 has different UUID to sda1
Jan 16 21:10:30 G530 kernel: [   12.504383] md: sdd2 has different UUID to sda1
Jan 16 21:10:30 G530 kernel: [   12.504387] md: sde2 has different UUID to sda1
Jan 16 21:10:30 G530 kernel: [   12.504391] md: sdf2 has different UUID to sda1
Jan 16 21:10:30 G530 kernel: [   12.504395] md: sdg2 has different UUID to sda1
Jan 16 21:10:30 G530 kernel: [   12.647433] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
Jan 16 21:10:30 G530 kernel: [   12.726663] bromolow_synobios: module license 'Synology Inc.' taints kernel.
Jan 16 21:10:30 G530 kernel: [   12.726666] Disabling lock debugging due to kernel taint
Jan 16 21:10:30 G530 kernel: [   12.727077] 2016-1-17 3:10:20 UTC
Jan 16 21:10:30 G530 kernel: [   12.727083] Brand: Synology
Jan 16 21:10:30 G530 kernel: [   12.727085] Model: DS-3615xs
Jan 16 21:10:30 G530 kernel: [   12.727087] set group disks wakeup number to 4, spinup time deno 7
Jan 16 21:10:30 G530 kernel: [   13.120649] Got empty serial number. Generate serial number from product.
Jan 16 21:10:30 G530 kernel: [   13.237986] synobios: unload
Jan 16 21:10:30 G530 kernel: [   13.380869] Got empty serial number. Generate serial number from product.
Jan 16 21:10:30 G530 kernel: [   13.380881] drivers/usb/core/hub.c (2674) Same device found. Change serial to ffffffd1ffffffb2ffffffdbffffffa0 
Jan 16 21:10:30 G530 kernel: [   15.471362] Got empty serial number. Generate serial number from product.
Jan 16 21:10:30 G530 kernel: [   15.471372] drivers/usb/core/hub.c (2674) Same device found. Change serial to ffffffd1ffffffb2ffffffdbffffffa0 
Jan 16 21:10:30 G530 kernel: [   15.471374] drivers/usb/core/hub.c (2674) Same device found. Change serial to ffffffd1ffffffb2ffffffdbffffffa1 
Jan 16 21:10:30 G530 kernel: [   16.055404] EXT4-fs (md0): synoacl module has not been loaded. Unable to mount with synoacl, vfs_mod status=-1
Jan 16 21:10:30 G530 kernel: [   16.767872] Got empty serial number. Generate serial number from product.
Jan 16 21:10:30 G530 kernel: [   16.767883] drivers/usb/core/hub.c (2674) Same device found. Change serial to ffffffd1ffffffb2ffffffdbffffffa0 
Jan 16 21:10:30 G530 kernel: [   16.767885] drivers/usb/core/hub.c (2674) Same device found. Change serial to ffffffd1ffffffb2ffffffdbffffffa1 
Jan 16 21:10:30 G530 kernel: [   16.767886] drivers/usb/core/hub.c (2674) Same device found. Change serial to ffffffd1ffffffb2ffffffdbffffffa2 
Jan 16 21:10:30 G530 kernel: [   16.768045] usb 3-3.4: ep 0x81 - rounding interval to 1024 microframes, ep desc says 2040 microframes
Jan 16 21:10:30 G530 kernel: [   18.093256] Got empty serial number. Generate serial number from product.
Jan 16 21:10:30 G530 kernel: [   18.093392] usb 3-3.4.1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
Jan 16 21:10:30 G530 kernel: [   18.093397] usb 3-3.4.1: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
Jan 16 21:10:30 G530 kernel: [   18.093400] usb 3-3.4.1: ep 0x83 - rounding interval to 32 microframes, ep desc says 40 microframes
Jan 16 21:10:30 G530 kernel: [   20.844390] EXT4-fs (md0): synoacl module has not been loaded. Unable to mount with synoacl, vfs_mod status=-1
Creating /dev/synoboot1...
Creating /dev/synoboot2...
Jan 16 21:10:33 G530 umount: can't umount /initrd: Invalid argument
Jan 16 21:10:35 G530 kernel: [   27.827659] zram: module is from the staging directory, the quality is unknown, you have been warned.
Jan 16 21:10:35 G530 [   27.916922] init: syno-auth-check main process (14182) killed by TERM signal
Jan 16 21:10:35 G530 kernel: [   28.347530] thermal_sys: exports duplicate symbol get_thermal_instance (owned by kernel)
insmod: can't insert '/lib/modules/thermal_sys.ko': invalid module format
Jan 16 21:10:35 G530 kernel: [   28.396328] processor: exports duplicate symbol acpi_processor_get_bios_limit (owned by kernel)
insmod: can't insert '/lib/modules/processor.ko': invalid module format
insmod: can't insert '/lib/modules/aesni-intel.ko': No such device
Jan 16 21:10:35 G530 kernel: [   28.608051] i2c_algo_bit: exports duplicate symbol i2c_bit_add_bus (owned by kernel)
insmod: can't insert '/lib/modules/i2c-algo-bit.ko': invalid module format
Jan 16 21:10:36 G530 kernel: [   28.741219] 2016-1-17 3:10:36 UTC
Jan 16 21:10:36 G530 kernel: [   28.741227] Brand: Synology
Jan 16 21:10:36 G530 kernel: [   28.741229] Model: DS-3615xs
Jan 16 21:10:36 G530 kernel: [   28.741231] set group disks wakeup number to 4, spinup time deno 7
Jan 16 21:10:36 G530 synonetseqadj: synonetseqadj.c:312 Error internal NIC devices 1 does not equal to internal NIC number 4
Jan 16 21:10:37 G530 interface-catcher: eth0 (dhcp) is added
Jan 16 21:10:37 G530 interface-catcher: lo (inet 127.0.0.1 netmask 255.0.0.0 ) is added
Jan 16 21:10:38 G530 synonetd: net_route_table_edit.c:72 eth0 ip route del failed, instead of route
Jan 16 21:10:39 G530 dhcp-client: started on eth0
Jan 16 21:10:39 G530 [   31.943766] init: dhcp-client (eth0) main process (18275) killed by TERM signal
Jan 16 21:10:39 G530 dhcp-client: stopped on eth0
Jan 16 21:10:39 G530 dhcp-client: started on eth0
Jan 16 21:10:39 G530 spacetool.shared: spacetool.c:1069 Try to force assemble RAID [/dev/md3]. [0x8000 raid_ioctl_info.c:55]
Jan 16 21:10:39 G530 spacetool.shared: raid_allow_rmw_check.c:48 fopen failed: /usr/syno/etc/.rmw.md4
Jan 16 21:10:39 G530 kernel: [   32.529366] md: md2: current auto_remap = 0
Jan 16 21:10:39 G530 kernel: [   32.529368] md: reshape of RAID array md2
Jan 16 21:10:39 G530 spacetool.shared: raid_allow_rmw_check.c:48 fopen failed: /usr/syno/etc/.rmw.md2
Jan 16 21:10:40 G530 spacetool.shared: raid_allow_rmw_check.c:35 Failed to get RAID '/dev/md3' info.
Jan 16 21:10:40 G530 spacetool.shared: raid_enable_multithread.c:42 Failed to get RAID '/dev/md3' info.
Jan 16 21:10:40 G530 spacetool.shared: spacetool.c:1097 Fail to enable multithread of [/dev/md3]
Jan 16 21:10:42 G530 [   34.826762] init: dhcp-client (eth0) main process (18642) killed by TERM signal
Jan 16 21:10:42 G530 dhcp-client: stopped on eth0
Jan 16 21:10:42 G530 dhcp-client: started on eth0
Jan 16 21:10:44 G530 synonetd: servicecfg_internal_lib.c:355 skip reload stopping/stopped job [ddnsd][0xD300 servicectl_job_reload.c:42]
Jan 16 21:10:45 G530 spacetool.shared: spacetool.c:2835 [Info] Old vg path: [/dev/vg1000], New vg path: [/dev/vg1000], UUID: [OJ3oNy-SLGN-RvdT-KLiG-jDs2-JbxB-4ommso]
Jan 16 21:10:45 G530 spacetool.shared: spacetool.c:2842 [Info] Activate all VG
Jan 16 21:10:46 G530 ddnsd: ddnsd.c:2912 DDNS Expired. UpdateAll.
Jan 16 21:10:47 G530 spacetool.shared: lvm_vg_activate.c:23 Failed to do '/sbin/vgchange -ay /dev/vg1000'
Jan 16 21:10:47 G530 spacetool.shared: spacetool.c:2851 Failed to activate LVM [/dev/vg1000]
Jan 16 21:10:47 G530 spacetool.shared: spacetool.c:2896 space: [/dev/vg1000]
Jan 16 21:10:47 G530 spacetool.shared: spacetool.c:2922 space: [/dev/vg1000], ndisk: [9]
Jan 16 21:10:47 G530 ddnsd: ddnsd.c:1968 Success to update [all.dnsomatic.com] with IP [72.64.92.20] at [DNS-O-Matic]
Jan 16 21:10:51 G530 spacetool.shared: space_map_file_dump.c:1440 Fail to get lv UUID: [/dev/vg1000/lv]
Jan 16 21:10:51 G530 spacetool.shared: space_map_file_dump.c:1251 Fail to get pv expansible: [/dev/md4]
Jan 16 21:10:51 G530 spacetool.shared: space_map_file_dump.c:1251 Fail to get pv expansible: [/dev/md2]
Jan 16 21:10:53 G530 synovspace: virtual_space_conf_check.c:78 [INFO] "PASS" checking configuration of virtual space [FCACHE], app: [1]
Jan 16 21:10:53 G530 synovspace: virtual_space_conf_check.c:74 [INFO] No implementation, skip checking configuration of virtual space [HA]
Jan 16 21:10:53 G530 synovspace: virtual_space_conf_check.c:74 [INFO] No implementation, skip checking configuration of virtual space [SNAPSHOT_ORG]
Jan 16 21:10:53 G530 synovspace: vspace_wrapper_load_all.c:76 [INFO] No virtual layer above space: [/volume1] / [/dev/vg1000/lv]
Jan 16 21:10:54 G530 s00_synocheckfstab: system_blk_dev_readahead_set.c:36 Failed to set '/dev/vg1000/lv''s readahead to 4096d 
Jan 16 21:10:54 G530 s00_synocheckfstab: volume_readahead_allset.c:33 Failed to set RA on [/dev/vg1000/lv]
mount: open failed, msg:No such file or directory
mount: mounting /dev/vg1000/lv on /volume1 failed: No such device
mv: can't rename '/volume1/@tmp': No such file or directory
quotacheck: Mountpoint (or device) /volume1 not found or has no quota enabled.
quotacheck: Cannot find filesystem to check or filesystem not mounted with quota option.
quotaon: Mountpoint (or device) /volume1 not found or has no quota enabled.
Jan 16 21:10:54 G530 synocheckhotspare: synocheckhotspare.c:149 [INFO] No hotspare config, skip hotspare config check. [0x2000 virtual_space_layer_get.c:98]
Jan 16 21:10:54 G530 rc.ha: ha related packages check
Jan 16 21:10:54 G530 rc.ha: ha related packages check status 0
Jan 16 21:10:55 G530 kernel: [   48.252145] Get empty minor:104
Jan 16 21:10:55 G530 kernel: [   48.254034] Get empty minor:105
Jan 16 21:10:55 G530 syno_hdd_util: Model:[WD20EARS-00MVWB0], Firmware:[51.0AB51], S/N:[WD-WMAZA4913001] in [/dev/sdg] is not ssd
Jan 16 21:10:55 G530 syno_hdd_util: Model:[WD20EARS-00S8B1], Firmware:[80.00A80], S/N:[WD-WCAVY5659881] in [/dev/sdf] is not ssd
Jan 16 21:10:55 G530 syno_hdd_util: Model:[ST3000DM001-1CH166], Firmware:[CC46], S/N:[Z1F3MY6N] in [/dev/sde] is not ssd
Jan 16 21:10:55 G530 syno_hdd_util: Model:[ST4000DM000-1F2168], Firmware:[CC54], S/N:[Z303MC89] in [/dev/sdd] is not ssd
Jan 16 21:10:55 G530 syno_hdd_util: Model:[ST3000DM001-1ER166], Firmware:[CC25], S/N:[Z500QP6V] in [/dev/sdc] is not ssd
Jan 16 21:10:56 G530 syno_hdd_util: Model:[ST4000DM000-1F2168], Firmware:[CC54], S/N:[Z3038CR3] in [/dev/sdb] is not ssd
Jan 16 21:10:56 G530 syno_hdd_util: Model:[WD20EARX-00PASB0], Firmware:[51.0AB51], S/N:[WD-WMAZA7147895] in [/dev/sda] is not ssd
Jan 16 21:10:56 G530 synocheckshare: synocheckshare_sync_conf.c:373 Remove Share config: anime / /volume1/anime
Jan 16 21:10:56 G530 synocheckshare: synocheckshare_sync_conf.c:373 Remove Share config: homes / /volume1/homes
Jan 16 21:10:56 G530 synocheckshare: synocheckshare_sync_conf.c:373 Remove Share config: movies / /volume1/movies
Jan 16 21:10:56 G530 synocheckshare: synocheckshare_sync_conf.c:373 Remove Share config: old backups / /volume1/old backups
Jan 16 21:10:56 G530 synocheckshare: synocheckshare_sync_conf.c:373 Remove Share config: photo / /volume1/photo
Jan 16 21:10:56 G530 synocheckshare: synocheckshare_sync_conf.c:373 Remove Share config: Plex / /volume1/Plex
Jan 16 21:10:56 G530 synocheckshare: synocheckshare_sync_conf.c:373 Remove Share config: surveillance / /volume1/surveillance
Jan 16 21:10:56 G530 synocheckshare: synocheckshare_sync_conf.c:373 Remove Share config: tv / /volume1/tv
Jan 16 21:10:57 G530 kernel: [   49.942850] BUG: unable to handle kernel paging request at 0000000000002ea9
Jan 16 21:10:57 G530 kernel: [   49.942855] IP: [<ffffffff813d8af7>] syno_mv_9235_disk_led_set+0x27/0xd0
Jan 16 21:10:57 G530 kernel: [   49.942861] PGD 2146d0067 PUD 2127c4067 PMD 0 
Jan 16 21:10:57 G530 kernel: [   49.942864] Oops: 0000 [#1] SMP 
Jan 16 21:10:57 G530 kernel: [   49.942941] CPU: 0 PID: 21066 Comm: scemd Tainted: P         C O 3.10.35 #1
Jan 16 21:10:57 G530 kernel: [   49.942943] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./H77M, BIOS P1.00 03/06/2012
Jan 16 21:10:57 G530 kernel: [   49.942945] task: ffff880213bef200 ti: ffff8801ff324000 task.ti: ffff8801ff324000
Jan 16 21:10:57 G530 kernel: [   49.942946] RIP: 0010:[<ffffffff813d8af7>]  [<ffffffff813d8af7>] syno_mv_9235_disk_led_set+0x27/0xd0
Jan 16 21:10:57 G530 kernel: [   49.942950] RSP: 0018:ffff8801ff327d18  EFLAGS: 00010202
Jan 16 21:10:57 G530 kernel: [   49.942951] RAX: ffff8802127ca000 RBX: 0000000000000000 RCX: ffff8802127ca3e8
Jan 16 21:10:57 G530 kernel: [   49.942952] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8802127ca000
Jan 16 21:10:57 G530 kernel: [   49.942953] RBP: 0000000000000000 R08: ffff88020b94a3f8 R09: 0000000000000009
Jan 16 21:10:57 G530 kernel: [   49.942955] R10: 00000000f773b430 R11: 0000000000000000 R12: ffff88020b94a3c0
Jan 16 21:10:57 G530 kernel: [   49.942956] R13: 000000000000000b R14: 0000000000000001 R15: 0000000000000000
Jan 16 21:10:57 G530 kernel: [   49.942957] FS:  0000000000000000(0000) GS:ffff88021f200000(0063) knlGS:00000000f4995b70
Jan 16 21:10:57 G530 kernel: [   49.942959] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
Jan 16 21:10:57 G530 kernel: [   49.942960] CR2: 0000000000002ea9 CR3: 000000020ba74000 CR4: 00000000000407f0
Jan 16 21:10:57 G530 kernel: [   49.942961] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 16 21:10:57 G530 kernel: [   49.942963] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 16 21:10:57 G530 synousbdisk: RCClean succeeded
Jan 16 21:10:57 G530 kernel: [   49.942964] Stack:
Jan 16 21:10:57 G530 kernel: [   49.942965]  0000000000000007 ffffffffa0af0b98 ffffffffffffffff 00000000f4995048
Jan 16 21:10:57 G530 kernel: [   49.942967]  ffff88020b94a3c0 ffffffffa0aed574 00000000f6f92000 ffff8801ff327de0
Jan 16 21:10:57 G530 kernel: [   49.942969]  ffff880211505000 0000000000000008 00000000ffffff9c 00000000ffffff9c
Jan 16 21:10:57 G530 kernel: [   49.942971] Call Trace:
Jan 16 21:10:57 G530 kernel: [   49.942976]  [<ffffffffa0af0b98>] ? SetSCSIHostLedStatusBy9235GPIOandAHCISGPIO+0x68/0x100 [bromolow_synobios]
Jan 16 21:10:57 G530 kernel: [   49.942980]  [<ffffffffa0aed574>] ? synobios_ioctl+0xe24/0x1060 [bromolow_synobios]
Jan 16 21:10:57 G530 kernel: [   49.942984]  [<ffffffff8110c26c>] ? filename_lookup+0x2c/0xb0
Jan 16 21:10:57 G530 kernel: [   49.942986]  [<ffffffff8110a464>] ? getname_flags.part.31+0x84/0x130
Jan 16 21:10:57 G530 kernel: [   49.942989]  [<ffffffff811111c0>] ? user_path_at_empty+0xa0/0x120
Jan 16 21:10:57 G530 kernel: [   49.942993]  [<ffffffff8116b3fb>] ? sysfs_getattr+0x4b/0x60
Jan 16 21:10:57 G530 kernel: [   49.942995]  [<ffffffff81117b32>] ? dput+0x22/0x1b0
Jan 16 21:10:57 G530 kernel: [   49.942999]  [<ffffffff8114c807>] ? compat_sys_ioctl+0x1e7/0x1500
Jan 16 21:10:57 G530 kernel: [   49.943003]  [<ffffffff810348e0>] ? sys32_stat64+0x10/0x30
Jan 16 21:10:57 G530 kernel: [   49.943007]  [<ffffffff81537a9c>] ? sysenter_dispatch+0x7/0x21
Jan 16 21:10:57 G530 kernel: [   49.943008] Code: 1f 44 00 00 53 0f b7 ff 89 f3 e8 d5 73 f9 ff 48 85 c0 48 89 c7 0f 84 a0 00 00 00 48 8b 90 68 06 00 00 48 85 d2 0f 84 97 00 00 00 <48> 8b 82 a8 2e 00 00 8b 4a 24 48 8b 70 78 48 8b 40 20 83 c1 04 
Jan 16 21:10:57 G530 kernel: [   49.943028] RIP  [<ffffffff813d8af7>] syno_mv_9235_disk_led_set+0x27/0xd0
Jan 16 21:10:57 G530 kernel: [   49.943031]  RSP <ffff8801ff327d18>
Jan 16 21:10:57 G530 kernel: [   49.943032] CR2: 0000000000002ea9
Jan 16 21:10:57 G530 kernel: [   49.943034] ---[ end trace 64d42d5492de5895 ]---
Jan 16 21:10:57 G530 synosata: synosata.c:71 no external sata devices granted
Jan 16 21:10:59 G530 hotplugd: hotplugd.c:1274 ##### ACTION:add
Jan 16 21:10:59 G530 hotplugd: DEVNAME:sda
Jan 16 21:10:59 G530 hotplugd: DEVGUID:0
Jan 16 21:10:59 G530 hotplugd: DEVPATH:sda
Jan 16 21:10:59 G530 hotplugd: SUBSYSTEM:block
Jan 16 21:10:59 G530 hotplugd: PHYSDEVPATH:/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host0/port-0:0/expander-0:0/port-0:0:0/end_device-0:0:0/target0:0:0/0:0:0:0
Jan 16 21:10:59 G530 synocheckshare: share_delete.c:439 Start to del homes with id 10
Jan 16 21:11:00 G530 synocheckshare: index_index_add_ex.c:125 Indexing daemon is not running
Jan 16 21:11:01 G530 synocheckshare: share_delete.c:439 Start to del photo with id 2
Jan 16 21:11:02 G530 synocheckshare: share_delete.c:439 Start to del surveillance with id 9
Jan 16 21:11:03 G530 hotplugd: hotplugd.c:1358 ==== SATA disk [sda] hotswap [add] ====
Jan 16 21:11:03 G530 hotplugd: enclosure_list_enum.c:93 failed to get enclosure head, please check enclosure firmware/hardware
Jan 16 21:11:03 G530 hotplugd: enclosure_enum_by_valid_link.c:61 Fail to SYNOEnclosureListEnum().
Jan 16 21:11:03 G530 hotplugd: enclosure_serialized_list_get.c:33 failed to enum enclosure lists
Jan 16 21:11:03 G530 hotplugd: enclosure_list_cache_update.c:29 failed to get serialized enclosure list
Jan 16 21:11:03 G530 hotplugd: hotplugd.c:1363 Failed to update enclosure list cache.
Jan 16 21:11:03 G530 hotplugd: disk_is_mv_soc_driver.c:72 Can't get sata chip name from pattern /sys/block/sda/device/../../scsi_host/host*/proc_name
Jan 16 21:11:04 G530 hotplugd: disk/disk_config_single.c:168 apply /usr/syno/bin/DiskApmSet.sh 255  /dev/sda 1>/dev/null 2>&1
Jan 16 21:11:04 G530 hotplugd: disk/disk_config_single.c:168 apply /usr/syno/bin/syno_disk_ctl --wcache-off  /dev/sda 1>/dev/null 2>&1
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1383 ==== SATA disk [sda] Model: [WD20EARX-00PASB0        ] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1384 ==== SATA disk [sda] Serial number: [WD-WMAZA7147895] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1385 ==== SATA disk [sda] Firmware version: [51.0AB51] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1274 ##### ACTION:add
Jan 16 21:11:04 G530 hotplugd: DEVNAME:sdb
Jan 16 21:11:04 G530 hotplugd: DEVGUID:0
Jan 16 21:11:04 G530 hotplugd: DEVPATH:sdb
Jan 16 21:11:04 G530 hotplugd: SUBSYSTEM:block
Jan 16 21:11:04 G530 hotplugd: PHYSDEVPATH:/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host0/port-0:0/expander-0:0/port-0:0:1/end_device-0:0:1/target0:0:1/0:0:1:0
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1358 ==== SATA disk [sdb] hotswap [add] ====
Jan 16 21:11:04 G530 hotplugd: enclosure_list_enum.c:93 failed to get enclosure head, please check enclosure firmware/hardware
Jan 16 21:11:04 G530 hotplugd: enclosure_enum_by_valid_link.c:61 Fail to SYNOEnclosureListEnum().
Jan 16 21:11:04 G530 hotplugd: enclosure_serialized_list_get.c:33 failed to enum enclosure lists
Jan 16 21:11:04 G530 hotplugd: enclosure_list_cache_update.c:29 failed to get serialized enclosure list
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1363 Failed to update enclosure list cache.
Jan 16 21:11:04 G530 hotplugd: disk_is_mv_soc_driver.c:72 Can't get sata chip name from pattern /sys/block/sdb/device/../../scsi_host/host*/proc_name
Jan 16 21:11:04 G530 hotplugd: disk/disk_config_single.c:168 apply /usr/syno/bin/DiskApmSet.sh 255  /dev/sdb 1>/dev/null 2>&1
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1383 ==== SATA disk [sdb] Model: [ST4000DM000-1F2168      ] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1384 ==== SATA disk [sdb] Serial number: [Z3038CR3] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1385 ==== SATA disk [sdb] Firmware version: [CC54] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1274 ##### ACTION:add
Jan 16 21:11:04 G530 hotplugd: DEVNAME:sdc
Jan 16 21:11:04 G530 hotplugd: DEVGUID:0
Jan 16 21:11:04 G530 hotplugd: DEVPATH:sdc
Jan 16 21:11:04 G530 hotplugd: SUBSYSTEM:block
Jan 16 21:11:04 G530 hotplugd: PHYSDEVPATH:/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host0/port-0:0/expander-0:0/port-0:0:2/end_device-0:0:2/target0:0:2/0:0:2:0
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1358 ==== SATA disk [sdc] hotswap [add] ====
Jan 16 21:11:04 G530 hotplugd: enclosure_list_enum.c:93 failed to get enclosure head, please check enclosure firmware/hardware
Jan 16 21:11:04 G530 hotplugd: enclosure_enum_by_valid_link.c:61 Fail to SYNOEnclosureListEnum().
Jan 16 21:11:04 G530 hotplugd: enclosure_serialized_list_get.c:33 failed to enum enclosure lists
Jan 16 21:11:04 G530 hotplugd: enclosure_list_cache_update.c:29 failed to get serialized enclosure list
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1363 Failed to update enclosure list cache.
Jan 16 21:11:04 G530 hotplugd: disk_is_mv_soc_driver.c:72 Can't get sata chip name from pattern /sys/block/sdc/device/../../scsi_host/host*/proc_name
Jan 16 21:11:04 G530 hotplugd: disk/disk_config_single.c:168 apply /usr/syno/bin/DiskApmSet.sh 255  /dev/sdc 1>/dev/null 2>&1
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1383 ==== SATA disk [sdc] Model: [ST3000DM001-1ER166      ] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1384 ==== SATA disk [sdc] Serial number: [Z500QP6V] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1385 ==== SATA disk [sdc] Firmware version: [CC25] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1274 ##### ACTION:add
Jan 16 21:11:04 G530 hotplugd: DEVNAME:sdd
Jan 16 21:11:04 G530 hotplugd: DEVGUID:0
Jan 16 21:11:04 G530 hotplugd: DEVPATH:sdd
Jan 16 21:11:04 G530 hotplugd: SUBSYSTEM:block
Jan 16 21:11:04 G530 hotplugd: PHYSDEVPATH:/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host0/port-0:0/expander-0:0/port-0:0:3/end_device-0:0:3/target0:0:3/0:0:3:0
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1358 ==== SATA disk [sdd] hotswap [add] ====
Jan 16 21:11:04 G530 hotplugd: enclosure_list_enum.c:93 failed to get enclosure head, please check enclosure firmware/hardware
Jan 16 21:11:04 G530 hotplugd: enclosure_enum_by_valid_link.c:61 Fail to SYNOEnclosureListEnum().
Jan 16 21:11:04 G530 hotplugd: enclosure_serialized_list_get.c:33 failed to enum enclosure lists
Jan 16 21:11:04 G530 hotplugd: enclosure_list_cache_update.c:29 failed to get serialized enclosure list
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1363 Failed to update enclosure list cache.
Jan 16 21:11:04 G530 hotplugd: disk_is_mv_soc_driver.c:72 Can't get sata chip name from pattern /sys/block/sdd/device/../../scsi_host/host*/proc_name
Jan 16 21:11:04 G530 hotplugd: disk/disk_config_single.c:168 apply /usr/syno/bin/DiskApmSet.sh 255  /dev/sdd 1>/dev/null 2>&1
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1383 ==== SATA disk [sdd] Model: [ST4000DM000-1F2168      ] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1384 ==== SATA disk [sdd] Serial number: [Z303MC89] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1385 ==== SATA disk [sdd] Firmware version: [CC54] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1274 ##### ACTION:add
Jan 16 21:11:04 G530 hotplugd: DEVNAME:sde
Jan 16 21:11:04 G530 hotplugd: DEVGUID:0
Jan 16 21:11:04 G530 hotplugd: DEVPATH:sde
Jan 16 21:11:04 G530 hotplugd: SUBSYSTEM:block
Jan 16 21:11:04 G530 hotplugd: PHYSDEVPATH:/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host0/port-0:0/expander-0:0/port-0:0:4/end_device-0:0:4/target0:0:4/0:0:4:0
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1358 ==== SATA disk [sde] hotswap [add] ====
Jan 16 21:11:04 G530 hotplugd: enclosure_list_enum.c:93 failed to get enclosure head, please check enclosure firmware/hardware
Jan 16 21:11:04 G530 hotplugd: enclosure_enum_by_valid_link.c:61 Fail to SYNOEnclosureListEnum().
Jan 16 21:11:04 G530 hotplugd: enclosure_serialized_list_get.c:33 failed to enum enclosure lists
Jan 16 21:11:04 G530 hotplugd: enclosure_list_cache_update.c:29 failed to get serialized enclosure list
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1363 Failed to update enclosure list cache.
Jan 16 21:11:04 G530 hotplugd: disk_is_mv_soc_driver.c:72 Can't get sata chip name from pattern /sys/block/sde/device/../../scsi_host/host*/proc_name
Jan 16 21:11:04 G530 hotplugd: disk/disk_config_single.c:168 apply /usr/syno/bin/DiskApmSet.sh 255  /dev/sde 1>/dev/null 2>&1
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1383 ==== SATA disk [sde] Model: [ST3000DM001-1CH166      ] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1384 ==== SATA disk [sde] Serial number: [Z1F3MY6N] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1385 ==== SATA disk [sde] Firmware version: [CC46] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1274 ##### ACTION:add
Jan 16 21:11:04 G530 hotplugd: DEVNAME:sdf
Jan 16 21:11:04 G530 hotplugd: DEVGUID:0
Jan 16 21:11:04 G530 hotplugd: DEVPATH:sdf
Jan 16 21:11:04 G530 hotplugd: SUBSYSTEM:block
Jan 16 21:11:04 G530 hotplugd: PHYSDEVPATH:/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host0/port-0:0/expander-0:0/port-0:0:5/end_device-0:0:5/target0:0:5/0:0:5:0
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1358 ==== SATA disk [sdf] hotswap [add] ====
Jan 16 21:11:04 G530 hotplugd: enclosure_list_enum.c:93 failed to get enclosure head, please check enclosure firmware/hardware
Jan 16 21:11:04 G530 hotplugd: enclosure_enum_by_valid_link.c:61 Fail to SYNOEnclosureListEnum().
Jan 16 21:11:04 G530 hotplugd: enclosure_serialized_list_get.c:33 failed to enum enclosure lists
Jan 16 21:11:04 G530 hotplugd: enclosure_list_cache_update.c:29 failed to get serialized enclosure list
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1363 Failed to update enclosure list cache.
Jan 16 21:11:04 G530 hotplugd: disk_is_mv_soc_driver.c:72 Can't get sata chip name from pattern /sys/block/sdf/device/../../scsi_host/host*/proc_name
Jan 16 21:11:04 G530 hotplugd: disk/disk_config_single.c:168 apply /usr/syno/bin/DiskApmSet.sh 255  /dev/sdf 1>/dev/null 2>&1
Jan 16 21:11:04 G530 hotplugd: disk/disk_config_single.c:168 apply /usr/syno/bin/syno_disk_ctl --wcache-off  /dev/sdf 1>/dev/null 2>&1
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1383 ==== SATA disk [sdf] Model: [WD20EARS-00S8B1         ] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1384 ==== SATA disk [sdf] Serial number: [WD-WCAVY5659881] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1385 ==== SATA disk [sdf] Firmware version: [80.00A80] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1274 ##### ACTION:add
Jan 16 21:11:04 G530 hotplugd: DEVNAME:sdg
Jan 16 21:11:04 G530 hotplugd: DEVGUID:0
Jan 16 21:11:04 G530 hotplugd: DEVPATH:sdg
Jan 16 21:11:04 G530 hotplugd: SUBSYSTEM:block
Jan 16 21:11:04 G530 hotplugd: PHYSDEVPATH:/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host0/port-0:0/expander-0:0/port-0:0:6/end_device-0:0:6/target0:0:6/0:0:6:0
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1358 ==== SATA disk [sdg] hotswap [add] ====
Jan 16 21:11:04 G530 hotplugd: enclosure_list_enum.c:93 failed to get enclosure head, please check enclosure firmware/hardware
Jan 16 21:11:04 G530 hotplugd: enclosure_enum_by_valid_link.c:61 Fail to SYNOEnclosureListEnum().
Jan 16 21:11:04 G530 hotplugd: enclosure_serialized_list_get.c:33 failed to enum enclosure lists
Jan 16 21:11:04 G530 hotplugd: enclosure_list_cache_update.c:29 failed to get serialized enclosure list
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1363 Failed to update enclosure list cache.
Jan 16 21:11:04 G530 hotplugd: disk_is_mv_soc_driver.c:72 Can't get sata chip name from pattern /sys/block/sdg/device/../../scsi_host/host*/proc_name
Jan 16 21:11:04 G530 hotplugd: disk/disk_config_single.c:168 apply /usr/syno/bin/DiskApmSet.sh 255  /dev/sdg 1>/dev/null 2>&1
Jan 16 21:11:04 G530 hotplugd: disk/disk_config_single.c:168 apply /usr/syno/bin/syno_disk_ctl --wcache-off  /dev/sdg 1>/dev/null 2>&1
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1383 ==== SATA disk [sdg] Model: [WD20EARS-00MVWB0        ] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1384 ==== SATA disk [sdg] Serial number: [WD-WMAZA4913001] ====
Jan 16 21:11:04 G530 hotplugd: hotplugd.c:1385 ==== SATA disk [sdg] Firmware version: [51.0AB51] ====
Jan 16 21:11:06 G530 synocheckshare: servicecfg_internal_lib.c:355 skip reload stopping/stopped job [netatalk][0xD300 servicectl_job_reload.c:42]
Jan 16 21:11:06 G530 synocheckshare: service_home_reload.c:91 Failed to reload 'atalk' [0xD300 servicectl_job_reload.c:42]
Jan 16 21:11:06 G530 synocheckshare: synocheckshare.c:74 Failed to enable PGSQL [0x8300] 
Jan 16 21:11:08 G530 root: No alive sharebin, pre-start process of php-fpm terminated
Jan 16 21:11:08 G530 [   61.344332] init: php-fpm pre-start process (22413) terminated with status 1
Jan 16 21:11:09 G530 kernel: [   62.229083] Get empty minor:105
Jan 16 21:11:12 G530 S99zbootok.sh: all service finish boot up.
Jan 16 21:11:12 G530 synofstool: fs_vol_expansible.c:36 device /dev/vg1000/lv with fs -1 not support resize.[0x0900 fs_type_get_from_disk.c:70]
Jan 16 21:11:12 G530 servicetool: service_third_party.c:38 synoservice: start all packages ...
Jan 16 21:11:12 G530 synopkg: pkgstartstop.cpp:147 Cannot start package [], version 
Jan 16 21:11:12 G530 synopkg: pkgstartstop.cpp:147 Cannot start package [], version 
Jan 16 21:11:12 G530 synopkg: pkgstartstop.cpp:147 Cannot start package [], version 
Jan 16 21:11:12 G530 synopkg: pkgstartstop.cpp:147 Cannot start package [], version 
Jan 16 21:11:12 G530 synopkg: pkgstartstop.cpp:147 Cannot start package [], version 
Jan 16 21:11:12 G530 synopkg: pkgstartstop.cpp:147 Cannot start package [], version 
Jan 16 21:11:12 G530 synopkg: pkgstartstop.cpp:147 Cannot start package [], version 
Jan 16 21:11:12 G530 synopkg: pkgstartstop.cpp:147 Cannot start package [], version 
Jan 16 21:11:12 G530 servicetool: service_third_party.c:57 synoservice: finish started all packages
Jan 16 21:11:12 G530 root: == DSM finished boot up ==
Jan 16 21:41:19 G530 synomkthumbd: synoidx_ipc_core.cpp:111 [Error] connect server: /tmp/synoindexplugind_sock
Jan 16 21:41:19 G530 synomkthumbd: synomk_ipc.cpp:110 fail
Jan 16 21:41:19 G530 synomkflvd: synoidx_ipc_core.cpp:111 [Error] connect server: /tmp/synoindexplugind_sock
Jan 16 21:41:19 G530 synomkflvd: synomk_ipc.cpp:83 fail
Jan 16 22:14:40 G530 umount: can't umount md0: No such file or directory

[pvdisplay]

  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find all physical volumes for volume group vg1000.
  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find all physical volumes for volume group vg1000.
  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find all physical volumes for volume group vg1000.
  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find all physical volumes for volume group vg1000.
  Volume group "vg1000" not found
  Skipping volume group vg1000
  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find all physical volumes for volume group vg1000.
  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find all physical volumes for volume group vg1000.
  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find all physical volumes for volume group vg1000.
  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find all physical volumes for volume group vg1000.
  Volume group "vg1000" not found
  Skipping volume group vg1000
  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find all physical volumes for volume group vg1000.
  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find all physical volumes for volume group vg1000.
  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find all physical volumes for volume group vg1000.
  Couldn't find device with uuid 'HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y'.
  Couldn't find all physical volumes for volume group vg1000.
  Volume group "vg1000" not found
  Skipping volume group vg1000

[/etc/lvm/backup/vg1000]

# Generated by LVM2 version 2.02.38 (2008-06-11): Sat Jan 16 04:00:38 2016

contents = "Text Format Volume Group"
version = 1

description = "Created *after* executing '/sbin/lvextend --alloc inherit /dev/vg1000/lv -l100%VG'"

creation_host = "G530"	# Linux G530 3.10.35 #1 SMP Sat Dec 12 17:01:14 MSK 2015 x86_64
creation_time = 1452938438	# Sat Jan 16 04:00:38 2016

vg1000 {
	id = "OJ3oNy-SLGN-RvdT-KLiG-jDs2-JbxB-4ommso"
	seqno = 14
	status = ["RESIZEABLE", "READ", "WRITE"]
	extent_size = 8192		# 4 Megabytes
	max_lv = 0
	max_pv = 0

	physical_volumes {

		pv0 {
			id = "8peoYO-TObT-0aOB-soTA-flZO-rySk-I9DTbB"
			device = "/dev/md2"	# Hint only

			status = ["ALLOCATABLE"]
			dev_size = 19486833408	# 9.07426 Terabytes
			pe_start = 1152
			pe_count = 2378763	# 9.07426 Terabytes
		}

		pv1 {
			id = "HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y"
			device = "/dev/md3"	# Hint only

			status = ["ALLOCATABLE"]
			dev_size = 3906970496	# 1.81932 Terabytes
			pe_start = 1152
			pe_count = 476925	# 1.81932 Terabytes
		}

		pv2 {
			id = "JgNxgM-8R3t-AO6s-DCRs-pR3x-Fk1z-3dyCXk"
			device = "/dev/md4"	# Hint only

			status = ["ALLOCATABLE"]
			dev_size = 1953485824	# 931.495 Gigabytes
			pe_start = 1152
			pe_count = 238462	# 931.492 Gigabytes
		}
	}

	logical_volumes {

		lv {
			id = "d8HMle-nC1C-Cx9s-f6ml-d2Lm-mC3R-S1ZjfX"
			status = ["READ", "WRITE", "VISIBLE"]
			segment_count = 5

			segment1 {
				start_extent = 0
				extent_count = 1427258	# 5.44456 Terabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv0", 0
				]
			}
			segment2 {
				start_extent = 1427258
				extent_count = 238462	# 931.492 Gigabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv1", 0
				]
			}
			segment3 {
				start_extent = 1665720
				extent_count = 951505	# 3.6297 Terabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv0", 1427258
				]
			}
			segment4 {
				start_extent = 2617225
				extent_count = 238463	# 931.496 Gigabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv1", 238462
				]
			}
			segment5 {
				start_extent = 2855688
				extent_count = 238462	# 931.492 Gigabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv2", 0
				]
			}
		}
	}
}

[/etc/lvm/archive/vg1000_* - starting with expansion of last disk]

# vg1000_0012.vg
# Generated by LVM2 version 2.02.38 (2008-06-11): Sat Jan 16 04:00:37 2016

contents = "Text Format Volume Group"
version = 1

description = "Created *before* executing '/sbin/vgextend /dev/vg1000 /dev/md4'"

creation_host = "G530"	# Linux G530 3.10.35 #1 SMP Sat Dec 12 17:01:14 MSK 2015 x86_64
creation_time = 1452938437	# Sat Jan 16 04:00:37 2016

vg1000 {
	id = "OJ3oNy-SLGN-RvdT-KLiG-jDs2-JbxB-4ommso"
	seqno = 12
	status = ["RESIZEABLE", "READ", "WRITE"]
	extent_size = 8192		# 4 Megabytes
	max_lv = 0
	max_pv = 0

	physical_volumes {

		pv0 {
			id = "8peoYO-TObT-0aOB-soTA-flZO-rySk-I9DTbB"
			device = "/dev/md2"	# Hint only

			status = ["ALLOCATABLE"]
			dev_size = 19486833408	# 9.07426 Terabytes
			pe_start = 1152
			pe_count = 2378763	# 9.07426 Terabytes
		}

		pv1 {
			id = "HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y"
			device = "/dev/md3"	# Hint only

			status = ["ALLOCATABLE"]
			dev_size = 3906970496	# 1.81932 Terabytes
			pe_start = 1152
			pe_count = 476925	# 1.81932 Terabytes
		}
	}

	logical_volumes {

		lv {
			id = "d8HMle-nC1C-Cx9s-f6ml-d2Lm-mC3R-S1ZjfX"
			status = ["READ", "WRITE", "VISIBLE"]
			segment_count = 4

			segment1 {
				start_extent = 0
				extent_count = 1427258	# 5.44456 Terabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv0", 0
				]
			}
			segment2 {
				start_extent = 1427258
				extent_count = 238462	# 931.492 Gigabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv1", 0
				]
			}
			segment3 {
				start_extent = 1665720
				extent_count = 951505	# 3.6297 Terabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv0", 1427258
				]
			}
			segment4 {
				start_extent = 2617225
				extent_count = 238463	# 931.496 Gigabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv1", 238462
				]
			}
		}
	}
}

# vg1000_0013.vg
# Generated by LVM2 version 2.02.38 (2008-06-11): Sat Jan 16 04:00:38 2016

contents = "Text Format Volume Group"
version = 1

description = "Created *before* executing '/sbin/lvextend --alloc inherit /dev/vg1000/lv -l100%VG'"

creation_host = "G530"	# Linux G530 3.10.35 #1 SMP Sat Dec 12 17:01:14 MSK 2015 x86_64
creation_time = 1452938438	# Sat Jan 16 04:00:38 2016

vg1000 {
	id = "OJ3oNy-SLGN-RvdT-KLiG-jDs2-JbxB-4ommso"
	seqno = 13
	status = ["RESIZEABLE", "READ", "WRITE"]
	extent_size = 8192		# 4 Megabytes
	max_lv = 0
	max_pv = 0

	physical_volumes {

		pv0 {
			id = "8peoYO-TObT-0aOB-soTA-flZO-rySk-I9DTbB"
			device = "/dev/md2"	# Hint only

			status = ["ALLOCATABLE"]
			dev_size = 19486833408	# 9.07426 Terabytes
			pe_start = 1152
			pe_count = 2378763	# 9.07426 Terabytes
		}

		pv1 {
			id = "HBo3L0-ZZqp-2ADK-CCSe-3IH8-mmEl-ca6y3Y"
			device = "/dev/md3"	# Hint only

			status = ["ALLOCATABLE"]
			dev_size = 3906970496	# 1.81932 Terabytes
			pe_start = 1152
			pe_count = 476925	# 1.81932 Terabytes
		}

		pv2 {
			id = "JgNxgM-8R3t-AO6s-DCRs-pR3x-Fk1z-3dyCXk"
			device = "/dev/md4"	# Hint only

			status = ["ALLOCATABLE"]
			dev_size = 1953485824	# 931.495 Gigabytes
			pe_start = 1152
			pe_count = 238462	# 931.492 Gigabytes
		}
	}

	logical_volumes {

		lv {
			id = "d8HMle-nC1C-Cx9s-f6ml-d2Lm-mC3R-S1ZjfX"
			status = ["READ", "WRITE", "VISIBLE"]
			segment_count = 4

			segment1 {
				start_extent = 0
				extent_count = 1427258	# 5.44456 Terabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv0", 0
				]
			}
			segment2 {
				start_extent = 1427258
				extent_count = 238462	# 931.492 Gigabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv1", 0
				]
			}
			segment3 {
				start_extent = 1665720
				extent_count = 951505	# 3.6297 Terabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv0", 1427258
				]
			}
			segment4 {
				start_extent = 2617225
				extent_count = 238463	# 931.496 Gigabytes

				type = "striped"
				stripe_count = 1	# linear

				stripes = [
					"pv1", 238462
				]
			}
		}
	}
}

