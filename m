From: Chris Schanzle <mdadm@cas.homelinux.org>
Subject: non-persistent superblocks?
Date: Wed, 29 Jan 2014 23:49:16 -0500
Message-ID: <52E9D9CC.9000908@cas.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

tl;dr: clean Fedora 20 install. created degraded RAID5 array using /dev/sd[a-d].  ran fine, but on reboot, raid doesn't exist, seems superblocks not populated.  recreating md0 with --assume-clean works, but same thing on next reboot. Adding parity disk changed one thing: it is the only disk with a RAID superblock found on boot.


I am upgrading my backup server.  The old server was 4x2TB RAID5 which I outgrew and added 2x4TB RAID0 from a pair of Seagate Backup Plus 4TB USB3 drives.  Data was split over two filesystems and hit annoying limits here and there.  The new serverhas four ST4000DX000-1CL160 4TB drives and will get redundancy from a fifth (a ST4000DX000-1CL1 pulled out of its USB3 enclosure) once data is migrated.  My plan was to create a degraded 5-drive RAID5 on the new server, add it to an LVM volume (so I can extend in the future), mkfs.xfs, copy/consolidate data, and once double-checked, move a 4TB drive from the old server as a parity disk.  Fedora 20 boot disk is a spare laptop drive, updated, kernel 3.12.7-300.fc20.x86_64, minimal install with packages added as necessary.

After using parted to make gpt partitions, I did a little research and decided to use the whole-disk devices to help avoid alignment issues:

mdadm --create /dev/md0 --level=5 --raid-devices=5 /dev/sd{a,b,c,d} missing
mdadm --detail /dev/md0
     /dev/md0:
         Version : 1.2
       Creation Time : Tue Jan 21 00:55:45 2014
      Raid Level : raid5
      Array Size : 15627548672 (14903.59 GiB 16002.61 GB)
       Used Dev Size : 3906887168 (3725.90 GiB 4000.65 GB)
        Raid Devices : 5
       Total Devices : 4
     Persistence : Superblock is persistent

       Intent Bitmap : Internal

     Update Time : Tue Jan 21 00:55:45 2014
           State : active, degraded
      Active Devices : 4
     Working Devices : 4
      Failed Devices : 0
       Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

            Name : d130.localdomain:0  (local to host d130.localdomain)
            UUID : 7092f71d:7f4585f0:cb93062a:4e188f7e
          Events : 0

     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/sda
        1       8       16        1      active sync   /dev/sdb
        2       8       32        2      active sync   /dev/sdc
        3       8       48        3      active sync   /dev/sdd
        8       0        0        8      removed

pvcreate -M2 --dataalignment 512K --zero y /dev/md0
vgcreate big1 /dev/md0
lvcreate -n lv1 -l 100%FREE big1
mkfs.xfs /dev/mapper/big1-lv1
# note parameters mkfs.xfs used for sunit/swidth are identical to mkfs.xfs on /dev/md0
     meta-data=/dev/mapper/big1-lv1   isize=256    agcount=32, agsize=122090240 blks
              =                       sectsz=4096  attr=2, projid32bit=0
     data     =                       bsize=4096 blocks=3906886656, imaxpct=5
              =                       sunit=128    swidth=512 blks
     naming   =version 2              bsize=4096   ascii-ci=0
     log      =internal log           bsize=4096   blocks=521728, version=2
              =                       sectsz=4096  sunit=1 blks, lazy-count=1
     realtime =none                   extsz=4096   blocks=0, rtextents=0

mkdir /local
mount /dev/mapper/big1-lv1 /local

All was good, I copied copious amounts of data over the next 32-ish hours.  On reboot, raid wasn't started, not a trace of /dev/md0.  After mild panic/frustration passed, I found I could start the array via:

mdadm --create --assume-clean /dev/md0 --level=5 --raid-devices=5 /dev/sd{a,b,c,d} missing

checking copied data and with confidence I could start the md0 device manually, I added a parity disk which appeared as sde and let it sync.  Note this disk likely did NOT have a gpt label on it; again it was from a md raid0.

mdadm /dev/md0 --add /dev/sde

Let it sync for 8 hours or so, /proc/mdstat is clean.

Now on reboot, I have what appears to be 4 drives with no superblock and the parity disk has one:

cat /proc/mdstat
Personalities :
md0 : inactive sde[4](S)
       3906887512 blocks super 1.2


mdadm -E /dev/sd{a,b,c,d,e}
/dev/sda:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdb:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdc:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdd:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sde:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 1abf0406:c826e4db:cc4e9a1a:dbf7a969
            Name : d130.localdomain:0  (local to host d130.localdomain)
   Creation Time : Wed Jan 29 09:47:21 2014
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
      Array Size : 15627548672 (14903.59 GiB 16002.61 GB)
   Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=688 sectors
           State : clean
     Device UUID : 2bfb6dba:f035e260:6c09bfa2:80689d6f

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Jan 29 09:47:21 2014
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : f7d062c2 - correct
          Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 4
    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)

cat /proc/mdstat
Personalities :
md0 : inactive sde[5](S)
       3906887512 blocks super 1.2


