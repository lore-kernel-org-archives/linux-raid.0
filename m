From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: And again help on deciphering an error (continued)
Date: Fri, 14 Nov 2008 15:12:02 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811141510470.22451@p34.internal.lan>
References: <4907A5FA.7050903@rabbit.us> <491DC218.9010301@rabbit.us> <alpine.DEB.1.10.0811141456550.22161@p34.internal.lan> <491DDA43.4030600@sauce.co.nz> <alpine.DEB.1.10.0811141505400.22451@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811141505400.22451@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid <linux-raid@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 14 Nov 2008, Justin Piszcz wrote:

>
>
> On Sat, 15 Nov 2008, Richard Scobie wrote:
>
>> Justin Piszcz wrote:
>>> 
>>> 
>>> On Fri, 14 Nov 2008, Peter Rabbitson wrote:
>>> 
>>>> Peter Rabbitson wrote:
>>>> 
>>>>> Hello,
>>>>> 
>>>>> I need help with understanding what is going on here
>>>>> (full log):
>> 
>> These posts might be worth sending to linux-ide.
>> 
>> Regards,
>> 
>> Richard
>> 
>
> I have a whole bunch, but here is the last one:

Here are some more:

Jul 14 05:54:55 p34 kernel: [478107.751877] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Jul 14 05:54:55 p34 kernel: [478107.751883] ata4.00: irq_stat 0x40000001
Jul 14 05:54:55 p34 kernel: [478107.751889] ata4.00: cmd 25/00:f8:08:b0:ee/00:00:22:00:00/e0 tag 0 dma 126976 in
Jul 14 05:54:55 p34 kernel: [478107.751890]          res 51/40:f8:47:b0:ee/00:00:22:00:00/e0 Emask 0x9 (media error)
Jul 14 05:54:55 p34 kernel: [478107.751895] ata4.00: status: { DRDY ERR }
Jul 14 05:54:55 p34 kernel: [478107.751898] ata4.00: error: { UNC }
Jul 14 05:54:55 p34 kernel: [478107.773836] ata4.00: configured for UDMA/133
Jul 14 05:54:55 p34 kernel: [478107.773845] ata4: EH complete
Jul 14 05:54:55 p34 kernel: [478107.844912] sd 3:0:0:0: [sdd] 586072368 512-byte hardware sectors (300069 MB)
Jul 14 05:54:55 p34 kernel: [478107.846321] sd 3:0:0:0: [sdd] Write Protect is off
Jul 14 05:54:55 p34 kernel: [478107.846325] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Jul 14 05:54:55 p34 kernel: [478107.849297] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Oct 12 09:25:22 p34 kernel: [1434196.959129] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Oct 12 09:25:30 p34 kernel: [1434196.959137] ata6.00: irq_stat 0x40000001
Oct 12 09:25:30 p34 kernel: [1434196.959142] ata6.00: cmd 25/00:00:00:af:ee/00:02:22:00:00/e0 tag 0 dma 262144 in
Oct 12 09:25:30 p34 kernel: [1434196.959144]          res 51/40:00:4f:b0:ee/00:02:22:00:00/e0 Emask 0x9 (media error)
Oct 12 09:25:30 p34 kernel: [1434196.959149] ata6.00: status: { DRDY ERR }
Oct 12 09:25:30 p34 kernel: [1434196.959152] ata6.00: error: { UNC }
Oct 12 09:25:30 p34 kernel: [1434196.999110] ata6.00: configured for UDMA/133
Oct 12 09:25:30 p34 kernel: [1434196.999144] ata6: EH complete
Oct 12 09:25:30 p34 kernel: [1434203.096157] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Oct 12 09:25:30 p34 kernel: [1434203.096165] ata6.00: irq_stat 0x40000001
Oct 12 09:25:30 p34 kernel: [1434203.096171] ata6.00: cmd 25/00:00:00:af:ee/00:02:22:00:00/e0 tag 0 dma 262144 in
Oct 12 09:25:30 p34 kernel: [1434203.096172]          res 51/40:00:4f:b0:ee/00:02:22:00:00/e0 Emask 0x9 (media error)
Oct 12 09:25:30 p34 kernel: [1434203.096177] ata6.00: status: { DRDY ERR }
Oct 12 09:25:30 p34 kernel: [1434203.096181] ata6.00: error: { UNC }
Oct 12 09:25:30 p34 kernel: [1434203.104811] ata6.00: configured for UDMA/133
Oct 12 09:25:30 p34 kernel: [1434203.104819] ata6: EH complete

