From: AndyLiebman@aol.com
Subject: MDADM Guru Needed
Date: Wed, 29 Oct 2003 11:43:05 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <ce.3f5f4f3c.2cd14819@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi. I'm hoping somebody can help me out here so that I don't destroy my data. 

I have a set of RAID arrays made with Firewire Drives. I have three pairs of 
RAID 1's (md0, md1, and md2). On top of that I have a RAID 0 striping all 
three RAID 1s together. 

I just had to reinstall my Linux distribution -- Mandrake 9.2. It's a long 
story. But I shut down cleanly, disconnected the Firewire Drives. Reinstalled 
Mandrake 9.2. Reinstalled MDADM, Raidtools, xfs file support, etc. 

When I attempted to restart my arrays with mdadm (using the UUID information 
I had previously saved),  I got some serious errors . I hope someone has a 
good suggestion -- step-by-step -- about what I have to do to reactivate/recover 
my arrays so that I don't lose my data. 

[root@localhost avidserver]# mdadm -Av /dev/md0 
--uuid=5cc02c9f:8d83c7b2:c9eafc6
8:2a40900e /dev/sd*
mdadm: looking for devices for /dev/md0
mdadm: /dev/sd is not a block device.
mdadm: /dev/sd has wrong uuid.
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdb has wrong uuid.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
mdadm: no RAID superblock on /dev/sdc
mdadm: /dev/sdc has wrong uuid.
mdadm: /dev/sdc1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdd
mdadm: /dev/sdd has wrong uuid.
mdadm: /dev/sdd1 has wrong uuid.
mdadm: no RAID superblock on /dev/sde
mdadm: /dev/sde has wrong uuid.
mdadm: /dev/sde1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdf
mdadm: /dev/sdf has wrong uuid.
mdadm: /dev/sdf1 has wrong uuid.
mdadm: added /dev/sdb1 to /dev/md0 as 1
mdadm: added /dev/sda1 to /dev/md0 as 0
mdadm: /dev/md0 has been started with 2 drives.
[root@localhost avidserver]# mdadm -Av /dev/md2 
--uuid=4c2bd3c9:563b2117:cb9ebfa
0:0e5d4594 /dev/sd*
mdadm: looking for devices for /dev/md2
mdadm: /dev/sd is not a block device.
mdadm: /dev/sd has wrong uuid.
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sda1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdb has wrong uuid.
mdadm: /dev/sdb1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdc
mdadm: /dev/sdc has wrong uuid.
mdadm: /dev/sdc1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdd
mdadm: /dev/sdd has wrong uuid.
mdadm: /dev/sdd1 is identified as a member of /dev/md2, slot 0.
mdadm: no RAID superblock on /dev/sde
mdadm: /dev/sde has wrong uuid.
mdadm: /dev/sde1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdf
mdadm: /dev/sdf has wrong uuid.
mdadm: /dev/sdf1 is identified as a member of /dev/md2, slot 1.
mdadm: added /dev/sdd1 to /dev/md2 as 0
mdadm: added /dev/sdf1 to /dev/md2 as 1
mdadm: /dev/md2 assembled from 1 drive - need all 2 to start it (use --run to 
in    sist).
[root@localhost avidserver]# mdadm -Av /dev/md1 
--uuid=c80b59ef:6c1fc70c:7e881254:d3e7e3c3 /dev/sd*
mdadm: looking for devices for /dev/md1
mdadm: /dev/sd is not a block device.
mdadm: /dev/sd has wrong uuid.
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sda1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdb has wrong uuid.
mdadm: /dev/sdb1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdc
mdadm: /dev/sdc has wrong uuid.
mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 0.
mdadm: no RAID superblock on /dev/sdd
mdadm: /dev/sdd has wrong uuid.
mdadm: /dev/sdd1 has wrong uuid.
mdadm: no RAID superblock on /dev/sde
mdadm: /dev/sde has wrong uuid.
mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 1.
mdadm: no RAID superblock on /dev/sdf
mdadm: /dev/sdf has wrong uuid.
mdadm: /dev/sdf1 has wrong uuid.
mdadm: device 1 in /dev/md1 has wrong state in superblock, but /dev/sde1 
seems ok
mdadm: added /dev/sde1 to /dev/md1 as 1
mdadm: added /dev/sdc1 to /dev/md1 as 0
mdadm: failed to RUN_ARRAY /dev/md1: Invalid argument


I checked all of my individual devices (sda1, sdb1, sdc1, etc. ) with mdadm 
-E. Here's the result. By the way, I noticed that what used to be sde1 before I 
had to reinstall was now sdf1. I could tell by the UUID number and the 
information about which PCI card (I have 5 of them) the drive was plugged into. But 
change device ids isn't supposed to matter with mdadm. 

