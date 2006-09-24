From: chapman <chris@datasetgo.com>
Subject: raid 1 recovery steps
Date: Sun, 24 Sep 2006 09:36:39 -0700 (PDT)
Message-ID: <6473812.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Sorry for the noob question but I want to make sure I get this right.

I have a raid 1 (sata) running on an active server - mdadm reports sda1 as
faulty.  Running "mdadm --examine /dev/sda1" shows the state as dirty, no
errors - no failed devices.  Can I assume the disk is ok, just needs to be
re-added to the array?

I'm assuming I need to first remove sda1 from the raid then re-add it,
correct?  If so, what are the specific steps?  Can this be done safely on a
live server without pulling the system down?  How will this affect rebooting
once completed - if at all?  Any gotchas I should look out for?


Here's some mdadm output...

/sbin/mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Thu Jan 27 09:55:22 2005
     Raid Level : raid1
     Array Size : 154183680 (147.04 GiB 157.88 GB)
    Device Size : 154183680 (147.04 GiB 157.88 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Sep 13 01:45:03 2006
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       8        1        0      faulty   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
           UUID : 49f6e41a:28dde75c:8f133fe5:823322fb
         Events : 0.40



/sbin/mdadm --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 49f6e41a:28dde75c:8f133fe5:823322fb
  Creation Time : Thu Jan 27 09:55:22 2005
     Raid Level : raid1
    Device Size : 154183680 (147.04 GiB 157.88 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

Update Time : Wed May 24 04:59:32 2006
State : dirty, no-errors
Active Devices : 2
Working Devices : 2
Failed Devices : 0
Spare Devices : 0
Checksum : bce563ef - correct
Events : 0.39


      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1


TIA for any assistance you can provide.

--chapman
-- 
View this message in context: http://www.nabble.com/raid-1-recovery-steps-tf2327020.html#a6473812
Sent from the linux-raid mailing list archive at Nabble.com.

