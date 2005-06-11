From: "Diego M. Vadell" <dvadell@lantech.com.ar>
Subject: sata_nv and RAID1
Date: Sat, 11 Jun 2005 16:13:42 +0000
Message-ID: <200506111613.42962.dvadell@lantech.com.ar>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
   A new computer arrived at work with 4 160GB SATA disks. I made a
couple of RAID 1 (mirror) with two disks each, and then joined them wih
LVM. Now I have 320GB in my root volume.

My boss asked me to test it, so we all gathered and unplugged the data
cable of one of the disks. I was hoping to see linux making warnings for
some seconds, then giving up and running a degraded raid, but it just
hang, repeating disk errors about the just-removed disk:

Jun  9 20:29:24 localhost kernel:  disk 1, wo:0, o:1, dev:sdd2
Jun  9 20:29:55 localhost kernel: nv_sata: Primary device removed
Jun  9 20:30:25 localhost kernel: ata3: command 0x35 timeout, stat 0xd0
host_stat 0x41
Jun  9 20:30:25 localhost kernel: ata3: status=0xd0 { Busy }
Jun  9 20:30:25 localhost kernel: ata3: called with no error (D0)!
Jun  9 20:30:25 localhost kernel: scsi2: ERROR on channel 0, id 0, lun
0, CDB: Write (10) 00 12 a1 89 e1 00 00 08 00
Jun  9 20:30:25 localhost kernel: Current sdc: sense key Medium Error
Jun  9 20:30:25 localhost kernel: Additional sense: Write error - auto
reallocation failed
Jun  9 20:30:25 localhost kernel: end_request: I/O error, dev sdc,
sector 312576481
Jun  9 20:30:25 localhost kernel: ATA: abnormal status 0xD0 on port 0x9E7
Jun  9 20:30:25 localhost last message repeated 2 times
Jun  9 20:30:55 localhost kernel: ata3: command 0x35 timeout, stat 0xd0
host_stat 0x41
Jun  9 20:30:55 localhost kernel: ata3: status=0xd0 { Busy }
Jun  9 20:40:59 localhost kernel: ata3: called with no error (D0)!
Jun  9 20:40:59 localhost kernel: scsi2: ERROR on channel 0, id 0, lun
0, CDB: Write (10) 00 12 a1 89 e2 00 00 07 00
Jun  9 20:40:59 localhost crond(pam_unix)[5681]: session opened for user
root by (uid=0)
Jun  9 20:40:59 localhost kernel: Current sdc: sense key Medium Error
Jun  9 20:40:59 localhost kernel: Additional sense: Write error - auto
reallocation failed
Jun  9 20:40:59 localhost kernel: end_request: I/O error, dev sdc,
sector 312576482
Jun  9 20:40:59 localhost crond(pam_unix)[5687]: session opened for user
root by (uid=0)
Jun  9 20:40:59 localhost kernel: ATA: abnormal status 0xD0 on port 0x9E7
Jun  9 20:40:59 localhost crond(pam_unix)[5680]: session opened for user
root by (uid=0)
Jun  9 20:40:59 localhost kernel: ATA: abnormal status 0xD0 on port 0x9E7
Jun  9 20:40:59 localhost kernel: ATA: abnormal status 0xD0 on port 0x9E7
Jun  9 20:40:59 localhost kernel: ata3: command 0x35 timeout, stat 0xd0
host_stat 0x41


It can stay forever giving this errors, and it wont timeout and run in
degraded mode. Does anybody knows why? 

I read somewhere that if the lower layer (the sata_nv here) retries forever 
when it finds it has no comunication with the disk, it will never report that 
to the md layer, and that maybe what is happening. But Im just a newbie and I 
dont know if it can be applied here.

Some more configuration follow. 

Thanks in advance,
 -- Diego.

-------------------------------------------------------

[root@localhost ~]# cat /etc/redhat-release
CentOS release 4.0 (Final)

-------------------------------------------------------

[root@localhost ~]# uname -a
Linux localhost.localdomain 2.6.9-5.0.3.EL #1 Sat Feb 19 15:25:58 CST 2005 
x86_64 x86_64 x86_64 GNU/Linux

-------------------------------------------------------

[root@localhost ~]# lspci
00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller
(rev a3)
00:01.0 ISA bridge: nVidia Corporation: Unknown device 0050 (rev a3)
00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3)
00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97
Audio Controller (rev a2)
00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev a2)
00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller
(rev a3)
00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller
(rev a3)
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2)
00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
05:06.0 VGA compatible controller: Silicon Integrated Systems [SiS]
86C326 5598/6326 (rev 0b)
05:0b.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A
IEEE-1394a-2000 Controller (PHY/Link)

