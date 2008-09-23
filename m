From: "Brian Rademacher" <rad@radfiles.net>
Subject: Re: exception Emask 0x0 SAct 0x1 / SErr 0x0 action 0x2 frozen
Date: Tue, 23 Sep 2008 14:59:47 -0600
Message-ID: <7842CAE4393A4005827A88307EB4E83B@909927SOSLA>
References: <3E6D0C24877245C3A5A327129A7B4CA7@909927SOSLA> <alpine.DEB.1.10.0809220404400.18908@p34.internal.lan> <5A4A9A3B0AAA4A20A33BC2D578F5F75F@909927SOSLA> <alpine.DEB.1.10.0809220828490.23159@p34.internal.lan> <5419A02543384E69AF2BA82FF6E66C14@909927SOSLA> <alpine.DEB.1.10.0809220903400.23159@p34.internal.lan> <4B1ABD0393EF40FFB0A12242FE8356AF@909927SOSLA> <alpine.DEB.1.10.0809220915470.23159@p34.internal.lan> <alpine.DEB.1.10.0809220926240.23159@p34.internal.lan> <e7510f760809231114y6cbaf13aqf7c63bd48a73c978@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e7510f760809231114y6cbaf13aqf7c63bd48a73c978@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gwendal Grignou <gwendal@google.com>, Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

I disabled NCQ and same thing...Just says DMA freeze instead of NCQ 
freeze...

----- Original Message ----- 
From: "Gwendal Grignou" <gwendal@google.com>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Cc: "Brian Rademacher" <rad@radfiles.net>; <linux-ide@vger.kernel.org>; 
<linux-raid@vger.kernel.org>; <linux-kernel@vger.kernel.org>
Sent: Tuesday, September 23, 2008 12:14 PM
Subject: Re: exception Emask 0x0 SAct 0x1 / SErr 0x0 action 0x2 frozen


