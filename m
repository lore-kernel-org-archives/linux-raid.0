From: dturner <dan@voiceweather.net>
Subject: Help a Newbie on Linux-Raid 1
Date: Sat, 13 Dec 2008 15:43:55 -0800 (PST)
Message-ID: <20995732.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I am rather new to linux and decided to set up a system using linux raid on
centos 5.2  Being new I find some howtos easy to follow and I used one in
setting up the raid. All looked fine when I finished and everything was was
in order showing working raid and then I did a stupid thing and stopped the
machine to make sure each drive could boot. Stopping the machine between
drive swaps. THis all worked well then I configured the machine and a few
days latter I noticed that the raid was showing degraded on both drives. 

Now being a newbie I am in a bind. The machine is still running and after
spending many hours configuring it, I do not want to screw it up so I look
to someone with lots more knowledge than I for help.

Please help with full command lines to solve this issue and get the raid
rebuilt as I do not want to screw anything up. I have included the
information on the system below. If anything else is needed please let me
know.

Many thanks in advance guys.....

Dan

/var/log/dmesg

ata1.00: ATA-7: ST3250310AS, 4.AAA, max UDMA/133
ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2.00: ATA-7: ST3250310AS, 4.AAA, max UDMA/133
ata2.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
  Vendor: ATA       Model: ST3250310AS       Rev: 4.AA
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
 sda: sda1 sda2
sd 0:0:0:0: Attached scsi disk sda
  Vendor: ATA       Model: ST3250310AS       Rev: 4.AA
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
 sdb: sdb1 sdb2
sd 1:0:0:0: Attached scsi disk sdb
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.11.5-ioctl (2007-12-12) initialised:
dm-devel@redhat.com
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdb2 ...
md:  adding sdb2 ...
md: sdb1 has different UUID to sdb2
md:  adding sda2 ...
md: sda1 has different UUID to sdb2
md: created md1
md: bind<sda2>
md: bind<sdb2>
md: running: <sdb2><sda2>
md: kicking non-fresh sda2 from array!
md: unbind<sda2>
md: export_rdev(sda2)
raid1: raid set md1 active with 1 out of 2 mirrors
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1>
md: kicking non-fresh sda1 from array!
md: unbind<sda1>
md: export_rdev(sda1)
raid1: raid set md0 active with 1 out of 2 mirrors
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.





# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdb1[1]
      104320 blocks [2/1] [_U]

md1 : active raid1 sdb2[1]
      244091520 blocks [2/1] [_U]

unused devices: <none>


# /sbin/mdadm -D /dev/md1
/dev/md1:
        Version : 00.90.03
  Creation Time : Sat Nov  8 13:31:37 2008
     Raid Level : raid1
     Array Size : 244091520 (232.78 GiB 249.95 GB)
  Used Dev Size : 244091520 (232.78 GiB 249.95 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Tue Dec  2 08:06:57 2008
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           UUID : 86e86a3b:8e87f809:12ea81c3:2a8cb750
         Events : 0.743680

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       18        1      active sync   /dev/sdb2




# /sbin/mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Sat Nov  8 13:33:46 2008
     Raid Level : raid1
     Array Size : 104320 (101.89 MiB 106.82 MB)
  Used Dev Size : 104320 (101.89 MiB 106.82 MB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Dec  1 10:26:34 2008
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           UUID : de04b561:d5722aa5:39fbf8b1:b8b8884b
         Events : 0.210

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       17        1      active sync   /dev/sdb1


-- 
View this message in context: http://www.nabble.com/Help-a-Newbie-on-Linux-Raid-1-tp20995732p20995732.html
Sent from the linux-raid mailing list archive at Nabble.com.

