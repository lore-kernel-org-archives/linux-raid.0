From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Where is the performance bottleneck?
Date: Wed, 31 Aug 2005 13:38:46 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0508311334090.16574@diagnostix.dwd.de>
References: <Pine.LNX.4.61.0508291811480.24072@diagnostix.dwd.de>
 <20050829202529.GA32214@midnight.suse.cz> <Pine.LNX.4.61.0508301919250.25574@diagnostix.dwd.de>
 <20050831071126.GA7502@midnight.ucw.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050831071126.GA7502@midnight.ucw.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 31 Aug 2005, Vojtech Pavlik wrote:

> On Tue, Aug 30, 2005 at 08:06:21PM +0000, Holger Kiehl wrote:
>>>> How does one determine the PCI-X bus speed?
>>>
>>> Usually only the card (in your case the Symbios SCSI controller) can
>>> tell. If it does, it'll be most likely in 'dmesg'.
>>>
>> There is nothing in dmesg:
>>
>>    Fusion MPT base driver 3.01.20
>>    Copyright (c) 1999-2004 LSI Logic Corporation
>>    ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 24 (level, low) -> IRQ 217
>>    mptbase: Initiating ioc0 bringup
>>    ioc0: 53C1030: Capabilities={Initiator,Target}
>>    ACPI: PCI Interrupt 0000:02:04.1[B] -> GSI 25 (level, low) -> IRQ 225
>>    mptbase: Initiating ioc1 bringup
>>    ioc1: 53C1030: Capabilities={Initiator,Target}
>>    Fusion MPT SCSI Host driver 3.01.20
>>
>>> To find where the bottleneck is, I'd suggest trying without the
>>> filesystem at all, and just filling a large part of the block device
>>> using the 'dd' command.
>>>
>>> Also, trying without the RAID, and just running 4 (and 8) concurrent
>>> dd's to the separate drives could show whether it's the RAID that's
>>> slowing things down.
>>>
>> Ok, I did run the following dd command in different combinations:
>>
>>    dd if=/dev/zero of=/dev/sd?1 bs=4k count=5000000
>
> I think a bs of 4k is way too small and will cause huge CPU overhead.
> Can you try with something like 4M? Also, you can use /dev/full to avoid
> the pre-zeroing.
>
Ok, I now use the following command:

       dd if=/dev/full of=/dev/sd?1 bs=4M count=4883

Here the results for all 8 disks in parallel:

       /dev/sdc1 24.957257 MB/s
       /dev/sdd1 25.290177 MB/s
       /dev/sde1 25.046711 MB/s
       /dev/sdf1 26.369777 MB/s
       /dev/sdg1 24.080695 MB/s
       /dev/sdh1 25.008803 MB/s
       /dev/sdi1 24.202202 MB/s
       /dev/sdj1 24.712840 MB/s

A little bit faster but not much.

Holger

