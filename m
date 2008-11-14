From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: And again help on deciphering an error (continued)
Date: Fri, 14 Nov 2008 15:06:03 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811141505400.22451@p34.internal.lan>
References: <4907A5FA.7050903@rabbit.us> <491DC218.9010301@rabbit.us> <alpine.DEB.1.10.0811141456550.22161@p34.internal.lan> <491DDA43.4030600@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <491DDA43.4030600@sauce.co.nz>
Sender: linux-ide-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid <linux-raid@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 15 Nov 2008, Richard Scobie wrote:

> Justin Piszcz wrote:
>> 
>> 
>> On Fri, 14 Nov 2008, Peter Rabbitson wrote:
>> 
>>> Peter Rabbitson wrote:
>>> 
>>>> Hello,
>>>> 
>>>> I need help with understanding what is going on here
>>>> (full log):
>
> These posts might be worth sending to linux-ide.
>
> Regards,
>
> Richard
>

I have a whole bunch, but here is the last one:

[64894.610696] ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[64894.610703] ata9.00: irq_stat 0x00020002, device error via D2H FIS
[64894.610708] ata9.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[64894.610709]          res 51/04:00:34:cf:f3/00:00:00:f3:40/a3 Emask 0x1 (devic
e error)
[64894.610714] ata9.00: status: { DRDY ERR }
[64894.610718] ata9.00: error: { ABRT }
[64894.626437] ata9.00: configured for UDMA/100
[64894.626449] ata9: EH complete
[64894.626654] sd 8:0:0:0: [sdh] 586072368 512-byte hardware sectors (300069 MB)
[64894.637744] end_request: I/O error, dev sdh, sector 586067135
[64894.637759] md: super_written gets error=-5, uptodate=0
[64894.637762] raid5: Disk failure on sdh1, disabling device.
[64894.637763] raid5: Operation continuing on 9 devices.
[64894.638129] sd 8:0:0:0: [sdh] Write Protect is off
[64894.638131] sd 8:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[64894.638148] sd 8:0:0:0: [sdh] Write cache: enabled, read cache: enabled, does
n't support DPO or FUA

Justin.
