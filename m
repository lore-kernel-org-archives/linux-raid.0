From: Troy Cauble <troycauble@gmail.com>
Subject: Can't boot with drive pulled from RAID-1 /home (was: problem growing
	raid-1)
Date: Sun, 1 Feb 2009 17:18:45 -0500
Message-ID: <6d344ffd0902011418k4eaf1a10sc58358f289f1d5c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK.  Forget about the "growing" part of my question.
I'll re-state things:

Why doesn't my system boot when I pull a drive that's
part of the the RAID-1 /home?

Recent history:
I discovered a couple of weeks ago that I had been running
this RAID degraded for an unknown amount of time.  So it
could boot and run degraded then.
I did a (fail, add, remove) pattern and was up and running.

Later, I figured out that my partition types for the raid drives
shouldn't be 83 and I changed them to 0xDA with fdisk.  I
did this while the raid was mounted, if it matters.

NOW I find out that if I shutdown, pull a disk and boot, I get
dropped into a repair shell with:

fsck.ext3: Unable to resolve 'UUID=806153bf-6917-440d-ae48-553418cfbbeb'

 which is the UUID of the raid filesystem.

But when I put the drive back in and reboot, and everything is fine.
I've repeated this with both disks of the raid.

In the repair shell I captured the following:

root@mastershake:/root# mdadm -D --scan
mdadm: md device /dev/md0 does not appear to be active.
root@mastershake:/root# mdadm -E --scan
ARRAY /dev/md0 level=raid1 num-devices=2
UUID=61645020:223a69dc:12d77363:0c0f047d
root@mastershake:/root# mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 61645020:223a69dc:12d77363:0c0f047d
  Creation Time : Sun Jan  2 12:53:01 2005
     Raid Level : raid1
  Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 244195904 (232.88 GiB 250.06 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Sun Feb  1 16:14:11 2009
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e639550e - correct
         Events : 0.5125560


      Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   /dev/sdc1

   0     0       8       17        0      active sync
   1     1       8       33        1      active sync   /dev/sdc1



So, why
"md device /dev/md0 does not appear to be active." ????

Again, if I put the 2nd drive back in, everything's fine.

Thanks,
-troy
