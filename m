From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Determining which spindle is out of order
Date: Sat, 6 Nov 2010 14:58:25 -0500
Message-ID: <5C.4F.13137.C53B5DC4@cdptpa-omtalb.mail.rr.com>
References: <4CD57048.4020107@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD57048.4020107@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Phil Turmel' <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Phil Turmel
> Sent: Saturday, November 06, 2010 10:12 AM
> To: Leslie Rhorer
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Determining which spindle is out of order
> 
> On 11/06/2010 06:22 AM, Leslie Rhorer wrote:
> >
> >
> >> -----Original Message-----
> >> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> >> owner@vger.kernel.org] On Behalf Of Phil Turmel
> >> Sent: Wednesday, November 03, 2010 4:55 PM
> >> To: Nat Makarevitch
> >> Cc: linux-raid@vger.kernel.org
> >> Subject: Re: Determining which spindle is out of order
> >>
> >> On 11/3/2010 2:13 PM, Nat Makarevitch wrote:
> >>> Hi,
> >>>
> >>> After a spindle (physical hard disk, a "drive") failure in a "md" RAID
> >> array,
> >>> how can we know which spindle must be replaced?
> >>>
> >>> We want to avoid extracting a working spindle by mistakenly thinking
> it
> >> is the
> >>> faulty one...
> >>
> >> I wrote a little script that would tell me device name and serial
> number
> >> for each host port on my motherboard, along with anything else that
> lists
> >> a scsi host in sysfs.  Output like so:
> >>
> >> Controller device @ pci0000:00/0000:00:1c.1/0000:06:00.0 [ahci]
> >>   RAID bus controller: Marvell Technology Group Ltd. 88SE6145 SATA II
> PCI-
> >> E controller (rev a1)
> >>     host4: [Empty]
> >>     host5: /dev/sdd ATA WDC WD5000AAKS-7 {SN: WD-WMAWF1370668}
> >>     host6: [Empty]
> >>     host7: [Empty]
> >>     host8: [Empty]
> >> Controller device @ pci0000:00/0000:00:1f.1 [ata_piix]
> >>   IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller
> >> (rev 01)
> >>     host9: [Empty]
> >>     host10: [Empty]
> >> Controller device @ pci0000:00/0000:00:1f.2 [ahci]
> >>   SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) SATA AHCI
> >> Controller (rev 01)
> >>     host0: /dev/sda ATA ST31000333AS {SN: 9TE1LTW0}
> >>     host1: /dev/sdb ATA ST31000333AS {SN: 9TE1MAJT}
> >>     host2: /dev/sdc ATA ST31000333AS {SN: 9TE1MV1R}
> >>     host3: /dev/sr0 HL-DT-ST BD-RE GBW-H20L
> >>
> >> Shows me my empty ports, too.  As long as I keep my cables straight to
> my
> >> hot-swap bays, getting the right drive is a snap.
> >
> > 	I haven't had a chance to dig into the script, but it doesn't
> > produce any output when I run it on one of my servers, and on the other
> one
> > it produces errors on line 7, but otherwise seems to work.
> >
> 
> Thanks for the feedback.  The script only looks in sysfs for controllers
> implementing the scsi_host interface.  So it won't pick up anything using
> the legacy IDE interface.  If that's not the case on the first server, I'd
> like to see lspci -vvv for the controller in question.

	It's the same controller on both servers.  The motherboards are
different, although both are Asus motherboards hosting AMD Athlon 64 x 2
CPUs.  At the moment they are running different kernels.  The one that is
working is running 2.6.32-3-amd64, and the one that is not is running
2.6.26-2-amd64.  Below is the result from lspci on the failing system.

06:00.0 RAID bus controller: Silicon Image, Inc. SiI 3124 PCI-X Serial ATA
Controller (rev 02)
        Subsystem: Silicon Image, Inc. Device 7124
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping+ SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fdcff000 (64-bit, non-prefetchable) [size=128]
        Region 2: Memory at fdcf0000 (64-bit, non-prefetchable) [size=32K]
        Region 4: I/O ports at ac00 [size=16]
        Expansion ROM at fdc00000 [disabled] [size=512K]
        Capabilities: [64] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [40] PCI-X non-bridge device
                Command: DPERE- ERO+ RBC=512 OST=12
                Status: Dev=06:00.0 64bit+ 133MHz+ SCD- USC- DC=simple
DMMRBC=2048 DMOST=12 DMCRS=128 RSCEM- 266MHz- 533MHz-
        Capabilities: [54] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Kernel driver in use: sata_sil24
        Kernel modules: sata_sil24

