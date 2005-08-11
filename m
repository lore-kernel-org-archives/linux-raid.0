From: "David M. Strang" <dstrang@shellpower.net>
Subject: Rebuilt Array Issue
Date: Thu, 11 Aug 2005 06:18:13 -0400
Message-ID: <003701c59e5d$fbbc5ca0$c700a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Awhile back; with some help from Neil and the others in this mailing list --  
I was able to bring my failed array back online. It's running healthy 28/28 
disks -- however; I rebooted the other day. Attempted to reassemble the 
raid, and it would only assemble 27 of 28 disks. I had to assemble with a 
force and hotadd /dev/sdaa back into the raid and let it rebuild. Below is 
the output from my mdadm --detail /dev/md0

/dev/md0:
        Version : 01.00.01
  Creation Time : Wed Dec 31 19:00:00 1969
     Raid Level : raid5
     Array Size : 1935556992 (1845.89 GiB 1982.01 GB)
    Device Size : 71687296 (68.37 GiB 73.41 GB)
   Raid Devices : 28
  Total Devices : 28
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Aug 11 06:09:12 2005
          State : clean
 Active Devices : 28
Working Devices : 28
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-asymmetric
     Chunk Size : 128K

           UUID : 4e2b6b0a8e:92e91c0c:018a4bf0:9bb74d
         Events : 259462

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync 
/dev/scsi/host2/bus0/target0/lun0/disc
       1       8       16        1      active sync 
/dev/scsi/host2/bus0/target1/lun0/disc
       2       8       32        2      active sync 
/dev/scsi/host2/bus0/target2/lun0/disc
       3       8       48        3      active sync 
/dev/scsi/host2/bus0/target3/lun0/disc
       4       8       64        4      active sync 
/dev/scsi/host2/bus0/target4/lun0/disc
       5       8       80        5      active sync 
/dev/scsi/host2/bus0/target5/lun0/disc
       6       8       96        6      active sync 
/dev/scsi/host2/bus0/target6/lun0/disc
       7       8      112        7      active sync 
/dev/scsi/host2/bus0/target7/lun0/disc
       8       8      128        8      active sync 
/dev/scsi/host2/bus0/target8/lun0/disc
       9       8      144        9      active sync 
/dev/scsi/host2/bus0/target9/lun0/disc
      10       8      160       10      active sync 
/dev/scsi/host2/bus0/target10/lun0/disc
      11       8      176       11      active sync 
/dev/scsi/host2/bus0/target11/lun0/disc
      12       8      192       12      active sync 
/dev/scsi/host2/bus0/target12/lun0/disc
      13       8      208       13      active sync 
/dev/scsi/host2/bus0/target13/lun0/disc
      14       8      224       14      active sync 
/dev/scsi/host2/bus0/target14/lun0/disc
      15       8      240       15      active sync 
/dev/scsi/host2/bus0/target15/lun0/disc
      16      65        0       16      active sync 
/dev/scsi/host2/bus0/target16/lun0/disc
      17      65       16       17      active sync 
/dev/scsi/host2/bus0/target17/lun0/disc
      18      65       32       18      active sync 
/dev/scsi/host2/bus0/target18/lun0/disc
      19      65       48       19      active sync 
/dev/scsi/host2/bus0/target19/lun0/disc
      20      65       64       20      active sync 
/dev/scsi/host2/bus0/target20/lun0/disc
      21      65       80       21      active sync 
/dev/scsi/host2/bus0/target21/lun0/disc
      22      65       96       22      active sync 
/dev/scsi/host2/bus0/target22/lun0/disc
      23      65      112       23      active sync 
/dev/scsi/host2/bus0/target23/lun0/disc
      24      65      128       24      active sync 
/dev/scsi/host2/bus0/target24/lun0/disc
      25      65      144       25      active sync 
/dev/scsi/host2/bus0/target25/lun0/disc
      26       0        0        -      removed
      27      65      176       27      active sync 
/dev/scsi/host2/bus0/target27/lun0/disc

      28      65      160       26      active sync 
/dev/scsi/host2/bus0/target26/lun0/disc


Is it supposed to stay with number 26 as removed forever? Does number 28 
ever jump back up to that spot? I shouldn't have to hotadd and allow it to 
resync everytime I re-assemble the raid should I?

-- David M. Strang 

