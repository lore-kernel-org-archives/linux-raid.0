From: Michael Alger <linux-raid@mm.quex.org>
Subject: Updating superblock to reflect new disc locations
Date: Wed, 11 Jan 2006 13:20:58 +0800
Message-ID: <43C495BA.9070502@mm.quex.org>
Reply-To: linux-raid@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm running Debian sarge on a system with two IDE drives. I used the 
installer to create a mirrored filesystem on the first partition of both 
discs and it's mounted as the root; everything was working fine.

Unfortunately, I noticed the two devices were on the same IDE channel 
(i.e. /dev/hda1 and /dev/hdb1), so I moved them on to different channels 
(/dev/hda1 and /dev/hdc1). Now, the array only finds the one device when 
it starts up (/dev/hda1). In case it's relevant, because of the cable 
lengths the drives moved as follows:

dev/hda -> dev/hdc
dev/hdb -> dev/hda

I believe all I really need to do is update the superblock on /dev/hda1 
so the md driver knows to look at /dev/hdc1 rather than /dev/hdb1. 
Unfortunately, I can't work out how to do this. The only references I've 
seen to rewriting the superblock is with mdadm --assemble, but I can't 
use that because it's already running.

I've tried removing both drives from the array (not at the same time, of 
course), then re-adding them and waiting for it to finish syncing, but 
that doesn't help. After a reboot, I still get the same problem. In 
fact, now it looks like it's not even trying /dev/hdb1; it looks like it 
recorded the fact I had removed the drive, but not the fact I'd added it 
again.

After using mdadm --manage /dev/md0 --add /dev/hdc1 and waiting for the 
array to resync, the superblock info on both discs match.

Below is the current situation in terms of mdadm output, after re-adding 
/dev/hdc1 to /dev/md0 and waiting for it to resync. (md1 is on hda1 and 
hdc1, and has the same problem.)


# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 hda3[1]
      9767424 blocks [2/1] [_U]

md0 : active raid1 hdc1[0] hda1[1]
      2441728 blocks [2/2] [UU]

unused devices: <none>


The superblocks look correct to me, as the following shows:

# mdadm --misc --examine /dev/hda1
/dev/hda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : d2b494fc:a181e190:a09f1dfb:b226ea79
  Creation Time : Tue Jan 10 15:53:02 2006
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Wed Jan 11 13:10:10 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f7d5252c - correct
         Events : 0.3266

      Number   Major   Minor   RaidDevice State
this     1       3        1        1      active sync   /dev/hda1

   0     0      22        1        0      active sync   /dev/hdc1
   1     1       3        1        1      active sync   /dev/hda1

# mdadm --misc --examine /dev/hdc1
/dev/hdc1:
(I removed the status information here to make it more readable; it is 
identical for both devices, so it looks like they are properly 
synchronized.)

      Number   Major   Minor   RaidDevice State
this     0      22        1        0      active sync   /dev/hdc1

   0     0      22        1        0      active sync   /dev/hdc1
   1     1       3        1        1      active sync   /dev/hda1



After a reboot:

# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 hda3[1]
      9767424 blocks [2/1] [_U]

md0 : active raid1 hda1[1]
      2441728 blocks [2/1] [_U]

unused devices: <none>

# mdadm --misc --examine /dev/hda1
/dev/hda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : d2b494fc:a181e190:a09f1dfb:b226ea79
  Creation Time : Tue Jan 10 15:53:02 2006
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0

    Update Time : Wed Jan 11 13:17:37 2006
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f7d5275f - correct
         Events : 0.3336


      Number   Major   Minor   RaidDevice State
this     1       3        1        1      active sync   /dev/hda1

   0     0       0        0        0      removed
   1     1       3        1        1      active sync   /dev/hda1

# mdadm --misc --examine /dev/hdc1
/dev/hdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : d2b494fc:a181e190:a09f1dfb:b226ea79
  Creation Time : Tue Jan 10 15:53:02 2006
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Wed Jan 11 13:12:00 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f7d525d7 - correct
         Events : 0.3288


      Number   Major   Minor   RaidDevice State
this     0      22        1        0      active sync   /dev/hdc1

   0     0      22        1        0      active sync   /dev/hdc1
   1     1       3        1        1      active sync   /dev/hda1


Relevant parts of the boot process:

Kernel command line: root=/dev/md0 ro
hda: ST380011A, ATA DISK drive
Using anticipatory io scheduler
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 128KiB
hda: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=65535/16/63, 
UDMA(100)
 /dev/ide/host0/bus0/target0/lun0: p1 p2 p3 p4 < p5 p6 >
hdc: ST380011A, ATA DISK drive
ide1 at 0x170-0x177,0x376 on irq 15
hdc: max request size: 128KiB
hdc: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=65535/16/63, 
UDMA(100)
 /dev/ide/host0/bus1/target0/lun0: p1 p2 p3 p4 < p5 p6 >
md: md0 stopped.
md: bind<hda1>
raid1: raid set md0 active with 1 out of 2 mirrors


Any suggestions would be greatly appreciated. The system's new and not 
yet in production, so I can reinstall it if I have to, but I'd prefer to 
be able to fix something as simple as this.
