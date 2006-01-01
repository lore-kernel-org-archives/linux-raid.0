From: Matt Darcy <kernel-lists@projecthugo.co.uk>
Subject: 2.6.15-rc5-mm3 sata_mv raid5 array failure to start
Date: Sun, 01 Jan 2006 19:27:30 +0000
Message-ID: <43B82D22.7080705@projecthugo.co.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080200020308010406040907"
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080200020308010406040907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello all,

I am still persisting with my quest for a usable sata_mv driver.

The 2.5.15-rc5-m3 kernel appear to have been good to me.

Before I attempt moving to later releases of the 2.6.15 tree I thought 
I'd get feedback from the people in the know

This is an intentional cross-post as I'm not %100 sure if the problems 
sits in the raid error or the actual libata/driver area (more probable)

I have 7 SATA disks hanging of an 8 port controller which uses the 
sata_mv driver.

I create a raid 5 array consisting of 6 disks (using 1 full disk 
partition) and 1 spare

The array builds fine - although it takes 300 minutes so its not a quick 
process to run through tests.


md6 : active raid5 sdh[5] sdi[6](S) sdg[4] sdf[3] sde[2] sdd[1] sdc[0]
      1225586560 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]


as you can see, all looking good. sdi is marked as the spare./dev/md6:
        Version : 00.90.03
  Creation Time : Sat Dec 31 16:23:11 2005
     Raid Level : raid5
     Array Size : 1225586560 (1168.81 GiB 1255.00 GB)
    Device Size : 245117312 (233.76 GiB 251.00 GB)
   Raid Devices : 6
  Total Devices : 7
Preferred Minor : 6
    Persistence : Superblock is persistent

    Update Time : Sat Dec 31 22:04:56 2005
          State : clean
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : f92fa512:1fe54278:d3ba820f:cecb842a
         Events : 0.2

    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc
       1       8       48        1      active sync   /dev/sdd
       2       8       64        2      active sync   /dev/sde
       3       8       80        3      active sync   /dev/sdf
       4       8       96        4      active sync   /dev/sdg
       5       8      112        5      active sync   /dev/sdh

       6       8      128        -      spare   /dev/sdi




I've played around with this large md, using lvm2, and as a flat 
filesystem, it performs well, interacts well, seems solid and stable. 
I'm pretty pleased with it.

When I reboot however, the md6 device fails to start

when I look into this its because only 2 devices are showing as usable 
for the array, so not enough to start the raid 5 array.

However when I actually look all the devices are physically there and I 
can interact with them as seperate disks, fdisk them, format them etc etc.

On close inspection, it appears that although the devices are there, 
raid subsystem finds reasons not to use them. I've attatched the syslog 
so you can see for yourself as its quite a long post to put in the body 
of this message.

I understand why the array is not starting, however I don't understand 
why the disks are not forming into the raid array.

even now, I can't start the array manually, however, if I issue the 
create array command again now, it builds a perfect array and the loop 
starts again.

I've followed a lot of changed in the 2.6.15-rc7 branch, but I thought 
I'd get input before blindly upgrading.

Matt



--------------080200020308010406040907
Content-Type: text/plain;
 name="sys.log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sys.log.txt"

