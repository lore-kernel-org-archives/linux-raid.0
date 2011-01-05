From: "Patrick H." <linux-raid@feystorm.net>
Subject: Re: filesystem corruption
Date: Tue, 04 Jan 2011 18:22:33 -0700
Message-ID: <4D23C7D9.3040109@feystorm.net>
References: <4D212D4A.3040003@feystorm.net>	<20110103141603.632fdf3e@notabene.brown>	<4D214B5C.3010103@feystorm.net>	<20110103155630.565341d0@notabene.brown>	<4D215902.9010308@feystorm.net> <20110104163324.70baff54@notabene.brown> <4D22D14F.8070407@feystorm.net> <4D23598C.3040901@feystorm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D23598C.3040901@feystorm.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think I may have found something on this. I was messing around with it 
more (switched to iSCSI instead of ATAoE), and managed to create a 
situation where 2 of the 3 raid-5 disks had failed, yet the MD device 
was still active, and it was letting me use it. This is bad.

mdadm -D /dev/md/fs01
/dev/md/fs01:
        Version : 1.2
  Creation Time : Tue Jan  4 04:45:50 2011
     Raid Level : raid5
     Array Size : 2119424 (2.02 GiB 2.17 GB)
  Used Dev Size : 1059712 (1035.05 MiB 1085.15 MB)
   Raid Devices : 3
  Total Devices : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Jan  4 22:58:44 2011
          State : active, FAILED
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : dm01:125  (local to host dm01)
           UUID : 9cd9ae9b:39454845:62f2b08d:a4a1ac6c
         Events : 2980

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       80        1      active sync   /dev/sdf
       2       0        0        2      removed


Notice, there's only one disk in the array, the other 2 failed and were 
removed. Yet state is still saying active. The filesystem is still up 
and running, and I can even read and write to it, though it spits out 
tons of IO errors.
I then stopped the array and tried to reassemble it, and now it wont 
reassemble.


# mdadm -A /dev/md/fs01 --uuid 9cd9ae9b:39454845:62f2b08d:a4a1ac6c -vv
mdadm: looking for devices for /dev/md/fs01
mdadm: no recogniseable superblock on /dev/md/fs01_journal
mdadm: /dev/md/fs01_journal has wrong uuid.
mdadm: cannot open device /dev/sdg: Device or resource busy
mdadm: /dev/sdg has wrong uuid.
mdadm: cannot open device /dev/sdd: Device or resource busy
mdadm: /dev/sdd has wrong uuid.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: /dev/sdb has wrong uuid.
mdadm: cannot open device /dev/sda2: Device or resource busy
mdadm: /dev/sda2 has wrong uuid.
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has wrong uuid.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sde is identified as a member of /dev/md/fs01, slot 2.
mdadm: /dev/sdc is identified as a member of /dev/md/fs01, slot 0.
mdadm: /dev/sdf is identified as a member of /dev/md/fs01, slot 1.
mdadm: added /dev/sdc to /dev/md/fs01 as 0
mdadm: added /dev/sde to /dev/md/fs01 as 2
mdadm: added /dev/sdf to /dev/md/fs01 as 1
mdadm: /dev/md/fs01 assembled from 1 drive - not enough to start the array.


# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md125 : inactive sdf[1](S) sde[3](S) sdc[0](S)
      3179280 blocks super 1.2

md126 : active raid1 sdg[0] sdb[2] sdd[1]
      265172 blocks super 1.2 [3/3] [UUU]
      bitmap: 0/3 pages [0KB], 64KB chunk

unused devices: <none>


md126 is the ext3 journal for the filesystem
Below is mdadm info on all the devices in the array

# mdadm -E /dev/sdc
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 9cd9ae9b:39454845:62f2b08d:a4a1ac6c
           Name : dm01:125  (local to host dm01)
  Creation Time : Tue Jan  4 04:45:50 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 2119520 (1035.10 MiB 1085.19 MB)
     Array Size : 4238848 (2.02 GiB 2.17 GB)
  Used Dev Size : 2119424 (1035.05 MiB 1085.15 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : a20adb76:af00f276:5be79a36:b4ff3a8b

Internal Bitmap : 2 sectors from superblock
    Update Time : Tue Jan  4 22:44:20 2011
       Checksum : 350c988f - correct
         Events : 1150

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AA. ('A' == active, '.' == missing)

# mdadm -X /dev/sdc
        Filename : /dev/sdc
           Magic : 6d746962
         Version : 4
            UUID : 9cd9ae9b:39454845:62f2b08d:a4a1ac6c
          Events : 1150
  Events Cleared : 1144
           State : OK
       Chunksize : 64 KB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 1059712 (1035.05 MiB 1085.15 MB)
          Bitmap : 16558 bits (chunks), 93 dirty (0.6%)

# mdadm -E /dev/sdf
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 9cd9ae9b:39454845:62f2b08d:a4a1ac6c
           Name : dm01:125  (local to host dm01)
  Creation Time : Tue Jan  4 04:45:50 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 2119520 (1035.10 MiB 1085.19 MB)
     Array Size : 4238848 (2.02 GiB 2.17 GB)
  Used Dev Size : 2119424 (1035.05 MiB 1085.15 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f9205ace:0796ecf5:2cca363c:c2873816

Internal Bitmap : 2 sectors from superblock
    Update Time : Tue Jan  4 23:00:49 2011
       Checksum : 9c20ba71 - correct
         Events : 3062

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : .A. ('A' == active, '.' == missing)

# mdadm -X /dev/sdf
        Filename : /dev/sdf
           Magic : 6d746962
         Version : 4
            UUID : 9cd9ae9b:39454845:62f2b08d:a4a1ac6c
          Events : 3062
  Events Cleared : 1144
           State : OK
       Chunksize : 64 KB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 1059712 (1035.05 MiB 1085.15 MB)
          Bitmap : 16558 bits (chunks), 150 dirty (0.9%)

# mdadm -E /dev/sde
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 9cd9ae9b:39454845:62f2b08d:a4a1ac6c
           Name : dm01:125  (local to host dm01)
  Creation Time : Tue Jan  4 04:45:50 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 2119520 (1035.10 MiB 1085.19 MB)
     Array Size : 4238848 (2.02 GiB 2.17 GB)
  Used Dev Size : 2119424 (1035.05 MiB 1085.15 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 7f90958d:22de5c08:88750ecb:5f376058

Internal Bitmap : 2 sectors from superblock
    Update Time : Tue Jan  4 22:43:53 2011
       Checksum : 3ecec198 - correct
         Events : 1144

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : AAA ('A' == active, '.' == missing)

# mdadm -X /dev/sde
        Filename : /dev/sde
           Magic : 6d746962
         Version : 4
            UUID : 9cd9ae9b:39454845:62f2b08d:a4a1ac6c
          Events : 1144
  Events Cleared : 1143
           State : OK
       Chunksize : 64 KB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 1059712 (1035.05 MiB 1085.15 MB)
          Bitmap : 16558 bits (chunks), 38 dirty (0.2%)







