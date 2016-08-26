From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Fri, 26 Aug 2016 08:01:04 -0500
Message-ID: <CAJvUf-DJJ4ZqR+kS6SCqgaq9_MXuQxFwyHJbv7YH7hVx5xbBRQ@mail.gmail.com>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <20160824010241.GC57645@kernel.org> <CAJvUf-DXC6AtO3a=ox2XOinpRWgAv5NMPkRWAcsSZmBggF5_Dw@mail.gmail.com>
 <83f67452-9f09-2d6f-f82a-77d83309f618@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <83f67452-9f09-2d6f-f82a-77d83309f618@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 25, 2016 at 6:39 PM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
>> Do you think more RAM might be beneficial then?
>
> I'm not sure of this, but I can suggest that you try various sizes for the
> stripe_cache_size, in my testing, I tried various values up to 64k, but 4k
> ended up being the optimal value (I only have 8 disks with 64k chunk
> size)...
>
> You should find out if you are swapping with vmstat:
> vmstat 5
> Watch the Swap (SI and SO) columns, if they are non-zero, then you are
> indeed swapping.
>
> You might find that if there is insufficient memory, then the kernel will
> automatically reduce/limit the value for the stripe_cache_size (I'm only
> guessing, but my memory tells me that the kernel locks this memory and it
> can't be swapped/etc).

Good ideas.  I actually halved the amount of physical memory in this
machine.  I replaced the original eight 8GB DIMMs with eight 4GB
DIMMs.  So no change in number of modules, but total RAM went from 64
GB to 32 GB.

I then cranked the stripe_cache_size up to 32k, degraded the array,
and kicked off my reader test.

Performance is basically the same.  And I'm definitely not swapping,
vmstat shows both swap values constant at zero.  So it appears the
kernel is smart enough to scale back the stripe_cache_size to avoid
swapping.


>> On Tue, Aug 23, 2016 at 8:02 PM, Shaohua Li <shli@kernel.org> wrote:
>>>
>>> 2. the state machine runs in a single thread, which is a bottleneck. try
>>> to
>>> increase group_thread_cnt, which will make the handling multi-thread.
>>
>> For others' reference, this parameter is in
>> /sys/block/<device>/md/stripe_cache_size.
>>
>> On this CentOS (RHEL) 7.2 server, the parameter defaults to 0.  I set
>> it to 4, and the degraded reads went up dramatically.  Need to
>> experiment with this (and all the other tunables) some more, but that
>> change alone put me up to 2.5 GB/s read from the degraded array!
>
>
> Did you mean group_thread_cnt which defaults to 0?
> I don't recall the default for stripe_cache_size, but I'm pretty certain it
> is not 0...
> Note, in your case, it might increase the "test read scenario" but since
> your "live" scenario has a lot more CPU overhead, then this option might
> decrease overall results... Unfortunately, only testing with "live" load
> will really provide the information you will need to decide on this.

Yes, sorry, that is a typo, meant to write group_thread_cnt.  That
defaults to 0.  stripe_cache_size appears to default to 256.  (At
least on CentOS/RHEL 7.2.)

Agreed, yes, upping group_thread_cnt could improve one thing only to
the detriment of something else.  Nothing like a little "testing in
production" to make the higher-ups sweat.  :)

Thanks again all!
Matt