Jan  1 16:58:31 berger shutdown[3363]: shutting down for system reboot
Jan  1 16:58:32 berger init: Switching to runlevel: 6
Jan  1 16:58:33 berger fcron[2338]: SIGTERM signal received
Jan  1 16:58:33 berger fcron[2338]: Exiting with code 0
Jan  1 16:58:34 berger bootlog:  Stopping fcron...[  OK  ]
Jan  1 16:58:35 berger bootlog:  Stopping gpm...[  OK  ]
Jan  1 16:58:36 berger bootlog:  Stopping exim...[  OK  ]
Jan  1 16:58:40 berger bootlog:  Stopping MySQL daemon...[  OK  ]
Jan  1 16:58:41 berger bootlog:  Stopping PostgreSQL daemon...[  OK  ]
Jan  1 16:58:42 berger bootlog:  Stopping vsFTPD Server...[  OK  ]
Jan  1 16:58:43 berger bootlog:  Stopping SSH Server...[  OK  ]
Jan  1 16:58:43 berger bootlog:  Saving random seed...[  OK  ]
Jan  1 16:58:43 berger ntpd_initres[2716]: ntpd exiting on signal 15
Jan  1 16:58:44 berger ntpd[2241]: ntpd exiting on signal 15
Jan  1 16:58:45 berger bootlog:  Stopping ntpd...[  OK  ]
Jan  1 16:58:47 berger bootlog:  Setting hardware clock...[  OK  ]
Jan  1 16:58:47 berger bootlog:  Stopping smbd...[  OK  ]
Jan  1 16:58:47 berger bootlog:  Stopping nmbd...[  OK  ]
Jan  1 16:58:48 berger bootlog:  Stopping Portmap[  OK  ]
Jan  1 16:58:48 berger bootlog:  Removing IPv4 address 10.11.216.2 from the eth2 interface...[  OK  ]
Jan  1 16:58:48 berger bootlog:  Bringing down the eth2 interface...[  OK  ]
Jan  1 16:58:48 berger bootlog:  Removing default gateway...[  OK  ]
Jan  1 16:58:48 berger bootlog:  Removing IPv4 address 81.138.64.233 from the eth1 interface...[  OK  ]
Jan  1 16:58:48 berger bootlog:  Bringing down the eth1 interface...[  OK  ]
Jan  1 16:58:48 berger kernel: Kernel logging (proc) stopped.
Jan  1 16:58:48 berger kernel: Kernel log daemon terminating.
Jan  1 16:58:50 berger bootlog:  Stopping kernel log daemon...[  OK  ]
Jan  1 16:58:50 berger exiting on signal 15
Jan  1 16:59:51 berger syslogd 1.4.1: restart.
Jan  1 16:59:51 berger bootlog:  Starting system log daemon...[  OK  ]
Jan  1 16:59:51 berger kernel: klogd 1.4.1, log source = /proc/kmsg started.
Jan  1 16:59:51 berger bootlog:  Starting kernel log daemon...[  OK  ]
Jan  1 16:59:51 berger kernel: Cannot find map file.
Jan  1 16:59:51 berger kernel: No module symbols loaded - kernel modules not enabled. 
Jan  1 16:59:51 berger kernel: 12kB Cache, UDMA(33)
Jan  1 16:59:51 berger kernel: Uniform CD-ROM driver Revision: 3.20
Jan  1 16:59:51 berger kernel: libata version 1.20 loaded.
Jan  1 16:59:51 berger kernel: sata_via 0000:00:0f.0: version 1.1
Jan  1 16:59:51 berger kernel: ACPI: PCI Interrupt 0000:00:0f.0[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Jan  1 16:59:51 berger kernel: sata_via 0000:00:0f.0: routed to hard irq line 10
Jan  1 16:59:51 berger kernel: ata1: SATA max UDMA/133 cmd 0xE200 ctl 0xE302 bmdma 0xE600 irq 10
Jan  1 16:59:51 berger kernel: ata2: SATA max UDMA/133 cmd 0xE400 ctl 0xE502 bmdma 0xE608 irq 10
Jan  1 16:59:51 berger kernel: ata1: SATA link up 1.5 Gbps (SStatus 113)
Jan  1 16:59:51 berger kernel: ata1: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 88:407f
Jan  1 16:59:51 berger kernel: ata1: dev 0 ATA-6, max UDMA/133, 156301488 sectors: LBA48
Jan  1 16:59:51 berger kernel: ata1: dev 0 configured for UDMA/133
Jan  1 16:59:51 berger kernel: scsi0 : sata_via
Jan  1 16:59:51 berger kernel: ata2: SATA link up 1.5 Gbps (SStatus 113)
Jan  1 16:59:51 berger kernel: ata2: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 88:407f
Jan  1 16:59:51 berger kernel: ata2: dev 0 ATA-6, max UDMA/133, 156301488 sectors: LBA48
Jan  1 16:59:51 berger kernel: ata2: dev 0 configured for UDMA/133
Jan  1 16:59:51 berger kernel: scsi1 : sata_via
Jan  1 16:59:51 berger kernel:   Vendor: ATA       Model: ST380817AS        Rev: 3.42
Jan  1 16:59:51 berger kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Jan  1 16:59:51 berger kernel:   Vendor: ATA       Model: ST380817AS        Rev: 3.42
Jan  1 16:59:51 berger kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Jan  1 16:59:51 berger kernel: sata_mv 0000:00:0c.0: version 0.5
Jan  1 16:59:51 berger kernel: ACPI: PCI Interrupt 0000:00:0c.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Jan  1 16:59:51 berger kernel: sata_mv 0000:00:0c.0: 32 slots 8 ports SCSI mode IRQ via INTx
Jan  1 16:59:51 berger kernel: ata3: SATA max UDMA/133 cmd 0x0 ctl 0xF8922120 bmdma 0x0 irq 11
Jan  1 16:59:51 berger kernel: ata4: SATA max UDMA/133 cmd 0x0 ctl 0xF8924120 bmdma 0x0 irq 11
Jan  1 16:59:51 berger kernel: ata5: SATA max UDMA/133 cmd 0x0 ctl 0xF8926120 bmdma 0x0 irq 11
Jan  1 16:59:51 berger kernel: ata6: SATA max UDMA/133 cmd 0x0 ctl 0xF8928120 bmdma 0x0 irq 11
Jan  1 16:59:51 berger kernel: ata7: SATA max UDMA/133 cmd 0x0 ctl 0xF8932120 bmdma 0x0 irq 11
Jan  1 16:59:51 berger kernel: ata8: SATA max UDMA/133 cmd 0x0 ctl 0xF8934120 bmdma 0x0 irq 11
Jan  1 16:59:51 berger kernel: ata9: SATA max UDMA/133 cmd 0x0 ctl 0xF8936120 bmdma 0x0 irq 11
Jan  1 16:59:51 berger kernel: ata10: SATA max UDMA/133 cmd 0x0 ctl 0xF8938120 bmdma 0x0 irq 11
Jan  1 16:59:51 berger kernel: ata3: no device found (phy stat 00000000)
Jan  1 16:59:51 berger kernel: scsi2 : sata_mv
Jan  1 16:59:51 berger kernel: ata4: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4673 85:7c69 86:3e01 87:4663 88:007f
Jan  1 16:59:51 berger kernel: ata4: dev 0 ATA-7, max UDMA/133, 490234752 sectors: LBA48
Jan  1 16:59:51 berger kernel: ata4: dev 0 configured for UDMA/133
Jan  1 16:59:51 berger kernel: scsi3 : sata_mv
Jan  1 16:59:51 berger kernel: ata5: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4773 85:7c69 86:3e01 87:4763 88:407f
Jan  1 16:59:51 berger kernel: ata5: dev 0 ATA-7, max UDMA/133, 490234752 sectors: LBA48
Jan  1 16:59:51 berger kernel: ata5: dev 0 configured for UDMA/133
Jan  1 16:59:51 berger kernel: scsi4 : sata_mv
Jan  1 16:59:51 berger kernel: ata6: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4673 85:7c69 86:3e01 87:4663 88:007f
Jan  1 16:59:51 berger kernel: ata6: dev 0 ATA-7, max UDMA/133, 490234752 sectors: LBA48
Jan  1 16:59:51 berger kernel: ata6: dev 0 configured for UDMA/133
Jan  1 16:59:51 berger kernel: scsi5 : sata_mv
Jan  1 16:59:51 berger kernel: ata7: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4773 85:7c69 86:3e01 87:4763 88:407f
Jan  1 16:59:51 berger kernel: ata7: dev 0 ATA-7, max UDMA/133, 490234752 sectors: LBA48
Jan  1 16:59:51 berger kernel: ata7: dev 0 configured for UDMA/133
Jan  1 16:59:51 berger kernel: scsi6 : sata_mv
Jan  1 16:59:51 berger kernel: ata8: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4673 85:7c69 86:3e01 87:4663 88:007f
Jan  1 16:59:51 berger kernel: ata8: dev 0 ATA-7, max UDMA/133, 490234752 sectors: LBA48
Jan  1 16:59:51 berger kernel: ata8: dev 0 configured for UDMA/133
Jan  1 16:59:51 berger kernel: scsi7 : sata_mv
Jan  1 16:59:51 berger kernel: ata9: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4673 85:7c69 86:3e01 87:4663 88:007f
Jan  1 16:59:51 berger kernel: ata9: dev 0 ATA-7, max UDMA/133, 490234752 sectors: LBA48
Jan  1 16:59:51 berger kernel: ata9: dev 0 configured for UDMA/133
Jan  1 16:59:51 berger kernel: scsi8 : sata_mv
Jan  1 16:59:51 berger kernel: ata10: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4063 85:7c69 86:3e01 87:4063 88:007f
Jan  1 16:59:51 berger kernel: ata10: dev 0 ATA-7, max UDMA/133, 490234752 sectors: LBA48
Jan  1 16:59:51 berger kernel: ata10: dev 0 configured for UDMA/133
Jan  1 16:59:51 berger kernel: scsi9 : sata_mv
Jan  1 16:59:51 berger kernel:   Vendor: ATA       Model: Maxtor 6L250S0    Rev: BANC
Jan  1 16:59:51 berger kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Jan  1 16:59:51 berger kernel:   Vendor: ATA       Model: Maxtor 6V250F0    Rev: VA11
Jan  1 16:59:51 berger kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Jan  1 16:59:51 berger kernel:   Vendor: ATA       Model: Maxtor 6L250S0    Rev: BANC
Jan  1 16:59:51 berger kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Jan  1 16:59:51 berger kernel:   Vendor: ATA       Model: Maxtor 6V250F0    Rev: VA11
Jan  1 16:59:51 berger kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Jan  1 16:59:51 berger kernel:   Vendor: ATA       Model: Maxtor 6L250S0    Rev: BANC
Jan  1 16:59:51 berger kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Jan  1 16:59:51 berger kernel:   Vendor: ATA       Model: Maxtor 6L250S0    Rev: BANC
Jan  1 16:59:51 berger kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Jan  1 16:59:51 berger kernel:   Vendor: ATA       Model: Maxtor 6L250S0    Rev: BANC
Jan  1 16:59:51 berger kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Jan  1 16:59:51 berger kernel: SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
Jan  1 16:59:51 berger kernel: SCSI device sda: drive cache: write back
Jan  1 16:59:51 berger kernel: SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
Jan  1 16:59:51 berger kernel: SCSI device sda: drive cache: write back
Jan  1 16:59:51 berger kernel:  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
Jan  1 16:59:51 berger kernel: sd 0:0:0:0: Attached scsi disk sda
Jan  1 16:59:51 berger kernel: SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
Jan  1 16:59:51 berger kernel: SCSI device sdb: drive cache: write back
Jan  1 16:59:51 berger kernel: SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
Jan  1 16:59:51 berger kernel: SCSI device sdb: drive cache: write back
Jan  1 16:59:51 berger kernel:  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 >
Jan  1 16:59:51 berger kernel: sd 1:0:0:0: Attached scsi disk sdb
Jan  1 16:59:51 berger kernel: SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)
Jan  1 16:59:51 berger kernel: SCSI device sdc: drive cache: write back
Jan  1 16:59:51 berger kernel: SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)
Jan  1 16:59:51 berger kernel: SCSI device sdc: drive cache: write back
Jan  1 16:59:51 berger kernel:  sdc: sdc1
Jan  1 16:59:51 berger kernel: sd 3:0:0:0: Attached scsi disk sdc
Jan  1 16:59:51 berger kernel: SCSI device sdd: 490234752 512-byte hdwr sectors (251000 MB)
Jan  1 16:59:51 berger kernel: SCSI device sdd: drive cache: write back
Jan  1 16:59:51 berger kernel: SCSI device sdd: 490234752 512-byte hdwr sectors (251000 MB)
Jan  1 16:59:51 berger kernel: SCSI device sdd: drive cache: write back
Jan  1 16:59:51 berger kernel:  sdd: sdd1
Jan  1 16:59:51 berger kernel: sd 4:0:0:0: Attached scsi disk sdd
Jan  1 16:59:51 berger kernel: SCSI device sde: 490234752 512-byte hdwr sectors (251000 MB)
Jan  1 16:59:51 berger kernel: SCSI device sde: drive cache: write back
Jan  1 16:59:51 berger kernel: SCSI device sde: 490234752 512-byte hdwr sectors (251000 MB)
Jan  1 16:59:51 berger kernel: SCSI device sde: drive cache: write back
Jan  1 16:59:51 berger kernel:  sde: sde1
Jan  1 16:59:51 berger kernel: sd 5:0:0:0: Attached scsi disk sde
Jan  1 16:59:51 berger kernel: SCSI device sdf: 490234752 512-byte hdwr sectors (251000 MB)
Jan  1 16:59:51 berger kernel: SCSI device sdf: drive cache: write back
Jan  1 16:59:51 berger kernel: SCSI device sdf: 490234752 512-byte hdwr sectors (251000 MB)
Jan  1 16:59:51 berger kernel: SCSI device sdf: drive cache: write back
Jan  1 16:59:51 berger kernel:  sdf: sdf1
Jan  1 16:59:51 berger kernel: sd 6:0:0:0: Attached scsi disk sdf
Jan  1 16:59:51 berger kernel: SCSI device sdg: 490234752 512-byte hdwr sectors (251000 MB)
Jan  1 16:59:51 berger kernel: SCSI device sdg: drive cache: write back
Jan  1 16:59:51 berger kernel: SCSI device sdg: 490234752 512-byte hdwr sectors (251000 MB)
Jan  1 16:59:51 berger kernel: SCSI device sdg: drive cache: write back
Jan  1 16:59:51 berger kernel:  sdg: sdg1
Jan  1 16:59:51 berger kernel: sd 7:0:0:0: Attached scsi disk sdg
Jan  1 16:59:51 berger kernel: SCSI device sdh: 490234752 512-byte hdwr sectors (251000 MB)
Jan  1 16:59:51 berger kernel: SCSI device sdh: drive cache: write back
Jan  1 16:59:51 berger kernel: SCSI device sdh: 490234752 512-byte hdwr sectors (251000 MB)
Jan  1 16:59:51 berger kernel: SCSI device sdh: drive cache: write back
Jan  1 16:59:51 berger kernel:  sdh: sdh1
Jan  1 16:59:51 berger kernel: sd 8:0:0:0: Attached scsi disk sdh
Jan  1 16:59:51 berger kernel: SCSI device sdi: 490234752 512-byte hdwr sectors (251000 MB)
Jan  1 16:59:51 berger kernel: SCSI device sdi: drive cache: write back
Jan  1 16:59:51 berger kernel: SCSI device sdi: 490234752 512-byte hdwr sectors (251000 MB)
Jan  1 16:59:51 berger kernel: SCSI device sdi: drive cache: write back
Jan  1 16:59:51 berger kernel:  sdi: sdi1
Jan  1 16:59:51 berger kernel: sd 9:0:0:0: Attached scsi disk sdi
Jan  1 16:59:51 berger kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Jan  1 16:59:51 berger kernel: sd 1:0:0:0: Attached scsi generic sg1 type 0
Jan  1 16:59:51 berger kernel: sd 3:0:0:0: Attached scsi generic sg2 type 0
Jan  1 16:59:51 berger kernel: sd 4:0:0:0: Attached scsi generic sg3 type 0
Jan  1 16:59:51 berger kernel: sd 5:0:0:0: Attached scsi generic sg4 type 0
Jan  1 16:59:51 berger kernel: sd 6:0:0:0: Attached scsi generic sg5 type 0
Jan  1 16:59:51 berger kernel: sd 7:0:0:0: Attached scsi generic sg6 type 0
Jan  1 16:59:51 berger kernel: sd 8:0:0:0: Attached scsi generic sg7 type 0
Jan  1 16:59:51 berger kernel: sd 9:0:0:0: Attached scsi generic sg8 type 0
Jan  1 16:59:51 berger kernel: usbmon: debugfs is not available
Jan  1 16:59:51 berger kernel: ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 3
Jan  1 16:59:51 berger kernel: PCI: setting IRQ 3 as level-triggered
Jan  1 16:59:51 berger kernel: ACPI: PCI Interrupt 0000:00:10.4[C] -> Link [LNKC] -> GSI 3 (level, low) -> IRQ 3
Jan  1 16:59:51 berger kernel: ehci_hcd 0000:00:10.4: EHCI Host Controller
Jan  1 16:59:51 berger kernel: ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
Jan  1 16:59:51 berger kernel: ehci_hcd 0000:00:10.4: irq 3, io mem 0xe20a1000
Jan  1 16:59:51 berger kernel: ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Jan  1 16:59:51 berger kernel: usb usb1: configuration #1 chosen from 1 choice
Jan  1 16:59:51 berger kernel: hub 1-0:1.0: USB hub found
Jan  1 16:59:51 berger kernel: hub 1-0:1.0: 8 ports detected
Jan  1 16:59:51 berger kernel: USB Universal Host Controller Interface driver v2.3
Jan  1 16:59:51 berger kernel: ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Jan  1 16:59:51 berger kernel: PCI: Via IRQ fixup for 0000:00:10.0, from 5 to 10
Jan  1 16:59:51 berger kernel: uhci_hcd 0000:00:10.0: UHCI Host Controller
Jan  1 16:59:51 berger kernel: uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
Jan  1 16:59:51 berger kernel: uhci_hcd 0000:00:10.0: irq 10, io base 0x0000e900
Jan  1 16:59:51 berger kernel: usb usb2: configuration #1 chosen from 1 choice
Jan  1 16:59:51 berger kernel: hub 2-0:1.0: USB hub found
Jan  1 16:59:51 berger kernel: hub 2-0:1.0: 2 ports detected
Jan  1 16:59:51 berger kernel: ACPI: PCI Interrupt 0000:00:10.1[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
Jan  1 16:59:51 berger kernel: PCI: Via IRQ fixup for 0000:00:10.1, from 5 to 10
Jan  1 16:59:51 berger kernel: uhci_hcd 0000:00:10.1: UHCI Host Controller
Jan  1 16:59:51 berger kernel: uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
Jan  1 16:59:51 berger kernel: uhci_hcd 0000:00:10.1: irq 10, io base 0x0000ea00
Jan  1 16:59:51 berger kernel: usb usb3: configuration #1 chosen from 1 choice
Jan  1 16:59:51 berger kernel: hub 3-0:1.0: USB hub found
Jan  1 16:59:51 berger kernel: hub 3-0:1.0: 2 ports detected
Jan  1 16:59:51 berger kernel: ACPI: PCI Interrupt 0000:00:10.2[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Jan  1 16:59:51 berger kernel: uhci_hcd 0000:00:10.2: UHCI Host Controller
Jan  1 16:59:51 berger kernel: uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
Jan  1 16:59:51 berger kernel: uhci_hcd 0000:00:10.2: irq 10, io base 0x0000eb00
Jan  1 16:59:51 berger kernel: usb usb4: configuration #1 chosen from 1 choice
Jan  1 16:59:51 berger kernel: hub 4-0:1.0: USB hub found
Jan  1 16:59:51 berger kernel: hub 4-0:1.0: 2 ports detected
Jan  1 16:59:51 berger kernel: ACPI: PCI Interrupt 0000:00:10.3[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Jan  1 16:59:51 berger kernel: uhci_hcd 0000:00:10.3: UHCI Host Controller
Jan  1 16:59:51 berger kernel: uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
Jan  1 16:59:51 berger kernel: uhci_hcd 0000:00:10.3: irq 10, io base 0x0000ec00
Jan  1 16:59:51 berger kernel: usb usb5: configuration #1 chosen from 1 choice
Jan  1 16:59:51 berger kernel: hub 5-0:1.0: USB hub found
Jan  1 16:59:51 berger kernel: hub 5-0:1.0: 2 ports detected
Jan  1 16:59:51 berger kernel: usbcore: registered new driver usblp
Jan  1 16:59:51 berger kernel: drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Jan  1 16:59:51 berger kernel: Initializing USB Mass Storage driver...
Jan  1 16:59:51 berger kernel: usbcore: registered new driver usb-storage
Jan  1 16:59:51 berger kernel: USB Mass Storage support registered.
Jan  1 16:59:51 berger kernel: usbcore: registered new driver usbhid
Jan  1 16:59:51 berger kernel: drivers/usb/input/hid-core.c: v2.6:USB HID core driver
Jan  1 16:59:51 berger kernel: md: linear personality registered for level -1
Jan  1 16:59:51 berger kernel: md: raid0 personality registered for level 0
Jan  1 16:59:51 berger kernel: md: raid1 personality registered for level 1
Jan  1 16:59:51 berger kernel: md: raid5 personality registered for level 5
Jan  1 16:59:51 berger kernel: md: raid4 personality registered for level 4
Jan  1 16:59:51 berger kernel: raid5: automatically using best checksumming function: pIII_sse
Jan  1 16:59:51 berger kernel:    pIII_sse  :  4865.000 MB/sec
Jan  1 16:59:51 berger kernel: raid5: using function: pIII_sse (4865.000 MB/sec)
Jan  1 16:59:51 berger kernel: md: faulty personality registered for level -5
Jan  1 16:59:51 berger kernel: md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
Jan  1 16:59:51 berger kernel: md: bitmap version 4.39
Jan  1 16:59:51 berger kernel: device-mapper: 4.5.0-ioctl (2005-10-04) initialised: dm-devel@redhat.com
Jan  1 16:59:51 berger kernel: MC: drivers/edac/edac_mc.c version MC $Revision: 1.4.2.10 $
Jan  1 16:59:51 berger kernel: NET: Registered protocol family 2
Jan  1 16:59:51 berger kernel: IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Jan  1 16:59:51 berger kernel: TCP established hash table entries: 131072 (order: 7, 524288 bytes)
Jan  1 16:59:51 berger kernel: TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
Jan  1 16:59:51 berger kernel: TCP: Hash tables configured (established 131072 bind 65536)
Jan  1 16:59:51 berger kernel: TCP reno registered
Jan  1 16:59:51 berger kernel: ip_conntrack version 2.4 (8183 buckets, 65464 max) - 232 bytes per conntrack
Jan  1 16:59:51 berger kernel: ip_conntrack_pptp version 3.1 loaded
Jan  1 16:59:51 berger kernel: ip_tables: (C) 2000-2002 Netfilter core team
Jan  1 16:59:51 berger kernel: ipt_recent v0.3.1: Stephen Frost <sfrost@snowman.net>.  http://snowman.net/projects/ipt_recent/
Jan  1 16:59:51 berger kernel: arp_tables: (C) 2002 David S. Miller
Jan  1 16:59:51 berger kernel: TCP bic registered
Jan  1 16:59:51 berger kernel: NET: Registered protocol family 1
Jan  1 16:59:51 berger kernel: NET: Registered protocol family 17
Jan  1 16:59:51 berger kernel: Using IPI Shortcut mode
Jan  1 16:59:51 berger kernel: ACPI wakeup devices: 
Jan  1 16:59:51 berger kernel: SLPB PCI0 USB3 USB4 USB5 USB6 USB7 LAN0 UAR1 ECP1 
Jan  1 16:59:51 berger kernel: ACPI: (supports S0 S1 S4 S5)
Jan  1 16:59:51 berger kernel: md: Autodetecting RAID arrays.
Jan  1 16:59:51 berger kernel: md: invalid superblock checksum on sdh1
Jan  1 16:59:51 berger kernel: md: sdh1 has invalid sb, not importing!
Jan  1 16:59:51 berger kernel: md: autorun ...
Jan  1 16:59:51 berger kernel: md: considering sdi1 ...
Jan  1 16:59:51 berger kernel: md:  adding sdi1 ...
Jan  1 16:59:51 berger kernel: md:  adding sdg1 ...
Jan  1 16:59:51 berger kernel: md:  adding sdf1 ...
Jan  1 16:59:51 berger kernel: md:  adding sde1 ...
Jan  1 16:59:51 berger kernel: md:  adding sdd1 ...
Jan  1 16:59:51 berger kernel: md:  adding sdc1 ...
Jan  1 16:59:51 berger kernel: md: sdb7 has different UUID to sdi1
Jan  1 16:59:51 berger kernel: md: sdb6 has different UUID to sdi1
Jan  1 16:59:51 berger kernel: md: sdb5 has different UUID to sdi1
Jan  1 16:59:51 berger kernel: md: sdb3 has different UUID to sdi1
Jan  1 16:59:51 berger kernel: md: sdb2 has different UUID to sdi1
Jan  1 16:59:51 berger kernel: md: sdb1 has different UUID to sdi1
Jan  1 16:59:51 berger kernel: md: sda7 has different UUID to sdi1
Jan  1 16:59:51 berger kernel: md: sda6 has different UUID to sdi1
Jan  1 16:59:51 berger kernel: md: sda5 has different UUID to sdi1
Jan  1 16:59:51 berger kernel: md: sda3 has different UUID to sdi1
Jan  1 16:59:51 berger kernel: md: sda2 has different UUID to sdi1
Jan  1 16:59:51 berger kernel: md: sda1 has different UUID to sdi1
Jan  1 16:59:51 berger kernel: md: created md6
Jan  1 16:59:51 berger kernel: md: bind<sdc1>
Jan  1 16:59:51 berger kernel: md: bind<sdd1>
Jan  1 16:59:51 berger kernel: md: bind<sde1>
Jan  1 16:59:51 berger kernel: md: bind<sdf1>
Jan  1 16:59:51 berger kernel: md: bind<sdg1>
Jan  1 16:59:51 berger kernel: md: export_rdev(sdi1)
Jan  1 16:59:51 berger kernel: md: running: <sdg1><sdf1><sde1><sdd1><sdc1>
Jan  1 16:59:51 berger kernel: md: kicking non-fresh sdf1 from array!
Jan  1 16:59:51 berger kernel: md: unbind<sdf1>
Jan  1 16:59:51 berger kernel: md: export_rdev(sdf1)
Jan  1 16:59:51 berger kernel: raid5: device sdg1 operational as raid disk 4
Jan  1 16:59:51 berger kernel: raid5: device sde1 operational as raid disk 2
Jan  1 16:59:51 berger kernel: raid5: device sdd1 operational as raid disk 1
Jan  1 16:59:51 berger kernel: raid5: device sdc1 operational as raid disk 0
Jan  1 16:59:51 berger kernel: raid5: not enough operational devices for md6 (2/6 failed)
Jan  1 16:59:51 berger kernel: RAID5 conf printout:
Jan  1 16:59:51 berger kernel:  --- rd:6 wd:4 fd:2
Jan  1 16:59:51 berger kernel:  disk 0, o:1, dev:sdc1
Jan  1 16:59:51 berger kernel:  disk 1, o:1, dev:sdd1
Jan  1 16:59:51 berger kernel:  disk 2, o:1, dev:sde1
Jan  1 16:59:51 berger kernel:  disk 4, o:1, dev:sdg1
Jan  1 16:59:51 berger kernel: raid5: failed to run raid set md6
Jan  1 16:59:51 berger kernel: md: pers->run() failed ...
Jan  1 16:59:51 berger kernel: md: do_md_run() returned -5
Jan  1 16:59:51 berger kernel: md: md6 stopped.
Jan  1 16:59:51 berger kernel: md: unbind<sdg1>
Jan  1 16:59:51 berger kernel: md: export_rdev(sdg1)
Jan  1 16:59:51 berger kernel: md: unbind<sde1>
Jan  1 16:59:51 berger kernel: md: export_rdev(sde1)
Jan  1 16:59:51 berger kernel: md: unbind<sdd1>
Jan  1 16:59:51 berger kernel: md: export_rdev(sdd1)
Jan  1 16:59:51 berger kernel: md: unbind<sdc1>
Jan  1 16:59:51 berger kernel: md: export_rdev(sdc1)
Jan  1 16:59:51 berger kernel: md: considering sdb7 ...
Jan  1 16:59:51 berger kernel: md:  adding sdb7 ...
Jan  1 16:59:51 berger kernel: md: sdb6 has different UUID to sdb7
Jan  1 16:59:51 berger kernel: md: sdb5 has different UUID to sdb7
Jan  1 16:59:51 berger kernel: md: sdb3 has different UUID to sdb7
Jan  1 16:59:51 berger kernel: md: sdb2 has different UUID to sdb7
Jan  1 16:59:51 berger kernel: md: sdb1 has different UUID to sdb7
Jan  1 16:59:51 berger kernel: md:  adding sda7 ...
Jan  1 16:59:51 berger kernel: md: sda6 has different UUID to sdb7
Jan  1 16:59:51 berger kernel: md: sda5 has different UUID to sdb7
Jan  1 16:59:51 berger kernel: md: sda3 has different UUID to sdb7
Jan  1 16:59:51 berger kernel: md: sda2 has different UUID to sdb7
Jan  1 16:59:51 berger kernel: md: sda1 has different UUID to sdb7
Jan  1 16:59:51 berger kernel: md: created md5
Jan  1 16:59:51 berger kernel: md: bind<sda7>
Jan  1 16:59:51 berger kernel: md: bind<sdb7>
Jan  1 16:59:51 berger kernel: md: running: <sdb7><sda7>
Jan  1 16:59:51 berger kernel: raid1: raid set md5 active with 2 out of 2 mirrors
Jan  1 16:59:51 berger kernel: md: considering sdb6 ...
Jan  1 16:59:51 berger kernel: md:  adding sdb6 ...
Jan  1 16:59:51 berger kernel: md: sdb5 has different UUID to sdb6
Jan  1 16:59:51 berger kernel: md: sdb3 has different UUID to sdb6
Jan  1 16:59:51 berger kernel: md: sdb2 has different UUID to sdb6
Jan  1 16:59:51 berger kernel: md: sdb1 has different UUID to sdb6
Jan  1 16:59:51 berger kernel: md:  adding sda6 ...
Jan  1 16:59:51 berger kernel: md: sda5 has different UUID to sdb6
Jan  1 16:59:51 berger kernel: md: sda3 has different UUID to sdb6
Jan  1 16:59:51 berger kernel: md: sda2 has different UUID to sdb6
Jan  1 16:59:51 berger kernel: md: sda1 has different UUID to sdb6
Jan  1 16:59:51 berger kernel: md: created md4
Jan  1 16:59:51 berger kernel: md: bind<sda6>
Jan  1 16:59:51 berger kernel: md: bind<sdb6>
Jan  1 16:59:51 berger kernel: md: running: <sdb6><sda6>
Jan  1 16:59:51 berger kernel: raid1: raid set md4 active with 2 out of 2 mirrors
Jan  1 16:59:51 berger kernel: md: considering sdb5 ...
Jan  1 16:59:51 berger kernel: md:  adding sdb5 ...
Jan  1 16:59:51 berger kernel: md: sdb3 has different UUID to sdb5
Jan  1 16:59:51 berger kernel: md: sdb2 has different UUID to sdb5
Jan  1 16:59:51 berger kernel: md: sdb1 has different UUID to sdb5
Jan  1 16:59:51 berger kernel: md:  adding sda5 ...
Jan  1 16:59:51 berger kernel: md: sda3 has different UUID to sdb5
Jan  1 16:59:51 berger kernel: md: sda2 has different UUID to sdb5
Jan  1 16:59:51 berger kernel: md: sda1 has different UUID to sdb5
Jan  1 16:59:51 berger kernel: md: created md3
Jan  1 16:59:51 berger kernel: md: bind<sda5>
Jan  1 16:59:51 berger kernel: md: bind<sdb5>
Jan  1 16:59:51 berger kernel: md: running: <sdb5><sda5>
Jan  1 16:59:51 berger kernel: raid1: raid set md3 active with 2 out of 2 mirrors
Jan  1 16:59:51 berger kernel: md: considering sdb3 ...
Jan  1 16:59:51 berger kernel: md:  adding sdb3 ...
Jan  1 16:59:51 berger kernel: md: sdb2 has different UUID to sdb3
Jan  1 16:59:51 berger kernel: md: sdb1 has different UUID to sdb3
Jan  1 16:59:51 berger kernel: md:  adding sda3 ...
Jan  1 16:59:51 berger kernel: md: sda2 has different UUID to sdb3
Jan  1 16:59:51 berger kernel: md: sda1 has different UUID to sdb3
Jan  1 16:59:51 berger kernel: md: created md2
Jan  1 16:59:51 berger kernel: md: bind<sda3>
Jan  1 16:59:51 berger kernel: md: bind<sdb3>
Jan  1 16:59:51 berger kernel: md: running: <sdb3><sda3>
Jan  1 16:59:51 berger kernel: raid1: raid set md2 active with 2 out of 2 mirrors
Jan  1 16:59:51 berger kernel: md: considering sdb2 ...
Jan  1 16:59:51 berger kernel: md:  adding sdb2 ...
Jan  1 16:59:51 berger kernel: md: sdb1 has different UUID to sdb2
Jan  1 16:59:51 berger kernel: md:  adding sda2 ...
Jan  1 16:59:51 berger kernel: md: sda1 has different UUID to sdb2
Jan  1 16:59:51 berger kernel: md: created md0
Jan  1 16:59:51 berger kernel: md: bind<sda2>
Jan  1 16:59:51 berger kernel: md: bind<sdb2>
Jan  1 16:59:51 berger kernel: md: running: <sdb2><sda2>
Jan  1 16:59:51 berger kernel: raid1: raid set md0 active with 2 out of 2 mirrors
Jan  1 16:59:51 berger kernel: md: considering sdb1 ...
Jan  1 16:59:51 berger kernel: md:  adding sdb1 ...
Jan  1 16:59:51 berger kernel: md:  adding sda1 ...
Jan  1 16:59:51 berger kernel: md: created md1
Jan  1 16:59:51 berger kernel: md: bind<sda1>
Jan  1 16:59:51 berger kernel: md: bind<sdb1>
Jan  1 16:59:51 berger kernel: md: running: <sdb1><sda1>
Jan  1 16:59:51 berger kernel: raid1: raid set md1 active with 2 out of 2 mirrors
Jan  1 16:59:51 berger kernel: md: ... autorun DONE.
Jan  1 16:59:51 berger kernel: EXT3-fs: mounted filesystem with ordered data mode.
Jan  1 16:59:51 berger kernel: VFS: Mounted root (ext3 filesystem) readonly.
Jan  1 16:59:51 berger kernel: Freeing unused kernel memory: 200k freed
Jan  1 16:59:51 berger kernel: kjournald starting.  Commit interval 5 seconds
Jan  1 16:59:51 berger kernel: Adding 4008120k swap on /dev/md2.  Priority:1 extents:1 across:4008120k
Jan  1 16:59:51 berger kernel: EXT3 FS on md0, internal journal
Jan  1 16:59:51 berger kernel: kjournald starting.  Commit interval 5 seconds
Jan  1 16:59:51 berger kernel: EXT3 FS on md1, internal journal
Jan  1 16:59:51 berger kernel: EXT3-fs: mounted filesystem with ordered data mode.
Jan  1 16:59:51 berger kernel: kjournald starting.  Commit interval 5 seconds
Jan  1 16:59:51 berger kernel: EXT3 FS on md3, internal journal
Jan  1 16:59:51 berger kernel: EXT3-fs: mounted filesystem with ordered data mode.
Jan  1 16:59:51 berger kernel: kjournald starting.  Commit interval 5 seconds
Jan  1 16:59:51 berger kernel: EXT3 FS on md4, internal journal
Jan  1 16:59:51 berger kernel: EXT3-fs: mounted filesystem with ordered data mode.
Jan  1 16:59:51 berger kernel: kjournald starting.  Commit interval 5 seconds
Jan  1 16:59:51 berger kernel: EXT3 FS on md5, internal journal
Jan  1 16:59:51 berger kernel: EXT3-fs: mounted filesystem with ordered data mode.
Jan  1 16:59:51 berger bootlog:  Bringing up the eth0 interface...
Jan  1 16:59:51 berger bootlog:  Bringing up the eth1 interface...
Jan  1 16:59:51 berger kernel: eth1: link up, 100Mbps, full-duplex, lpa 0x41E1
Jan  1 16:59:51 berger bootlog:  Adding IPv4 address 81.138.64.233 to the eth1 interface...[  OK  ]
Jan  1 16:59:51 berger bootlog:  Setting up default gateway...[  OK  ]
Jan  1 16:59:51 berger bootlog:  Bringing up the eth2 interface...
Jan  1 16:59:51 berger kernel: r8169: eth2: link up
Jan  1 16:59:51 berger bootlog:  Adding IPv4 address 10.11.216.2 to the eth2 interface...[  OK  ]
Jan  1 16:59:51 berger bootlog:  Starting RPC Portmap[  OK  ]
Jan  1 16:59:51 berger bootlog:  Initializing kernel random number generator...[  OK  ]
Jan  1 16:59:51 berger ntpd[2241]: ntpd 4.2.0@1.1161-r Tue Nov 22 12:28:51 GMT 2005 (1)
Jan  1 16:59:51 berger bootlog:  Starting ntpd...[  OK  ]
Jan  1 16:59:51 berger ntpd[2241]: precision = 1.000 usec
Jan  1 16:59:51 berger ntpd[2241]: no IPv6 interfaces found
Jan  1 16:59:51 berger ntpd[2241]: kernel time sync status 0040
Jan  1 16:59:52 berger bootlog:  Starting SSH Server...[  OK  ]
Jan  1 16:59:52 berger bootlog:  Starting vsFTPD Server...[  OK  ]
Jan  1 16:59:52 berger bootlog:  Starting MySQL daemon...[  OK  ]
Jan  1 16:59:52 berger bootlog:  Starting PostgreSQL daemon...[  OK  ]
Jan  1 16:59:52 berger bootlog:  Starting exim...[  OK  ]
Jan  1 16:59:52 berger fcron[2338]: fcron[2338] 3.0.0 started
Jan  1 16:59:52 berger fcron[2338]: updating configuration from /var/spool/fcron
Jan  1 16:59:52 berger bootlog:  Starting fcron...[  OK  ]
Jan  1 16:59:53 berger bootlog:  Starting nmbd...[ FAIL ]
Jan  1 16:59:53 berger bootlog:  Starting smbd...[ FAIL ]
Jan  1 16:59:54 berger bootlog:  Starting gpm...[  OK  ]
Jan  1 17:00:19 berger ntpd[2241]: frequency initialized -141.393 PPM from /var/cache/ntp.drift
Jan  1 17:08:52 berger ntpd[2241]: synchronized to 146.64.241.229, stratum=2
Jan  1 17:08:52 berger ntpd[2241]: time reset -0.460111 s
Jan  1 17:08:52 berger ntpd[2241]: kernel time sync disabled 0041
Jan  1 17:18:30 berger ntpd[2241]: synchronized to 212.85.158.10, stratum=3
Jan  1 17:18:32 berger ntpd[2241]: synchronized to 146.64.241.229, stratum=2
Jan  1 17:27:05 berger ntpd[2241]: kernel time sync enabled 0001

--------------080200020308010406040907
Content-Type: text/plain;
 name="dmesg.out.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.out.txt"

ion 1.20 loaded.
sata_via 0000:00:0f.0: version 1.1
ACPI: PCI Interrupt 0000:00:0f.0[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
sata_via 0000:00:0f.0: routed to hard irq line 10
ata1: SATA max UDMA/133 cmd 0xE200 ctl 0xE302 bmdma 0xE600 irq 10
ata2: SATA max UDMA/133 cmd 0xE400 ctl 0xE502 bmdma 0xE608 irq 10
ata1: SATA link up 1.5 Gbps (SStatus 113)
ata1: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 88:407f
ata1: dev 0 ATA-6, max UDMA/133, 156301488 sectors: LBA48
ata1: dev 0 configured for UDMA/133
scsi0 : sata_via
ata2: SATA link up 1.5 Gbps (SStatus 113)
ata2: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 88:407f
ata2: dev 0 ATA-6, max UDMA/133, 156301488 sectors: LBA48
ata2: dev 0 configured for UDMA/133
scsi1 : sata_via
  Vendor: ATA       Model: ST380817AS        Rev: 3.42
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: ST380817AS        Rev: 3.42
  Type:   Direct-Access                      ANSI SCSI revision: 05
sata_mv 0000:00:0c.0: version 0.5
ACPI: PCI Interrupt 0000:00:0c.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
sata_mv 0000:00:0c.0: 32 slots 8 ports SCSI mode IRQ via INTx
ata3: SATA max UDMA/133 cmd 0x0 ctl 0xF8922120 bmdma 0x0 irq 11
ata4: SATA max UDMA/133 cmd 0x0 ctl 0xF8924120 bmdma 0x0 irq 11
ata5: SATA max UDMA/133 cmd 0x0 ctl 0xF8926120 bmdma 0x0 irq 11
ata6: SATA max UDMA/133 cmd 0x0 ctl 0xF8928120 bmdma 0x0 irq 11
ata7: SATA max UDMA/133 cmd 0x0 ctl 0xF8932120 bmdma 0x0 irq 11
ata8: SATA max UDMA/133 cmd 0x0 ctl 0xF8934120 bmdma 0x0 irq 11
ata9: SATA max UDMA/133 cmd 0x0 ctl 0xF8936120 bmdma 0x0 irq 11
ata10: SATA max UDMA/133 cmd 0x0 ctl 0xF8938120 bmdma 0x0 irq 11
ata3: no device found (phy stat 00000000)
scsi2 : sata_mv
ata4: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4673 85:7c69 86:3e01 87:4663 88:007f
ata4: dev 0 ATA-7, max UDMA/133, 490234752 sectors: LBA48
ata4: dev 0 configured for UDMA/133
scsi3 : sata_mv
ata5: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4773 85:7c69 86:3e01 87:4763 88:407f
ata5: dev 0 ATA-7, max UDMA/133, 490234752 sectors: LBA48
ata5: dev 0 configured for UDMA/133
scsi4 : sata_mv
ata6: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4673 85:7c69 86:3e01 87:4663 88:007f
ata6: dev 0 ATA-7, max UDMA/133, 490234752 sectors: LBA48
ata6: dev 0 configured for UDMA/133
scsi5 : sata_mv
ata7: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4773 85:7c69 86:3e01 87:4763 88:407f
ata7: dev 0 ATA-7, max UDMA/133, 490234752 sectors: LBA48
ata7: dev 0 configured for UDMA/133
scsi6 : sata_mv
ata8: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4673 85:7c69 86:3e01 87:4663 88:007f
ata8: dev 0 ATA-7, max UDMA/133, 490234752 sectors: LBA48
ata8: dev 0 configured for UDMA/133
scsi7 : sata_mv
ata9: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4673 85:7c69 86:3e01 87:4663 88:007f
ata9: dev 0 ATA-7, max UDMA/133, 490234752 sectors: LBA48
ata9: dev 0 configured for UDMA/133
scsi8 : sata_mv
ata10: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4063 85:7c69 86:3e01 87:4063 88:007f
ata10: dev 0 ATA-7, max UDMA/133, 490234752 sectors: LBA48
ata10: dev 0 configured for UDMA/133
scsi9 : sata_mv
  Vendor: ATA       Model: Maxtor 6L250S0    Rev: BANC
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: Maxtor 6V250F0    Rev: VA11
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: Maxtor 6L250S0    Rev: BANC
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: Maxtor 6V250F0    Rev: VA11
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: Maxtor 6L250S0    Rev: BANC
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: Maxtor 6L250S0    Rev: BANC
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: Maxtor 6L250S0    Rev: BANC
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
sd 0:0:0:0: Attached scsi disk sda
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
SCSI device sdb: drive cache: write back
 sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 >
sd 1:0:0:0: Attached scsi disk sdb
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sdc: drive cache: write back
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sdc: drive cache: write back
 sdc: sdc1
sd 3:0:0:0: Attached scsi disk sdc
SCSI device sdd: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sdd: drive cache: write back
SCSI device sdd: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sdd: drive cache: write back
 sdd: sdd1
sd 4:0:0:0: Attached scsi disk sdd
SCSI device sde: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sde: drive cache: write back
SCSI device sde: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sde: drive cache: write back
 sde: sde1
sd 5:0:0:0: Attached scsi disk sde
SCSI device sdf: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sdf: drive cache: write back
SCSI device sdf: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sdf: drive cache: write back
 sdf: sdf1
sd 6:0:0:0: Attached scsi disk sdf
SCSI device sdg: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sdg: drive cache: write back
SCSI device sdg: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sdg: drive cache: write back
 sdg: sdg1
sd 7:0:0:0: Attached scsi disk sdg
SCSI device sdh: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sdh: drive cache: write back
SCSI device sdh: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sdh: drive cache: write back
 sdh: sdh1
sd 8:0:0:0: Attached scsi disk sdh
SCSI device sdi: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sdi: drive cache: write back
SCSI device sdi: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sdi: drive cache: write back
 sdi: sdi1
sd 9:0:0:0: Attached scsi disk sdi
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 3:0:0:0: Attached scsi generic sg2 type 0
sd 4:0:0:0: Attached scsi generic sg3 type 0
sd 5:0:0:0: Attached scsi generic sg4 type 0
sd 6:0:0:0: Attached scsi generic sg5 type 0
sd 7:0:0:0: Attached scsi generic sg6 type 0
sd 8:0:0:0: Attached scsi generic sg7 type 0
sd 9:0:0:0: Attached scsi generic sg8 type 0
usbmon: debugfs is not available
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 3
PCI: setting IRQ 3 as level-triggered
ACPI: PCI Interrupt 0000:00:10.4[C] -> Link [LNKC] -> GSI 3 (level, low) -> IRQ 3
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.4: irq 3, io mem 0xe20a1000
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
USB Universal Host Controller Interface driver v2.3
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
PCI: Via IRQ fixup for 0000:00:10.0, from 5 to 10
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: irq 10, io base 0x0000e900
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.1[A] -> Link [LNKA] -> GSI 10 (level, low) -> IRQ 10
PCI: Via IRQ fixup for 0000:00:10.1, from 5 to 10
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: irq 10, io base 0x0000ea00
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.2[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: irq 10, io base 0x0000eb00
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.3[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:10.3: UHCI Host Controller
uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:10.3: irq 10, io base 0x0000ec00
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usbcore: registered new driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Initializing USB Mass Storage driver...
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :  4865.000 MB/sec
raid5: using function: pIII_sse (4865.000 MB/sec)
md: faulty personality registered for level -5
md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 4.39
device-mapper: 4.5.0-ioctl (2005-10-04) initialised: dm-devel@redhat.com
MC: drivers/edac/edac_mc.c version MC $Revision: 1.4.2.10 $
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 7, 524288 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
ip_conntrack version 2.4 (8183 buckets, 65464 max) - 232 bytes per conntrack
ip_conntrack_pptp version 3.1 loaded
ip_tables: (C) 2000-2002 Netfilter core team
ipt_recent v0.3.1: Stephen Frost <sfrost@snowman.net>.  http://snowman.net/projects/ipt_recent/
arp_tables: (C) 2002 David S. Miller
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
ACPI wakeup devices: 
SLPB PCI0 USB3 USB4 USB5 USB6 USB7 LAN0 UAR1 ECP1 
ACPI: (supports S0 S1 S4 S5)
md: Autodetecting RAID arrays.
md: invalid superblock checksum on sdh1
md: sdh1 has invalid sb, not importing!
md: autorun ...
md: considering sdi1 ...
md:  adding sdi1 ...
md:  adding sdg1 ...
md:  adding sdf1 ...
md:  adding sde1 ...
md:  adding sdd1 ...
md:  adding sdc1 ...
md: sdb7 has different UUID to sdi1
md: sdb6 has different UUID to sdi1
md: sdb5 has different UUID to sdi1
md: sdb3 has different UUID to sdi1
md: sdb2 has different UUID to sdi1
md: sdb1 has different UUID to sdi1
md: sda7 has different UUID to sdi1
md: sda6 has different UUID to sdi1
md: sda5 has different UUID to sdi1
md: sda3 has different UUID to sdi1
md: sda2 has different UUID to sdi1
md: sda1 has different UUID to sdi1
md: created md6
md: bind<sdc1>
md: bind<sdd1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sdg1>
md: export_rdev(sdi1)
md: running: <sdg1><sdf1><sde1><sdd1><sdc1>
md: kicking non-fresh sdf1 from array!
md: unbind<sdf1>
md: export_rdev(sdf1)
raid5: device sdg1 operational as raid disk 4
raid5: device sde1 operational as raid disk 2
raid5: device sdd1 operational as raid disk 1
raid5: device sdc1 operational as raid disk 0
raid5: not enough operational devices for md6 (2/6 failed)
RAID5 conf printout:
 --- rd:6 wd:4 fd:2
 disk 0, o:1, dev:sdc1
 disk 1, o:1, dev:sdd1
 disk 2, o:1, dev:sde1
 disk 4, o:1, dev:sdg1
raid5: failed to run raid set md6
md: pers->run() failed ...
md: do_md_run() returned -5
md: md6 stopped.
md: unbind<sdg1>
md: export_rdev(sdg1)
md: unbind<sde1>
md: export_rdev(sde1)
md: unbind<sdd1>
md: export_rdev(sdd1)
md: unbind<sdc1>
md: export_rdev(sdc1)
md: considering sdb7 ...
md:  adding sdb7 ...
md: sdb6 has different UUID to sdb7
md: sdb5 has different UUID to sdb7
md: sdb3 has different UUID to sdb7
md: sdb2 has different UUID to sdb7
md: sdb1 has different UUID to sdb7
md:  adding sda7 ...
md: sda6 has different UUID to sdb7
md: sda5 has different UUID to sdb7
md: sda3 has different UUID to sdb7
md: sda2 has different UUID to sdb7
md: sda1 has different UUID to sdb7
md: created md5
md: bind<sda7>
md: bind<sdb7>
md: running: <sdb7><sda7>
raid1: raid set md5 active with 2 out of 2 mirrors
md: considering sdb6 ...
md:  adding sdb6 ...
md: sdb5 has different UUID to sdb6
md: sdb3 has different UUID to sdb6
md: sdb2 has different UUID to sdb6
md: sdb1 has different UUID to sdb6
md:  adding sda6 ...
md: sda5 has different UUID to sdb6
md: sda3 has different UUID to sdb6
md: sda2 has different UUID to sdb6
md: sda1 has different UUID to sdb6
md: created md4
md: bind<sda6>
md: bind<sdb6>
md: running: <sdb6><sda6>
raid1: raid set md4 active with 2 out of 2 mirrors
md: considering sdb5 ...
md:  adding sdb5 ...
md: sdb3 has different UUID to sdb5
md: sdb2 has different UUID to sdb5
md: sdb1 has different UUID to sdb5
md:  adding sda5 ...
md: sda3 has different UUID to sdb5
md: sda2 has different UUID to sdb5
md: sda1 has different UUID to sdb5
md: created md3
md: bind<sda5>
md: bind<sdb5>
md: running: <sdb5><sda5>
raid1: raid set md3 active with 2 out of 2 mirrors
md: considering sdb3 ...
md:  adding sdb3 ...
md: sdb2 has different UUID to sdb3
md: sdb1 has different UUID to sdb3
md:  adding sda3 ...
md: sda2 has different UUID to sdb3
md: sda1 has different UUID to sdb3
md: created md2
md: bind<sda3>
md: bind<sdb3>
md: running: <sdb3><sda3>
raid1: raid set md2 active with 2 out of 2 mirrors
md: considering sdb2 ...
md:  adding sdb2 ...
md: sdb1 has different UUID to sdb2
md:  adding sda2 ...
md: sda1 has different UUID to sdb2
md: created md0
md: bind<sda2>
md: bind<sdb2>
md: running: <sdb2><sda2>
raid1: raid set md0 active with 2 out of 2 mirrors
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md1
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1>
raid1: raid set md1 active with 2 out of 2 mirrors
md: ... autorun DONE.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 200k freed
kjournald starting.  Commit interval 5 seconds
Adding 4008120k swap on /dev/md2.  Priority:1 extents:1 across:4008120k
EXT3 FS on md0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
eth1: link up, 100Mbps, full-duplex, lpa 0x41E1
r8169: eth2: link up

--------------080200020308010406040907--
