From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux Software RAID Bitmap Question
Date: Tue, 27 Feb 2007 22:00:32 -0500
Message-ID: <45E4F050.2090109@tmr.com>
References: <Pine.LNX.4.64.0702250903120.21821@p34.internal.lan>	<17890.24681.249414.635536@notabene.brown>	<45E46D7F.9000501@tmr.com> <17892.40143.389564.172608@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17892.40143.389564.172608@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday February 27, davidsen@tmr.com wrote:
>   
>> Neil Brown wrote:
>>     
>>> When md find a bad block (read failure) it either fixes it (by
>>> successfully over-writing the correct date) or fails the drive.
>>>
>>> The count of the times that this has happened is available via
>>>    /sys/block/mdX/md/errors
>>>   
>>>       
>> What kernel provides this? I have system running everything from 2.6.15 
>> to 2.6.20-get14, and there is no such file in any of them. There is a 
>> per-device errors file one level down, but that presumably wouldn't be 
>> in the superblock.
>>     
>
> Sorry, I did get that wrong.  As you say it is a per-device field:
>   /sys/block/mdX/md/dev-*/errors
>
> which makes sense because it is individual devices that get errors,
> not whole arrays.  And it *is* stored in the superblock for v1.  The
> superblock has a per-device section which is potentially different on
> each device,  The corrected-error count is stored there.
>
>   
OK, I can add...
>> Do I have to go from 0.90 to v1 or later superblocks to get this, and if 
>> so is that a safe thing to do?
>>     
>
> It is not currently easy to convert a v0.90 array to use v1
> superblocks.  I should put that on my todo list as it isn't
> conceptually hard.
Unfortunately the thing I'd like most is hard (RAID5E), but if/when the 
SB conversion is available I would give it a test drive.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

