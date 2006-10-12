From: Gordon Henderson <gordon@drogon.net>
Subject: MegaRaid problems..
Date: Thu, 12 Oct 2006 10:06:14 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0610120913480.11816@lion.drogon.net>
References: <200609241503.09808.Dexter.Filmore@gmx.de>
 <Pine.LNX.4.64.0609241829100.17345@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0609241829100.17345@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This might not be strictly on-topic here, but you may provide
enlightenment, as a lot of web searching hasn't helpmed me so-far )-:

A client has bought some Dell hardware - Dell 1950 1U server, 2 on-board
SATA drives connected to a Fusion MPT SAS controller. This works just
fine. The on-board drives are mirrored using s/w RAID, which is great and
just how I want it.

The server also has 2 x Dell PERC dual-port SAS Raid Cards which have LSI
MegaRaid chipssets on them. One cable from each raid card connect to half
of a Dell external disk array box - 15 500GB SATA drives with a SAS
backplane, one card has 8 drives, the other 7. I want to run the RAID
cards in JBOD mode, so I can use linux s/w RAID. A nice little package,
which takes up 4U of rack space in total. (although the disk box is f'ing
heavy!!!)

And this is where I'm a little frustrated! I've compiled up a custom
kernel, (which is what I always do for my servers - no modules, no initrd,
this is 2.6.18), and at boot time the dmesg output sees the drives in the
external enclosure, but does not associate them to sdX drives! The
underlying distro is Debian stable, but I doubt theres anything of issue
there.

ie.:

megasas: 00.00.03.01 Sun May 14 22:49:52 PDT 2006
megasas: 0x1028:0x0015:0x1028:0x1f01: bus 12:slot 14:func 0
ACPI: PCI Interrupt 0000:0c:0e.0[A] -> GSI 18 (level, low) -> IRQ 66
scsi0 : LSI Logic SAS based MegaRAID driver
  Vendor: DELL      Model: MD1000            Rev: A.00
  Type:   Enclosure                          ANSI SCSI revision: 05
  Vendor: ATA       Model: HDS725050KLA360   Rev: AB5A
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: HDS725050KLA360   Rev: AB5A
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: HDS725050KLA360   Rev: AB5A
  Type:   Direct-Access                      ANSI SCSI revision: 05

etc. and it's repeated for the 2nd card. I've never seen this behaviour
before - normally it sees the drives, then associated them to sdX devices
- which is exactly what it does for the internal 2 drives:

On the internal drives, it goes like:

Fusion MPT base driver 3.04.01
Copyright (c) 1999-2005 LSI Logic Corporation
Fusion MPT SAS Host driver 3.04.01
ACPI: PCI Interrupt 0000:02:08.0[A] -> GSI 64 (level, low) -> IRQ 74
mptbase: Initiating ioc0 bringup
ioc0: SAS1068: Capabilities={Initiator}
scsi2 : ioc0: LSISAS1068, FwRev=00062800h, Ports=1, MaxQ=511, IRQ=74
  Vendor: ATA       Model: WDC WD1600JS-75N  Rev: 2E04
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 312500000 512-byte hdwr sectors (160000 MB)
sda: Write Protect is off
sda: Mode Sense: 67 00 00 08
SCSI device sda: drive cache: write back
SCSI device sda: 312500000 512-byte hdwr sectors (160000 MB)
sda: Write Protect is off
sda: Mode Sense: 67 00 00 08
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 2:0:0:0: Attached scsi disk sda
sd 2:0:0:0: Attached scsi generic sg2 type 0

and the same for the 2nd drive, sdb.

# cat/proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD1000           Rev: A.00
  Type:   Enclosure                        ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD1000           Rev: A.00
  Type:   Enclosure                        ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD1600JS-75N Rev: 2E04
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 01 Lun: 00
  Vendor: ATA      Model: WDC WD1600JS-75N Rev: 2E04
  Type:   Direct-Access                    ANSI SCSI revision: 05

So it's a bit frustrating.

LUN support is enabled, and the boot-line is:

  auto BOOT_IMAGE=Linux ro root=901 max_luns=8

So if it's a LUN issue, then they ought to be being probed...

I'm wondering about things like the controllers needing some poking at the
BIOS level, but I've looked and there isn't a JBOD mode - only various
built-in RAID modes, so I've not created any RAID sets through the BIOS (I
want raid 6 on this box over all 15 drives)

I'm sure it's something dead obvious, so any clues would be appreciated!

Thanks,

Gordon
