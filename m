From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Raid-0 speed
Date: Fri, 27 Aug 2004 19:35:02 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408272335.i7RNZ7323733@watkins-home.com>
References: <20040825211158.1242221a@vovapc.kpml.int>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040825211158.1242221a@vovapc.kpml.int>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The PCI bus vs slot confuses me.

My 32 bit, 33 Mhz cards can process 132 Mbytes/sec.
As I understand it, more than 1 PCI slot shares a single PCI bus.
How fast is the PCI bus?

This is from "lspci":
00:00.0 Host bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX Host bridge
(rev 03)
00:01.0 PCI bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev
03)
00:07.0 ISA bridge: Intel Corp. 82371AB/EB/MB PIIX4 ISA (rev 02)
00:07.1 IDE interface: Intel Corp. 82371AB/EB/MB PIIX4 IDE (rev 01)
00:07.2 USB Controller: Intel Corp. 82371AB/EB/MB PIIX4 USB (rev 01)
00:07.3 Bridge: Intel Corp. 82371AB/EB/MB PIIX4 ACPI (rev 02)
00:0d.0 SCSI storage controller: Adaptec AHA-2940U2/U2W
00:0e.0 SCSI storage controller: Adaptec AHA-2940U2/U2W
00:11.0 Ethernet controller: 3Com Corporation 3c905B 100BaseTX [Cyclone]
00:13.0 PCI bridge: Digital Equipment Corporation DECchip 21152 (rev 03)
01:00.0 VGA compatible controller: Texas Instruments TVP4020 [Permedia 2]
(rev 01)
02:0a.0 SCSI storage controller: Adaptec AHA-2940U2/U2W / 7890/7891
02:0e.0 SCSI storage controller: Adaptec AIC-7880U (rev 01)

Do I have 3 PCI buses?

Thanks,
Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Vladimir I. Umnov
Sent: Wednesday, August 25, 2004 1:12 PM
To: linux-raid@vger.kernel.org
Subject: Re: Raid-0 speed

> Also, doing a dd from 4 drives maxes out my read speed as per mdstat
> at 160MB/s (How? PCI is 133MB/s and according to lspci all my
> controllers are on the same bus). Does vmstat lie?
NO! PCI 2.3 can about 512 MB/s


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

