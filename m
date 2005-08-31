From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: raid5: Disk failure on sdm, disabling device
Date: Wed, 31 Aug 2005 15:38:45 -0400
Message-ID: <004301c5ae63$99f14b50$c100a8c0@NCNF5131FTH>
References: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH> <1125516500.3194.3.camel@x1-6-00-0d-60-fd-e8-4c>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Forrest Taylor <ftaylor@redhat.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Aug 31 04:48:15 abyss kernel: md: excessive errors occurred during 
superblock update, exiting
Aug 31 04:48:15 abyss kernel: scsi2 (12:0): rejecting I/O to offline device
Aug 31 04:48:15 abyss kernel: raid5: Disk failure on sdm, disabling device. 
Operation continuing on 27 devices

However, in the past -- I had to rebuild the array; and now it looks like 
this:

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

    Update Time : Wed Aug 31 11:04:22 2005
          State : clean, degraded
 Active Devices : 27
Working Devices : 27
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-asymmetric
     Chunk Size : 128K

           UUID : 4e2b6b0a8e:92e91c0c:018a4bf0:9bb74d
         Events : 333051

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
      12       8      192        -      faulty 
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


My last reboot -- which was due in part to a power failure; this device --  
/dev/scsi/host2/bus0/target26/lun0/disc -- wouldn't join back into the raid 
w/o being re-hotadded. With another device failed, I'm fearful of a reboot. 
I want to attempt to rebuild the failed device; and see what happens.

-- David M. Strang



----- Original Message ----- 
From: Forrest Taylor
To: David M. Strang
Cc: Linux RAID
Sent: Wednesday, August 31, 2005 3:28 PM
Subject: Re: raid5: Disk failure on sdm, disabling device


On Wed, 2005-08-31 at 13:26, David M. Strang wrote:
> Okay, my array is degraded -- and the device /dev/sdm is disabled.
>
> Short of a reboot, is there a way to re-enable the device? It's already
> flagged as faulty in mdadm.

Have you tried to remove /dev/sdm from the RAID and add it back in?  I
guess that the larger question is what caused it to be flagged faulty?

Forrest

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html 

