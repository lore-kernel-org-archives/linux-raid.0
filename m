From: Hendrik Visage <hvisage@envisage.co.za>
Subject: Re: VT 8237 Support?
Date: Wed, 21 Jan 2004 10:24:04 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040121082404.GA11827@hvs.envisage.co.za>
References: <Pine.LNX.4.58.0401201207050.13886@wormwood.cs.yorku.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0401201207050.13886@wormwood.cs.yorku.ca>
To: Andrew Hogue <hogue@cs.yorku.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 20, 2004 at 12:11:45PM -0500, Andrew Hogue wrote:
> Hi,
> 
> I just noticed that there is a patch that supposedly enables the S-ATA
> support with this chipset for the latest kernels.

"stock standard" in 2.6.0

Using my MSI Neo K8T:

hvisage@swartes hvisage $ dmesg -s 128000|grep 8237
VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
sata_via version 0.11
ata1: SATA max UDMA/133 cmd 0xD800 ctl 0xD402 bmdma 0xC800 irq 10
ata2: SATA max UDMA/133 cmd 0xD000 ctl 0xCC02 bmdma 0xC808 irq 10
ata1: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 88:407f
ata1: dev 0 ATA, max UDMA/133, 234441648 sectors (lba48)
ata1: dev 0 configured for UDMA/133
scsi0 : sata_via
ata2: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 88:407f
ata2: dev 0 ATA, max UDMA/133, 234441648 sectors (lba48)
ata2: dev 0 configured for UDMA/133
scsi1 : sata_via
  Vendor: ATA       Model: ST3120026AS       Rev: 0.81
    Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: ST3120026AS       Rev: 0.81
    Type:   Direct-Access                      ANSI SCSI revision: 05
<etc.>

> Has anyone tried this patch?  How stable is libata for the VIA chipset...?

On 2.6.0 & 2.6.1 with the gentoo patches, I only have a single drive that
appears to be "problematic", but I suspect either heat or cabling troubles,
as it does the same on the Promise 20378 onboard controller.

Otherwise I can't complain yet.

HEndrik
