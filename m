From: AndyLiebman@aol.com
Subject: Linux Raid confused about one drive and two arrays
Date: Thu, 22 Jan 2004 09:34:43 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6a.3aa594bc.2d413983@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have just encountered a very disturbing RAID problem. I hope somebody 
understands what happened and can tell me how to fix it.

I have two RAID 5 arrays on my Linux machine -- md4 and md6.. Each array 
consists of 5 firewire (1394a) drives -- one partition on each drive, 10 drives in 
total. Because the device ID's on these drives can change, I always use MDADM 
to create and manage my arrays based on UUIDs. I am using MDADM 1.3. Mandrake 
9.2 with mandrake's 2.4.22-21 kernel.

After running these arrays successfully for two months -- rebooting my file 
server every day -- one of my arrays came up in a degraded mode. It looks as if 
the Linux RAID subsystem "thinks" one of my drives belongs to both arrays.

As you can see below, when I run mdadm -E on each of my ten firewire drives, 
mdadm is telling me that for each of the drives in the md4 array (UUID group 
62d8b91d:a2368783:6a78ca50:5793492f )  there are 5 Raid devices and 6 total 
devices with one failed. However this array always only had 5 devices.

On the other hand, for most of the drives in the md6 arary (UUID group  
57f26496:25520b96:41757b62:f83fcb7b), mdadm is telling me that there are 5 raid 
devices and 5 total devices with one failed.

However, when I run mdadm -E on the drive currently identified as /dev/sdh1 
-- which also belongs to md6 or  the UUID group 
57f26496:25520b96:41757b62:f83fcb7b -- mdadm tells me that sdh1 is part of an array with 6 total devices, 5 
raid devices, one failed.

/dev/sdh1 is identified as device number 3 in the RAID with the UUID 
57f26496:25520b96:41757b62:f83fcb7b.  Howver, when I run mdadm -E on the other 4 
drives that belong to md6, mdadm tells me that device number 3 is faulty.

My questions are:

How do I fix this problem?
Why did it occur?
How can I prevent it from occurring again?

Hope somebody can answer these questions today.

Here is all the output from starting up my arrays and running mdadm:

[root@localhost avidserver]# mdadm -Av /dev/md4 
--uuid=62d8b91d:a2368783:6a78ca50:5793492f /dev/sd*
mdadm: looking for devices for /dev/md4
mdadm: /dev/sd is not a block device.
mdadm: /dev/sd has wrong uuid.
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sda1 is identified as a member of /dev/md4, slot 0.
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdb has wrong uuid.
mdadm: /dev/sdb1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdc
mdadm: /dev/sdc has wrong uuid.
mdadm: /dev/sdc1 is identified as a member of /dev/md4, slot 1.
mdadm: no RAID superblock on /dev/sdd
mdadm: /dev/sdd has wrong uuid.
mdadm: /dev/sdd1 has wrong uuid.
mdadm: no RAID superblock on /dev/sde
mdadm: /dev/sde has wrong uuid.
mdadm: /dev/sde1 is identified as a member of /dev/md4, slot 3.
mdadm: no RAID superblock on /dev/sdf
mdadm: /dev/sdf has wrong uuid.
mdadm: /dev/sdf1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdg
mdadm: /dev/sdg has wrong uuid.
mdadm: /dev/sdg1 is identified as a member of /dev/md4, slot 4.
mdadm: no RAID superblock on /dev/sdh
mdadm: /dev/sdh has wrong uuid.
mdadm: /dev/sdh1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdi
mdadm: /dev/sdi has wrong uuid.
mdadm: /dev/sdi1 is identified as a member of /dev/md4, slot 2.
mdadm: no RAID superblock on /dev/sdj
mdadm: /dev/sdj has wrong uuid.
mdadm: /dev/sdj1 has wrong uuid.
mdadm: added /dev/sdc1 to /dev/md4 as 1
mdadm: added /dev/sdi1 to /dev/md4 as 2
mdadm: added /dev/sde1 to /dev/md4 as 3
mdadm: added /dev/sdg1 to /dev/md4 as 4
mdadm: added /dev/sda1 to /dev/md4 as 0
mdadm: /dev/md4 has been started with 5 drives.

