From: dick.streefland@xs4all.nl (Dick Streefland)
Subject: Re: resync on every raidstart
Date: Tue, 23 Sep 2003 20:43:04 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <dad.3f70b057.ee5c4@altium.nl>
References: <7e6d.3f6de874.1ece7@altium.nl> <16239.60542.191148.816664@notabene.cse.unsw.edu.au>
Reply-To: dick.streefland@xs4all.nl (Dick Streefland)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
| I cannot reproduce this.
| Does it happen with real devices, or only loopback devices?
| 
| Can you try with mdadm and see if that makes a difference?
| 
| After raidstop, and before raidstart, can you
| 
|   mdadm -E /dev/loop1
|   mdadm -E /dev/loop2
| 
| and show me the results?

This is the output of mdadm-1.3.0:

# mdadm -E /dev/loop1
/dev/loop1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 44f2804a:f7890a34:bd644666:becddad4
  Creation Time : Tue Sep 23 21:08:17 2003
     Raid Level : raid1
    Device Size : 10176 (9.94 MiB 10.42 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Tue Sep 23 21:08:33 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e0ba675d - correct
         Events : 0.2


      Number   Major   Minor   RaidDevice State
this     0       7        1        0      active sync   /dev/loop1
   0     0       7        1        0      active sync   /dev/loop1
   1     1       7        2        1      active sync   /dev/loop2
# mdadm -E /dev/loop2
/dev/loop2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 44f2804a:f7890a34:bd644666:becddad4
  Creation Time : Tue Sep 23 21:08:17 2003
     Raid Level : raid1
    Device Size : 10176 (9.94 MiB 10.42 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Tue Sep 23 21:08:33 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e0ba6760 - correct
         Events : 0.2


      Number   Major   Minor   RaidDevice State
this     1       7        2        1      active sync   /dev/loop2
   0     0       7        1        0      active sync   /dev/loop1
   1     1       7        2        1      active sync   /dev/loop2

I guess the "dirty" state is the problem?

I also created a RAID1 array on another machine (2.6.0-test5 kernel,
raidtools-1.00.3, mdadm-0.7.2) with real disks:

# mkraid /dev/md3
handling MD device /dev/md3
analyzing super-block
disk 0: /dev/hda3, 535752kB, raid superblock at 535680kB
disk 1: /dev/hdb3, 535752kB, raid superblock at 535680kB

... waiting for sync completion ...

# mdadm -E /dev/hda3
/dev/hda3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8e85542d:e073310b:b5478b9a:67ea873f
  Creation Time : Tue Sep 23 21:38:39 2003
     Raid Level : raid1
    Device Size : 535680 (523.12 MiB 548.53 MB)
     Raid Disks : 2
    Total Disks : 2
Preferred Minor : 3

    Update Time : Tue Sep 23 21:49:36 2003
          State : dirty, no-errors
  Active Drives : 2
 Working Drives : 2
  Failed Drives : 0
   Spare Drives : 0
       Checksum : b43f696d - correct
         Events : 0.1


      Number   Major   Minor   RaidDisk   State
this     0       3        3        0      active sync   /dev/hda3
   0     0       3        3        0      active sync   /dev/hda3
   1     1       3       67        1      active sync   /dev/hdb3
# raidstop /dev/md3
# mdadm -E /dev/hda3
/dev/hda3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8e85542d:e073310b:b5478b9a:67ea873f
  Creation Time : Tue Sep 23 21:38:39 2003
     Raid Level : raid1
    Device Size : 535680 (523.12 MiB 548.53 MB)
     Raid Disks : 2
    Total Disks : 2
Preferred Minor : 3

    Update Time : Tue Sep 23 21:50:45 2003
          State : dirty, no-errors
  Active Drives : 2
 Working Drives : 2
  Failed Drives : 0
   Spare Drives : 0
       Checksum : b43f69b4 - correct
         Events : 0.2


      Number   Major   Minor   RaidDisk   State
this     0       3        3        0      active sync   /dev/hda3
   0     0       3        3        0      active sync   /dev/hda3
   1     1       3       67        1      active sync   /dev/hdb3

A raidstart resulted in a second resync, but after that, it is clean:

# mdadm -E /dev/hda3
/dev/hda3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8e85542d:e073310b:b5478b9a:67ea873f
  Creation Time : Tue Sep 23 21:38:39 2003
     Raid Level : raid1
    Device Size : 535680 (523.12 MiB 548.53 MB)
     Raid Disks : 2
    Total Disks : 2
Preferred Minor : 3

    Update Time : Tue Sep 23 22:20:08 2003
          State : clean, no-errors
  Active Drives : 2
 Working Drives : 2
  Failed Drives : 0
   Spare Drives : 0
       Checksum : b43f709c - correct
         Events : 0.4


      Number   Major   Minor   RaidDisk   State
this     0       3        3        0      active sync   /dev/hda3
   0     0       3        3        0      active sync   /dev/hda3
   1     1       3       67        1      active sync   /dev/hdb3

However, the RAID1 array on the loopback devices stays "dirty", even
after multiple raidstop/raidstart commands.

-- 
Dick Streefland                    ////               De Bilt
dick.streefland@xs4all.nl         (@ @)       The Netherlands
------------------------------oOO--(_)--OOo------------------

