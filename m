From: "Turbo Fredriksson" <turbo@swe.net>
Subject: RAID5 won't start
Date: Mon, 25 Oct 2004 10:42:06 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <9fBHj5pj.1098700926.1885870.turbo@emil.swe.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[sorry about the crappy formating - my real mail system is on the failed
 array, and I'm forced to use the job email - juck!]

I'll try to recreate my steps in getting this problem...

When I built my external RAID cabinet, I was lacking a disk bracket
(what Sun calls drive spuds -
http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&category=20328&item=5726798994&rd=1).
So instead I used cardboard to separate the disks. This have worked just
fine (roughly 3-4 months).
Today I received my replacement spuds, and I thought I mount it on to the
disks.

Removed the disk (mdadm md1 -f sdd1 -r sdd1), and then later replaced it
again in the exact same location (mdadm md1 -a sdd1)...

It took about half hour to sync again. I had a oneliner that looked at the
output from "mdadm -D md1 | grep 'whatever the string was'" (how far
it
got rebuilding). A couple of seconds/minutes (don't know exactly, I had
other things on my mind in another window :) it reached 99% it seemed to
have hung. Cat'ing /proc/mdstat also hung...

Starting a serial console, I saw a lot of stuff but what catched my eyes
was that it had finished syncing the md1 array.... Since I was in a rush,
i cykled the power (I know - DUMB!). Now it won't start the array...


----- s n i p -----
Number  Major  Minor  RaidDevice State
0       0        0       -1      removed
1       8       81        1      active sync  
/dev/scsi/host3/bus0/target8/lun0/part1
2       8       97        2      active sync  
/dev/scsi/host3/bus0/target9/lun0/part1
3       8      241        3      active sync  
/dev/scsi/host4/bus0/target4/lun0/part1
4      65        1        4      active sync  
/dev/scsi/host4/bus0/target5/lun0/part1
5      65       17        5      active sync  
/dev/scsi/host4/bus0/target8/lun0/part1
6      65       33        6      active sync  
/dev/scsi/host4/bus0/target9/lun0/part1
7      65      113        7      active sync  
/dev/scsi/host4/bus0/target14/lun0/part1
8       0        0       -1      removed
9       8       49       -1      spare  
/dev/scsi/host3/bus0/target4/lun0/part1

sdf1    /dev/scsi/host3/bus0/target8/lun0/part1:  device 1 in 9 device
active raid5 md1.
sdg1    /dev/scsi/host3/bus0/target9/lun0/part1:  device 2 in 9 device
active raid5 md1.
sdp1    /dev/scsi/host4/bus0/target4/lun0/part1:  device 3 in 9 device
active raid5 md1.
sdq1    /dev/scsi/host4/bus0/target5/lun0/part1:  device 4 in 9 device
active raid5 md1.
sdr1    /dev/scsi/host4/bus0/target8/lun0/part1:  device 5 in 9 device
active raid5 md1.
sds1    /dev/scsi/host4/bus0/target9/lun0/part1:  device 6 in 9 device
active raid5 md1.
sdx1    /dev/scsi/host4/bus0/target14/lun0/part1: device 7 in 9 device
active raid5 md1.
sdd1    /dev/scsi/host3/bus0/target4/lun0/part1:  device 9 in 9 device
active raid5 md1.

sdd1:     Update Time : Mon Oct 25 09:19:09 2004
sdx1:     Update Time : Mon Oct 25 07:37:42 2004
sds1:     Update Time : Mon Oct 25 09:19:09 2004
sdr1:     Update Time : Mon Oct 25 09:19:09 2004
sdq1:     Update Time : Mon Oct 25 09:19:09 2004
sdp1:     Update Time : Mon Oct 25 09:19:09 2004
sdg1:     Update Time : Mon Oct 25 09:19:09 2004
sdf1:     Update Time : Mon Oct 25 09:19:09 2004

md1 : inactive sdf1[1] sdd1[9] sdx1[7] sds1[6] sdr1[5] sdq1[4] sdp1[3]
sdg1[2]
      141763072 blocks
----- s n i p -----

The problem here is that sdd1 is now marked as a spare! The command to get
it this far was:

mdadm -v --assemble md1 --force --run sdf1 sdg1 sdp1 sdq1 sdr1 sds1 sdx1
sdd1

And this will give me the following:
----- s n i p -----
md: md1 stopped.
mdadm: looking for devices for md1
mdadm: sdf1 is identified as a mmd: bind<sdg1>
embermd: bind<sdp1>
md: bind<sdq1>
md: bind<sdr1>
md: bind<sds1>
md: bind<sdx1>
 of mdmd: bind<sdd1>
md: bind<sdf1>
raid5: device sdf1 operational as raid disk 1
raid5: device sdx1 operational as raid disk 7
raid5: device sds1 operational as raid disk 6
raid5: device sdr1 operational as raid disk 5
raid5: device sdq1 operational as raid disk 4
raid5: device sdp1 operational as raid disk 3
raid5: device sdg1 operational as raid disk 2
raid5: not enough operational devices for md1 (2/9 failed)
RAID5 conf printout:
 --- rd:9 wd:7 fd:2
 disk 1, o:1, dev:sdf1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sdp1
 disk 4, o:1, dev:sdq1
 disk 5, o:1, dev:sdr1
 disk 6, o:1, dev:sds1
 disk 7, o:1, dev:sdx1
raid5: failed to run raid set md1
md: pers->run() failed ...
1, slot 1.
mdadm: sdg1 is identified as a member of md1, slot 2.
mdadm: sdp1 is identified as a member of md1, slot 3.
mdadm: sdq1 is identified as a member of md1, slot 4.
mdadm: sdr1 is identified as a member of md1, slot 5.
mdadm: sds1 is identified as a member of md1, slot 6.
mdadm: sdx1 is identified as a member of md1, slot 7.
mdadm: sdd1 is identified as a member of md1, slot 9.
mdadm: no uptodate device for slot 0 of md1
mdadm: added sdg1 to md1 as 2
mdadm: added sdp1 to md1 as 3
mdadm: added sdq1 to md1 as 4
mdadm: added sdr1 to md1 as 5
mdadm: added sds1 to md1 as 6
mdadm: added sdx1 to md1 as 7
mdadm: no uptodate device for slot 8 of md1
mdadm: added sdd1 to md1 as 9
mdadm: added sdf1 to md1 as 1
mdadm: failed to RUN_ARRAY md1: Invalid argument
----- s n i p -----

I have no idea which disk is supposed to be 0 and/or 8... These are the
disks
used when creating the array!

This message was sent using Swe.Net webmail
