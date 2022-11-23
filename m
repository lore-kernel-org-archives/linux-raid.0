Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0181EC433FE
	for <linux-raid@archiver.kernel.org>; Wed, 23 Nov 2022 22:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbiKWWHo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Nov 2022 17:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbiKWWHm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Nov 2022 17:07:42 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B61A472
        for <linux-raid@vger.kernel.org>; Wed, 23 Nov 2022 14:07:39 -0800 (PST)
Received: from c-73-207-192-158.hsd1.ga.comcast.net ([73.207.192.158]:48078 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1oxxu8-0007St-KR
        for linux-raid@vger.kernel.org;
        Wed, 23 Nov 2022 16:07:38 -0600
Date:   Wed, 23 Nov 2022 22:07:36 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: how do i fix these RAID5 arrays?
Message-ID: <20221123220736.GD19721@jpo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - www18.qth.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - justpickone.org
X-Get-Message-Sender-Via: www18.qth.com: authenticated_id: dmail@justpickone.org
X-Authenticated-Sender: www18.qth.com: dmail@justpickone.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, all --

TL;DR : I'm providing lots of detail to try to not leave anything
unexplained, but in the end I need to remove "removed" devices from
RAID5 arrays and add them back to rebuild.


I have 3ea 10T (in round numbers, of course :-) drives 

  diskfarm:~ # fdisk -l /dev/sd[bcd]
  Disk /dev/sdb: 9.1 TiB, 10000831348736 bytes, 19532873728 sectors
  Disk model: TOSHIBA HDWR11A 
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 4096 bytes
  I/O size (minimum/optimal): 4096 bytes / 4096 bytes
  Disklabel type: gpt
  Disk identifier: EDF3B089-018E-454F-BD3F-6161A0A0FBFB
  
  Device            Start         End    Sectors  Size Type
  /dev/sdb51         2048  3254781951 3254779904  1.5T Linux LVM
  /dev/sdb52   3254781952  6509561855 3254779904  1.5T Linux LVM
  /dev/sdb53   6509561856  9764341759 3254779904  1.5T Linux LVM
  /dev/sdb54   9764341760 13019121663 3254779904  1.5T Linux LVM
  /dev/sdb55  13019121664 16273901567 3254779904  1.5T Linux LVM
  /dev/sdb56  16273901568 19528681471 3254779904  1.5T Linux LVM
  /dev/sdb128 19528681472 19532873694    4192223    2G Linux filesystem
  
  
  Disk /dev/sdc: 9.1 TiB, 10000831348736 bytes, 19532873728 sectors
  Disk model: TOSHIBA HDWR11A 
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 4096 bytes
  I/O size (minimum/optimal): 4096 bytes / 4096 bytes
  Disklabel type: gpt
  Disk identifier: 1AD8FC0A-5ADD-49E6-9BB2-6161A0BEFBFB
  
  Device            Start         End    Sectors  Size Type
  /dev/sdc51         2048  3254781951 3254779904  1.5T Linux LVM
  /dev/sdc52   3254781952  6509561855 3254779904  1.5T Linux LVM
  /dev/sdc53   6509561856  9764341759 3254779904  1.5T Linux LVM
  /dev/sdc54   9764341760 13019121663 3254779904  1.5T Linux LVM
  /dev/sdc55  13019121664 16273901567 3254779904  1.5T Linux LVM
  /dev/sdc56  16273901568 19528681471 3254779904  1.5T Linux LVM
  /dev/sdc128 19528681472 19532873694    4192223    2G Linux filesystem
  
  
  Disk /dev/sdd: 9.1 TiB, 10000831348736 bytes, 19532873728 sectors
  Disk model: TOSHIBA HDWR11A 
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 4096 bytes
  I/O size (minimum/optimal): 4096 bytes / 4096 bytes
  Disklabel type: gpt
  Disk identifier: EDF3B089-018E-454F-BD3F-6161A0A0FBFB
  
  Device            Start         End    Sectors  Size Type
  /dev/sdd51         2048  3254781951 3254779904  1.5T Linux LVM
  /dev/sdd52   3254781952  6509561855 3254779904  1.5T Linux LVM
  /dev/sdd53   6509561856  9764341759 3254779904  1.5T Linux LVM
  /dev/sdd54   9764341760 13019121663 3254779904  1.5T Linux LVM
  /dev/sdd55  13019121664 16273901567 3254779904  1.5T Linux LVM
  /dev/sdd56  16273901568 19528681471 3254779904  1.5T Linux LVM
  /dev/sdd128 19528681472 19532873694    4192223    2G Linux filesystem

that I've sliced, RAID5-ed 

  diskfarm:~ # mdadm -D /dev/md51
  /dev/md51:
             Version : 1.2
       Creation Time : Thu Nov  4 00:46:28 2021
          Raid Level : raid5
          Array Size : 4881773568 (4.55 TiB 5.00 TB)
       Used Dev Size : 1627257856 (1551.87 GiB 1666.31 GB)
        Raid Devices : 4
       Total Devices : 3
         Persistence : Superblock is persistent
  
       Intent Bitmap : Internal
  
         Update Time : Wed Nov 23 02:53:35 2022
               State : clean, degraded 
      Active Devices : 3
     Working Devices : 3
      Failed Devices : 0
       Spare Devices : 0
  
              Layout : left-symmetric
          Chunk Size : 512K
  
  Consistency Policy : bitmap
  
                Name : diskfarm:51  (local to host diskfarm)
                UUID : 9330e44f:35baf039:7e971a8e:da983e31
              Events : 37727
  
      Number   Major   Minor   RaidDevice State
         0     259        9        0      active sync   /dev/sdb51
         1     259        2        1      active sync   /dev/sdc51
         3     259       16        2      active sync   /dev/sdd51
         -       0        0        3      removed
  diskfarm:~ # mdadm -E /dev/md51
  /dev/md51:
            Magic : a92b4efc
          Version : 1.2
      Feature Map : 0x0
       Array UUID : cccbe073:d92c6ecd:77ba5c46:5db6b3f0
             Name : diskfarm:10T  (local to host diskfarm)
    Creation Time : Thu Nov  4 00:56:36 2021
       Raid Level : raid0
     Raid Devices : 6
  
   Avail Dev Size : 6508767232 sectors (3.03 TiB 3.33 TB)
      Data Offset : 264192 sectors
     Super Offset : 8 sectors
     Unused Space : before=264112 sectors, after=3254515712 sectors
            State : clean
      Device UUID : 4eb64186:15de3406:50925d42:54df22e1
  
      Update Time : Thu Nov  4 00:56:36 2021
    Bad Block Log : 512 entries available at offset 8 sectors
         Checksum : 45a70eae - correct
           Events : 0
  
       Chunk Size : 512K
  
     Device Role : Active device 0
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  
into arrays (ignore the "degraded" for the moment), and striped 

  diskfarm:~ # mdadm -D /dev/md50
  /dev/md50:
             Version : 1.2
       Creation Time : Thu Nov  4 00:56:36 2021
          Raid Level : raid0
          Array Size : 19526301696 (18.19 TiB 19.99 TB)
        Raid Devices : 6
       Total Devices : 6
         Persistence : Superblock is persistent
  
         Update Time : Thu Nov  4 00:56:36 2021
               State : clean 
      Active Devices : 6
     Working Devices : 6
      Failed Devices : 0
       Spare Devices : 0
  
              Layout : -unknown-
          Chunk Size : 512K
  
  Consistency Policy : none
  
                Name : diskfarm:10T  (local to host diskfarm)
                UUID : cccbe073:d92c6ecd:77ba5c46:5db6b3f0
              Events : 0
  
      Number   Major   Minor   RaidDevice State
         0       9       51        0      active sync   /dev/md/51
         1       9       52        1      active sync   /dev/md/52
         2       9       53        2      active sync   /dev/md/53
         3       9       54        3      active sync   /dev/md/54
         4       9       55        4      active sync   /dev/md/55
         5       9       56        5      active sync   /dev/md/56
  diskfarm:~ # mdadm -E /dev/md50
  /dev/md50:
     MBR Magic : aa55
  Partition[0] :   4294967295 sectors at            1 (type ee)

into a 20T array, the idea being that each piece of which should take
less time to rebuild if something fails.  That was all great, and then I
wanted to add another disk

  diskfarm:~ # fdisk -l /dev/sdk
  Disk /dev/sdk: 9.1 TiB, 10000831348736 bytes, 19532873728 sectors
  Disk model: TOSHIBA HDWR11A 
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 4096 bytes
  I/O size (minimum/optimal): 4096 bytes / 4096 bytes
  Disklabel type: gpt
  Disk identifier: FAB535F8-F57B-4BA4-8DEB-B0DEB49496C1
  
  Device            Start         End    Sectors  Size Type
  /dev/sdk51         2048  3254781951 3254779904  1.5T Linux LVM
  /dev/sdk52   3254781952  6509561855 3254779904  1.5T Linux LVM
  /dev/sdk53   6509561856  9764341759 3254779904  1.5T Linux LVM
  /dev/sdk54   9764341760 13019121663 3254779904  1.5T Linux LVM
  /dev/sdk55  13019121664 16273901567 3254779904  1.5T Linux LVM
  /dev/sdk56  16273901568 19528681471 3254779904  1.5T Linux LVM
  /dev/sdk128 19528681472 19532873694    4192223    2G Linux filesystem

to it to give me 30T usable.

I sliced up the new drive as above, added each slice to each RAID5 array,
and then grow-ed each array to take advantage of it.  And, sure enough,
for 52 it worked:

  diskfarm:~ # mdadm -D /dev/md52
  /dev/md52:
	     Version : 1.2
       Creation Time : Thu Nov  4 00:47:09 2021
	  Raid Level : raid5
	  Array Size : 4881773568 (4.55 TiB 5.00 TB)
       Used Dev Size : 1627257856 (1551.87 GiB 1666.31 GB)
	Raid Devices : 4
       Total Devices : 4
	 Persistence : Superblock is persistent
  
       Intent Bitmap : Internal
  
	 Update Time : Wed Nov 23 02:52:00 2022
	       State : clean 
      Active Devices : 4
     Working Devices : 4
      Failed Devices : 0
       Spare Devices : 0
  
	      Layout : left-symmetric
	  Chunk Size : 512K
  
  Consistency Policy : bitmap
  
		Name : diskfarm:52  (local to host diskfarm)
		UUID : d9eada18:29478a43:37654ef5:d34df19c
	      Events : 10996
  
      Number   Major   Minor   RaidDevice State
	 0     259       10        0      active sync   /dev/sdb52
	 1     259        3        1      active sync   /dev/sdc52
	 3     259       17        2      active sync   /dev/sdd52
	 4     259       24        3      active sync   /dev/sdk52
  diskfarm:~ # mdadm -E /dev/md52
  /dev/md52:
	    Magic : a92b4efc
	  Version : 1.2
      Feature Map : 0x0
       Array UUID : cccbe073:d92c6ecd:77ba5c46:5db6b3f0
	     Name : diskfarm:10T  (local to host diskfarm)
    Creation Time : Thu Nov  4 00:56:36 2021
       Raid Level : raid0
     Raid Devices : 6
  
   Avail Dev Size : 6508767232 sectors (3.03 TiB 3.33 TB)
      Data Offset : 264192 sectors
     Super Offset : 8 sectors
     Unused Space : before=264112 sectors, after=3254515712 sectors
	    State : clean
      Device UUID : 74ab812f:7e1695ec:360638b6:0c73d8b0
  
      Update Time : Thu Nov  4 00:56:36 2021
    Bad Block Log : 512 entries available at offset 8 sectors
	 Checksum : 18d743dd - correct
	   Events : 0
  
       Chunk Size : 512K
  
     Device Role : Active device 1
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)

