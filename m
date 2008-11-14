From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: And again help on deciphering an error (continued)
Date: Fri, 14 Nov 2008 14:57:42 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811141456550.22161@p34.internal.lan>
References: <4907A5FA.7050903@rabbit.us> <491DC218.9010301@rabbit.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <491DC218.9010301@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Fri, 14 Nov 2008, Peter Rabbitson wrote:

> Peter Rabbitson wrote:
>> Hello,
>>
>> I need help with understanding what is going on here
>> (full log):
>>
>>
>> Oct 27 11:33:41 Arzamas kernel: ata6.00: exception Emask 0x10 SAct 0x0
>> SErr 0x80000 action 0xe frozen
>> Oct 27 11:33:41 Arzamas kernel: ata6.00: irq_stat 0x01100010, PHY RDY
>> changed
>> Oct 27 11:33:41 Arzamas kernel: ata6: SError: { 10B8B }
>> Oct 27 11:33:41 Arzamas kernel: ata6.00: cmd
>> ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>> Oct 27 11:33:41 Arzamas kernel: res 06/37:00:00:00:00/00:00:00:00:06/00
>> Emask 0x12 (ATA bus error)
>> Oct 27 11:33:41 Arzamas kernel: ata6.00: error: { IDNF ABRT }
>> Oct 27 11:33:41 Arzamas kernel: ata6: hard resetting link
>> Oct 27 11:33:46 Arzamas kernel: ata6: SATA link up 3.0 Gbps (SStatus 123
>> SControl 0)
>> Oct 27 11:33:46 Arzamas kernel: ata6.00: configured for UDMA/100
>> Oct 27 11:33:46 Arzamas kernel: ata6: EH complete
>> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] 488397168 512-byte
>> hardware sectors (250059 MB)
>> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Write Protect is off
>> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
>> Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Write cache: enabled,
>> read cache: enabled, doesn't support DPO or FUA
>> Oct 27 11:33:46 Arzamas kernel: end_request: I/O error, dev sde, sector
>> 488166955
>
> The saga continues. After replacing the drive (and I didn't make a
> mistake as the serial numbers don't match) I got _exaclty_ the same
> error a week later. I have replaced the cable for the drive in question,
> will see what happens. The controller is:
>
> 02:03.0 Mass storage controller: Silicon Image, Inc. SiI 3124 PCI-X
> Serial ATA Controller (rev 02)
> 	Subsystem: Silicon Image, Inc. SiI 3124 PCI-X Serial ATA Controller
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr+
> Stepping+ SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 25
> 	Region 0: Memory at fc5fd800 (64-bit, non-prefetchable) [size=128]
> 	Region 2: Memory at fc5f0000 (64-bit, non-prefetchable) [size=32K]
> 	Region 4: I/O ports at b000 [size=16]
> 	Expansion ROM at fc480000 [disabled] [size=512K]
> 	Capabilities: [64] Power Management version 2
> 		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
> 	Capabilities: [40] PCI-X non-bridge device
> 		Command: DPERE- ERO+ RBC=512 OST=12
> 		Status: Dev=ff:1f.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048
> DMOST=12 DMCRS=128 RSCEM- 266MHz- 533MHz-
> 	Capabilities: [54] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
> Enable-
> 		Address: 0000000000000000  Data: 0000
> 	Kernel driver in use: sata_sil24
>
>
> Anyone has any bright ideas?

Hm, someone else also has similar problems, maybe we ought to buy new hw or
something, I have the same/similar issue as you.

BTW, after that error, if you re-run a short/long test, do they succeed or
hang (never complete)?

Justin.

