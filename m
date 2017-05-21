From: <jan.weber@volny.cz>
Subject: =?utf-8?q?Fwd=3A_Re=3A_Promise_Technology_FakeRAID?=
Date: Mon, 22 May 2017 00:12:54 +0200
Message-ID: <20170522001254.BD8293E0@volny.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As I was recomended to send my question to this address, I do:


> Re From: NeilBrown <neilb@suse.com>

>
On Mon, May 15 2017, jan.weber@volny.cz wrote:

> Sorry to interrupt you.

I'm sorry, but I don't provide private consulting for free.
Please post your question to linux-raid@vger.kernel.org
(you will need to make sure the email only contains text, no html
component).

NeilBrown

>
> I need to assemble and get data from FakeRAID 5 originaly build on Windows 7 64 OS form 4 disk. 
> But the system failed, and I have to save the data. I cannot start the array neither with mdadm neither the dmraid. 
> The FakeRAID is managed by AMD RAID controller:
>
> 00:11.0 RAID bus controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 SATA Controller [RAID5 mode] (rev 40)
>         Subsystem: ASRock Incorporation SB7x0/SB8x0/SB9x0 SATA Controller [RAID5 mode]
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 32
>         Interrupt: pin A routed to IRQ 19
>         NUMA node: 0
>         Region 0: I/O ports at f040 [size=8]
>         Region 1: I/O ports at f030 [size=4]
>         Region 2: I/O ports at f020 [size=8]
>         Region 3: I/O ports at f010 [size=4]
>         Region 4: I/O ports at f000 [size=16]
>         Region 5: Memory at feb0b000 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [70] SATA HBA v1.0 InCfgSpace
>         Capabilities: [a4] PCI Advanced Features
>                 AFCap: TP+ FLR+
>                 AFCtrl: FLR-
>                 AFStatus: TP-
>         Kernel driver in use: ahci
>         Kernel modules: ahci
>
> The mdadm --examine /dev/sda [bcd] gives nothing,  
> but on the disks themselves, there is a 32256 byte area before the end of each disk 
> with some kind of “metadata” saying that the system is Promise Technology:
>
> /dev/sda
> 2baa146e200  50 72 6f 6d 69 73 65 20  54 65 63 68 6e 6f 6c 6f  |Promise Technolo|
> 2baa146e210  67 79 2c 20 49 6e 63 2e  00 00 02 00 87 a1 58 58  |gy, Inc.......XX|
> 2baa146e220  41 f6 00 00 87 a1 58 58  41 f6 01 01 00 d3 d2 d1  |A.....XXA.......|
> 2baa146e230  d0 cf ce cd cc cb ca c9  c8 c7 c6 c5 c4 c3 c2 c1  |................|
> 2baa146e240  c0 bf be bd bc bb ba b9  b8 b7 b6 b5 b4 b3 b2 b1  |................|
> 2baa146e250  b0 af ae ad ac ab aa a9  a8 a7 a6 a5 a4 a3 a2 a1  |................|

> /dev/sdb
> 2baa146e200  50 72 6f 6d 69 73 65 20  54 65 63 68 6e 6f 6c 6f  |Promise Technolo|
> 2baa146e210  67 79 2c 20 49 6e 63 2e  00 00 02 00 87 a1 58 58  |gy, Inc.......XX|
> 2baa146e220  34 f8 01 00 87 a1 58 58  34 f8 01 01 00 d3 d2 d1  |4.....XX4.......|
> 2baa146e230  d0 cf ce cd cc cb ca c9  c8 c7 c6 c5 c4 c3 c2 c1  |................|
> 2baa146e240  c0 bf be bd bc bb ba b9  b8 b7 b6 b5 b4 b3 b2 b1  |................|
> 2baa146e250  b0 af ae ad ac ab aa a9  a8 a7 a6 a5 a4 a3 a2 a1  |................|

> /dev/sdc
> 2baa146e200  50 72 6f 6d 69 73 65 20  54 65 63 68 6e 6f 6c 6f  |Promise Technolo|
> 2baa146e210  67 79 2c 20 49 6e 63 2e  00 00 02 00 88 a1 58 58  |gy, Inc.......XX|
> 2baa146e220  46 fa 02 00 88 a1 58 58  46 fa 01 01 00 d3 d2 d1  |F.....XXF.......|
> 2baa146e230  d0 cf ce cd cc cb ca c9  c8 c7 c6 c5 c4 c3 c2 c1  |................|
> 2baa146e240  c0 bf be bd bc bb ba b9  b8 b7 b6 b5 b4 b3 b2 b1  |................|
> 2baa146e250  b0 af ae ad ac ab aa a9  a8 a7 a6 a5 a4 a3 a2 a1  |................|

