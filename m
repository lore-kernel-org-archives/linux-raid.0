From: Brad Campbell <brad@wasp.net.au>
Subject: libata and md issues with 2.9.1-rc1
Date: Tue, 24 Aug 2004 21:24:47 +0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <412B79DF.2000705@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
To: linux-ide@vger.kernel.org
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Just a heads up. I'm experiencing "issues" with 2.6.9-rc1 that don't occur with 2.6.5.

I run a 10 disk raid-5 on 3xPromise SATA150 cards and a 2 disk raid-0 on the on-board VIA chipset.
The 10 disks are Maxtor Maxline-II SATA drives and the raid-0 is a pair of WD2000JB drives with
Addonics SATA->PATA converters.

I am not seeing any issues with the Promise/Maxtor combo at this stage, but I'm getting random
read/write errors with the VIA/WD combo that don't appear under 2.6.5 or DOS (I also use Spinrite to
check the disks when I get issues).

This only appears when the 2 drives are run in the raid-0.

Under 2.6.5 I ran a complete badlocks -n on both drives simultaneously, and repeated the same under 
2.6.9-rc1 with no problems (7 hours for a complete run). I even ran 5 simultaneous badblocks runs on 
host 1, 6, 9, 12 & 13 for about 30 minutes with no problems (except PCI bus saturation!)

After starting the raid I ran a complete badblocks -n on /dev/md1 under 2.6.5 with no problems. 
Under 2.6.9-rc1 I get timeouts immediately I start badblocks -n (the -n is the key as I have to 
write something to cause the problem)

Aug 24 18:55:03 srv kernel: raid0: looking at sdk1
Aug 24 18:55:03 srv kernel: raid0:   comparing sdk1(195310080) with sdk1(195310080)
Aug 24 18:55:03 srv kernel: raid0:   END
Aug 24 18:55:03 srv kernel: raid0:   ==> UNIQUE
Aug 24 18:55:03 srv kernel: raid0: 1 zones
Aug 24 18:55:03 srv kernel: raid0: looking at sdl1
Aug 24 18:55:03 srv kernel: raid0:   comparing sdl1(195358336) with sdk1(195310080)
Aug 24 18:55:03 srv kernel: raid0:   NOT EQUAL
Aug 24 18:55:03 srv kernel: raid0:   comparing sdl1(195358336) with sdl1(195358336)
Aug 24 18:55:03 srv kernel: raid0:   END
Aug 24 18:55:03 srv kernel: raid0:   ==> UNIQUE
Aug 24 18:55:03 srv kernel: raid0: 2 zones
Aug 24 18:55:03 srv kernel: raid0: FINAL 2 zones
Aug 24 18:55:03 srv kernel: raid0: zone 1
Aug 24 18:55:03 srv kernel: raid0: checking sdk1 ... nope.
Aug 24 18:55:03 srv kernel: raid0: checking sdl1 ... contained as device 0
Aug 24 18:55:03 srv kernel:   (195358336) is smallest!.
Aug 24 18:55:03 srv kernel: raid0: zone->nb_dev: 1, size: 48256
Aug 24 18:55:03 srv kernel: raid0: current zone offset: 195358336
Aug 24 18:55:03 srv kernel: raid0: done.
Aug 24 18:55:03 srv kernel: raid0 : md_size is 390668416 blocks.
Aug 24 18:55:03 srv kernel: raid0 : conf->hash_spacing is 390620160 blocks.
Aug 24 18:55:03 srv kernel: raid0 : nb_zone is 2.
Aug 24 18:55:03 srv kernel: raid0 : Allocating 8 bytes for hash.
Aug 24 19:01:37 srv kernel: ata13: command 0x35 timeout, stat 0xd0 host_stat 0x0
Aug 24 19:01:37 srv kernel: ata13: status=0xd0 { Busy }
Aug 24 19:01:37 srv kernel: SCSI error : <12 0 0 0> return code = 0x8000002
Aug 24 19:01:37 srv kernel: FMK EOM ILI Current sdk: sense = 70 ef
Aug 24 19:01:37 srv kernel: ASC=28 ASCQ=c0
Aug 24 19:01:37 srv kernel: end_request: I/O error, dev sdk, sector 63
Aug 24 19:01:37 srv kernel: ATA: abnormal status 0xD0 on port 0x8807
Aug 24 19:01:37 srv last message repeated 2 times
Aug 24 19:02:07 srv kernel: ata13: command 0x35 timeout, stat 0xd0 host_stat 0x1
Aug 24 19:02:07 srv kernel: ata13: status=0xd0 { Busy }
Aug 24 19:02:07 srv kernel: SCSI error : <12 0 0 0> return code = 0x8000002
Aug 24 19:02:07 srv kernel: FMK EOM ILI Current sdk: sense = 70 ef
Aug 24 19:02:07 srv kernel: ASC=28 ASCQ=c0
Aug 24 19:02:07 srv kernel: end_request: I/O error, dev sdk, sector 71
Aug 24 19:02:07 srv kernel: ATA: abnormal status 0xD0 on port 0x8807
Aug 24 19:02:07 srv last message repeated 2 times