Nov  9 09:25:19 p34 kernel: [ 3686.460568] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Nov  9 09:25:19 p34 kernel: [ 3686.460574] ata4.00: irq_stat 0x40000001
Nov  9 09:25:19 p34 kernel: [ 3686.460579] ata4.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Nov  9 09:25:19 p34 kernel: [ 3686.460580]          res 51/10:00:34:cf:f3/00:00:00:f3:40/a3 Emask 0x81 (invalid argument)
Nov  9 09:25:19 p34 kernel: [ 3686.460585] ata4.00: status: { DRDY ERR }
Nov  9 09:25:19 p34 kernel: [ 3686.460589] ata4.00: error: { IDNF }
Nov  9 09:25:24 p34 kernel: [ 3691.461173] ata4.00: qc timeout (cmd 0xec)
Nov  9 09:25:24 p34 kernel: [ 3691.461183] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x5)
Nov  9 09:25:24 p34 kernel: [ 3691.461187] ata4.00: revalidation failed (errno=-5)
Nov  9 09:25:24 p34 kernel: [ 3691.461192] ata4: hard resetting link
Nov  9 09:25:24 p34 kernel: [ 3691.766178] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Nov  9 09:25:24 p34 kernel: [ 3691.803834] ata4.00: configured for UDMA/133
Nov  9 09:25:24 p34 kernel: [ 3691.803846] end_request: I/O error, dev sdd, sector 586067135
Nov  9 09:25:24 p34 kernel: [ 3691.803849] md: super_written gets error=-5, uptodate=0
Nov  9 09:25:24 p34 kernel: [ 3691.803853] raid5: Disk failure on sdd1, disabling device.
Nov  9 09:25:24 p34 kernel: [ 3691.803854] raid5: Operation continuing on 8 devices.

Nov 12 01:22:28 p34 kernel: [64894.610696] ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Nov 12 01:22:28 p34 kernel: [64894.610703] ata9.00: irq_stat 0x00020002, device error via D2H FIS
Nov 12 01:22:28 p34 kernel: [64894.610708] ata9.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Nov 12 01:22:28 p34 kernel: [64894.610709]          res 51/04:00:34:cf:f3/00:00:00:f3:40/a3 Emask 0x1 (device error)
Nov 12 01:22:28 p34 kernel: [64894.610714] ata9.00: status: { DRDY ERR }
Nov 12 01:22:28 p34 kernel: [64894.610718] ata9.00: error: { ABRT }
Nov 12 01:22:28 p34 kernel: [64894.626437] ata9.00: configured for UDMA/100
Nov 12 01:22:28 p34 kernel: [64894.626449] ata9: EH complete
Nov 12 01:22:28 p34 kernel: [64894.626654] sd 8:0:0:0: [sdh] 586072368 512-byte hardware sectors (300069 MB)
Nov 12 01:22:28 p34 kernel: [64894.637744] end_request: I/O error, dev sdh, sector 586067135
Nov 12 01:22:28 p34 kernel: [64894.637759] md: super_written gets error=-5, uptodate=0
Nov 12 01:22:28 p34 kernel: [64894.637762] raid5: Disk failure on sdh1, disabling device.
Nov 12 01:22:28 p34 kernel: [64894.637763] raid5: Operation continuing on 9 devices.
Nov 12 01:22:28 p34 kernel: [64894.638129] sd 8:0:0:0: [sdh] Write Protect is off
Nov 12 01:22:28 p34 kernel: [64894.638131] sd 8:0:0:0: [sdh] Mode Sense: 00 3a 00 00
Nov 12 01:22:28 p34 kernel: [64894.638148] sd 8:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA


