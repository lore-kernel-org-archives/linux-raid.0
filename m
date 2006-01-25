From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Re: Problems with multiple Promise SATA150 TX4 cards
Date: Wed, 25 Jan 2006 11:15:04 +1100
Message-ID: <43D6C308.5040603@nighthawkrad.net>
References: <Pine.LNX.4.44.0601240132560.32305-100000@coffee.psychology.mcmaster.ca> <43D5EF58.9010807@wasp.net.au> <43D62B4F.1080505@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D62B4F.1080505@nighthawkrad.net>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christopher Smith wrote:
> Brad Campbell wrote:
>> Can you send an lspci -vv please? I did have some strange problems 
>> with the BIOS setting up weird timing modes on some of the cards. This 
>> did not present a reliability problem for me, just performance however.
> 
> I attached lspci output to my original post.  I have also included it on 
> the end of this one (with a slight difference regarding which slots the 
> cards were in, but that makes no difference to the problem).

Oops, forgot to attach lspci output - that's what you get for posting 
just before bed :).

[root@terminus ~]# lspci -vv
00:00.0 Host bridge: Intel Corporation E7501 Memory Controller Hub (rev 01)
         Subsystem: Intel Corporation E7501 Memory Controller Hub
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Capabilities: [40] Vendor Specific Information

00:02.0 PCI bridge: Intel Corporation E7500/E7501 Hub Interface B 
PCI-to-PCI Bridge (rev 01) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 64
         Bus: primary=00, secondary=01, subordinate=03, sec-latency=0
         I/O behind bridge: 0000a000-0000bfff
         Memory behind bridge: fc400000-fc6fffff
         Prefetchable memory behind bridge: ff300000-ff5fffff
         Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:03.0 PCI bridge: Intel Corporation E7500/E7501 Hub Interface C 
PCI-to-PCI Bridge (rev 01) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 64
         Bus: primary=00, secondary=04, subordinate=06, sec-latency=0
         I/O behind bridge: 0000c000-0000cfff
         Memory behind bridge: fc700000-fc9fffff
         Prefetchable memory behind bridge: ff600000-ff8fffff
         Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:1d.0 USB Controller: Intel Corporation 82801CA/CAM USB (Hub #1) (rev 
02) (prog-if 00 [UHCI])
         Subsystem: Gateway 2000: Unknown device 891f
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 209
         Region 4: I/O ports at ec00 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801CA/CAM USB (Hub #2) (rev 
02) (prog-if 00 [UHCI])
         Subsystem: Gateway 2000: Unknown device 891f
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 217
         Region 4: I/O ports at e880 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801CA/CAM USB (Hub #3) (rev 
02) (prog-if 00 [UHCI])
         Subsystem: Gateway 2000: Unknown device 891f
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin C routed to IRQ 169
         Region 4: I/O ports at e800 [size=32]

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 42) (prog-if 
00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Bus: primary=00, secondary=07, subordinate=07, sec-latency=32
         I/O behind bridge: 0000d000-0000dfff
         Memory behind bridge: fca00000-feafffff
         Prefetchable memory behind bridge: ff900000-ff9fffff
         Secondary status: 66Mhz- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801CA LPC Interface Controller 
(rev 02)
         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801CA Ultra ATA Storage 
Controller (rev 02) (prog-if 8a [Master SecP PriP])
         Subsystem: Gateway 2000: Unknown device 891f
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 169
         Region 0: I/O ports at <unassigned>
         Region 1: I/O ports at <unassigned>
         Region 2: I/O ports at <unassigned>
         Region 3: I/O ports at <unassigned>
         Region 4: I/O ports at ffa0 [size=16]
         Region 5: Memory at 88000000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corporation 82801CA/CAM SMBus Controller (rev 02)
         Subsystem: Gateway 2000: Unknown device 891f
         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin B routed to IRQ 0
         Region 4: I/O ports at 0540 [size=32]

01:1c.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04) (prog-if 
20 [IO(X)-APIC])
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Region 0: Memory at fc6ff000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [50] PCI-X non-bridge device.
                 Command: DPERE- ERO- RBC=0 OST=0
                 Status: Bus=1 Dev=28 Func=0 64bit+ 133MHz+ SCD- USC-, 
DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

01:1d.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 
04) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 64, Cache Line Size 10
         Bus: primary=01, secondary=02, subordinate=02, sec-latency=48
         I/O behind bridge: 0000a000-0000afff
         Memory behind bridge: fc400000-fc4fffff
         Prefetchable memory behind bridge: 
00000000ff300000-00000000ff300000
         Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         Capabilities: [50] PCI-X bridge device.
                 Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, 
SRD- Freq=0
                 Status: Bus=1 Dev=29 Func=0 64bit+ 133MHz+ SCD- USC-, 
SCO-, SRD-
                 : Upstream: Capacity=65535, Commitment Limit=65535
                 : Downstream: Capacity=65535, Commitment Limit=65535

01:1e.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04) (prog-if 
20 [IO(X)-APIC])
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Region 0: Memory at fc6fe000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [50] PCI-X non-bridge device.
                 Command: DPERE- ERO- RBC=0 OST=0
                 Status: Bus=1 Dev=30 Func=0 64bit+ 133MHz+ SCD- USC-, 
DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

01:1f.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 
04) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 64, Cache Line Size 10
         Bus: primary=01, secondary=03, subordinate=03, sec-latency=64
         I/O behind bridge: 0000b000-0000bfff
         Memory behind bridge: fc500000-fc5fffff
         Prefetchable memory behind bridge: 
00000000ff400000-00000000ff400000
         Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         Capabilities: [50] PCI-X bridge device.
                 Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, 
SRD- Freq=3
                 Status: Bus=1 Dev=31 Func=0 64bit+ 133MHz+ SCD- USC-, 
SCO-, SRD-
                 : Upstream: Capacity=65535, Commitment Limit=65535
                 : Downstream: Capacity=65535, Commitment Limit=65535

02:02.0 Mass storage controller: Promise Technology, Inc. PDC20318 
(SATA150 TX4) (rev 02)
         Subsystem: Promise Technology, Inc. PDC20318 (SATA150 TX4)
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (1000ns min, 4500ns max), Cache Line Size 10
         Interrupt: pin A routed to IRQ 177
         Region 0: I/O ports at ac00 [size=64]
         Region 1: I/O ports at a880 [size=16]
         Region 2: I/O ports at a800 [size=128]
         Region 3: Memory at fc4ff000 (32-bit, non-prefetchable) [size=4K]
         Region 4: Memory at fc4c0000 (32-bit, non-prefetchable) [size=128K]
         Expansion ROM at fc4f8000 [disabled] [size=16K]
         Capabilities: [60] Power Management version 2
                 Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

03:02.0 Ethernet controller: Intel Corporation 82544GC Gigabit Ethernet 
Controller (LOM) (rev 02)
         Subsystem: Gateway 2000: Unknown device 891f
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (63750ns min), Cache Line Size 10
         Interrupt: pin A routed to IRQ 201
         Region 0: Memory at fc5e0000 (64-bit, non-prefetchable) [size=128K]
         Region 2: Memory at fc5c0000 (64-bit, non-prefetchable) [size=128K]
         Region 4: I/O ports at bc00 [size=32]
         Expansion ROM at fc5a0000 [disabled] [size=128K]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
         Capabilities: [e4] PCI-X non-bridge device.
                 Command: DPERE- ERO+ RBC=0 OST=0
                 Status: Bus=3 Dev=2 Func=0 64bit+ 133MHz+ SCD- USC-, 
DC=simple, DMMRBC=2, DMOST=0, DMCRS=1, RSCEM-
         Capabilities: [f0] Message Signalled Interrupts: 64bit+ 
Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000

04:1c.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04) (prog-if 
20 [IO(X)-APIC])
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Region 0: Memory at fc9ff000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [50] PCI-X non-bridge device.
                 Command: DPERE- ERO- RBC=0 OST=0
                 Status: Bus=4 Dev=28 Func=0 64bit+ 133MHz+ SCD- USC-, 
DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

04:1d.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 
04) (prog-if 00 [Normal decode])
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 64, Cache Line Size 10
         Bus: primary=04, secondary=05, subordinate=05, sec-latency=64
         Memory behind bridge: fc700000-fc7fffff
         Prefetchable memory behind bridge: 
00000000ff600000-00000000ff600000
         Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         Capabilities: [50] PCI-X bridge device.
                 Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, 
SRD- Freq=3
                 Status: Bus=4 Dev=29 Func=0 64bit+ 133MHz+ SCD- USC-, 
SCO-, SRD-
                 : Upstream: Capacity=65535, Commitment Limit=65535
                 : Downstream: Capacity=65535, Commitment Limit=65535

04:1e.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04) (prog-if 
20 [IO(X)-APIC])
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Region 0: Memory at fc9fe000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [50] PCI-X non-bridge device.
                 Command: DPERE- ERO- RBC=0 OST=0
                 Status: Bus=4 Dev=30 Func=0 64bit+ 133MHz+ SCD- USC-, 
DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

04:1f.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 
04) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 64, Cache Line Size 10
         Bus: primary=04, secondary=06, subordinate=06, sec-latency=64
         I/O behind bridge: 0000c000-0000cfff
         Memory behind bridge: fc800000-fc8fffff
         Prefetchable memory behind bridge: 
00000000ff700000-00000000ff700000
         Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         Capabilities: [50] PCI-X bridge device.
                 Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, 
SRD- Freq=0
                 Status: Bus=4 Dev=31 Func=0 64bit+ 133MHz+ SCD- USC-, 
SCO-, SRD-
                 : Upstream: Capacity=65535, Commitment Limit=65535
                 : Downstream: Capacity=65535, Commitment Limit=65535

06:03.0 Mass storage controller: Promise Technology, Inc. PDC20318 
(SATA150 TX4) (rev 02)
         Subsystem: Promise Technology, Inc. PDC20318 (SATA150 TX4)
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 96 (1000ns min, 4500ns max), Cache Line Size 90
         Interrupt: pin A routed to IRQ 185
         Region 0: I/O ports at cc00 [size=64]
         Region 1: I/O ports at c880 [size=16]
         Region 2: I/O ports at c800 [size=128]
         Region 3: Memory at fc8ff000 (32-bit, non-prefetchable) [size=4K]
         Region 4: Memory at fc8c0000 (32-bit, non-prefetchable) [size=128K]
         Expansion ROM at fc8f8000 [disabled] [size=16K]
         Capabilities: [60] Power Management version 2
                 Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

07:02.0 Mass storage controller: Promise Technology, Inc. PDC20318 
(SATA150 TX4) (rev 02)
         Subsystem: Promise Technology, Inc. PDC20318 (SATA150 TX4)
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 96 (1000ns min, 4500ns max), Cache Line Size 90
         Interrupt: pin A routed to IRQ 193
         Region 0: I/O ports at dc00 [size=64]
         Region 1: I/O ports at d480 [size=16]
         Region 2: I/O ports at d400 [size=128]
         Region 3: Memory at feafe000 (32-bit, non-prefetchable) [size=4K]
         Region 4: Memory at feaa0000 (32-bit, non-prefetchable) [size=128K]
         Expansion ROM at ff920000 [disabled] [size=16K]
         Capabilities: [60] Power Management version 2
                 Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

07:0c.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27) 
(prog-if 00 [VGA])
         Subsystem: Gateway 2000: Unknown device 891f
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping+ SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (2000ns min), Cache Line Size 10
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
         Region 1: I/O ports at d800 [size=256]
         Region 2: Memory at feaff000 (32-bit, non-prefetchable) [size=4K]
         Expansion ROM at ff900000 [disabled] [size=128K]
         Capabilities: [5c] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

[root@terminus ~]#

