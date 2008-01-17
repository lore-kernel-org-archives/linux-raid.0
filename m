From: Jeff Garzik <jeff@garzik.org>
Subject: The SX4 challenge
Date: Wed, 16 Jan 2008 19:55:48 -0500
Message-ID: <478EA794.8080608@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux IDE mailing list <linux-ide@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux RAID list <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


Promise just gave permission to post the docs for their PDC20621 (i.e. 
SX4) hardware:
http://gkernel.sourceforge.net/specs/promise/pdc20621-pguide-1.2.pdf.bz2

joining the existing PDC20621 DIMM and PLL docs:
http://gkernel.sourceforge.net/specs/promise/pdc20621-pguide-dimm-1.6.pdf.bz2
http://gkernel.sourceforge.net/specs/promise/pdc20621-pguide-pll-ata-timing-1.2.pdf.bz2


So, the SX4 is now open.  Yay :)  I am hoping to talk Mikael into 
becoming the sata_sx4 maintainer, and finally integrating my 'new-eh' 
conversion in libata-dev.git.

But now is a good time to remind people how lame the sata_sx4 driver 
software really is -- and I should know, I wrote it.

The SX4 hardware, simplified, is three pieces:  XOR engine (for raid5), 
host<->board memcpy engine, and several ATA engines (and some helpful 
transaction sequencing features).  Data for each WRITE command is first 
copied to the board RAM, then the ATA engines DMA to/from the board RAM. 
  Data for each READ command is copied to board RAM via the ATA engines, 
then DMA'd across PCI to your host memory.

Therefore, while it is not hardware RAID, the SX4 provides all the 
pieces necessary to offload RAID1 and RAID5, and handle other RAID 
levels optimally.  RAID1 and 5 copies can be offloaded (provided all 
copies go to SX4-attached devices of course).  RAID5 XOR gen and 
checking can be offloaded, allowing the OS to see a single request, 
while the hardware processes a sequence of low-level requests sent in a 
batch.

This hardware presents an interesting challenge:  it does not really fit 
into software RAID (i.e. no RAID) /or/ hardware RAID categories.  The 
sata_sx4 driver presents the no-RAID configuration, while is terribly 
inefficient:

	WRITE:
		submit host DMA (copy to board)
		host DMA completion via interrupt
		submit ATA command
		ATA command completion via interrupt
	READ:
		submit ATA command
		ATA command completion via interrupt
		submit host DMA (copy from board)
		host DMA completion via interrupt

Thus, the "SX4 challenge" is a challenge to developers to figure out the 
most optimal configuration for this hardware, given the existing MD and 
DM work going on.

Now, it must be noted that the SX4 is not current-gen technology.  Most 
vendors have moved towards an "IOP" model, where the hw vendor puts most 
of their hard work into an ARM/MIPS firmware, running on an embedded 
chip specially tuned for storage purposes.  (ref "hptiop" and "stex" 
drivers, very very small SCSI drivers)

I know Dan Williams @ Intel is working on very similar issues on the IOP 
-- async memcpy, XOR offload, etc. -- and I am hoping that, due to that 
current work, some of the good ideas can be reused with the SX4.

Anyway...  it's open, it's interesting, even if it's not current-gen 
tech anymore.  You can probably find them on Ebay or in an 
out-of-the-way computer shop somewhere.

	Jeff



