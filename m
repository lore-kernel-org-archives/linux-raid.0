From: Tim Bostrom <tbostrom@writemem.com>
Subject: Problem with 5disk RAID5 array - two drives lost
Date: Wed, 19 Apr 2006 12:39:25 -0700
Message-ID: <A2F915E2-EC52-4EFE-86C2-547A71F8D788@writemem.com>
Mime-Version: 1.0 (Apple Message framework v749.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good day,

I'm running FC4 kernel 2.6.11-1.1369 with a 5 disk RAID5 array.    
This past weekend after a reboot to my machine, /dev/md0 will no  
longer mount and Fedora will abort booting the system and force me to  
fix the filesystem.  Upon further investigation, it looks like I lost  
two drives within a few weeks of each other.  I'll go ahead and get  
this out of the way - I'm an idiot and didn't setup mdadm -F for  
mailing with RAID problems.

It appears that /dev/hdf1 failed this past week and /dev/hdh1 failed  
back in February.  I tried a mdadm --assemble --force and was able to  
get the following:

==========================
mdadm: forcing event count in /dev/hdf1(1) from 777532 upto 777535
mdadm: clearing FAULTY flag for device 2 in /dev/md0 for /dev/hdf1
raid5: raid level 5 set md0 active with 4 out of 5 devices, algorithm 2
mdadm: /dev/md0 has been started with 4 drives (out of 5).
==========================


I then tried to mount /dev/md0 and received the following:
====================
raid5: Disk failure on hdf1, disabling device.  Operation continuing  
on  drives
mount: wrong fs type, bad option, bad superblock on /dev/md0,
missing codepage or other error
In some cases useful info is found in syslog - try dmesg | tail
=====================

In checking dmesg, I find:
==================================
raid5: device hde1 operational as raid disk 0
raid5: device hdc1 operational as raid disk 4
raid5: device hdg1 operational as raid disk 2
raid5: device hdf1 operational as raid disk 1
raid5: allocated 5254kB for md0
raid5: raid level 5 set md0 active with 4 out of 5 devices, algorithm 2
RAID5 conf printout:
--- rd:5 wd:4 fd:1
disk 0, o:1, dev:hde1
disk 1, o:1, dev:hdf1
disk 2, o:1, dev:hdg1
disk 4, o:1, dev:hdc1
usb 1-2: USB disconnect, address 2
usb 1-2: new full speed USB device using uhci_hcd and address 3
usb 1-2: not running at top speed; connect to a high speed hub
scsi1 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
   Vendor: SanDisk   Model: Cruzer Mini       Rev: 0.1
   Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 1000944 512-byte hdwr sectors (512 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: assuming drive cache: write through
SCSI device sda: 1000944 512-byte hdwr sectors (512 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: assuming drive cache: write through
sda: sda1
Attached scsi removable disk sda at scsi1, channel 0, id 0, lun 0
usb-storage: device scan complete
spurious 8259A interrupt: IRQ7.
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6720,  
high=0, low=6720, sector=6719
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6719
raid5: Disk failure on hdf1, disabling device. Operation continuing  
on 3 devices
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6731,  
high=0, low=6731, sector=6727
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6727
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6735,  
high=0, low=6735, sector=6735
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6735
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6743,  
high=0, low=6743, sector=6743
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6743
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6753,  
high=0, low=6753, sector=6751
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6751
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6763,  
high=0, low=6763, sector=6759
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6759
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6770,  
high=0, low=6770, sector=6767
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6767
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6776,  
high=0, low=6776, sector=6775
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6775
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6803,  
high=0, low=6803, sector=6783
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6783
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6803,  
high=0, low=6803, sector=6791
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6791
JBD: Failed to read block at offset 1794
JBD: recovery failed
EXT3-fs: error loading journal.
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6803,  
high=0, low=6803, sector=6799
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6799
Buffer I/O error on device md0, logical block 1604
lost page write due to I/O error on md0
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6807,  
high=0, low=6807, sector=6807
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6807
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6815,  
high=0, low=6815, sector=6815
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6815
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6823,  
high=0, low=6823, sector=6823
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6823
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6831,  
high=0, low=6831, sector=6831
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6831
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6841,  
high=0, low=6841, sector=6839
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6839
hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=6851,  
high=0, low=6851, sector=6847
ide: failed opcode was: unknown
end_request: I/O error, dev hdf, sector 6847
RAID5 conf printout:
--- rd:5 wd:3 fd:2
disk 0, o:1, dev:hde1
disk 1, o:0, dev:hdf1
disk 2, o:1, dev:hdg1
disk 4, o:1, dev:hdc1
RAID5 conf printout:
--- rd:5 wd:3 fd:2
disk 0, o:1, dev:hde1
disk 2, o:1, dev:hdg1
disk 4, o:1, dev:hdc1
================================

I'm guessing /dev/hdf is shot.  I haven't tried an fsck though.   
Would this be advisable?  I don't want to bork all the data.  It's  
about 700 GB of data.  I'm open to losing any data that was added  
since the February drive failure.  Is there a way that I can try and  
build the array again with /dev/hdh instead of /dev/hdf with some  
possible data corruption on files that were added since Feb?

Any advice would great.  I'm at a loss and I don't want to lose all  
of the data if I don't have to.  I might end up visiting one of those  
data recovery shops if I can't fix this on my own.

Thank you,

Tim



mdadm -E outputs below:
=================================

/dev/hdc1:
           Magic : a92b4efc
         Version : 00.90.01
            UUID : 2d1d58c2:23357cca:12b8e65a:a80cdebe
   Creation Time : Tue Jul 26 17:20:10 2005
      Raid Level : raid5
    Raid Devices : 5
   Total Devices : 4
Preferred Minor : 0

     Update Time : Sun Apr 16 09:10:28 2006
           State : clean
Active Devices : 3
Working Devices : 3
Failed Devices : 3
   Spare Devices : 0
        Checksum : 4a150769 - correct
          Events : 0.777535

          Layout : left-symmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     4      22        1        4      active sync   /dev/hdc1

    0     0      33        1        0      active sync   /dev/hde1
    1     1       0        0        1      faulty removed
    2     2      34        1        2      active sync   /dev/hdg1
    3     3       0        0        3      faulty removed
    4     4      22        1        4      active sync   /dev/hdc1



/dev/hde1:
           Magic : a92b4efc
         Version : 00.90.01
            UUID : 2d1d58c2:23357cca:12b8e65a:a80cdebe
   Creation Time : Tue Jul 26 17:20:10 2005
      Raid Level : raid5
    Raid Devices : 5
   Total Devices : 4
Preferred Minor : 0

     Update Time : Sun Apr 16 09:10:28 2006
           State : clean
Active Devices : 3
Working Devices : 3
Failed Devices : 3
   Spare Devices : 0
        Checksum : 4a15076c - correct
          Events : 0.777535

          Layout : left-symmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     0      33        1        0      active sync   /dev/hde1

    0     0      33        1        0      active sync   /dev/hde1
    1     1       0        0        1      faulty removed
    2     2      34        1        2      active sync   /dev/hdg1
    3     3       0        0        3      faulty removed
    4     4      22        1        4      active sync   /dev/hdc1




/dev/hdf1:
           Magic : a92b4efc
         Version : 00.90.01
            UUID : 2d1d58c2:23357cca:12b8e65a:a80cdebe
   Creation Time : Tue Jul 26 17:20:10 2005
      Raid Level : raid5
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 0

     Update Time : Fri Apr 14 13:46:06 2006
           State : clean
Active Devices : 4
Working Devices : 4
Failed Devices : 2
   Spare Devices : 0
        Checksum : 4a06c868 - correct
          Events : 0.777532

          Layout : left-symmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     1      33       65        1      active sync   /dev/hdf1

    0     0      33        1        0      active sync   /dev/hde1
    1     1      33       65        1      active sync   /dev/hdf1
    2     2      34        1        2      active sync   /dev/hdg1
    3     3       0        0        3      faulty removed
    4     4      22        1        4      active sync   /dev/hdc1

/dev/hdh1:
           Magic : a92b4efc
         Version : 00.90.01
            UUID : 2d1d58c2:23357cca:12b8e65a:a80cdebe
   Creation Time : Tue Jul 26 17:20:10 2005
      Raid Level : raid5
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 0

     Update Time : Tue Feb 21 07:47:51 2006
           State : active
Active Devices : 5
Working Devices : 5
Failed Devices : 0
   Spare Devices : 0
        Checksum : 49c0be2c - correct
          Events : 0.698097

          Layout : left-symmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     3      34       65        3      active sync   /dev/hdh1

    0     0      33        1        0      active sync   /dev/hde1
    1     1      33       65        1      active sync   /dev/hdf1
    2     2      34        1        2      active sync   /dev/hdg1
    3     3      34       65        3      active sync   /dev/hdh1
    4     4      22        1        4      active sync   /dev/hdc1



/dev/hdh1:
           Magic : a92b4efc
         Version : 00.90.01
            UUID : 2d1d58c2:23357cca:12b8e65a:a80cdebe
   Creation Time : Tue Jul 26 17:20:10 2005
      Raid Level : raid5
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 0

     Update Time : Tue Feb 21 07:47:51 2006
           State : active
Active Devices : 5
Working Devices : 5
Failed Devices : 0
   Spare Devices : 0
        Checksum : 49c0be2c - correct
          Events : 0.698097

          Layout : left-symmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     3      34       65        3      active sync   /dev/hdh1

    0     0      33        1        0      active sync   /dev/hde1
    1     1      33       65        1      active sync   /dev/hdf1
    2     2      34        1        2      active sync   /dev/hdg1
    3     3      34       65        3      active sync   /dev/hdh1
    4     4      22        1        4      active sync   /dev/hdc1


/dev/hdg1:
           Magic : a92b4efc
         Version : 00.90.01
            UUID : 2d1d58c2:23357cca:12b8e65a:a80cdebe
   Creation Time : Tue Jul 26 17:20:10 2005
      Raid Level : raid5
    Raid Devices : 5
   Total Devices : 4
Preferred Minor : 0

     Update Time : Sun Apr 16 09:10:28 2006
           State : clean
Active Devices : 3
Working Devices : 3
Failed Devices : 3
   Spare Devices : 0
        Checksum : 4a150771 - correct
          Events : 0.777535

          Layout : left-symmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     2      34        1        2      active sync   /dev/hdg1

    0     0      33        1        0      active sync   /dev/hde1
    1     1       0        0        1      faulty removed
    2     2      34        1        2      active sync   /dev/hdg1
    3     3       0        0        3      faulty removed
    4     4      22        1        4      active sync   /dev/hdc1




