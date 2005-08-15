From: Jon Lewis <jlewis@lewis.org>
Subject: confused raid1
Date: Mon, 15 Aug 2005 11:41:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0508151131020.10349@soloth.lewis.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've inheritted responsibility for a server with a root raid1 that 
degrades every time the system is rebooted.  It's a 2.4.x kernel.  I've 
got both raidutils and mdadm available.

The raid1 device is supposed to be /dev/hde1 & /dev/hdg1 with /dev/hdc1 as 
a spare.  I believe it was created with raidutils and the following 
portion of /etc/raidtab:

raiddev             /dev/md1
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              1
     device          /dev/hde1
     raid-disk     0
     device          /dev/hdg1
     raid-disk     1
     device          /dev/hdc1
     spare-disk    0

The output of mdadm -E concerns me though.

# mdadm -E /dev/hdc1
/dev/hdc1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 8b65fa52:21176cc9:cbb74149:c418b5a4
   Creation Time : Tue Jan 13 13:21:41 2004
      Raid Level : raid1
     Device Size : 30716160 (29.29 GiB 31.45 GB)
    Raid Devices : 2
   Total Devices : 1
Preferred Minor : 1

     Update Time : Thu Aug 11 08:38:59 2005
           State : dirty, no-errors
  Active Devices : 2
Working Devices : 2
  Failed Devices : -1
   Spare Devices : 0
        Checksum : 6a4dddb8 - correct
          Events : 0.195

       Number   Major   Minor   RaidDevice State
this     1      22        1        1      active sync   /dev/hdc1
    0     0      33        1        0      active sync   /dev/hde1
    1     1      22        1        1      active sync   /dev/hdc1

# mdadm -E /dev/hde1
/dev/hde1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 8b65fa52:21176cc9:cbb74149:c418b5a4
   Creation Time : Tue Jan 13 13:21:41 2004
      Raid Level : raid1
     Device Size : 30716160 (29.29 GiB 31.45 GB)
    Raid Devices : 2
   Total Devices : 1
Preferred Minor : 1

     Update Time : Mon Aug 15 11:16:43 2005
           State : dirty, no-errors
  Active Devices : 2
Working Devices : 2
  Failed Devices : -1
   Spare Devices : 0
        Checksum : 6a5348c9 - correct
          Events : 0.199


       Number   Major   Minor   RaidDevice State
this     0      33        1        0      active sync   /dev/hde1
    0     0      33        1        0      active sync   /dev/hde1
    1     1      34        1        1      active sync   /dev/hdg1

# mdadm -E /dev/hdg1
/dev/hdg1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 8b65fa52:21176cc9:cbb74149:c418b5a4
   Creation Time : Tue Jan 13 13:21:41 2004
      Raid Level : raid1
     Device Size : 30716160 (29.29 GiB 31.45 GB)
    Raid Devices : 2
   Total Devices : 1
Preferred Minor : 1

     Update Time : Mon Aug 15 11:16:43 2005
           State : dirty, no-errors
  Active Devices : 2
Working Devices : 2
  Failed Devices : -1
   Spare Devices : 0
        Checksum : 6a5348cc - correct
          Events : 0.199


       Number   Major   Minor   RaidDevice State
this     1      34        1        1      active sync   /dev/hdg1
    0     0      33        1        0      active sync   /dev/hde1
    1     1      34        1        1      active sync   /dev/hdg1

Shouldn't total devices be at least 2?  How can failed devices be -1?

When the system reboots, md1 becomes just /dev/hdc1.  I've used mdadm to 
add hde1, fail and then remove hdc1, and add hdg1.  How can I repair the 
array such that it will survive the next reboot and keep hde1 and hdg1 as 
the working devices?

md1 : active raid1 hdg1[1] hde1[0]
       30716160 blocks [2/2] [UU]

----------------------------------------------------------------------
  Jon Lewis                   |  I route
  Senior Network Engineer     |  therefore you are
  Atlantic Net                | 
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
