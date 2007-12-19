From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Wed, 19 Dec 2007 14:18:48 -0500
Message-ID: <47696E98.8080103@tmr.com>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan> <Pine.GSO.4.64.0712191558290.1549@montezuma.acc.umu.se> <Pine.LNX.4.64.0712191002580.2468@p34.internal.lan> <476957A7.5010805@tmr.com> <Pine.LNX.4.64.0712191253180.2468@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712191253180.2468@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Mattias Wadenstein <maswan@acc.umu.se>, linux-raid@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids

Justin Piszcz wrote:
>
>
> On Wed, 19 Dec 2007, Bill Davidsen wrote:
>
>> Justin Piszcz wrote:
>>>
>>>
>>> On Wed, 19 Dec 2007, Mattias Wadenstein wrote:
>>>
>>>> On Wed, 19 Dec 2007, Justin Piszcz wrote:
>>>>
>>>>> ------
>>>>>
>>>>> Now to my setup / question:
>>>>>
>>>>> # fdisk -l /dev/sdc
>>>>>
>>>>> Disk /dev/sdc: 150.0 GB, 150039945216 bytes
>>>>> 255 heads, 63 sectors/track, 18241 cylinders
>>>>> Units = cylinders of 16065 * 512 = 8225280 bytes
>>>>> Disk identifier: 0x5667c24a
>>>>>
>>>>>   Device Boot      Start         End      Blocks   Id  System
>>>>> /dev/sdc1               1       18241   146520801   fd  Linux raid 
>>>>> autodetect
>>>>>
>>>>> ---
>>>>>
>>>>> If I use 10-disk RAID5 with 1024 KiB stripe, what would be the 
>>>>> correct start and end size if I wanted to make sure the RAID5 was 
>>>>> stripe aligned?
>>>>>
>>>>> Or is there a better way to do this, does parted handle this 
>>>>> situation better?
>>>>
>>>>> From that setup it seems simple, scrap the partition table and use 
>>>>> the 
>>>> disk device for raid. This is what we do for all data storage disks 
>>>> (hw raid) and sw raid members.
>>>>
>>>> /Mattias Wadenstein
>>>>
>>>
>>> Is there any downside to doing that?  I remember when I had to take 
>>> my machine apart for a BIOS downgrade when I plugged in the sata 
>>> devices again I did not plug them back in the same order, everything 
>>> worked of course but when I ran LILO it said it was not part of the 
>>> RAID set, because /dev/sda had become /dev/sdg and overwrote the MBR 
>>> on the disk, if I had not used partitions here, I'd have lost (or 
>>> more of the drives) due to a bad LILO run?
>>
>> As other posts have detailed, putting the partition on a 64k aligned 
>> boundary can address the performance problems. However, a poor choice 
>> of chunk size, cache_buffer size, or just random i/o in small sizes 
>> can eat up a lot of the benefit.
>>
>> I don't think you need to give up your partitions to get the benefit 
>> of alignment.
>>
>> -- 
>> Bill Davidsen <davidsen@tmr.com>
>> "Woe unto the statesman who makes war without a reason that will still
>> be valid when the war is over..." Otto von Bismark
>
> Hrmm..
>
> I am doing a benchmark now with:
>
> 6 x 400GB (SATA) / 256 KiB stripe with unaligned vs. aligned raid setup.
>
> unligned, just fdisk /dev/sdc, mkpartition, fd raid.
>  aligned, fdisk, expert, start at 512 as the off-set
>
> Per a Microsoft KB:
>
> Example of alignment calculations in kilobytes for a 256-KB stripe 
> unit size:
> (63 * .5) / 256 = 0.123046875
> (64 * .5) / 256 = 0.125
> (128 * .5) / 256 = 0.25
> (256 * .5) / 256 = 0.5
> (512 * .5) / 256 = 1
> These examples shows that the partition is not aligned correctly for a 
> 256-KB stripe unit size until the partition is created by using an 
> offset of 512 sectors (512 bytes per sector).
>
> So I should start at 512 for a 256k chunk size.
>
> I ran bonnie++ three consecutive times and took the average for the 
> unaligned, rebuilding the RAID5 now and then I will re-execute the 
> test 3 additional times and take the average of that.

I'm going to try another approach, I'll describe it when I get results 
(or not).

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


