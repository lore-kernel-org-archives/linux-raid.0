From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC]raid5: multiple thread handle stripe
Date: Tue, 17 Jul 2012 14:03:40 -0600
Message-ID: <CANejiEUPDjaV3psEAuJ5tqom6sKF=NbXhkKO6Xzg9r61hkAtSg@mail.gmail.com>
References: <20120709080024.GA801@kernel.org>
	<20120716144746.08d26926@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120716144746.08d26926@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

2012/7/15 NeilBrown <neilb@suse.de>:
> On Mon, 9 Jul 2012 16:00:24 +0800 Shaohua Li <shli@kernel.org> wrote:
>
>> I had another implementation of raid5 mult-thread. The basic idea is to record
>> stripe submitted CPU. Each cpu has a thread, which only handles stripes
>> submitted from this cpu.
>>
>> Dan mentioned similar idea several day ago. I used to think we need make
>> conf->device_lock per-cpu to make this work, but turn out that isn't required.
>> Simply using percpu list and still using global device_lock works here.
>> Performance is good too.
>>
>> This is a RFC patch, I'll resubmit in a better reviewable way if you like the idea.
>
> I mostly like this, thanks.  It seems to take a fairly simple approach -
> having a single list of pending stripes and each thread just takes the ones
> that are relevant for it.
>
> I'm not convinced of the idea of having one thread for every CPU though. I
> wonder if we should be more NUMA-aware.
> E.g. on an Intel core with SMT we want at most one thread per core, not one
> thread per control thread.
> Similarly in a larger NUMA machine we might want one or 2 threads per node
> even if they have multiple CPUs.  Does that seem reasonable?
>
> So I imagine having each aux thread be tied to some collection of CPUs.
> We keep a mask of all CPUs that any thread is tied to.  If a stripe_head is
> marked for a CPU not in that mask (or that is not available) the main thread
> handles that stripe, otherwise it is left for the thread (or threads) which
> request that CPU.
> Then we have a simple program that, based on some policy configuration,
> creates multiple threads, sets the allows_cpu mask for each, and then calls
> some new "MD_RUN_AUX_THREAD" ioctl passing a mask of cpus to service
> (presumably similar to the mask of CPUs that it can run on).
>
> This gives up  the flexiblity to experiment with different NUMA and SMT
> policies without putting too much knowledge into the kernel.
>
> What do you think of that?

I definitely like this. It's basically a combination of my first implementation
(thread number is configurable) and this implementation (thread only handles
relevant stripes). One thing I want to avoid is wakeup unrelevant thread, I'll
check how to do it.

Thanks,
Shaohua
