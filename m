From: Steve Bergman <sbergman27@gmail.com>
Subject: Re: Is this expected RAID10 performance?
Date: Fri, 7 Jun 2013 06:25:24 -0500
Message-ID: <CAO9HMNG2M7KDke3A0c06G47kvVWgssu7ur47BN=0goc2ELDhKQ@mail.gmail.com>
References: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com>
	<CAAMCDefb7TFXDOD7=aK-FjHVCQXMdiQKdz=CFJT4+q9rKR3KGA@mail.gmail.com>
	<CAGqvA+svdBvWTbwnzQjoHWQz6n0iEaAZzmu-EqKqdPx-AK0Zkg@mail.gmail.com>
	<CAO9HMNE3F-ZN0fQmHW7yz2JLRFaUqSYSaVpZe3KaXuaLMojV8w@mail.gmail.com>
	<20130607165236.60ac7451@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130607165236.60ac7451@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I don't have the source link handy, but it was an industry white
paper. (I doubt you'll get it changed.)

There does seem to be some interface limitation here. Running "dd
if=/dev/sdX of=/dev/null bs=512k" simultaneously for various
combinations of drives gives me:

Port   A alone : 155MByte/s
Ports A & B   :  105MByte/s per drive
Ports A, B & C: 105MBytes/s per drive for A & B. 155MBytess's for C.
Ports A, B, C & D: 105MBytes/s per drive

So there's an aggregate limitation of ~1.7Gbit/s per port pair, with
A&B and C&D making up the pairs.

More information on the interfaces:

From lshw:

description: IDE interface
product: 5 Series/3400 Series Chipset 4 port SATA IDE Controller
vendor: Intel Corporation
physical id: 1f.2
bus info: pci@0000:00:1f.2
logical name: scsi0
logical name: scsi1
version: 05
width: 32 bits
clock: 66MHz
capabilities: ide pm bus_master cap_list emulated
configuration: driver=ata_piix latency=0
resources: irq:20 ioport:dca0(size=8) ioport:dc90(size=4)
ioport:dca8(size=8) ioport:dc94(size=4) ioport:dcc0(size=16)
ioport:dcd0(size=16)


From dmesg:

ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)


From lspci:

IDE interface: Intel Corporation 5 Series/3400 Series Chipset 4 port
SATA IDE Controller (rev 05) (prog-if 8f [Master SecP SecO PriP PriO])
Subsystem: Dell Device 02a4
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 20
Region 0: I/O ports at dca0 [size=8]
Region 1: I/O ports at dc90 [size=4]
Region 2: I/O ports at dca8 [size=8]
Region 3: I/O ports at dc94 [size=4]
Region 4: I/O ports at dcc0 [size=16]
Region 5: I/O ports at dcd0 [size=16]
Capabilities: [70] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [b0] PCI Advanced Features
AFCap: TP+ FLR+
 AFCtrl: FLR-
 AFStatus: TP-
 Kernel driver in use: ata_piix
 Kernel modules: ata_generic, pata_acpi, ata_piix

-Steve Bergman
