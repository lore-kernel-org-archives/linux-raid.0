From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Thu, 25 Aug 2016 10:07:40 -0500
Message-ID: <CAJvUf-DXC6AtO3a=ox2XOinpRWgAv5NMPkRWAcsSZmBggF5_Dw@mail.gmail.com>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <20160824010241.GC57645@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160824010241.GC57645@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Note: again I consolidated several previous posts into one for inline replies...

On Tue, Aug 23, 2016 at 2:41 PM, Doug Dumitru <doug@easyco.com> wrote:
> So you are up at 1GB/sec, which is only 1/4 the degraded speed, but
> 1/2 the expected speed based on drive data transfers required.  This
> is actually pretty good.

I get 8 GB/sec non-degraded.  So I'd say I'm still only 1/8
non-degraded speed, and about 1/4 of what I expect in degraded state.
I.e., I expect 4 GB/sec non-degraded.  However, based on what I'm
reading in this thread, maybe I can't do any better?  But
group_thread_cnt might save the day...


> If you need this to go faster, then it is either a raid re-design, or
> perhaps you should consider cutting your array into two parts.  Two 12
> drives raid-6 arrays will give you more bandwidth both because the
> failures are less "wide", so a single drive will only do 11 reads
> instead of 22.  Plus you get the benefit of two raid-6 threads should
> you have dead drives on both halves.  You can raid-0 the arrays
> together.  Then again, you lose two drives worth of space.

Yes, that's on the list to test.  Actually we'll try three 8-disk
raid-5s striped into one big raid0.  That only loses one drive's worth
of space (compared to a single 24-disk raid6).  Space is at a premium
here, as we're really needing to build this system with 4 TB drives.

The loss of resiliency using raid5 instead of raid6 "shouldn't" be an
issue here.  The design is to deliberately over-provision these
servers so that we have one more than we need.  Then in case of
failure (or major degradation) of a single server, we can migrate
clients to the other ones.


On Tue, Aug 23, 2016 at 3:15 PM, Doug Ledford <dledford@redhat.com> wrote:
> OK, 50 sequential I/Os at a time.  Good point to know.

Note that's just the test workload.  The real workload has literally
*thousands* of sequential reads at once.  However. those thousands of
reads aren't reading at full speed like dd of=/dev/null.  In the real
workload, after a chunk of data is read, some computations are done.
IOW, when the storage backend is working optimally, the read processes
are CPU bound.  But it's extremely hard to accurately generate this
kind of test workload, so we have fewer reader threads (50 in this
case), but they are pure read-as-fast-as-we-can jobs, as opposed to
read-and-compute.

> You're raid device has a good chunk size for your usage pattern.  If you
> had a smallish chunk size (like 64k or 32k), I would actually expect
> things to behave differently.  But, then again, maybe I'm wrong and that
> would help.  With a smaller chunk size, you would be able to fit more
> stripes in the stripe cache using less memory.

For some reason I thought we had a 64k chunk size, which I believe is
the mdadm default?  But, you're right, it is indeed 512k.  I will try
to experiment with different chunk sizes, as my Internet-research
suggests that's a very application-dependent setting; I can't seem to
find any rules of thumb as to what our ideal chunk size might be for
this particular workload.  My intuition says bigger is better, since
we're dealing with sequential reads of generally large-ish files.


> Makes sense.  I know the stripe cache size is conservative by default
> because of the fact that it's not shared with the page cache, so you
> might as well consider it's memory lost.  When you upped it to 64k, and
> you have 22 disks at 512k chunk, that 11MB per stripe and 65536 total
> allowed stripes which is a maximum memory consumption of around 700GB
> RAM.  I doubt you have that much in your machine, so I'm guessing it's
> simply using all available RAM that the page cache or something else
> isn't already using.  That's also explains why setting it higher doesn't
> provide any additional benefits ;-).

Do you think more RAM might be beneficial then?


> The math fits.  Most quad channel Intel CPUs have memory bandwidths in
> the 50GByte/s range theoretical maximum, but it's not bidirectional,
> it's not even multi-access, so you have to remember that the usage looks
> like this on a good read:

I'll have to re-read your explanation a few more times to fully grasp
it, but thank you for that!

For what it's worth, this is a NUMA system: two E5-2620v3 CPUs.  More
cores, but I understand the complexities added by memory controller
and PCIe node locality.


>> My colleague tested that exact same config with hardware raid5, and
>> striped the three raid5 arrays together with software raid1.
>
> That's a huge waste, are you sure he didn't use raid0 for the stripe?

Sorry, typo, that was raid0 indeed.


> I would try to tune your stripe cache size such that the kswapd?
> processes go to sleep.  Those are reading/writing swap.  That won't help
> your overall performance.

Do you mean swapping as in swapping memory to disk?  I don't think
that is happening.  I have 32 GB of swap space, but according to "free
-k" only 48k of swap is being used, and that number never grows.
Also, I don't have any of the classic telltale signs of disk-swapping,
e.g. overall laggy system feel.

Also, I re-set the stripe_cache_size back down to 256, and those
kswapd processes continue to peg a couple CPUs.  IOW,
stripe_cache_size doesn't appear to have much effect on kswapd.


On Tue, Aug 23, 2016 at 8:02 PM, Shaohua Li <shli@kernel.org> wrote:
> 2. the state machine runs in a single thread, which is a bottleneck. try to
> increase group_thread_cnt, which will make the handling multi-thread.

For others' reference, this parameter is in
/sys/block/<device>/md/stripe_cache_size.

On this CentOS (RHEL) 7.2 server, the parameter defaults to 0.  I set
it to 4, and the degraded reads went up dramatically.  Need to
experiment with this (and all the other tunables) some more, but that
change alone put me up to 2.5 GB/s read from the degraded array!

Thanks again,
Matt
