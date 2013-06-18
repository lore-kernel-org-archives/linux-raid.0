From: Corey Hickey <bugfood-ml@fatooh.org>
Subject: Re: RAID 5: low sequential write performance?
Date: Mon, 17 Jun 2013 23:29:09 -0700
Message-ID: <51BFFE35.7060109@fatooh.org>
References: <51BCF46B.40704@fatooh.org> <20926.11718.556180.928129@tree.ty.sabi.co.uk> <51BEAF12.10909@fatooh.org> <51BF1BAC.9020701@hardwarefreak.com> <51BF43E6.4000900@fatooh.org> <51BFF58A.60602@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51BFF58A.60602@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2013-06-17 22:52, Stan Hoeppner wrote:
>>> (num_of_disks * 4KB) * stripe_cache_size
>>>
>>> In your case this would be
>>>
>>> (3 * 4KB) * 32768 = 384MB
>>
>> I'm actually seeing a bit more memory difference: 401-402 MB when going
>> from 256 to to 32768, on a mostly idle system, so maybe there's
>> something else coming into play.
> 
> 384MB = 402,653,184 bytes

:)

I think that's just a coincidence, but it's possible I'm measuring it
wrong. I just did "free -m" (without --si) immediately before and after
changing the cache size.


stripe_cache_size = 256
---
             total       used       free     shared    buffers     cached
Mem:         16083      13278       2805          0       1387       4028
-/+ buffers/cache:       7862       8221
Swap:            0          0          0
---


stripe_cache_size = 32768
---
             total       used       free     shared    buffers     cached
Mem:         16083      12876       3207          0       1387       4028
-/+ buffers/cache:       7461       8622
Swap:            0          0          0
---

The exact memory usage isn't really that important to me; I just
mentioned it.

> memory_consumed = system_page_size * nr_disks * stripe_cache_size
> 
> The current default, 256.  On i386/x86-64 platforms with default 4KB
> page size, this consumes 1MB memory per drive.  A 12 drive arrays eats
> 12MB.  Increase the default to 1024 and you now eat 4MB/drive.  A
> default kernel managing a 12 drive md/RAID6 array now eats 48MB just to
> manage the array, 96MB for a 24 drive RAID6.  This memory consumption is
> unreasonable for a default kernel.
> 
> Defaults do not exist to work optimally with your setup.  They exist to
> work reasonably well with all possible setups.

True, and I will grant you that I was not considering low-memory setups.
I wouldn't want the kernel to frivolously consume RAM either. In a choice
between getting the low performance I was seeing vs. spending the RAM,
though, I'd much rather spend the RAM. Now that I know I can tune that,
I'm happy enough; I was just surprised...

Thanks,
Corey
