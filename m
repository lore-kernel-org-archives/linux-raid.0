From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Fri, 26 Aug 2016 09:39:49 +1000
Message-ID: <83f67452-9f09-2d6f-f82a-77d83309f618@websitemanagers.com.au>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <20160824010241.GC57645@kernel.org>
 <CAJvUf-DXC6AtO3a=ox2XOinpRWgAv5NMPkRWAcsSZmBggF5_Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-DXC6AtO3a=ox2XOinpRWgAv5NMPkRWAcsSZmBggF5_Dw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/08/16 01:07, Matt Garman wrote:
>
>> Makes sense.  I know the stripe cache size is conservative by default
>> because of the fact that it's not shared with the page cache, so you
>> might as well consider it's memory lost.  When you upped it to 64k, and
>> you have 22 disks at 512k chunk, that 11MB per stripe and 65536 total
>> allowed stripes which is a maximum memory consumption of around 700GB
>> RAM.  I doubt you have that much in your machine, so I'm guessing it's
>> simply using all available RAM that the page cache or something else
>> isn't already using.  That's also explains why setting it higher doesn't
>> provide any additional benefits ;-).
> Do you think more RAM might be beneficial then?
I'm not sure of this, but I can suggest that you try various sizes for 
the stripe_cache_size, in my testing, I tried various values up to 64k, 
but 4k ended up being the optimal value (I only have 8 disks with 64k 
chunk size)...
>
>> I would try to tune your stripe cache size such that the kswapd?
>> processes go to sleep.  Those are reading/writing swap.  That won't help
>> your overall performance.
> Do you mean swapping as in swapping memory to disk?  I don't think
> that is happening.  I have 32 GB of swap space, but according to "free
> -k" only 48k of swap is being used, and that number never grows.
> Also, I don't have any of the classic telltale signs of disk-swapping,
> e.g. overall laggy system feel.
>
> Also, I re-set the stripe_cache_size back down to 256, and those
> kswapd processes continue to peg a couple CPUs.  IOW,
> stripe_cache_size doesn't appear to have much effect on kswapd.
You should find out if you are swapping with vmstat:
vmstat 5
Watch the Swap (SI and SO) columns, if they are non-zero, then you are 
indeed swapping.

You might find that if there is insufficient memory, then the kernel 
will automatically reduce/limit the value for the stripe_cache_size (I'm 
only guessing, but my memory tells me that the kernel locks this memory 
and it can't be swapped/etc).

>
> On Tue, Aug 23, 2016 at 8:02 PM, Shaohua Li <shli@kernel.org> wrote:
>> 2. the state machine runs in a single thread, which is a bottleneck. try to
>> increase group_thread_cnt, which will make the handling multi-thread.
> For others' reference, this parameter is in
> /sys/block/<device>/md/stripe_cache_size.
>
> On this CentOS (RHEL) 7.2 server, the parameter defaults to 0.  I set
> it to 4, and the degraded reads went up dramatically.  Need to
> experiment with this (and all the other tunables) some more, but that
> change alone put me up to 2.5 GB/s read from the degraded array!

Did you mean group_thread_cnt which defaults to 0?
I don't recall the default for stripe_cache_size, but I'm pretty certain 
it is not 0...
Note, in your case, it might increase the "test read scenario" but since 
your "live" scenario has a lot more CPU overhead, then this option might 
decrease overall results... Unfortunately, only testing with "live" load 
will really provide the information you will need to decide on this.

Regards,
Adam



-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
