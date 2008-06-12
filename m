From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte Veliciraptors
Date: Thu, 12 Jun 2008 15:08:48 -0400
Message-ID: <48517440.6020905@tmr.com>
References: <alpine.DEB.1.10.0806071015110.23323@p34.internal.lan> <4850354A.8090503@tmr.com> <alpine.DEB.1.10.0806111647360.18136@p34.internal.lan> <alpine.DEB.1.10.0806111652550.18136@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0806111652550.18136@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Justin Piszcz wrote:
>
>
> On Wed, 11 Jun 2008, Justin Piszcz wrote:
>
>>
>>
>> On Wed, 11 Jun 2008, Bill Davidsen wrote:
>>
>>> Justin Piszcz wrote:
>>>> First, the original benchmarks with 6-SATA drives with fixed 
>>>> formatting, using
>>>> right justification and the same decimal point precision throughout:
>>>> http://home.comcast.net/~jpiszcz/20080607/raid-benchmarks-decimal-fix-and-right-justified/disks.html 
>>>> Now for for veliciraptors! Ever wonder what kind of speed is 
>>>> possible with
>>>> 3 disk, 4,5,6,7,8,9,10-disk RAID5s? I ran a loop to find out, each 
>>>> run is
>>>> executed three times and the average is taken of all three runs per 
>>>> each RAID5 disk set.
>>>>
>>>> In short? The 965 no longer does justice with faster drives, a new 
>>>> chipset
>>>> and motherboard are needed. After reading or writing to 4-5 
>>>> veliciraptors
>>>> it saturates the bus/965 chipset.
>>>
>>> This is very interesting, but a 16GB chunk size bears no 
>>> relationship to anything I would run in the real world, and I 
>>> suspect most people are in the same category.
>>
>> I based my bonnie++ test on:
>> http://everything2.org/?node_id=1479435
>>
>> So I could compare to his results.
>>
>> I use a 1024k (1MiB) with 16384 stripe, this offered the best overall 
>> read/write/rewrite performance AFAIK.
>
> 1024k chunk size (raid5 chunk size)
> echo 16384 > stripe_cache_size

Please don't explain any more, I'm confused enough already. I can't make 
those numbers match 16G no matter how I add them, either the contents of 
the column labeled "size:chunk size" isn't the size of the chunk, or you 
have a multiplier floating around that I don't see.  And you eliminated 
the degraded performance, since your stripe_cache_size is less than 
(raid5 chunk size)*(#disks), I would expect the reads in degraded mode 
to be dog slow because the don't fit in cache, even if 1024k is what I 
call chunk size and certainly not if chunk size is 16G.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


