From: "Tom Fojta" <tj21@post.cz>
Subject: RAID5 starts degraded after reboot
Date: Tue, 18 Sep 2007 16:47:39 +0200
Message-ID: <NCBBJOOHGLJMMINKAGGBCEAMHFAB.tj21@post.cz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I have created a 3 drive RAID5 array, but after each reboot it starts
degraded with only 1 drive. It also changes the UUID of that drive. I have
to manualy stop the array and force create it. I've seen similar problems in
the archives but still have not found solution.

Here are my details:

My machine runs Debian 4.0 with 2.6.18-5-686 #1 SMP kernel. I have 4 drive
controllers. One onboard IDE, one SCSI and two identical two port SATA
controllers. The root is on /dev/sda1 SCSI drive. Drives /dev/sdb, /dev/sdc
and /dev/sdd are used for the RAID5 array.

# fdisk -l

Disk /dev/sda: 9139 MB, 9139200000 bytes
255 heads, 63 sectors/track, 1111 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1         985     7911981   83  Linux
/dev/sda2             986        1111     1012095   82  Linux swap / Solaris

Disk /dev/sdb: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       60801   488384001   fd  Linux raid
autodetect

Disk /dev/sdc: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       60801   488384032   fd  Linux raid
autodetect

Disk /dev/sdd: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       60801   488384001   fd  Linux raid
autodetect

Disk /dev/hdc: 300.0 GB, 300069052416 bytes
255 heads, 63 sectors/track, 36481 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hdc1               1       36481   293033601   83  Linux

Disk /dev/md0: 1000.2 GB, 1000210300928 bytes
2 heads, 4 sectors/track, 244191968 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

Disk /dev/md0 doesn't contain a valid partition table



# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Tue Sep 18 08:58:19 2007
     Raid Level : raid5
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
    Device Size : 488383936 (465.76 GiB 500.11 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Sep 18 09:35:29 2007
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 72591f57:6d449586:dc3c5ed4:95c964aa
         Events : 0.2

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1


The file /etc/mdadm/mdadm.conf has these two lines:

DEVICES /dev/sdb1 /dev/sdc1 /dev/sdd1
ARRAY /dev/md0 level=raid5 num-devices=3
UUID=72591f57:6d449586:dc3c5ed4:95c964aa
devices=/dev/sdb1,/dev/sdc1,/dev/sdd1

After reboot I see this:

# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Tue Sep 18 08:58:19 2007
     Raid Level : raid5
    Device Size : 488383936 (465.76 GiB 500.11 GB)
   Raid Devices : 3
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Sep 18 16:30:01 2007
          State : active, degraded, Not Started
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 72591f57:6d449586:b90eefda:5c4888bb
         Events : 0.4

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       0        0        1      removed
       2       8       49        2      active sync   /dev/sdd1

# mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 72591f57:6d449586:dc3c5ed4:95c964aa
  Creation Time : Tue Sep 18 08:58:19 2007
     Raid Level : raid5
    Device Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Tue Sep 18 16:30:01 2007
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : a5cb4636 - correct
         Events : 0.4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1

# mdadm --examine /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 72591f57:6d449586:dc3c5ed4:95c964aa
  Creation Time : Tue Sep 18 08:58:19 2007
     Raid Level : raid5
    Device Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Tue Sep 18 16:30:01 2007
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : a5cb4648 - correct
         Events : 0.4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   /dev/sdc1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1

So the md0 array was started only with partition /dev/sdd1 and the last 64
bits of the UUID were changed. The partitions /dev/sdb1 and /dev/sdd1 keep
the original UUID.

Here is part of the dmesg:

scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec aic7895 Ultra SCSI adapter>
        aic7895C: Ultra Wide Channel A, SCSI Id=7, 32/253 SCBs

  Vendor: IBM       Model: DDRS-39130D       Rev: DC1B
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi0:A:6:0: Tagged Queuing enabled.  Depth 8
 target0:0:6: Beginning Domain Validation
 target0:0:6: wide asynchronous
 target0:0:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 8)
 target0:0:6: Domain Validation skipping write tests
 target0:0:6: Ending Domain Validation
ACPI: PCI Interrupt 0000:00:05.1[B] -> GSI 18 (level, low) -> IRQ 177
ahc_pci:0:5:1: Host Adapter Bios disabled.  Using default SCSI device
parameters
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec aic7895 Ultra SCSI adapter>
        aic7895C: Ultra Wide Channel B, SCSI Id=7, 32/253 SCBs