[root@localhost avidserver]# mdadm -Av /dev/md6 
--uuid=57f26496:25520b96:41757b62:f83fcb7b /dev/sd*
mdadm: looking for devices for /dev/md6
mdadm: /dev/sd is not a block device.
mdadm: /dev/sd has wrong uuid.
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sda1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdb has wrong uuid.
mdadm: /dev/sdb1 is identified as a member of /dev/md6, slot 0.
mdadm: no RAID superblock on /dev/sdc
mdadm: /dev/sdc has wrong uuid.
mdadm: /dev/sdc1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdd
mdadm: /dev/sdd has wrong uuid.
mdadm: /dev/sdd1 is identified as a member of /dev/md6, slot 1.
mdadm: no RAID superblock on /dev/sde
mdadm: /dev/sde has wrong uuid.
mdadm: /dev/sde1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdf
mdadm: /dev/sdf has wrong uuid.
mdadm: /dev/sdf1 is identified as a member of /dev/md6, slot 2.
mdadm: no RAID superblock on /dev/sdg
mdadm: /dev/sdg has wrong uuid.
mdadm: /dev/sdg1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdh
mdadm: /dev/sdh has wrong uuid.
mdadm: /dev/sdh1 is identified as a member of /dev/md6, slot 3.
mdadm: no RAID superblock on /dev/sdi
mdadm: /dev/sdi has wrong uuid.
mdadm: /dev/sdi1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdj
mdadm: /dev/sdj has wrong uuid.
mdadm: /dev/sdj1 is identified as a member of /dev/md6, slot 4.
mdadm: added /dev/sdd1 to /dev/md6 as 1
mdadm: added /dev/sdf1 to /dev/md6 as 2
mdadm: added /dev/sdh1 to /dev/md6 as 3
mdadm: added /dev/sdj1 to /dev/md6 as 4
mdadm: added /dev/sdb1 to /dev/md6 as 0
mdadm: /dev/md6 has been started with 4 drives (out of 5).

NOTE THAT mdadm identified sdh1 as being in slot 3 on md6, yet under cat 
/proc/mdstat the slot 3
Drive in md6 is reported as missing. 

[root@localhost avidserver]# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md6 : active raid5 scsi/host1/bus0/target1/lun0/part1[0] 
scsi/host5/bus0/target1/lun0/part1[4] scsi/host3/bus0/target1/lun0/part1[2] 
scsi/host2/bus0/target1/lun0/part1[1]
      796566528 blocks level 5, 128k chunk, algorithm 2 [5/4] [UUU_U]

md4 : active raid5 scsi/host1/bus0/target0/lun0/part1[0] 
scsi/host4/bus0/target0/lun0/part1[4] scsi/host3/bus0/target0/lun0/part1[3] 
scsi/host5/bus0/target0/lun0/part1[2] scsi/host2/bus0/target0/lun0/part1[1]
      480214528 blocks level 5, 128k chunk, algorithm 2 [5/5] [UUUUU]

unused devices: <none>