> About ata1:0 problem, as reported in the bugzilla bug: I would try to
> disable NCQ to see if it helps. Your disks firmware might not fully
> support it.
>
> You can either add the parameter "libata.force=noncq" when loading
> your kernel, or set queue_depth to 1 for all the Seagate drives behind
> the Marvell MV88SX6081 controller.
>
> About ata5:0 , someone - in user space probably - is trying to do a
> SMART ENABLE operation, but the device ignores it. I don't know which
> device you are using, but I assume it does not support ATA SMART
> feature set. Timeout is an acceptable but not a nice way to answer, a
> cancel would have been better; check if there is a firmware upgrade
> for your device.
>
> Gwendal.
>
> On Mon, Sep 22, 2008 at 6:26 AM, Justin Piszcz <jpiszcz@lucidpixels.com> 
> wrote:
>> From Brian's earlier e-mail:
>>
>>> > I filed this kernel bug:
>>> > https://bugzilla.redhat.com/show_bug.cgi?id=462425
>>
>>
>> On Mon, 22 Sep 2008, Justin Piszcz wrote:
>>
>>> I could not agree more.
>>>
>>> CC'ing the relevant mailing lists to see if someone out there has any 
>>> idea
>>> what more we could do as this has been affecting you (more so than 
>>> myself,
>>> but I would still like to get some sort of resolution as well, as it 
>>> still
>>> happens to me too):
>>>
>>> Similar, but not the same issue:
>>>
>>> Sep 17 20:20:05 p34 kernel: [1422169.440538] ata5.00: exception Emask 
>>> 0x0
>>> SAct 0x0 SErr 0x0 action 0x6 frozen
>>> Sep 17 20:20:05 p34 kernel: [1422169.440549] ata5.00: cmd
>>> b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
>>> Sep 17 20:20:05 p34 kernel: [1422169.440551]          res
>>> 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> Sep 17 20:20:05 p34 kernel: [1422169.440556] ata5.00: status: { DRDY }
>>> Sep 17 20:20:05 p34 kernel: [1422169.440561] ata5: hard resetting link
>>> Sep 17 20:20:06 p34 kernel: [1422169.744980] ata5: SATA link up 3.0 Gbps
>>> (SStatus 123 SControl 300)
>>> Sep 17 20:20:06 p34 kernel: [1422169.770448] ata5.00: configured for
>>> UDMA/133
>>> Sep 17 20:20:06 p34 kernel: [1422169.770461] ata5: EH complete
>>>
>>> (2.6.23.3) above
>>>
>>> On Mon, 22 Sep 2008, Brian Rademacher wrote:
>>>
>>>> Works fine...Also works under heavy load with only 4 drives.  I could
>>>> only get it to fail by doing a raid resync with 4 drives, except for 
>>>> the
>>>> newer kernel, which dies pretty easily..
>>>>
>>>> What is really frustrating about it is that short of the bugzilla bug I
>>>> submitted, I don't know who would be willing to listen...A lot of the 
>>>> google
>>>> hits when searching "action 0x2 frozen" are related to a particular 
>>>> CDROM
>>>> drive, or general hardware failure.  I really don't think that is the 
>>>> case
>>>> here, but I bet most of the kernel people think the same thing, so they 
>>>> have
>>>> no reason to care...
>>>>
>>>>
>>>> Sent: Monday, September 22, 2008 7:04 AM
>>>> Subject: Re: Hardware RAID
>>>>
>>>>
>>>>> What about if you just 'stress' one drive?
>>>>>
>>>>> 1. dd if=/dev/sda of=/dev/null bs=1M &
>>>>> Does it do it?
>>>>> 2. Same thing for sdb?
>>>>>
>>>>> Justin.
>>>>>
>>>>> On Mon, 22 Sep 2008, Brian Rademacher wrote:
>>>>>
>>>>>> I killed smartd for testing.  Other than that, it seems entirely load
>>>>>> based. Anything disk intensive (backups, raid resync, a bunch of spam 
>>>>>> comes
>>>>>> in at once, etc.) makes it fail...
>>>>>>
>>>>>> Sent: Monday, September 22, 2008 6:29 AM
>>>>>> Subject: Re: Hardware RAID
>>>>>>
>>>>>>
>>>>>>> While the error happens for me as well it does NOT happen with that
>>>>>>> much consistency, if I were you, I would start testing different 
>>>>>>> kernels and
>>>>>>> run it in single user mode (or as close to it as you can) to see if 
>>>>>>> you can
>>>>>>> narrow down what is causing it, also boot knoppix and see if it 
>>>>>>> occurs-- ?
>>>>>>>
>>>>>>> Justin.
>>>>>>>
>>>>>>> On Mon, 22 Sep 2008, Brian Rademacher wrote:
>>>>>>>
>>>>>>>> Doesn't look like a very powerful RAID card, so I may pass on it. 
>>>>>>>> I
>>>>>>>> don't think it will have the BW to run as fast as the software RAID
>>>>>>>> currently does since it's only a 64bit/66mhz PCI slot...
>>>>>>>>
>>>>>>>> I hate to do the hardware RAID thing, but this error is killing me:
>>>>>>>> Sep 21 12:05:19 radfiles kernel: ata1.00: exception Emask 0x0 SAct
>>>>>>>> 0x1 SErr 0x0 action 0x2 frozen
>>>>>>>> Sep 21 12:32:12 radfiles kernel: ata1.00: exception Emask 0x0 SAct
>>>>>>>> 0x1 SErr 0x0 action 0x2 frozen
>>>>>>>> Sep 21 12:41:34 radfiles kernel: ata1.00: exception Emask 0x0 SAct
>>>>>>>> 0x1 SErr 0x0 action 0x2 frozen
>>>>>>>> Sep 21 12:58:22 radfiles kernel: ata1.00: exception Emask 0x0 SAct
>>>>>>>> 0x1 SErr 0x0 action 0x2 frozen
>>>>>>>> Sep 21 13:11:04 radfiles kernel: ata1.00: exception Emask 0x0 SAct
>>>>>>>> 0x1 SErr 0x0 action 0x2 frozen
>>>>>>>> Sep 21 13:23:55 radfiles kernel: ata1.00: exception Emask 0x0 SAct
>>>>>>>> 0x1 SErr 0x0 action 0x2 frozen
>>>>>>>> Sep 21 13:54:23 radfiles kernel: ata1.00: exception Emask 0x0 SAct
>>>>>>>> 0x1 SErr 0x0 action 0x2 frozen
>>>>>>>> Sep 21 15:15:04 radfiles kernel: ata1.00: exception Emask 0x0 SAct
>>>>>>>> 0x1 SErr 0x0 action 0x2 frozen
>>>>>>>> Sep 21 15:44:06 radfiles kernel: ata1.00: exception Emask 0x0 SAct
>>>>>>>> 0x1 SErr 0x0 action 0x2 frozen
>>>>>>>> Sep 21 21:15:12 radfiles kernel: ata1.00: exception Emask 0x0 SAct
>>>>>>>> 0x1 SErr 0x0 action 0x2 frozen
>>>>>>>>
>>>>>>>> And at this point, I can either regress to a 4 drive RAID and don't
>>>>>>>> update the kernel, or move forward with hardware...
>>>>>>>>
>>>>>>>> I don't see a fix coming any time soon, but maybe I'll try one of 
>>>>>>>> the
>>>>>>>> latest F10 kernels just to see if anything has changed...
>>>>>>>>
>>>>>>>>
>>>>>>>> ----- Original Message ----- From: "Justin Piszcz" Sent: Monday,
>>>>>>>> September 22, 2008 2:05 AM
>>>>>>>> Subject: Re: Hardware RAID
>>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On Sun, 21 Sep 2008, Brian Rademacher wrote:
>>>>>>>>>
>>>>>>>>>> The RAID gods must have been thinking about me.  My MB has one of
>>>>>>>>>> these funny slots and supports ZCR, so for the price I'm going to 
>>>>>>>>>> jump ship.
>>>>>>>>>> I would guess (and hope) this solves the problem, especially 
>>>>>>>>>> since I'll have
>>>>>>>>>> to reconstruct the entire array...
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> http://cgi.ebay.com/2113600-R-Adaptec-Serial-ATA-RAID-2025SA-Storage_W0QQitemZ250295938636QQihZ015QQcategoryZ167QQssPageNameZWDVWQQrdZ1QQcmdZViewItem
>>>>>>>>>
>>>>>>>>> Hm cool-- let me know how it goes.
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 

