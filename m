From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: filesystem corruption with RAID6.
Date: Fri, 3 Sep 2004 13:15:01 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200409031715.i83HF6327457@watkins-home.com>
References: <wxx7jrbo87d.fsf@nommo.uio.no>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wxx7jrbo87d.fsf@nommo.uio.no>
To: 'Terje Kvernes' <terjekv@math.uio.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I can't help debug it.  But you may be able to determine if it is RAID6
related.  Can you re-do your test, this time use RAID5?  The problems should
go away if it is RAID6 related.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Terje Kvernes
Sent: Friday, September 03, 2004 8:20 AM
To: linux-raid@vger.kernel.org
Subject: filesystem corruption with RAID6.


  howdy.

  I've recently started testing RAID6 on a Promise SATA150 TX4, using
  the controller as a pure SATA-controller and running software RAID
  over the four drives connected to it.  the kernel is 2.6.8.1-mm4.
  the drives are all identical, WD2500JD-00H.

  I've fiddled a bit with testing the array, setting drives as faulty
  and removing them, only to reinsert them afterwards.  there were no
  complaints from the system while doing these trials, and everything
  looked good.  my md was then turned into a PV and added to a VG.
  all was seemingly well.  I probably created the PV while the system
  was doing the initial sync of the RAIDset, I am however unsure if
  that should cause any problems as the pvcreate didn't report any
  errors from the block device.

  I then created two LVs and copied data from the network onto one of
  the LVs while a recovery was in process (the re-adding of
  /dev/sdc1), which didn't report any errors.  upon copying from the
  recently populated LV to the blank LV however, I get a lot of I/O
  errors while reading from the recently populated filesystem.  I've
  removed the LVs, tested different filesystems (ext3, reiserfs) but
  the errors always show in the same way.  

  now, this isn't exactly a good thing.  especially since the only
  thing I see are I/O errors upon reading the data.  I'm not quite
  sure what I can provide to help anyone debug this, but I'm more than
  willing to help with testing.  

  thanks for all the great md-work, and please CC me, I'm not on the
  list.


gayomart:/# cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6] 
md0 : active raid6 sdc1[2] sdd1[3] sdb1[1] sda1[0]
      488391808 blocks level 6, 64k chunk, algorithm 2 [4/4] [UUUU]
      
unused devices: <none>
gayomart:/# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Thu Sep  2 22:00:49 2004
     Raid Level : raid6
     Array Size : 488391808 (465.77 GiB 500.11 GB)
    Device Size : 244195904 (232.88 GiB 250.06 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Sep  3 14:07:43 2004
          State : clean, no-errors
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
           UUID : a9b70f65:e3d7bda8:a0a37b4d:4ae0aab1
         Events : 0.1835

-- 
Terje
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