I'm not really even sure where to start here as it only occurs when the 2 drives are in a Raid-0 and 
  depending on what is going on with the system it can take a while to manifest. (Never more than a 
hundred megs or so of data though)

Relevant boot log from 2.6.9-rc1 attached

Regards,
Brad (Certified libata torturer)

Aug 24 19:03:55 srv kernel: Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Aug 24 19:03:55 srv kernel: ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Aug 24 19:03:55 srv kernel: VP_IDE: IDE controller at PCI slot 0000:00:0f.1
Aug 24 19:03:55 srv kernel: VP_IDE: chipset revision 6
Aug 24 19:03:55 srv kernel: VP_IDE: not 100%% native mode: will probe irqs later
Aug 24 19:03:55 srv kernel: VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
Aug 24 19:03:55 srv kernel:     ide0: BM-DMA at 0x6800-0x6807, BIOS settings: hda:DMA, hdb:pio
Aug 24 19:03:55 srv kernel:     ide1: BM-DMA at 0x6808-0x680f, BIOS settings: hdc:pio, hdd:pio
Aug 24 19:03:55 srv kernel: hda: WDC WD400EB-00CPF0, ATA DISK drive
Aug 24 19:03:55 srv kernel: Using anticipatory io scheduler
Aug 24 19:03:55 srv kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Aug 24 19:03:55 srv kernel: hda: max request size: 128KiB
Aug 24 19:03:55 srv kernel: hda: Host Protected Area detected.
Aug 24 19:03:55 srv kernel: ^Icurrent capacity is 78159151 sectors (40017 MB)
Aug 24 19:03:55 srv kernel: ^Inative  capacity is 78165360 sectors (40020 MB)
Aug 24 19:03:55 srv kernel: hda: 78159151 sectors (40017 MB) w/2048KiB Cache, CHS=65535/16/63, UDMA(100)
Aug 24 19:03:55 srv kernel:  /dev/ide/host0/bus0/target0/lun0: p1 p2 p3
Aug 24 19:03:55 srv kernel: libata version 1.02 loaded.
Aug 24 19:03:55 srv kernel: sata_promise version 0.91
Aug 24 19:03:55 srv kernel: ata1: SATA max UDMA/133 cmd 0xE080B200 ctl 0xE080B238 bmdma 0x0 irq 19
Aug 24 19:03:55 srv kernel: ata2: SATA max UDMA/133 cmd 0xE080B280 ctl 0xE080B2B8 bmdma 0x0 irq 19
Aug 24 19:03:55 srv kernel: ata3: SATA max UDMA/133 cmd 0xE080B300 ctl 0xE080B338 bmdma 0x0 irq 19
Aug 24 19:03:55 srv kernel: ata4: SATA max UDMA/133 cmd 0xE080B380 ctl 0xE080B3B8 bmdma 0x0 irq 19
Aug 24 19:03:55 srv kernel: ata1: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4003 85:7c69 86:3e01 87:4003 
88:407f
Aug 24 19:03:55 srv kernel: ata1: dev 0 ATA, max UDMA/133, 490234752 sectors (lba48)
Aug 24 19:03:55 srv kernel: ata1: dev 0 configured for UDMA/133
Aug 24 19:03:55 srv kernel: scsi0 : sata_promise
Aug 24 19:03:55 srv kernel: ata2: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4003 85:7c69 86:3e01 87:4003 
88:407f
Aug 24 19:03:55 srv kernel: ata2: dev 0 ATA, max UDMA/133, 490234752 sectors (lba48)
Aug 24 19:03:55 srv kernel: ata2: dev 0 configured for UDMA/133
Aug 24 19:03:55 srv kernel: scsi1 : sata_promise
Aug 24 19:03:55 srv kernel: ata3: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4003 85:7c69 86:3e01 87:4003 
88:407f
Aug 24 19:03:55 srv kernel: ata3: dev 0 ATA, max UDMA/133, 490234752 sectors (lba48)
Aug 24 19:03:55 srv kernel: ata3: dev 0 configured for UDMA/133
Aug 24 19:03:55 srv kernel: scsi2 : sata_promise
Aug 24 19:03:55 srv kernel: ata4: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4003 85:7c69 86:3e01 87:4003 
88:407f
Aug 24 19:03:55 srv kernel: ata4: dev 0 ATA, max UDMA/133, 490234752 sectors (lba48)
Aug 24 19:03:55 srv kernel: ata4: dev 0 configured for UDMA/133
Aug 24 19:03:55 srv kernel: scsi3 : sata_promise
Aug 24 19:03:55 srv kernel:   Vendor: ATA       Model: Maxtor 7Y250M0    Rev: 1.02
Aug 24 19:03:55 srv kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug 24 19:03:55 srv kernel:   Vendor: ATA       Model: Maxtor 7Y250M0    Rev: 1.02
Aug 24 19:03:55 srv kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug 24 19:03:55 srv kernel:   Vendor: ATA       Model: Maxtor 7Y250M0    Rev: 1.02
Aug 24 19:03:55 srv kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug 24 19:03:55 srv kernel:   Vendor: ATA       Model: Maxtor 7Y250M0    Rev: 1.02
Aug 24 19:03:55 srv kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug 24 19:03:55 srv kernel: ata5: SATA max UDMA/133 cmd 0xE080D200 ctl 0xE080D238 bmdma 0x0 irq 17
Aug 24 19:03:55 srv kernel: ata6: SATA max UDMA/133 cmd 0xE080D280 ctl 0xE080D2B8 bmdma 0x0 irq 17
Aug 24 19:03:55 srv kernel: ata7: SATA max UDMA/133 cmd 0xE080D300 ctl 0xE080D338 bmdma 0x0 irq 17
Aug 24 19:03:55 srv kernel: ata8: SATA max UDMA/133 cmd 0xE080D380 ctl 0xE080D3B8 bmdma 0x0 irq 17
Aug 24 19:03:55 srv kernel: ata5: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4003 85:7c69 86:3e01 87:4003 
88:407fAug 24 19:03:55 srv kernel: ata5: dev 0 ATA, max UDMA/133, 490234752 sectors (lba48)
Aug 24 19:03:55 srv kernel: ata5: dev 0 configured for UDMA/133
Aug 24 19:03:55 srv kernel: scsi4 : sata_promise
Aug 24 19:03:55 srv kernel: ata6: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4003 85:7c69 86:3e01 87:4003 
88:407f
Aug 24 19:03:55 srv kernel: ata6: dev 0 ATA, max UDMA/133, 490234752 sectors (lba48)
Aug 24 19:03:55 srv kernel: ata6: dev 0 configured for UDMA/133
Aug 24 19:03:55 srv kernel: scsi5 : sata_promise
Aug 24 19:03:55 srv kernel: ata7: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4003 85:7c69 86:3e01 87:4003 
88:407f
Aug 24 19:03:55 srv kernel: ata7: dev 0 ATA, max UDMA/133, 490234752 sectors (lba48)
Aug 24 19:03:55 srv kernel: ata7: dev 0 configured for UDMA/133
Aug 24 19:03:55 srv kernel: scsi6 : sata_promise
Aug 24 19:03:55 srv kernel: ata8: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4003 85:7c69 86:3e01 87:4003 
88:407f
Aug 24 19:03:55 srv kernel: ata8: dev 0 ATA, max UDMA/133, 490234752 sectors (lba48)
Aug 24 19:03:55 srv kernel: ata8: dev 0 configured for UDMA/133
Aug 24 19:03:55 srv kernel: scsi7 : sata_promise
Aug 24 19:03:55 srv kernel:   Vendor: ATA       Model: Maxtor 7Y250M0    Rev: 1.02
Aug 24 19:03:55 srv kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug 24 19:03:55 srv kernel:   Vendor: ATA       Model: Maxtor 7Y250M0    Rev: 1.02
Aug 24 19:03:55 srv kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug 24 19:03:55 srv kernel:   Vendor: ATA       Model: Maxtor 7Y250M0    Rev: 1.02
Aug 24 19:03:55 srv kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug 24 19:03:55 srv kernel:   Vendor: ATA       Model: Maxtor 7Y250M0    Rev: 1.02
Aug 24 19:03:55 srv kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug 24 19:03:55 srv kernel: ata9: SATA max UDMA/133 cmd 0xE080F200 ctl 0xE080F238 bmdma 0x0 irq 18
Aug 24 19:03:55 srv kernel: ata10: SATA max UDMA/133 cmd 0xE080F280 ctl 0xE080F2B8 bmdma 0x0 irq 18
Aug 24 19:03:55 srv kernel: ata11: SATA max UDMA/133 cmd 0xE080F300 ctl 0xE080F338 bmdma 0x0 irq 18
Aug 24 19:03:55 srv kernel: ata12: SATA max UDMA/133 cmd 0xE080F380 ctl 0xE080F3B8 bmdma 0x0 irq 18
Aug 24 19:03:55 srv kernel: ata9: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4003 85:7c69 86:3e01 87:4003 
88:407f
Aug 24 19:03:55 srv kernel: ata9: dev 0 ATA, max UDMA/133, 490234752 sectors (lba48)
Aug 24 19:03:55 srv kernel: ata9: dev 0 configured for UDMA/133
Aug 24 19:03:55 srv kernel: scsi8 : sata_promise
Aug 24 19:03:55 srv kernel: ata10: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4003 85:7c69 86:3e01 87:4003 
88:407f
Aug 24 19:03:55 srv kernel: ata10: dev 0 ATA, max UDMA/133, 490234752 sectors (lba48)
Aug 24 19:03:55 srv kernel: ata10: dev 0 configured for UDMA/133
Aug 24 19:03:55 srv kernel: scsi9 : sata_promise
Aug 24 19:03:55 srv kernel: ata11: no device found (phy stat 00000000)
Aug 24 19:03:55 srv kernel: ata11: thread exiting
Aug 24 19:03:55 srv kernel: scsi10 : sata_promise
Aug 24 19:03:55 srv kernel: ata12: no device found (phy stat 00000000)
Aug 24 19:03:55 srv kernel: ata12: thread exiting
Aug 24 19:03:55 srv kernel: scsi11 : sata_promise
Aug 24 19:03:55 srv kernel:   Vendor: ATA       Model: Maxtor 7Y250M0    Rev: 1.02
Aug 24 19:03:55 srv kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug 24 19:03:55 srv kernel:   Vendor: ATA       Model: Maxtor 7Y250M0    Rev: 1.02
Aug 24 19:03:55 srv kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug 24 19:03:55 srv kernel: sata_via version 0.20
Aug 24 19:03:55 srv kernel: sata_via(0000:00:0f.0): routed to hard irq line 6
Aug 24 19:03:55 srv kernel: ata13: SATA max UDMA/133 cmd 0x8800 ctl 0x8402 bmdma 0x7400 irq 20
Aug 24 19:03:55 srv kernel: ata14: SATA max UDMA/133 cmd 0x8000 ctl 0x7802 bmdma 0x7408 irq 20
Aug 24 19:03:55 srv kernel: ata13: dev 0 cfg 49:2f00 82:346b 83:7f01 84:4003 85:3469 86:3c01 87:4003 
88:203f
Aug 24 19:03:55 srv kernel: ata13: dev 0 ATA, max UDMA/100, 390622887 sectors (lba48)
Aug 24 19:03:55 srv kernel: ata13: dev 0 configured for UDMA/100
Aug 24 19:03:55 srv kernel: scsi12 : sata_via
Aug 24 19:03:55 srv kernel: ata14: dev 0 cfg 49:2f00 82:346b 83:7f01 84:4003 85:3469 86:3c01 87:4003 
88:203f
Aug 24 19:03:55 srv kernel: ata14: dev 0 ATA, max UDMA/100, 390719855 sectors (lba48)
Aug 24 19:03:55 srv kernel: ata14: dev 0 configured for UDMA/100
Aug 24 19:03:55 srv kernel: scsi13 : sata_via
Aug 24 19:03:55 srv kernel:   Vendor: ATA       Model: WDC WD2000JB-00D  Rev: 1.02
Aug 24 19:03:55 srv kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug 24 19:03:55 srv kernel:   Vendor: ATA       Model: WDC WD2000JB-00F  Rev: 1.02
Aug 24 19:03:55 srv kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug 24 19:03:55 srv kernel: SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
Aug 24 19:03:55 srv kernel: SCSI device sda: drive cache: write through
Aug 24 19:03:55 srv kernel:  /dev/scsi/host0/bus0/target0/lun0: p1
Aug 24 19:03:55 srv kernel: Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Aug 24 19:03:55 srv kernel: SCSI device sdb: 490234752 512-byte hdwr sectors (251000 MB)
Aug 24 19:03:55 srv kernel: SCSI device sdb: drive cache: write through
Aug 24 19:03:55 srv kernel:  /dev/scsi/host1/bus0/target0/lun0: p1
Aug 24 19:03:55 srv kernel: Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
Aug 24 19:03:55 srv kernel: SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)
Aug 24 19:03:55 srv kernel: SCSI device sdc: drive cache: write through
Aug 24 19:03:55 srv kernel:  /dev/scsi/host2/bus0/target0/lun0: p1
Aug 24 19:03:55 srv kernel: Attached scsi disk sdc at scsi2, channel 0, id 0, lun 0
Aug 24 19:03:55 srv kernel: SCSI device sdd: 490234752 512-byte hdwr sectors (251000 MB)
Aug 24 19:03:55 srv kernel: SCSI device sdd: drive cache: write through
Aug 24 19:03:55 srv kernel:  /dev/scsi/host3/bus0/target0/lun0: p1
Aug 24 19:03:55 srv kernel: Attached scsi disk sdd at scsi3, channel 0, id 0, lun 0
Aug 24 19:03:55 srv kernel: SCSI device sde: 490234752 512-byte hdwr sectors (251000 MB)
Aug 24 19:03:55 srv kernel: SCSI device sde: drive cache: write through
Aug 24 19:03:55 srv kernel:  /dev/scsi/host4/bus0/target0/lun0: p1
Aug 24 19:03:55 srv kernel: Attached scsi disk sde at scsi4, channel 0, id 0, lun 0
Aug 24 19:03:55 srv kernel: SCSI device sdf: 490234752 512-byte hdwr sectors (251000 MB)
Aug 24 19:03:55 srv kernel: SCSI device sdf: drive cache: write through
Aug 24 19:03:55 srv kernel:  /dev/scsi/host5/bus0/target0/lun0: p1
Aug 24 19:03:55 srv kernel: Attached scsi disk sdf at scsi5, channel 0, id 0, lun 0
Aug 24 19:03:55 srv kernel: SCSI device sdg: 490234752 512-byte hdwr sectors (251000 MB)
Aug 24 19:03:55 srv kernel: SCSI device sdg: drive cache: write through
Aug 24 19:03:55 srv kernel:  /dev/scsi/host6/bus0/target0/lun0: p1
Aug 24 19:03:55 srv kernel: Attached scsi disk sdg at scsi6, channel 0, id 0, lun 0
Aug 24 19:03:55 srv kernel: SCSI device sdh: 490234752 512-byte hdwr sectors (251000 MB)
Aug 24 19:03:55 srv kernel: SCSI device sdh: drive cache: write through
Aug 24 19:03:55 srv kernel:  /dev/scsi/host7/bus0/target0/lun0: p1
Aug 24 19:03:55 srv kernel: Attached scsi disk sdh at scsi7, channel 0, id 0, lun 0
Aug 24 19:03:55 srv kernel: SCSI device sdi: 490234752 512-byte hdwr sectors (251000 MB)
Aug 24 19:03:55 srv kernel: SCSI device sdi: drive cache: write through
Aug 24 19:03:55 srv kernel:  /dev/scsi/host8/bus0/target0/lun0: p1
Aug 24 19:03:55 srv kernel: Attached scsi disk sdi at scsi8, channel 0, id 0, lun 0
Aug 24 19:03:55 srv kernel: SCSI device sdj: 490234752 512-byte hdwr sectors (251000 MB)
Aug 24 19:03:55 srv kernel: SCSI device sdj: drive cache: write through
Aug 24 19:03:55 srv kernel:  /dev/scsi/host9/bus0/target0/lun0: p1
Aug 24 19:03:55 srv kernel: Attached scsi disk sdj at scsi9, channel 0, id 0, lun 0
Aug 24 19:03:55 srv kernel: SCSI device sdk: 390622887 512-byte hdwr sectors (199999 MB)
Aug 24 19:03:55 srv kernel: SCSI device sdk: drive cache: write through
Aug 24 19:03:55 srv kernel:  /dev/scsi/host12/bus0/target0/lun0: p1
Aug 24 19:03:55 srv kernel: Attached scsi disk sdk at scsi12, channel 0, id 0, lun 0
Aug 24 19:03:55 srv kernel: SCSI device sdl: 390719855 512-byte hdwr sectors (200049 MB)
Aug 24 19:03:55 srv kernel: SCSI device sdl: drive cache: write through
Aug 24 19:03:55 srv kernel:  /dev/scsi/host13/bus0/target0/lun0: p1
Aug 24 19:03:55 srv kernel: Attached scsi disk sdl at scsi13, channel 0, id 0, lun 0
Aug 24 19:03:55 srv kernel: Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
Aug 24 19:03:55 srv kernel: Attached scsi generic sg1 at scsi1, channel 0, id 0, lun 0,  type 0
Aug 24 19:03:55 srv kernel: Attached scsi generic sg2 at scsi2, channel 0, id 0, lun 0,  type 0
Aug 24 19:03:55 srv kernel: Attached scsi generic sg3 at scsi3, channel 0, id 0, lun 0,  type 0
Aug 24 19:03:55 srv kernel: Attached scsi generic sg4 at scsi4, channel 0, id 0, lun 0,  type 0
Aug 24 19:03:55 srv kernel: Attached scsi generic sg5 at scsi5, channel 0, id 0, lun 0,  type 0
Aug 24 19:03:55 srv kernel: Attached scsi generic sg6 at scsi6, channel 0, id 0, lun 0,  type 0
Aug 24 19:03:55 srv kernel: Attached scsi generic sg7 at scsi7, channel 0, id 0, lun 0,  type 0
Aug 24 19:03:55 srv kernel: Attached scsi generic sg8 at scsi8, channel 0, id 0, lun 0,  type 0
Aug 24 19:03:55 srv kernel: Attached scsi generic sg9 at scsi9, channel 0, id 0, lun 0,  type 0
Aug 24 19:03:55 srv kernel: Attached scsi generic sg10 at scsi12, channel 0, id 0, lun 0,  type 0
Aug 24 19:03:55 srv kernel: Attached scsi generic sg11 at scsi13, channel 0, id 0, lun 0,  type 0
Aug 24 19:03:55 srv kernel: mice: PS/2 mouse device common for all mice


