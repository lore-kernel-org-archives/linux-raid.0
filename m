From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID 5 performance issue.
Date: Thu, 4 Oct 2007 12:19:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710041218100.25506@p34.internal.lan>
References: <20071003105321.06943824@zeus.pccl.info>
 <Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
 <20071003211910.439ded54@alpha.digital-domain.net>
 <72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
 <20071004150831.6edbf926@zeus.pccl.info> <Pine.LNX.4.64.0710041009150.8275@p34.internal.lan>
 <20071004153656.16e10f9e@zeus.pccl.info> <Pine.LNX.4.64.0710041038400.8275@p34.internal.lan>
 <20071004160316.5332a370@zeus.pccl.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071004160316.5332a370@zeus.pccl.info>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Clayton <andrew@digital-domain.net>
Cc: David Rees <drees76@gmail.com>, Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 4 Oct 2007, Andrew Clayton wrote:

> On Thu, 4 Oct 2007 10:39:09 -0400 (EDT), Justin Piszcz wrote:
>
>
>> What type (make/model) of the drives?
>
> The drives are 250GB  Hitachi Deskstar 7K250 series ATA-6 UDMA/100
>
>> True, the controller may not be able to do it either.
>>
>> What types of disks/controllers again?
>
> The RAID disks are currently connected to a Silicon Image PCI card are
> configured as a software RAID 5
>
> 03:04.0 RAID bus controller: Silicon Image, Inc. SiI 3124 PCI-X Serial ATA Controller (rev 02)
>        Subsystem: Silicon Image, Inc. Unknown device 7124
>        Flags: bus master, stepping, 66MHz, medium devsel, latency 64, IRQ 16
>        Memory at feafec00 (64-bit, non-prefetchable) [size=128]
>        Memory at feaf0000 (64-bit, non-prefetchable) [size=32K]
>        I/O ports at bc00 [size=16]
>        Expansion ROM at fea00000 [disabled] [size=512K]
>        Capabilities: [64] Power Management version 2
>        Capabilities: [40] PCI-X non-bridge device
>        Capabilities: [54] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
>
>
> The problem originated  when the disks where connected to the on board
> Silicon Image 3114 controller.
>
>> Justin.
>
> Andrew
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

7K250

http://www.itreviews.co.uk/hardware/h912.htm

http://techreport.com/articles.x/8362
"The T7K250 also supports Native Command Queuing (NCQ)."

You need to enable AHCI in order to reap the benefits though.

Justin.
