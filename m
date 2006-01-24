From: mdadm@lr-netcon.de
Subject: mdadm: superblock on /dev/sdr1 doesn't match others - assembly aborted
Date: Wed, 25 Jan 2006 00:23:53 +0100
Message-ID: <1138145033.43d6b70968906@mail.lr-netcon.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am using a 8 disc scsi raid5 array on a fedora 3 system.

after a system crash, while the array was rebuilding a missing hd, 
i am now unable to get this array running again.

thats all i get (/dev/sdr1 is not the one which was rebuild):
# mdadm -R /dev/md4
mdadm: failed to run array /dev/md4: Invalid argument   

# mdadm -A /dev/md4 -
v /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1 /dev/sdq1 /dev/sdr
1
looking for devices for /dev/md4
/dev/sdk1 is identified as a member of /dev/md4, slot 0.
/dev/sdl1 is identified as a member of /dev/md4, slot 1.
/dev/sdm1 is identified as a member of /dev/md4, slot 2.
/dev/sdn1 is identified as a member of /dev/md4, slot 8.
/dev/sdo1 is identified as a member of /dev/md4, slot 4.
/dev/sdp1 is identified as a member of /dev/md4, slot 5.
/dev/sdq1 is identified as a member of /dev/md4, slot 6.
mdadm: superblock on /dev/sdr1 doesn't match others - assembly aborted    


# mdadm --examine /dev/sdk1
/dev/sdk1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 232635af:1afe6aa5:e06f8828:99966325
  Creation Time : Mon Jul  4 17:30:26 2005
     Raid Level : raid5
    Device Size : 195358336 (186.31 GiB 200.05 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 4

    Update Time : Tue Jan 24 00:04:48 2006
          State : active
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f3b7aef6 - correct
         Events : 0.986172

         Layout : left-symmetric
     Chunk Size : 4K

      Number   Major   Minor   RaidDevice State
this     0       8      161        0      active sync   /dev/sdk1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       8      177        1      active sync   /dev/sdl1
   2     2       8      193        2      active sync   /dev/sdm1
   3     3       0        0        3      faulty removed
   4     4       8      225        4      active sync   /dev/sdo1
   5     5       8      241        5      active sync   /dev/sdp1
   6     6      65        1        6      active sync   /dev/sdq1
   7     7      65       17        7      active sync   /dev/sdr1



# mdadm --examine /dev/sdr1
/dev/sdr1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 232605af:1afe6aa5:e06f8828:99966325
  Creation Time : Mon Jul  4 17:30:26 2005
     Raid Level : raid5
    Device Size : 195358336 (186.31 GiB 200.05 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 4

    Update Time : Tue Jan 24 00:05:03 2006
          State : active
 Active Devices : 7
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 0
       Checksum : f3a87282 - correct
         Events : 0.986172

         Layout : left-symmetric
     Chunk Size : 4K

      Number   Major   Minor   RaidDevice State
this     7      65       17        7      active sync   /dev/sdr1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       8      177        1      active sync   /dev/sdl1
   2     2       8      193        2      active sync   /dev/sdm1
   3     3       0        0        3      faulty removed
   4     4       8      225        4      active sync   /dev/sdo1
   5     5       8      241        5      active sync   /dev/sdp1
   6     6      65        1        6      active sync   /dev/sdq1
   7     7      65       17        7      active sync   /dev/sdr1


# mdadm --version
mdadm - v2.2 - 5 December 2005




Thx

Thomas




----------------------------------------------------------------------
This mail sent through L&R NetCon webmail Client