[root@localhost avidserver]# mdadm -E /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 62d8b91d:a2368783:6a78ca50:5793492f
  Creation Time : Fri Nov 22 09:13:16 2002
     Raid Level : raid5
    Device Size : 120053632 (114.49 GiB 122.93 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 4

    Update Time : Thu Jan 22 08:42:49 2004
          State : dirty, no-errors
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : f55e948c - correct
         Events : 0.146

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   
/dev/scsi/host1/bus0/target0/lun0/part1
   0     0       8        1        0      active sync   
/dev/scsi/host1/bus0/target0/lun0/part1
   1     1       8       33        1      active sync   
/dev/scsi/host2/bus0/target0/lun0/part1
   2     2       8      129        2      active sync   
/dev/scsi/host5/bus0/target0/lun0/part1
   3     3       8       65        3      active sync   
/dev/scsi/host3/bus0/target0/lun0/part1
   4     4       8       97        4      active sync   
/dev/scsi/host4/bus0/target0/lun0/part1

[root@localhost avidserver]# mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 57f26496:25520b96:41757b62:f83fcb7b
  Creation Time : Mon Nov 24 17:36:05 2003
     Raid Level : raid5
    Device Size : 199141632 (189.92 GiB 203.92 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 6

    Update Time : Thu Jan 22 08:43:28 2004
          State : dirty, no-errors
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : ebd80d56 - correct
         Events : 0.137

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   
/dev/scsi/host1/bus0/target1/lun0/part1
   0     0       8       17        0      active sync   
/dev/scsi/host1/bus0/target1/lun0/part1
   1     1       8       49        1      active sync   
/dev/scsi/host2/bus0/target1/lun0/part1
   2     2       8       81        2      active sync   
/dev/scsi/host3/bus0/target1/lun0/part1
   3     3       0        0        3      faulty removed
   4     4       8      145        4      active sync   
/dev/scsi/host5/bus0/target1/lun0/part1


    [root@localhost avidserver]# mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 62d8b91d:a2368783:6a78ca50:5793492f
  Creation Time : Fri Nov 22 09:13:16 2002
     Raid Level : raid5
    Device Size : 120053632 (114.49 GiB 122.93 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 4

    Update Time : Thu Jan 22 08:42:49 2004
          State : dirty, no-errors
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : f55e94ae - correct
         Events : 0.146

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   
/dev/scsi/host2/bus0/target0/lun0/part1
   0     0       8        1        0      active sync   
/dev/scsi/host1/bus0/target0/lun0/part1
   1     1       8       33        1      active sync   
/dev/scsi/host2/bus0/target0/lun0/part1
   2     2       8      129        2      active sync   
/dev/scsi/host5/bus0/target0/lun0/part1
   3     3       8       65        3      active sync   
/dev/scsi/host3/bus0/target0/lun0/part1
   4     4       8       97        4      active sync   
/dev/scsi/host4/bus0/target0/lun0/part1


   [root@localhost avidserver]# mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 57f26496:25520b96:41757b62:f83fcb7b
  Creation Time : Mon Nov 24 17:36:05 2003
     Raid Level : raid5
    Device Size : 199141632 (189.92 GiB 203.92 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 6

    Update Time : Thu Jan 22 08:43:28 2004
          State : dirty, no-errors
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : ebd80d78 - correct
         Events : 0.137

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     1       8       49        1      active sync   
/dev/scsi/host2/bus0/target1/lun0/part1
   0     0       8       17        0      active sync   
/dev/scsi/host1/bus0/target1/lun0/part1
   1     1       8       49        1      active sync   
/dev/scsi/host2/bus0/target1/lun0/part1
   2     2       8       81        2      active sync   
/dev/scsi/host3/bus0/target1/lun0/part1
   3     3       0        0        3      faulty removed
   4     4       8      145        4      active sync   
/dev/scsi/host5/bus0/target1/lun0/part1

   [root@localhost avidserver]# mdadm -E /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 62d8b91d:a2368783:6a78ca50:5793492f
  Creation Time : Fri Nov 22 09:13:16 2002
     Raid Level : raid5
    Device Size : 120053632 (114.49 GiB 122.93 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 4

    Update Time : Thu Jan 22 08:42:49 2004
          State : dirty, no-errors
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : f55e94d2 - correct
         Events : 0.146

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     3       8       65        3      active sync   
/dev/scsi/host3/bus0/target0/lun0/part1
   0     0       8        1        0      active sync   
/dev/scsi/host1/bus0/target0/lun0/part1
   1     1       8       33        1      active sync   /de
v/scsi/host2/bus0/target0/lun0/part1
   2     2       8      129        2      active sync   
/dev/scsi/host5/bus0/target0/lun0/part1
   3     3       8       65        3      active sync   
/dev/scsi/host3/bus0/target0/lun0/part1
   4     4       8       97        4      active sync   
/dev/scsi/host4/bus0/target0/lun0/part1

   [root@localhost avidserver]# mdadm -E /dev/sdf1
/dev/sdf1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 57f26496:25520b96:41757b62:f83fcb7b
  Creation Time : Mon Nov 24 17:36:05 2003
     Raid Level : raid5
    Device Size : 199141632 (189.92 GiB 203.92 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 6

    Update Time : Thu Jan 22 08:43:28 2004
          State : dirty, no-errors
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : ebd80d9a - correct
         Events : 0.137

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     2       8       81        2      active sync   
/dev/scsi/host3/bus0/target1/lun0/part1
   0     0       8       17        0      active sync   
/dev/scsi/host1/bus0/target1/lun0/part1
   1     1       8       49        1      active sync   
/dev/scsi/host2/bus0/target1/lun0/part1
   2     2       8       81        2      active sync   
/dev/scsi/host3/bus0/target1/lun0/part1
   3     3       0        0        3      faulty removed
   4     4       8      145        4      active sync   
/dev/scsi/host5/bus0/target1/lun0/part1


   [root@localhost avidserver]# mdadm -E /dev/sdg1
/dev/sdg1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 62d8b91d:a2368783:6a78ca50:5793492f
  Creation Time : Fri Nov 22 09:13:16 2002
     Raid Level : raid5
    Device Size : 120053632 (114.49 GiB 122.93 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 4

    Update Time : Thu Jan 22 08:42:49 2004
          State : dirty, no-errors
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : f55e94f4 - correct
         Events : 0.146

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     4       8       97        4      active sync   
/dev/scsi/host4/bus0/target0/lun0/part1
   0     0       8        1        0      active sync   
/dev/scsi/host1/bus0/target0/lun0/part1
   1     1       8       33        1      active sync   
/dev/scsi/host2/bus0/target0/lun0/part1
   2     2       8      129        2      active sync   
/dev/scsi/host5/bus0/target0/lun0/part1
   3     3       8       65        3      active sync   
/dev/scsi/host3/bus0/target0/lun0/part1
   4     4       8       97        4      active sync   
/dev/scsi/host4/bus0/target0/lun0/part1


   [root@localhost avidserver]# mdadm -E /dev/sdh1
/dev/sdh1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 57f26496:25520b96:41757b62:f83fcb7b
  Creation Time : Mon Nov 24 17:36:05 2003
     Raid Level : raid5
    Device Size : 199141632 (189.92 GiB 203.92 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 6

    Update Time : Thu Jan 15 08:18:48 2004
          State : dirty, no-errors
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : ebcecdda - correct
         Events : 0.118

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     3       8      113        3      active sync   
/dev/scsi/host4/bus0/target1/lun0/part1
   0     0       8       17        0      active sync   
/dev/scsi/host1/bus0/target1/lun0/part1
   1     1       8       49        1      active sync   
/dev/scsi/host2/bus0/target1/lun0/part1
   2     2       8       81        2      active sync   
/dev/scsi/host3/bus0/target1/lun0/part1
   3     3       8      113        3      active sync   
/dev/scsi/host4/bus0/target1/lun0/part1
   4     4       8      145        4      active sync   
/dev/scsi/host5/bus0/target1/lun0/part1

   [root@localhost avidserver]# mdadm -E /dev/sdi1
/dev/sdi1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 62d8b91d:a2368783:6a78ca50:5793492f
  Creation Time : Fri Nov 22 09:13:16 2002
     Raid Level : raid5
    Device Size : 120053632 (114.49 GiB 122.93 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 4

    Update Time : Thu Jan 22 08:42:49 2004
          State : dirty, no-errors
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : f55e9510 - correct
         Events : 0.146

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     2       8      129        2      active sync   
/dev/scsi/host5/bus0/target0/lun0/part1
   0     0       8        1        0      active sync   
/dev/scsi/host1/bus0/target0/lun0/part1
   1     1       8       33        1      active sync   
/dev/scsi/host2/bus0/target0/lun0/part1
   2     2       8      129        2      active sync   
/dev/scsi/host5/bus0/target0/lun0/part1
   3     3       8       65        3      active sync   
/dev/scsi/host3/bus0/target0/lun0/part1
   4     4       8       97        4      active sync   
/dev/scsi/host4/bus0/target0/lun0/part1


   [root@localhost avidserver]# mdadm -E /dev/sdj1
/dev/sdj1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 57f26496:25520b96:41757b62:f83fcb7b
  Creation Time : Mon Nov 24 17:36:05 2003
     Raid Level : raid5
    Device Size : 199141632 (189.92 GiB 203.92 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 6

    Update Time : Thu Jan 22 08:43:28 2004
          State : dirty, no-errors
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : ebd80dde - correct
         Events : 0.137

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     4       8      145        4      active sync   
/dev/scsi/host5/bus0/target1/lun0/part1
   0     0       8       17        0      active sync   
/dev/scsi/host1/bus0/target1/lun0/part1
   1     1       8       49        1      active sync   
/dev/scsi/host2/bus0/target1/lun0/part1
   2     2       8       81        2      active sync   
/dev/scsi/host3/bus0/target1/lun0/part1
   3     3       0        0        3      faulty removed
   4     4       8      145        4      active sync   
/dev/scsi/host5/bus0/target1/lun0/part1


 
