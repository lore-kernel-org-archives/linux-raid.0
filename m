From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Veliciraptor HDD 3.0gbps but UDMA/100 on PCI-e controller?
Date: Thu, 3 Jul 2008 13:02:08 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0807031259300.11579@p34.internal.lan>
References: <alpine.DEB.1.10.0807030447040.12072@p34.internal.lan> <486CCB12.7040205@garzik.org> <alpine.DEB.1.10.0807030941510.30458@p34.internal.lan> <486CFC08.3000004@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <486CFC08.3000004@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 3 Jul 2008, Roger Heflin wrote:

> Justin Piszcz wrote:
>> 
>> 
>> On Thu, 3 Jul 2008, Jeff Garzik wrote:
>> 
>>> Justin Piszcz wrote:
>> 
>> 
>
> Well, given that pcie x1 is max 250MB/second, and a number of pcie cards are 
> not native (they have a pcie to pci converter between them), "dmidecode -vvv" 
> will give you more details on the actual layout of things, and given that I 
> have seen several devices actually run slower by having the ability to 
> oversubscribe the bandwidth that is available and seemingly actually run 
> slower because of this ability, that may have some bearing,    Ie 2 slower 
> disks may be faster than 2 fast disks on the pcie just because they don't 
> oversubscribe the interfere. And given that if there is a pci converter that 
> may lower the overall bandwidth even more, and cause the issue.   If this was 
> old style ethernet I would have though collisions, but it must just come down 
> to the arbitration setups not being carefully designed for high utilization, 
> and high interference between devices.
>
>                               Roger
>

I have ordered a couple 4 port boards (that are PCI-e x4), my next plan
of action to acquire > 600MiB/s is as follows:

Current:
Mobo: 6 drives (full speed)
Silicon Image (3 cards, 2 drives each)

Future:
Mobo: 6 drives (full speed)
Silicon Image (3 cards, 1 drive each)
Four Port Card in x16 slot (the 3 remaining drives)

This should in theory allow 1000 MiB/s..

--

# dmidecode -vvv
dmidecode: invalid option -- v

Assume you mean lspci:

05:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)
         Subsystem: Silicon Image, Inc. Device 7132
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 16
         Region 0: Memory at e0104000 (64-bit, non-prefetchable) [size=128]
         Region 2: Memory at e0100000 (64-bit, non-prefetchable) [size=16K]
         Region 4: I/O ports at 2000 [size=128]
         Expansion ROM at e0900000 [disabled] [size=512K]
         Capabilities: [54] Power Management version 2
                 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
         Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000
         Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00
                 DevCap: MaxPayload 1024 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 unlimited, L1 unlimited
                         ClockPM- Suprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
         Capabilities: [100] Advanced Error Reporting <?>
         Kernel driver in use: sata_sil24