libata version 2.00 loaded.
sata_sil 0000:00:09.0: version 2.0
ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 185
ata1: SATA max UDMA/100 cmd 0xE083A080 ctl 0xE083A08A bmdma 0xE083A000 irq
185
ata2: SATA max UDMA/100 cmd 0xE083A0C0 ctl 0xE083A0CA bmdma 0xE083A008 irq
185
scsi2 : sata_sil
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-7, max UDMA/133, 976773168 sectors: LBA48 NCQ (depth 0/32)
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/100
scsi3 : sata_sil
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata2.00: ATA-7, max UDMA/133, 976773168 sectors: LBA48 NCQ (depth 0/32)
ata2.00: ata2: dev 0 multi count 16
ata2.00: configured for UDMA/100
  Vendor: ATA       Model: WDC WD5000ABYS-0  Rev: 12.0
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: WDC WD5000ABYS-0  Rev: 12.0
  Type:   Direct-Access                      ANSI SCSI revision: 05
ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 16 (level, low) -> IRQ 193
ata3: SATA max UDMA/100 cmd 0xE085C480 ctl 0xE085C48A bmdma 0xE085C400 irq
193
ata4: SATA max UDMA/100 cmd 0xE085C4C0 ctl 0xE085C4CA bmdma 0xE085C408 irq
193
scsi4 : sata_sil
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: ATA-7, max UDMA/133, 976773168 sectors: LBA48 NCQ (depth 0/32)
ata3.00: ata3: dev 0 multi count 16
ata3.00: configured for UDMA/100
scsi5 : sata_sil
ata4: SATA link down (SStatus 0 SControl 310)
  Vendor: ATA       Model: ST3500630AS       Rev: 3.AA
  Type:   Direct-Access                      ANSI SCSI revision: 05
 target0:0:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 8)
SCSI device sda: 17850000 512-byte hdwr sectors (9139 MB)
sda: Write Protect is off
sda: Mode Sense: b9 00 00 08
SCSI device sda: drive cache: write back
SCSI device sda: 17850000 512-byte hdwr sectors (9139 MB)
sda: Write Protect is off
sda: Mode Sense: b9 00 00 08
SCSI device sda: drive cache: write back
 sda: sda1 sda2
sd 0:0:6:0: Attached scsi disk sda
SCSI device sdb: 976773168 512-byte hdwr sectors (500108 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
SCSI device sdb: 976773168 512-byte hdwr sectors (500108 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
 sdb:<6>usbcore: registered new driver usbfs
usbcore: registered new driver hub
 sdb1
sd 2:0:0:0: Attached scsi disk sdb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:04.2[D] -> GSI 19 (level, low) -> IRQ 201
uhci_hcd 0000:00:04.2: UHCI Host Controller
uhci_hcd 0000:00:04.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:04.2: irq 201, io base 0x00001840
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
SCSI device sdc: 976773168 512-byte hdwr sectors (500108 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
SCSI device sdc: 976773168 512-byte hdwr sectors (500108 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
 sdc:<6>Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
 sdc1
sd 3:0:0:0: Attached scsi disk sdc
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: drive cache: write back
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: drive cache: write back
 sdd: sdd1
sd 4:0:0:0: Attached scsi disk sdd
e100: Intel(R) PRO/100 Network Driver, 3.5.10-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
PIIX4: IDE controller at PCI slot 0000:00:04.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1860-0x1867, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0x1868-0x186f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
Probing IDE interface ide1...
hdc: ST3300622A, ATA DISK drive
ide1 at 0x170-0x177,0x376 on irq 15
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 19 (level, low) -> IRQ 201
e100: eth0: e100_probe: addr 0xfc102000, irq 201, MAC addr 00:E0:18:C2:F2:B0
hdc: max request size: 512KiB
hdc: 586072368 sectors (300069 MB) w/16384KiB Cache, CHS=36481/255/63,
UDMA(33)
hdc: cache flushes supported
 hdc: hdc1
raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :   988.000 MB/sec
raid5: using function: pIII_sse (988.000 MB/sec)
md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 4.39
raid6: int32x1    109 MB/s
raid6: int32x2    106 MB/s
raid6: int32x4    123 MB/s
raid6: int32x8    121 MB/s
raid6: mmxx1      284 MB/s
raid6: mmxx2      326 MB/s
raid6: sse1x1     245 MB/s
raid6: sse1x2     309 MB/s
raid6: using algorithm sse1x2 (309 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: md0 stopped.
md: bind<sdd1>
raid5: device sdd1 operational as raid disk 2
raid5: not enough operational devices for md0 (2/3 failed)
RAID5 conf printout:
 --- rd:3 wd:1 fd:2
 disk 2, o:1, dev:sdd1
raid5: failed to run raid set md0
md: pers->run() failed ...
Attempting manual resume


So now I have to stop the array and recreate it:

# mdadm --stop /dev/md0
mdadm: stopped /dev/md0

# mdadm --create /dev/md0 --assume-clean --level=5 --raid-devices=3
/dev/sdb1 /dev/sdc1 /dev/sdd1
mdadm: /dev/sdb1 appears to be part of a raid array:
    level=raid5 devices=3 ctime=Tue Sep 18 08:58:19 2007
mdadm: /dev/sdc1 appears to be part of a raid array:
    level=raid5 devices=3 ctime=Tue Sep 18 08:58:19 2007
mdadm: /dev/sdd1 appears to be part of a raid array:
    level=raid5 devices=3 ctime=Tue Sep 18 08:58:19 2007
Continue creating array? y
mdadm: array /dev/md0 started.

And it is working fine (with new UUID):

# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Tue Sep 18 16:42:09 2007
     Raid Level : raid5
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
    Device Size : 488383936 (465.76 GiB 500.11 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Sep 18 16:42:09 2007
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : e3419c0a:59994dc9:bcdcb2cf:6e8e5621
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1


Any suggestion why it starts with two failed disks after the reboot? Why it
changes the UUID?

Thanks for any help.

Tomas

