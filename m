From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Some RAID levels do not support bitmap
Date: Tue, 12 Jun 2007 11:52:47 -0400
Message-ID: <466EC14F.1080501@tmr.com>
References: <Pine.LNX.4.64.0706111448500.19578@fbirervta.pbzchgretzou.qr>	<466DD7AF.7030107@tmr.com> <18029.56610.868907.654059@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18029.56610.868907.654059@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday June 11, davidsen@tmr.com wrote:
>   
>> Jan Engelhardt wrote:
>>     
>>> Hi,
>>>
>>>
>>> RAID levels 0 and 4 do not seem to like the -b internal. Is this 
>>> intentional? Runs 2.6.20.2 on i586.
>>> (BTW, do you already have a PAGE_SIZE=8K fix?)
>>>
>>> 14:47 ichi:/dev # mdadm -C /dev/md0 -l 4 -e 1.0 -b internal -n 2 /dev/ram[01]
>>> mdadm: RUN_ARRAY failed: Input/output error
>>> mdadm: stopped /dev/md0
>>> 14:47 ichi:/dev # mdadm -C /dev/md0 -l 0 -e 1.0 -b internal -n 2 /dev/ram[01]
>>> mdadm: RUN_ARRAY failed: Cannot allocate memory
>>> mdadm: stopped /dev/md0
>>>
>>> Right... md: bitmaps not supported for this level.
>>>   
>>>       
>> Bitmaps show what data has been modified but not written. For RAID-0 
>> there is no copy, therefore there can be no bitmap to show what "still 
>> needs to be updated." I would have thought that RAID-4 would support 
>> bitmaps, but maybe it was just never added because use of RAID-4 is 
>> pretty uncommon.
>>     
>
> "added late" rather than "never added".  2.6.21 supports bitmaps on
> RAID-4,  The patch is about 2 lines and would apply to 2.6.20 with no
> trouble.
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3d37890baa4ca962f8a6b77525b8f3d0698eee09
>
>
>   
>> BTW: RAID-4 seems to work fine with an external bitmap. Were you trying 
>> to do "internal?"
>>     
>
> I suspect you were using 2.6.21-rc6 or later?

No, the machine I had for trial was 2.6.15 with a few patches, none in 
RAID. Seemed to work just fine if I put the bitmap on an external 
device. Was that not as expected?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