THAT is what really confuses me.  I ran (sorry; they're gone) the same
commands for each device; they should work the same way!  But, obviously,
something ain't right.

On the 5 broken ones, we have one each removed device

  diskfarm:~ # mdadm -D /dev/md5[13456] | egrep '^/dev|active|removed'
  /dev/md51:
	 0     259        9        0      active sync   /dev/sdb51
	 1     259        2        1      active sync   /dev/sdc51
	 3     259       16        2      active sync   /dev/sdd51
	 -       0        0        3      removed
  /dev/md53:
	 0     259       11        0      active sync   /dev/sdb53
	 1     259        4        1      active sync   /dev/sdc53
	 3     259       18        2      active sync   /dev/sdd53
	 -       0        0        3      removed
  /dev/md54:
	 0     259       12        0      active sync   /dev/sdb54
	 1     259        5        1      active sync   /dev/sdc54
	 3     259       19        2      active sync   /dev/sdd54
	 -       0        0        3      removed
  /dev/md55:
	 0     259       13        0      active sync   /dev/sdb55
	 1     259        6        1      active sync   /dev/sdc55
	 3     259       20        2      active sync   /dev/sdd55
	 -       0        0        3      removed
  /dev/md56:
	 0     259       14        0      active sync   /dev/sdb56
	 1     259        7        1      active sync   /dev/sdc56
	 3     259       21        2      active sync   /dev/sdd56
	 -       0        0        3      removed

that are obviously the sdk (new disk) slice.  If md52 were also broken,
I'd figure that the disk was somehow unplugged, but I don't think I can
plug in one sixth of a disk and leave the rest unhooked :-)  So ...  In
addition to wondering how I got here, how do I remove the "removed" ones
and then re-add them to build and grow and finalize this?


TIA

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

