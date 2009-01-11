From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Corrupt data - RAID sata_sil 3114 chip
Date: Sat, 10 Jan 2009 18:43:00 -0600
Message-ID: <49694094.60501@shaw.ca>
References: <200901032104.15242.bs@q-leap.de> <496436C4.4070305@kernel.org> <49643FD4.9080100@shaw.ca> <200901071632.02264.bs@q-leap.de> <49693E08.3050209@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49693E08.3050209@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
Cc: Bernd Schubert <bs@q-leap.de>, Tejun Heo <tj@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Justin Piszcz <jpiszcz@lucidpixels.com>, debian-user@lists.debian.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Robert Hancock wrote:
> Bernd Schubert wrote:
>>>> I think it's something related to setting up the PCI side of things.
>>>> There have been hints that incorrect CLS setting was the culprit and I
>>>> tried thte combinations but without any success and unfortunately the
>>>> problem wasn't reproducible with the hardware I have here.  :-(
>>> As far as the cache line size register, the only thing the documentation
>>> says it controls _directly_ is "With the SiI3114 as a master, initiating
>>> a read transaction, it issues PCI command Read Multiple in place, when
>>> empty space in its FIFO is larger than the value programmed in this
>>> register."
>>>
>>> The interesting thing is the commit (log below) that added code to the
>>> driver to check the PCI cache line size register and set up the FIFO
>>> thresholds:
>>>
>>>    2005/03/24 23:32:42-05:00 Carlos.Pardo
>>>    [PATCH] sata_sil: Fix FIFO PCI Bus Arbitration
>>>
>>>    This patch set default values for the FIFO PCI Bus Arbitration to
>>>    avoid data corruption. The root cause is due to our PCI bus master
>>>    handling mismatch with the chipset PCI bridge during DMA xfer (write
>>>    data to the device). The patch is to setup the DMA fifo threshold so
>>>    that there is no chance for the DMA engine to change protocol. We 
>>> have
>>>    seen this problem only on one motherboard.
>>>
>>>    Signed-off-by: Silicon Image Corporation <cpardo@siliconimage.com>
>>>    Signed-off-by: Jeff Garzik <jgarzik@pobox.com>
>>> 4
>>> What the code's doing is setting the FIFO thresholds, used to assign
>>> priority when requesting a PCI bus read or write operation, based on the
>>> cache line size somehow. It seems to be trusting that the chip's cache
>>> line size register has been set properly by the BIOS. The kernel should
>>> know what the cache line size is but AFAIK normally only sets it when
>>> the driver requests MWI. This chip doesn't support MWI, but it looks
>>> like pci_set_mwi would fix up the CLS register as a side effect..
>>>
>>>> Anyways, there was an interesting report that updating the BIOS on the
>>>> controller fixed the problem.
>>>>
>>>>   http://bugzilla.kernel.org/show_bug.cgi?id=10480
>>>>
>>>> Taking "lspci -nnvvvxxx" output of before and after such BIOS update
>>>> will shed some light on what's really going on.  Can you please try
>>>> that?
>>> Yes, that would be quite interesting.. the output even with the current
>>> BIOS would be useful to see if the BIOS set some stupid cache line size
>>> value..
>>
>> Unfortunately I can't update the bios/firmware of the Sil3114 
>> directly, it is onboard and the firmware is included into the 
>> mainboard bios. There is not the most recent bios version installed, 
>> but when we initially had the problems, we first tried a bios update, 
>> but it didn't help.
> 
> Well if one is really adventurous one can sometimes use some BIOS image 
> editing tools to install an updated flash image for such integrated 
> chips into the main BIOS image. This is definitely for advanced users 
> only though..
> 
>>
>> As suggested by Robert, I'm presently trying to figure out the 
>> corruption pattern. Actually our test tool easily provides these data. 
>> Unfortunately, it so far didn't report anything, although the reiserfs 
>> already got corrupted. Might be my colleague, who wrote that tool, 
>> recently broke something (as it is the second time, it doesn't report 
>> corruptions), in the past it did work reliably. Please give me a few 
>> more days...
>>
>>
>> 03:05.0 Mass storage controller [0180]: Silicon Image, Inc. SiI 3114 
>> [SATALink/SATARaid] Serial ATA Controller [1095:3114] (rev 02)
>>         Subsystem: Silicon Image, Inc. SiI 3114 SATALink Controller 
>> [1095:3114]
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
>> ParErr- Stepping- SERR+ FastB2B-
>>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
>> >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 64, Cache Line Size: 64 bytes
> 
> Well, 64 seems quite reasonable, so that doesn't really give any more 
> useful information.
> 
> I'm CCing Carlos Pardo at Silicon Image who wrote the patch above, maybe 
> he has some insight.. Carlos, we have a case here where Bernd is 
> reporting seeing corruption on an integrated SiI3114 on a Tyan Thunder 
> K8S Pro (S2882) board, AMD 8111 chipset. This is reportedly occurring 
> only with certain Seagate drives. Do you have any insight into this 
> problem, in particular as far as whether the problem worked around in 
> the patch mentioned above might be related?
> 
> There are apparently some reports of issues on NVidia chipsets as well, 
> though I don't have any details at hand.

Well, Carlos' email bounces, so much for that one. Anyone have any other 
contacts at Silicon Image?

> 
>>         Interrupt: pin A routed to IRQ 19
>>         Region 0: I/O ports at bc00 [size=8]
>>         Region 1: I/O ports at b880 [size=4]
>>         Region 2: I/O ports at b800 [size=8]
>>         Region 3: I/O ports at ac00 [size=4]
>>         Region 4: I/O ports at a880 [size=16]
>>         Region 5: Memory at feafec00 (32-bit, non-prefetchable) [size=1K]
>>         Expansion ROM at fea00000 [disabled] [size=512K]
>>         Capabilities: [60] Power Management version 2
>>                 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                 Status: D0 PME-Enable- DSel=0 DScale=2 PME-
>> 00: 95 10 14 31 07 01 b0 02 02 00 80 01 10 40 00 00
>> 10: 01 bc 00 00 81 b8 00 00 01 b8 00 00 01 ac 00 00
>> 20: 81 a8 00 00 00 ec af fe 00 00 00 00 95 10 14 31
>> 30: 00 00 a0 fe 60 00 00 00 00 00 00 00 0a 01 00 00
>> 40: 02 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
>> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 60: 01 00 22 06 00 40 00 64 00 00 00 00 00 00 00 00
>> 70: 00 00 60 00 d0 d0 09 00 00 00 60 00 00 00 00 00
>> 80: 03 00 00 00 22 00 00 00 00 00 00 00 c8 93 7f ef
>> 90: 00 00 00 09 ff ff 00 00 00 00 00 19 00 00 00 00
>> a0: 01 31 15 65 dd 62 dd 62 92 43 92 43 09 40 09 40
>> b0: 01 21 15 65 dd 62 dd 62 92 43 92 43 09 40 09 40
>> c0: 84 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>
>>
>>
>> Cheers,
>> Bernd
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