Again, I can start the array via (note the dates and level=raid0 on first sd[a-d]:

mdadm --stop /dev/md0
mdadm --create --assume-clean /dev/md0 --level=5 --raid-devices=5 /dev/sd{a,b,c,d,e}
mdadm: /dev/sda appears to be part of a raid array:
        level=raid0 devices=0 ctime=Wed Dec 31 19:00:00 1969
mdadm: partition table exists on /dev/sda but will be lost or
        meaningless after creating array
mdadm: /dev/sdb appears to be part of a raid array:
        level=raid0 devices=0 ctime=Wed Dec 31 19:00:00 1969
mdadm: partition table exists on /dev/sdb but will be lost or
        meaningless after creating array
mdadm: /dev/sdc appears to be part of a raid array:
        level=raid0 devices=0 ctime=Wed Dec 31 19:00:00 1969
mdadm: partition table exists on /dev/sdc but will be lost or
        meaningless after creating array
mdadm: /dev/sdd appears to be part of a raid array:
        level=raid0 devices=0 ctime=Wed Dec 31 19:00:00 1969
mdadm: partition table exists on /dev/sdd but will be lost or
        meaningless after creating array
mdadm: /dev/sde appears to be part of a raid array:
        level=raid5 devices=5 ctime=Wed Jan 29 09:47:21 2014
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.


cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sde[4] sdd[3] sdc[2] sdb[1] sda[0]
       15627548672 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
       bitmap: 30/30 pages [120KB], 65536KB chunk


After a reboot, I tried to zero the superblocks to no avail:

mdadm --zero-superblock /dev/sd{a,b,c,d}
mdadm: Unrecognised md component device - /dev/sda
mdadm: Unrecognised md component device - /dev/sdb
mdadm: Unrecognised md component device - /dev/sdc
mdadm: Unrecognised md component device - /dev/sdd

However after starting the array then stopping it, --zero-superblock ran without error, but still no affect on reboot.


I also tried to fail/remove/re-add sda and sdb to no avail:

mdadm /dev/md0  --fail /dev/sda
mdadm /dev/md0  --remove /dev/sda
mdadm /dev/md0  --re-add /dev/sda
cat /proc/mdstat  # note no recovery/checking
mdadm /dev/md0  --fail /dev/sdb
mdadm /dev/md0  --remove /dev/sdb
mdadm /dev/md0  --re-add /dev/sdb


Once the array is running, mdadm shows lots of good superblock details, but sd[a-d] revert back to 'MBR magic' as above after a reboot:

mdadm -E /dev/sd{a,b,c,d,e}
/dev/sda:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : fb8e6d81:3123f2e8:38a4b426:84a21116
            Name : d130.localdomain:0  (local to host d130.localdomain)
   Creation Time : Wed Jan 29 23:09:54 2014
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
      Array Size : 15627548672 (14903.59 GiB 16002.61 GB)
   Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=688 sectors
           State : clean
     Device UUID : a86a1be0:3f8fd629:972a0680:de77a481

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Jan 29 23:09:54 2014
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 16baa0a5 - correct
          Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : fb8e6d81:3123f2e8:38a4b426:84a21116
            Name : d130.localdomain:0  (local to host d130.localdomain)
   Creation Time : Wed Jan 29 23:09:54 2014
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
      Array Size : 15627548672 (14903.59 GiB 16002.61 GB)
   Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=688 sectors
           State : clean
     Device UUID : 6e19ca6e:7a0b4eae:af698971:73777baa

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Jan 29 23:09:54 2014
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 443b0a54 - correct
          Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : fb8e6d81:3123f2e8:38a4b426:84a21116
            Name : d130.localdomain:0  (local to host d130.localdomain)
   Creation Time : Wed Jan 29 23:09:54 2014
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
      Array Size : 15627548672 (14903.59 GiB 16002.61 GB)
   Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=688 sectors
           State : clean
     Device UUID : 1d2421fe:47ac74e6:25ed3004:513d572c

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Jan 29 23:09:54 2014
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 203bff25 - correct
          Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : fb8e6d81:3123f2e8:38a4b426:84a21116
            Name : d130.localdomain:0  (local to host d130.localdomain)
   Creation Time : Wed Jan 29 23:09:54 2014
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
      Array Size : 15627548672 (14903.59 GiB 16002.61 GB)
   Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=688 sectors
           State : clean
     Device UUID : ee91db29:37295a8e:d47a6ebc:513e12a5

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Jan 29 23:09:54 2014
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 24d47896 - correct
          Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : fb8e6d81:3123f2e8:38a4b426:84a21116
            Name : d130.localdomain:0  (local to host d130.localdomain)
   Creation Time : Wed Jan 29 23:09:54 2014
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
      Array Size : 15627548672 (14903.59 GiB 16002.61 GB)
   Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=688 sectors
           State : clean
     Device UUID : 42e4bb4e:a0eff061:3b060f52:fff12632

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Jan 29 23:09:54 2014
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 4000d068 - correct
          Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 4
    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)


What's happening to my superblocks on /dev/sd[a-d]??  It's almost as if something is rewriting the partition table on shutdown, or they are never actually being written and it's an in-kernel copy that's never flushed.

Thanks for reading this far!