> /dev/sdd
> 2baa146e200  50 72 6f 6d 69 73 65 20  54 65 63 68 6e 6f 6c 6f  |Promise Technolo|
> 2baa146e210  67 79 2c 20 49 6e 63 2e  00 00 02 00 88 a1 58 58  |gy, Inc.......XX|
> 2baa146e220  59 fc 03 00 88 a1 58 58  59 fc 01 01 00 d3 d2 d1  |Y.....XXY.......|
> 2baa146e230  d0 cf ce cd cc cb ca c9  c8 c7 c6 c5 c4 c3 c2 c1  |................|
> 2baa146e240  c0 bf be bd bc bb ba b9  b8 b7 b6 b5 b4 b3 b2 b1  |................|
> 2baa146e250  b0 af ae ad ac ab aa a9  a8 a7 a6 a5 a4 a3 a2 a1  |................|
>
>
> I have also found in that area the name of the array : “pole” :
>
> /dev/sda
> 2baa146e440  07 02 01 00 25 01 f8 00  00 00 01 00 07 04 02 00  |....%...........|
> 2baa146e450  25 01 f9 00 00 00 02 00  07 06 03 00 25 01 fa 00  |%...........%...|
> 2baa146e460  00 00 03 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 2baa146e470  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 2baa146e490  00 00 00 00 70 6f 6c 65  00 00 00 00 00 00 00 00  |....pole........|
> 2baa146e4a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 2baa146e4d0  00 00 00 00 00 00 00 03  ff ff ff ff ff ff ff ff  |................|
> 2baa146e4e0  01 01 01 00 00 00 01 00  04 00 00 00 00 08 00 00  |................|
> 2baa146e4f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

> /dev/sdb
> 2baa146e440  07 02 01 00 25 01 f8 00  00 00 01 00 07 04 02 00  |....%...........|
> 2baa146e450  25 01 f9 00 00 00 02 00  07 06 03 00 25 01 fa 00  |%...........%...|
> 2baa146e460  00 00 03 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 2baa146e470  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 2baa146e490  00 00 00 00 70 6f 6c 65  00 00 00 00 00 00 00 00  |....pole........|
> 2baa146e4a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 2baa146e4d0  00 00 00 00 00 00 00 03  ff ff ff ff ff ff ff ff  |................|
> 2baa146e4e0  01 01 01 00 00 00 01 00  04 00 00 00 00 08 00 00  |................|
> 2baa146e4f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

> /dev/sdc
> 2baa146e440  07 02 01 00 25 01 f8 00  00 00 01 00 07 04 02 00  |....%...........|
> 2baa146e450  25 01 f9 00 00 00 02 00  07 06 03 00 25 01 fa 00  |%...........%...|
> 2baa146e460  00 00 03 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 2baa146e470  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 2baa146e490  00 00 00 00 70 6f 6c 65  00 00 00 00 00 00 00 00  |....pole........|
> 2baa146e4a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 2baa146e4d0  00 00 00 00 00 00 00 03  ff ff ff ff ff ff ff ff  |................|
> 2baa146e4e0  01 01 01 00 00 00 01 00  04 00 00 00 00 08 00 00  |................|
> 2baa146e4f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

> /dev/sdd
> 2baa146e440  07 02 01 00 25 01 f8 00  00 00 01 00 07 04 02 00  |....%...........|
> 2baa146e450  25 01 f9 00 00 00 02 00  07 06 03 00 25 01 fa 00  |%...........%...|
> 2baa146e460  00 00 03 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 2baa146e470  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 2baa146e490  00 00 00 00 70 6f 6c 65  00 00 00 00 00 00 00 00  |....pole........|
> 2baa146e4a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 2baa146e4d0  00 00 00 00 00 00 00 03  ff ff ff ff ff ff ff ff  |................|
> 2baa146e4e0  01 01 01 00 00 00 01 00  04 00 00 00 00 08 00 00  |................|
> 2baa146e4f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>
>
> Please, can be the mdadm forced to read the metadata form indicated area, or how can be this kind of FakeRAID accesed? 
>
> I was sucessful with various kind of “unrecognized” arrays telling the mdadm the guesed configuration 
> included the chunk size and raid level. But with this FakeRAID I can do nothing. 
>
> Thank for any answer
>
> dr. Weber