[root@localhost avidserver]# mdadm -E /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 5cc02c9f:8d83c7b2:c9eafc68:2a40900e
  Creation Time : Fri Oct 24 10:47:08 2003
     Raid Level : raid1
    Device Size : 199141632 (189.92 GiB 203.92 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Wed Oct 29 06:43:42 2003
          State : dirty, no-errors
Active Devices : 2
Working Devices : 2
Failed Devices : 0
  Spare Devices : 0
       Checksum : 12b45d42 - correct
         Events : 0.28


      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   
/dev/scsi/host1/bus0/target0/lun0/part1
   0     0       8        1        0      active sync   
/dev/scsi/host1/bus0/target0/lun0/part1
   1     1       8       17        1      active sync   
/dev/scsi/host2/bus0/target0/lun0/part1
[root@localhost avidserver]# mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 5cc02c9f:8d83c7b2:c9eafc68:2a40900e
  Creation Time : Fri Oct 24 10:47:08 2003
     Raid Level : raid1
    Device Size : 199141632 (189.92 GiB 203.92 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Wed Oct 29 06:43:42 2003
          State : dirty, no-errors
Active Devices : 2
Working Devices : 2
Failed Devices : 0
  Spare Devices : 0
       Checksum : 12b45d54 - correct
         Events : 0.28


      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   
/dev/scsi/host2/bus0/target0/lun0/part1
   0     0       8        1        0      active sync   
/dev/scsi/host1/bus0/target0/lun0/part1
   1     1       8       17        1      active sync   
/dev/scsi/host2/bus0/target0/lun0/part1
[root@localhost avidserver]# mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c80b59ef:6c1fc70c:7e881254:d3e7e3c3
  Creation Time : Sat Oct 25 10:39:48 2003
     Raid Level : raid1
    Device Size : 199141632 (189.92 GiB 203.92 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 1

    Update Time : Wed Oct 29 01:19:30 2003
          State : dirty, no-errors
Active Devices : 1
Working Devices : 1
Failed Devices : 0
  Spare Devices : 0
       Checksum : bae0f776 - correct
         Events : 0.17


      Number   Major   Minor   RaidDevice State
this     0       8       33        0      active sync   
/dev/scsi/host2/bus0/target1/lun0/part1
   0     0       8       33        0      active sync   
/dev/scsi/host2/bus0/target1/lun0/part1
   1     1       0        0        1      faulty removed
[root@localhost avidserver]# mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 4c2bd3c9:563b2117:cb9ebfa0:0e5d4594
  Creation Time : Sat Oct 25 17:27:01 2003
     Raid Level : raid1
    Device Size : 199141632 (189.92 GiB 203.92 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2

    Update Time : Tue Oct 28 20:22:28 2003
          State : clean, no-errors
Active Devices : 2
Working Devices : 2
Failed Devices : 0
  Spare Devices : 0
       Checksum : b0a8f4b4 - correct
         Events : 0.16


      Number   Major   Minor   RaidDevice State
this     0       8       49        0      active sync   
/dev/scsi/host3/bus0/target0/lun0/part1
   0     0       8       49        0      active sync   
/dev/scsi/host3/bus0/target0/lun0/part1
   1     1       8       65        1      active sync   
/dev/scsi/host4/bus0/target0/lun0/part1
[root@localhost avidserver]# mdadm -E /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c80b59ef:6c1fc70c:7e881254:d3e7e3c3
  Creation Time : Sat Oct 25 10:39:48 2003
     Raid Level : raid1
    Device Size : 199141632 (189.92 GiB 203.92 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Tue Oct 28 20:22:28 2003
          State : clean, no-errors
Active Devices : 2
Working Devices : 2
Failed Devices : 0
  Spare Devices : 0
       Checksum : bae0b263 - correct
         Events : 0.16


      Number   Major   Minor   RaidDevice State
this     1       8       81        1      active sync   
/dev/scsi/host4/bus0/target1/lun0/part1
   0     0       8       33        0      active sync   
/dev/scsi/host2/bus0/target1/lun0/part1
   1     1       8       81        1      active sync   
/dev/scsi/host4/bus0/target1/lun0/part1
[root@localhost avidserver]# mdadm -E /dev/sdf1
/dev/sdf1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 4c2bd3c9:563b2117:cb9ebfa0:0e5d4594
  Creation Time : Sat Oct 25 17:27:01 2003
     Raid Level : raid1
    Device Size : 199141632 (189.92 GiB 203.92 GB)
   Raid Devices : 2
  Total Devices : 0
Preferred Minor : 2

    Update Time : Wed Oct 29 06:38:20 2003
          State : clean, no-errors
Active Devices : 1
Working Devices : 1
Failed Devices : -1
  Spare Devices : 0
       Checksum : b0a984a3 - correct
         Events : 0.19


      Number   Major   Minor   RaidDevice State
this     1       8       81        1      active sync   
/dev/scsi/host4/bus0/target1/lun0/part1
   0     0       0        0        0      faulty removed
   1     1       8       81        1      active sync   
/dev/scsi/host4/bus0/target1/lun0/part1



I hope somebody can make some sense of this and tell me what to do next. 

Thanks in advance. 

Andy Liebman
