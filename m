From: Lars Gaarden <lar-gaar@online.no>
Subject: Re: HighPoint Rocket 1540 hang driver load
Date: Thu, 22 Apr 2004 19:55:48 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40880724.3060600@online.no>
References: <40865AEC.8040604@online.no>	<1082561078.40869236f3c14@www.tastycake.net> <yw1xd66146fo.fsf@kth.se>	<1082641732.4087cd44b504f@www.tastycake.net> <yw1x7jw8qeff.fsf@kth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yw1x7jw8qeff.fsf@kth.se>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

M=E5ns Rullg=E5rd wrote:
> Nick Maynard <nick.maynard@alumni.doc.ic.ac.uk> writes:
>=20
>>The Rocket 1540 and the RocketRAID 1540 are different cards.  I am su=
re the
>>RocketRAID 1540 is a lovely card.  The Rocket 1540 is not, however.
>=20
> Apparently that is the case.  What is the exact PCI id and revision o=
f
> the chip used on the Rocket1540?  My Rocketraid 1540 reports as
> 1103:0008 (rev 07).
>=20

No chance distinguishing them based on PCI id/rev, it seems.
Here is the lspci -vvn for my Rocket1540.

00:08.0 Class 0104: 1103:0008 (rev 07)
         Subsystem: 1103:0001
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium=20
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (2000ns min, 2000ns max), cache line size 08
         Interrupt: pin A routed to IRQ 19
         Region 0: I/O ports at d000 [size=3D8]
         Region 1: I/O ports at cc00 [size=3D4]
         Region 2: I/O ports at c800 [size=3D8]
         Region 3: I/O ports at c400 [size=3D4]
         Region 4: I/O ports at c000 [size=3D256]
         Expansion ROM at dffa0000 [disabled] [size=3D128K]
         Capabilities: [60] Power Management version 2
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:08.1 Class 0104: 1103:0008 (rev 07)
         Subsystem: 1103:0001
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium=20
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (2000ns min, 2000ns max), cache line size 08
         Interrupt: pin A routed to IRQ 19
         Region 0: I/O ports at e800 [size=3D8]
         Region 1: I/O ports at e400 [size=3D4]
         Region 2: I/O ports at e000 [size=3D8]
         Region 3: I/O ports at dc00 [size=3D4]
         Region 4: I/O ports at d800 [size=3D256]
         Capabilities: [60] Power Management version 2
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