-------------------------------------------------------
lsmod (edited)

dm_snapshot            17833  0
dm_zero                 2753  0
dm_mirror              26105  2
ext3                  139473  2
jbd                    86897  1 ext3
raid1                  24129  3
dm_mod                 65449  5 dm_snapshot,dm_zero,dm_mirror
sata_nv                10565  8
libata                 49481  1 sata_nv
sd_mod                 19265  12
scsi_mod              150449  2 libata,sd_mod
-------------------------------------------------------

[root@localhost ~]# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sdb2[1] sda2[0]
      156023168 blocks [2/2] [UU]

md2 : active raid1 sdd2[1] sdc2[0]
      156023168 blocks [2/2] [UU]

md0 : active raid1 sdd1[3] sdc1[2] sdb1[1] sda1[0]
      264960 blocks [4/4] [UUUU]

unused devices: <none>
-------------------------------------------------------
[root@localhost ~]# mdadm -D /dev/md[012]
/dev/md0:
        Version : 00.90.01
  Creation Time : Thu Jun  9 17:06:18 2005
     Raid Level : raid1
     Array Size : 264960 (258.75 MiB 271.32 MB)
    Device Size : 264960 (258.75 MiB 271.32 MB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sat Jun 11 15:12:21 2005
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
           UUID : 07c4b1ae:ca3db1d6:7833754b:22e5b3f0
         Events : 0.126
/dev/md1:
        Version : 00.90.01
  Creation Time : Thu Jun  9 12:05:46 2005
     Raid Level : raid1
     Array Size : 156023168 (148.80 GiB 159.77 GB)
    Device Size : 156023168 (148.80 GiB 159.77 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Sat Jun 11 15:21:36 2005
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
           UUID : e20bcfe0:17084c56:11607a12:cacafc30
         Events : 0.17840
/dev/md2:
        Version : 00.90.01
  Creation Time : Thu Jun  9 12:05:46 2005
     Raid Level : raid1
     Array Size : 156023168 (148.80 GiB 159.77 GB)
    Device Size : 156023168 (148.80 GiB 159.77 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Sat Jun 11 15:20:36 2005
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       8       34        0      active sync   /dev/sdc2
       1       8       50        1      active sync   /dev/sdd2
           UUID : 668b1447:f95d147b:8c8013e2:c6b1a724
         Events : 0.10631

-------------------------------------------------------
dmesg (edited)
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-CK804: IDE controller at PCI slot 0000:00:06.0
NFORCE-CK804: chipset revision 162
NFORCE-CK804: not 100% native mode: will probe irqs later
NFORCE-CK804: 0000:00:06.0 (rev a2) UDMA133 controller
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hdb: SAMSUNG CD-ROM SC-152G, ATAPI CD/DVD-ROM drive
Using cfq io scheduler
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
Probing IDE interface ide1...
Probing IDE interface ide2...
ide2: Wait for ready failed before probe !
Probing IDE interface ide3...
ide3: Wait for ready failed before probe !
Probing IDE interface ide4...
ide4: Wait for ready failed before probe !
Probing IDE interface ide5...
ide5: Wait for ready failed before probe !
hdb: ATAPI 52X CD-ROM drive, 128kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
usbcore: registered new driver hiddev
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.0:USB HID core driver
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard on isa0060/serio0
input: ImPS/2 Generic Wheel Mouse on isa0060/serio1
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
SCSI subsystem initialized
libata version 1.02 loaded.
sata_nv version 0.03
ACPI: PCI interrupt 0000:00:07.0[A] -> GSI 23 (level, low) -> IRQ 177
PCI: Setting latency timer of device 0000:00:07.0 to 64
ata1: SATA max UDMA/133 cmd 0x9F0 ctl 0xBF2 bmdma 0xD800 irq 177
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xB72 bmdma 0xD808 irq 177
ata1: dev 0 cfg 49:2f00 82:346b 83:7f01 84:4003 85:3c69 86:3c01 87:4003 
88:40ff
ata1: dev 0 ATA, max UDMA7, 312581808 sectors: lba48
nv_sata: Primary device added
nv_sata: Primary device removed
nv_sata: Secondary device added
nv_sata: Secondary device removed
ata1: dev 0 configured for UDMA/133
scsi0 : sata_nv
ata2: dev 0 cfg 49:2f00 82:346b 83:7f01 84:4003 85:3c69 86:3c01 87:4003 
88:40ff
ata2: dev 0 ATA, max UDMA7, 312581808 sectors: lba48
nv_sata: Primary device added
nv_sata: Primary device removed
nv_sata: Secondary device added
nv_sata: Secondary device removed
ata2: dev 0 configured for UDMA/133
scsi1 : sata_nv
  Vendor: ATA       Model: SAMSUNG SP1614C   Rev: SW10
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
SCSI device sda: drive cache: write back
 sda:<4>nv_sata: Primary device added
nv_sata: Primary device removed
nv_sata: Secondary device added
nv_sata: Secondary device removed
nv_sata: Primary device added
nv_sata: Primary device removed
nv_sata: Secondary device added
nv_sata: Secondary device removed
 sda1 sda2
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
  Vendor: ATA       Model: SAMSUNG SP1614C   Rev: SW10
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
SCSI device sdb: drive cache: write back
 sdb:<4>nv_sata: Primary device added
nv_sata: Primary device removed
nv_sata: Secondary device added
nv_sata: Secondary device removed
nv_sata: Primary device added
nv_sata: Primary device removed
nv_sata: Secondary device added
nv_sata: Secondary device removed
 sdb1 sdb2
Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
ACPI: PCI interrupt 0000:00:08.0[A] -> GSI 22 (level, low) -> IRQ 185
PCI: Setting latency timer of device 0000:00:08.0 to 64
ata3: SATA max UDMA/133 cmd 0x9E0 ctl 0xBE2 bmdma 0xC400 irq 185
ata4: SATA max UDMA/133 cmd 0x960 ctl 0xB62 bmdma 0xC408 irq 185
ata3: dev 0 cfg 49:2f00 82:346b 83:7f01 84:4003 85:3c69 86:3c01 87:4003 
88:40ff
ata3: dev 0 ATA, max UDMA7, 312581808 sectors: lba48
nv_sata: Primary device added
nv_sata: Primary device removed
nv_sata: Secondary device added
nv_sata: Secondary device removed
ata3: dev 0 configured for UDMA/133
scsi2 : sata_nv
ata4: dev 0 cfg 49:2f00 82:346b 83:7f21 84:4003 85:3469 86:3c01 87:4003 
88:003f
ata4: dev 0 ATA, max UDMA/100, 312581808 sectors: lba48
nv_sata: Primary device added
nv_sata: Primary device removed
nv_sata: Secondary device added
nv_sata: Secondary device removed
ata4: dev 0 configured for UDMA/100
scsi3 : sata_nv
  Vendor: ATA       Model: SAMSUNG SP1614C   Rev: SW10
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdc: 312581808 512-byte hdwr sectors (160042 MB)
SCSI device sdc: drive cache: write back
 sdc:<4>nv_sata: Primary device added
nv_sata: Primary device removed
nv_sata: Secondary device added
nv_sata: Secondary device removed
nv_sata: Primary device added
nv_sata: Primary device removed
nv_sata: Secondary device added
nv_sata: Secondary device removed
 sdc1 sdc2
Attached scsi disk sdc at scsi2, channel 0, id 0, lun 0
  Vendor: ATA       Model: WDC WD1600JD-00G  Rev: 02.0
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdd: 312581808 512-byte hdwr sectors (160042 MB)
SCSI device sdd: drive cache: write back
 sdd:<4>nv_sata: Primary device added
nv_sata: Primary device removed
nv_sata: Secondary device added
nv_sata: Secondary device removed
nv_sata: Primary device added
nv_sata: Primary device removed
nv_sata: Secondary device added
nv_sata: Secondary device removed
 sdd1 sdd2
Attached scsi disk sdd at scsi3, channel 0, id 0, lun 0
device-mapper: 4.1.0-ioctl (2003-12-10) initialised: dm@uk.sistina.com
md: raid1 personality registered as nr 3
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdd2 ...
md:  adding sdd2 ...
md: sdd1 has different UUID to sdd2
md:  adding sdc2 ...
md: sdc1 has different UUID to sdd2
md: sdb2 has different UUID to sdd2
md: sdb1 has different UUID to sdd2
md: sda2 has different UUID to sdd2
md: sda1 has different UUID to sdd2
md: created md2
md: bind<sdc2>
md: bind<sdd2>
md: running: <sdd2><sdc2>
raid1: raid set md2 active with 2 out of 2 mirrors
md: considering sdd1 ...
md:  adding sdd1 ...
md:  adding sdc1 ...
md: sdb2 has different UUID to sdd1
md:  adding sdb1 ...
md: sda2 has different UUID to sdd1
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb1>
md: bind<sdc1>
md: bind<sdd1>
md: running: <sdd1><sdc1><sdb1><sda1>
raid1: raid set md0 active with 4 out of 4 mirrors
md: considering sdb2 ...
md:  adding sdb2 ...
md:  adding sda2 ...
md: created md1
md: bind<sda2>
md: bind<sdb2>
md: running: <sdb2><sda2>
raid1: raid set md1 active with 2 out of 2 mirrors
md: ... autorun DONE.
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.

----------------------------------------------------------

More in /var/log/messages
Jun  9 20:29:24 localhost kernel:  disk 1, wo:0, o:1, dev:sdd2
Jun  9 20:29:55 localhost kernel: nv_sata: Primary device removed
Jun  9 20:30:25 localhost kernel: ata3: command 0x35 timeout, stat 0xd0
host_stat 0x41
Jun  9 20:30:25 localhost kernel: ata3: status=0xd0 { Busy }
Jun  9 20:30:25 localhost kernel: ata3: called with no error (D0)!
Jun  9 20:30:25 localhost kernel: scsi2: ERROR on channel 0, id 0, lun
0, CDB: Write (10) 00 12 a1 89 e1 00 00 08 00
Jun  9 20:30:25 localhost kernel: Current sdc: sense key Medium Error
Jun  9 20:30:25 localhost kernel: Additional sense: Write error - auto
reallocation failed
Jun  9 20:30:25 localhost kernel: end_request: I/O error, dev sdc,
sector 312576481
Jun  9 20:30:25 localhost kernel: ATA: abnormal status 0xD0 on port 0x9E7
Jun  9 20:30:25 localhost last message repeated 2 times
Jun  9 20:30:55 localhost kernel: ata3: command 0x35 timeout, stat 0xd0
host_stat 0x41
Jun  9 20:30:55 localhost kernel: ata3: status=0xd0 { Busy }
Jun  9 20:40:59 localhost kernel: ata3: called with no error (D0)!
Jun  9 20:40:59 localhost crond(pam_unix)[5686]: session opened for user
root by (uid=0)
Jun  9 20:40:59 localhost crond(pam_unix)[5685]: session opened for user
root by (uid=0)
Jun  9 20:40:59 localhost kernel: scsi2: ERROR on channel 0, id 0, lun
0, CDB: Write (10) 00 12 a1 89 e2 00 00 07 00
Jun  9 20:40:59 localhost crond(pam_unix)[5681]: session opened for user
root by (uid=0)
Jun  9 20:40:59 localhost kernel: Current sdc: sense key Medium Error
Jun  9 20:40:59 localhost kernel: Additional sense: Write error - auto
reallocation failed
Jun  9 20:40:59 localhost kernel: end_request: I/O error, dev sdc,
sector 312576482
Jun  9 20:40:59 localhost crond(pam_unix)[5687]: session opened for user
root by (uid=0)
Jun  9 20:40:59 localhost kernel: ATA: abnormal status 0xD0 on port 0x9E7
Jun  9 20:40:59 localhost crond(pam_unix)[5680]: session opened for user
root by (uid=0)
Jun  9 20:40:59 localhost kernel: ATA: abnormal status 0xD0 on port 0x9E7
Jun  9 20:40:59 localhost kernel: ATA: abnormal status 0xD0 on port 0x9E7
Jun  9 20:40:59 localhost kernel: ata3: command 0x35 timeout, stat 0xd0
host_stat 0x41
Jun  9 20:40:59 localhost kernel: ata3: status=0xd0 { Busy }
Jun  9 20:40:59 localhost kernel: ata3: called with no error (D0)!
Jun  9 20:40:59 localhost kernel: scsi2: ERROR on channel 0, id 0, lun
0, CDB: Write (10) 00 12 a1 89 e3 00 00 06 00
Jun  9 20:40:59 localhost kernel: Current sdc: sense key Medium Error
Jun  9 20:40:59 localhost kernel: Additional sense: Write error - auto
reallocation failed
Jun  9 20:40:59 localhost kernel: end_request: I/O error, dev sdc,
sector 312576483
