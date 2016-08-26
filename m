From: Doug Dumitru <doug@easyco.com>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Fri, 26 Aug 2016 13:04:15 -0700
Message-ID: <CAFx4rwTekSp6mNUtt7UfEmTi93Fu+25rYLGrp63XwoxYvwV54g@mail.gmail.com>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <20160824010241.GC57645@kernel.org> <CAJvUf-DXC6AtO3a=ox2XOinpRWgAv5NMPkRWAcsSZmBggF5_Dw@mail.gmail.com>
 <83f67452-9f09-2d6f-f82a-77d83309f618@websitemanagers.com.au> <CAJvUf-DJJ4ZqR+kS6SCqgaq9_MXuQxFwyHJbv7YH7hVx5xbBRQ@mail.gmail.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-DJJ4ZqR+kS6SCqgaq9_MXuQxFwyHJbv7YH7hVx5xbBRQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Aug 26, 2016 at 6:01 AM, Matt Garman <matthew.garman@gmail.com> wrote:
> On Thu, Aug 25, 2016 at 6:39 PM, Adam Goryachev
> <mailinglists@websitemanagers.com.au> wrote:
>>> Do you think more RAM might be beneficial then?
>>
>> I'm not sure of this, but I can suggest that you try various sizes for the
>> stripe_cache_size, in my testing, I tried various values up to 64k, but 4k
>> ended up being the optimal value (I only have 8 disks with 64k chunk
>> size)...
>>
>> You should find out if you are swapping with vmstat:
>> vmstat 5
>> Watch the Swap (SI and SO) columns, if they are non-zero, then you are
>> indeed swapping.
>>
>> You might find that if there is insufficient memory, then the kernel will
>> automatically reduce/limit the value for the stripe_cache_size (I'm only
>> guessing, but my memory tells me that the kernel locks this memory and it
>> can't be swapped/etc).
>
> Good ideas.  I actually halved the amount of physical memory in this
> machine.  I replaced the original eight 8GB DIMMs with eight 4GB
> DIMMs.  So no change in number of modules, but total RAM went from 64
> GB to 32 GB.
>
> I then cranked the stripe_cache_size up to 32k, degraded the array,
> and kicked off my reader test.
>
> Performance is basically the same.  And I'm definitely not swapping,
> vmstat shows both swap values constant at zero.  So it appears the
> kernel is smart enough to scale back the stripe_cache_size to avoid
> swapping.

The documentation implies that 32K is the upper limit for stripe_cache_size.

It is not immediately clear from the documentation or the code whether
a "stripe" is a page, a control structure, or a chunk.  I "think" it
is a control structure with a bio plus a single page.

I took a simple array from stripe_cache_size 256 => 32K and the system
allocated 265 MB of RAM (crude number via free), so this implies that
the stripe cache is 8K per entry.  The stripe cache struct appears to
have a bio plus a bunch of other control items in the struct.  I am
not sure if it has a statically allocated page, but at 8K it looks
like it does.  So I think the minimum/static memory allocated by the
stripe cache is 8K per entry.  This "might" also be the maximum, or
the cache size might grow to handle longer requests.

My test array is 16K chunks, and 8K is lower than 16K, so the max
might be (4K+stripe_cache_size) * chunk_size, but I suspect it is
actually (4K+4K) * stripe_cache_size.  Others write and breath this
code more than me, so clarification would be helpful.

It is were actually chunk size, the upper limits would be really bad
(32K * 512K) = 16GB.  Raid/5/6 is "compatible as a swap device", so
memory allocates during IO are generally not allowed.  So I think that
the stripe cache gets bumped and just stays there with little (or no)
dynamic allocation during operation.  If you run out of stripe cache
buckets, the driver "stalls" the calling IO operations until stripe
caches become available.  This "stall" of calling IOs will lower the
number of outstanding IOs to the member drives, which probably
explains your performance at 200 MB/sec.  Once stripe_cache_size gets
big enough to handle your workload, additional allocate does not help.
You can look at stripe_cache_active to see what is in use during your
run.

Doug

[... rest snipped ...]
