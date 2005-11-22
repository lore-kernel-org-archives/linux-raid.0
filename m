From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: comparing FreeBSD to linux
Date: Tue, 22 Nov 2005 09:49:30 +0200
Message-ID: <5d96567b0511212349m5145b99cj97f8370266ceb220@mail.gmail.com>
References: <5d96567b0511210647n144bcda6p53d2eb9ba20a8ebc@mail.gmail.com>
	 <200511211733.jALHXGE01893@www.watkins-home.com>
	 <5d96567b0511211010j36f37f06we47f3b6edc35d314@mail.gmail.com>
	 <5d96567b0511211015w88b5005n696899abb43c356e@mail.gmail.com>
	 <20051121182024.GA4590@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051121182024.GA4590@havoc.gtf.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Guy <bugzilla@watkins-home.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>lspci
00:00.0 Host bridge: Intel Corp.: Unknown device 2588 (rev 05)
00:01.0 PCI bridge: Intel Corp.: Unknown device 2589 (rev 05)
00:02.0 VGA compatible controller: Intel Corp.: Unknown device 258a (rev 05)
00:1c.0 PCI bridge: Intel Corp.: Unknown device 2660 (rev 03)
00:1c.1 PCI bridge: Intel Corp.: Unknown device 2662 (rev 03)
00:1e.0 PCI bridge: Intel Corp. 82801BA/CA/DB PCI Bridge (rev d3)
00:1f.0 ISA bridge: Intel Corp.: Unknown device 2640 (rev 03)
00:1f.1 IDE interface: Intel Corp.: Unknown device 266f (rev 03)
00:1f.2 IDE interface: Intel Corp.: Unknown device 2652 (rev 03)
00:1f.3 SMBus: Intel Corp.: Unknown device 266a (rev 03)
01:00.0 PCI bridge: Intel Corp.: Unknown device 032c (rev 09)
01:00.1 PIC: Intel Corp.: Unknown device 0326 (rev 09)
03:00.0 Ethernet controller: Broadcom Corporation: Unknown device 1659 (rev 11)
04:00.0 Ethernet controller: Broadcom Corporation: Unknown device 1659 (rev 11)

.config
...
#
# SCSI low-level drivers
#
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_SCSI_SATA=y
# CONFIG_SCSI_SATA_AHCI is not set
# CONFIG_SCSI_SATA_SVW is not set
CONFIG_SCSI_ATA_PIIX=y
# CONFIG_SCSI_SATA_NV is not set
CONFIG_SCSI_SATA_PROMISE=y
# CONFIG_SCSI_SATA_QSTOR is not set
# CONFIG_SCSI_SATA_SX4 is not set
CONFIG_SCSI_SATA_SIL=y
# CONFIG_SCSI_SATA_SIS is not set
# CONFIG_SCSI_SATA_ULI is not set
# CONFIG_SCSI_SATA_VIA is not set
# CONFIG_SCSI_SATA_VITESSE is not set

...

i am using a supermicro board.
sata controler is onboard. I know that when i use a controller such as 3ware
that "hides" the disks and export scsi disks i have much less cpu.
cpu is xeon 3.0 GHZ.
this is the storage information from dmesg.

ata1: SATA max UDMA/133 cmd 0xE900 ctl 0xEA02 bmdma 0xED00 irq 10
ata2: SATA max UDMA/133 cmd 0xEB00 ctl 0xEC02 bmdma 0xED08 irq 10
ata1: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4673 85:7c69 86:3e01 87:4663 88:207f
ata1: dev 0 ATA, max UDMA/133, 490234752 sectors: lba48
ata1: dev 0 configured for UDMA/133
scsi0 : ata_piix
ata2: dev 0 cfg 49:2f00 82:7c6b 83:7f09 84:4673 85:7c69 86:3e01 87:4663 88:207f
ata2: dev 0 ATA, max UDMA/133, 490234752 sectors: lba48
ata2: dev 0 configured for UDMA/133
scsi1 : ata_piix
  Vendor: ATA       Model: Maxtor 7L250S0    Rev: BANC
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: Maxtor 7L250S0    Rev: BANC
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sda: drive cache: write back
 /dev/scsi/host0/bus0/target0/lun0: p1 p2 p3
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sdb: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 490234752 512-byte hdwr sectors (251000 MB)
SCSI device sdb: drive cache: write back
 /dev/scsi/host1/bus0/target0/lun0: p1 p2 p3
Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
Attached scsi generic sg1 at scsi1, channel 0, id 0, lun 0,  type 0
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard on isa0060/serio0
i2c /dev entries driver
md: linear personality registered as nr 1
md: raid0 personality registered as nr 2
md: raid1 personality registered as nr 3
md: raid5 personality registered as nr 4

On 11/21/05, Jeff Garzik <jgarzik@pobox.com> wrote:
> On Mon, Nov 21, 2005 at 10:15:11AM -0800, Raz Ben-Jehuda(caro) wrote:
> > Well , i have tested the disk with a new tester i have written. it seems that
> > the ata driver causes the high cpu and not raid.
>
> Which drivers are you using?  lspci and kernel .config?
>
>         Jeff
>
>
>
>


--
Raz
