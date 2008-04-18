From: Phil Lobbes <phil@perkpartners.com>
Subject: RAID1 == two different ARRAY in scan, and Q on read error corrected
Date: Fri, 18 Apr 2008 15:35:59 -0400
Message-ID: <27567.1208547359@perkpartners.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have been lurking for a little while on the mail list and been doing
some investigation on my own.  I don't mean to impose and hopefully this
is the right forum for these questions.  If anyone has some
suggestions/recommendations/guidance on the following two questions I'm
all ears!

_________________________________________________________________
Q1: RAID1 == two different ARRAY in scan

I recently upgraded my server from Fedora Core 5 to Fedora 8 and along
with that I noticed something that either overlooked before or perhaps
caused during the upgrade.  On that system I have a 300G RAID1 mirror:

  # cat /proc/mdstat
  Personalities : [raid1]
  md0 : active raid1 sdc1[0] sdd1[1]
        293049600 blocks [2/2] [UU]

  unused devices: <none>

When I use mdadm --examine --scan my 300G RAID1 mirror returns two
separate UUIDs with different devices for each:
* (correct) a "complete disk partition" aka /dev/sd{c,d}1
* (bogus) a entire device aka /dev/sd{c,d}

  # mdadm --examine --scan --verbose
  ARRAY /dev/md0 level=raid1 num-devices=2 UUID=12c2d7a3:0b791468:9e965247:f4354b36
     devices=/dev/sdd,/dev/sdc
  ARRAY /dev/md0 level=raid1 num-devices=2 UUID=7b879b21:7cc83b9c:765dd3f3:2af46d19
     devices=/dev/sdd1,/dev/sdc1


I didn't find a match in a FAQ or other posting so I was hoping to get
some insight/pointers here.

Should I:
a. Ignore this?

b. Zero out the superblock on sd{c,d}?  I'm no expert here so not
   positive this is a good option.  My theory is that a superblock for
   sdc must be different than a superblock for sdc1 so if that is
   correct the "fix" might be something like:

   # mdadm --zero-superblock /dev/sdc /dev/sdd

   Is this correct and safe?  No worries about it somehow impacting
   /dev/sdc1 and /dev/sdd1 and the good mirror, right?

c. Something else altogether?

For what it's worth, I suppose there is a chance I may have caused this
by trying to 'rename' the md# used by the ARRAY /dev/md0 => /dev/md3.

-----------------------------------------------------------------
* Disk/Partition info:

NOTE: Valid mirror is for partition /dev/sd{c,d}1 (not device
/dev/sd{c,d})

# fdisk -l /dev/sdc /dev/sdd

Disk /dev/sdc: 300.0 GB, 300090728448 bytes
255 heads, 63 sectors/track, 36483 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       36483   293049666   fd  Linux raid autodetect

Disk /dev/sdd: 300.0 GB, 300090728448 bytes
255 heads, 63 sectors/track, 36483 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       36483   293049666   fd  Linux raid autodetect


_________________________________________________________________
* Q2: On read error corrected messages

On an unrelated note, during/after the upgrade I noticed that I'm now
seeing a few of these events logged:

Apr 15 11:07:14  kernel: raid1: sdc1: rescheduling sector 517365296
Apr 15 11:07:54  kernel: raid1:md0: read error corrected (8 sectors at 517365296 on sdc1)
Apr 15 11:07:54  kernel: raid1: sdc1: redirecting sector 517365296 to another mirror
Apr 15 11:08:32  kernel: raid1: sdc1: rescheduling sector 517365472
Apr 15 11:09:09  kernel: raid1:md0: read error corrected (8 sectors at 517365472 on sdc1)
Apr 15 11:09:09  kernel: raid1: sdc1: redirecting sector 517365472 to another mirror


And also more of these:

Apr 18 14:01:45  smartd[2104]: Device: /dev/sdc, 3 Currently unreadable (pending) sectors
Apr 18 14:01:45  smartd[2104]: Device: /dev/sdc, SMART Prefailure Attribute: 8 Seek_Time_Performance changed from 240 to 241
Apr 18 14:01:45  smartd[2104]: Device: /dev/sdd, SMART Prefailure Attribute: 8 Seek_Time_Performance changed from 238 to 239


Here's some info from smartctl:

# smartctl -a /dev/sdc
smartctl version 5.38 [i386-redhat-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Maxtor DiamondMax 10 family (ATA/133 and SATA/150)
Device Model:     Maxtor 6B300S0
Serial Number:    B60370HH
Firmware Version: BANC1980
User Capacity:    300,090,728,448 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 0
Local Time is:    Fri Apr 18 15:09:02 2008 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
...

SMART Error Log Version: 1
ATA Error Count: 36 (device log contains only the most recent five errors)
        CR = Command Register [HEX]
        FR = Features Register [HEX]
        SC = Sector Count Register [HEX]
        SN = Sector Number Register [HEX]
        CL = Cylinder Low Register [HEX]
        CH = Cylinder High Register [HEX]
        DH = Device/Head Register [HEX]
        DC = Device Command Register [HEX]
        ER = Error register [HEX]
        ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 36 occurred at disk power-on lifetime: 27108 hours (1129 days + 12 hours)
  When the command that caused the error occurred, the device was in an unknown state.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  5e 00 00 00 00 00 a0

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  00 00 00 00 00 00 a0 00  18d+12:45:51.593  NOP [Abort queued commands]
  00 00 08 1f 5f d6 e0 00  18d+12:45:48.339  NOP [Abort queued commands]
  00 00 00 00 00 00 e0 00  18d+12:45:48.338  NOP [Abort queued commands]
  00 00 00 00 00 00 a0 00  18d+12:45:48.335  NOP [Abort queued commands]
  00 03 46 00 00 00 a0 00  18d+12:45:48.332  NOP [Reserved subcommand]


Luckily, I'm not an expert on hard drives (nor their failures) but I'm
hoping that somebody might be able to give me some insight on any of
this and if I should be concerned or if I should just considered these
unreadable sectors as "normal" in the life of the drive.

Sincerely,
Phil
