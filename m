From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Raid-0 speed
Date: Sat, 28 Aug 2004 10:05:01 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16687.52269.343555.986500@cse.unsw.edu.au>
References: <20040825211158.1242221a@vovapc.kpml.int>
	<200408272335.i7RNZ7323733@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy on Friday August 27
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 27, bugzilla@watkins-home.com wrote:
> The PCI bus vs slot confuses me.
> 
> My 32 bit, 33 Mhz cards can process 132 Mbytes/sec.
> As I understand it, more than 1 PCI slot shares a single PCI bus.
> How fast is the PCI bus?

Only one card can be active on any one buss at any one time.
However, a buss can (I believe) handle different speed cards and will
adjust it's speed to match the features of the card.

> 
> This is from "lspci":
> 00:00.0 Host bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX Host bridge
> (rev 03)
> 00:01.0 PCI bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev
> 03)
> 00:07.0 ISA bridge: Intel Corp. 82371AB/EB/MB PIIX4 ISA (rev 02)
> 00:07.1 IDE interface: Intel Corp. 82371AB/EB/MB PIIX4 IDE (rev 01)
> 00:07.2 USB Controller: Intel Corp. 82371AB/EB/MB PIIX4 USB (rev 01)
> 00:07.3 Bridge: Intel Corp. 82371AB/EB/MB PIIX4 ACPI (rev 02)
> 00:0d.0 SCSI storage controller: Adaptec AHA-2940U2/U2W
> 00:0e.0 SCSI storage controller: Adaptec AHA-2940U2/U2W
> 00:11.0 Ethernet controller: 3Com Corporation 3c905B 100BaseTX [Cyclone]
> 00:13.0 PCI bridge: Digital Equipment Corporation DECchip 21152 (rev 03)
> 01:00.0 VGA compatible controller: Texas Instruments TVP4020 [Permedia 2]
> (rev 01)
> 02:0a.0 SCSI storage controller: Adaptec AHA-2940U2/U2W / 7890/7891
> 02:0e.0 SCSI storage controller: Adaptec AIC-7880U (rev 01)
> 
> Do I have 3 PCI buses?

Yes.  One with IDE/USB/scsi/ethernet and a couple of bridges
One for the VGA controller (possibly AGP rather than PCI)
One for two more SCSI controllers.

NeilBrown
