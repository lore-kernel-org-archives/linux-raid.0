From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: raid1: All my data completely vanished into the void
Date: Wed, 28 Dec 2005 00:17:56 -0500
Message-ID: <200512280017.56562.mlaks@verizon.net>
References: <200512272340.48483.mlaks@verizon.net> <43B2157F.8030505@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <43B2157F.8030505@h3c.com>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 27 December 2005 11:33 pm, you wrote:

> In short: it *definitely* should *not* have come back with what you saw.
> I have no clue why this happened, all I can say is that I use md on
> around 10 business critical production machines in exactly the way you
> describe, and I have not seen this (though I've seen the failure modes I
> described!).
I myself have been using md, mdadm for more than a year in multiple machines. 
I am at a loss. The only difference is now SATA drives with SATA controllers.

>
> Are you positively sure that nothing else weird could have been going
> on? Some layer that remaps drive names? funky hardware? write caching
> capable of holding 3GB before writing out? Write caching of some sort is
> actually my best guess.
  9.8Gb actually! same 3.2 Gb sent to each of the 3 raid 1 drive arrays to 
really  give them a workout, sent with rsync.

Only kicker is that this setup is Sata disks using the kernel sata drivers as 
modules. I have always used Pata drives before.

 

I get no kernel error messages at all. 
dmesg from the reboot tells me

First for the modules that come with linux: and the devices

libata version 1.02 loaded.
sata_via version 0.20
ACPI: PCI interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 185
sata_via(0000:00:0f.0): routed to hard irq line 10
ata1: SATA max UDMA/133 cmd 0xC000 ctl 0xB802 bmdma 0xA800 irq 185
ata2: SATA max UDMA/133 cmd 0xB400 ctl 0xB002 bmdma 0xA808 irq 185
ata1: dev 0 cfg 49:2f00 82:746b 83:7f01 84:4023 85:7469 86:3c01 87:4023 
88:407f
ata1: dev 0 ATA, max UDMA/133, 781422768 sectors: lba48
ata1: dev 0 configured for UDMA/133
scsi1 : sata_via
ata2: dev 0 cfg 49:2f00 82:746b 83:7f01 84:4023 85:7469 86:3c01 87:4023 
88:407f
ata2: dev 0 ATA, max UDMA/133, 781422768 sectors: lba48
ata2: dev 0 configured for UDMA/133
scsi2 : sata_via
  Vendor: ATA       Model: WDC WD4000YR-01P  Rev: 01.0
 Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sde: 781422768 512-byte hdwr sectors (400088 MB)
SCSI device sde: drive cache: write back
 /dev/scsi/host1/bus0/target0/lun0: unknown partition table
Attached scsi disk sde at scsi1, channel 0, id 0, lun 0
  Vendor: ATA       Model: WDC WD4000YR-01P  Rev: 01.0
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdf: 781422768 512-byte hdwr sectors (400088 MB)
SCSI device sdf: drive cache: write back
 /dev/scsi/host2/bus0/target0/lun0: unknown partition table
Attached scsi disk sdf at scsi2, channel 0, id 0, lun 0

Notice the unknown partition table:

Then for the data from dmesg about the devices mounted on the highpoint 
rocketraid 1520 which used the proprietary hpt37x2.ko kernel module that I 
added to initrd and /lib/modules/`uname -r`/kernel/drivers/ide or whatever

hpt37x2: no version for "scsi_remove_host" found: kernel tainted.
HPT37x2 RAID Controller driver

SCSI device sda: 781422767 512-byte hdwr sectors (400088 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
 /dev/scsi/host0/bus0/target0/lun0: p1
SCSI device sda: 781422767 512-byte hdwr sectors (400088 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
 /dev/scsi/host0/bus0/target0/lun0: p1
SCSI device sdb: 781422767 512-byte hdwr sectors (400088 MB)
sdb: asking for cache data failed
sdb: assuming drive cache: write through
 /dev/scsi/host0/bus0/target1/lun0: p1
SCSI device sdb: 781422767 512-byte hdwr sectors (400088 MB)
sdb: asking for cache data failed
sdb: assuming drive cache: write through
 /dev/scsi/host0/bus0/target1/lun0: p1
SCSI device sdc: 781422767 512-byte hdwr sectors (400088 MB)
sdc: asking for cache data failed
sdc: assuming drive cache: write through
 /dev/scsi/host0/bus0/target2/lun0: p1
SCSI device sdc: 781422767 512-byte hdwr sectors (400088 MB)
sdc: asking for cache data failed
sdc: assuming drive cache: write through
 /dev/scsi/host0/bus0/target2/lun0: p1
SCSI device sdd: 781422767 512-byte hdwr sectors (400088 MB)
sdd: asking for cache data failed
sdd: assuming drive cache: write through
 /dev/scsi/host0/bus0/target3/lun0: p1
SCSI device sdd: 781422767 512-byte hdwr sectors (400088 MB)
sdd: asking for cache data failed
sdd: assuming drive cache: write through
 /dev/scsi/host0/bus0/target3/lun0: p1

> If there's no extra data to explain this, I'm at a loss.

I wish I knew what else to check. I just bought 16 SATA drives for 2 servers!

>
> Anyone else?
>
> -Mike
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
