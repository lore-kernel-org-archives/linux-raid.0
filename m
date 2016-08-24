From: Shaohua Li <shli@kernel.org>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Tue, 23 Aug 2016 18:02:41 -0700
Message-ID: <20160824010241.GC57645@kernel.org>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 12, 2016 at 04:09:25PM -0500, Matt Garman wrote:
> We have a system with a 24-disk raid6 array, using 2TB SSDs.  We use
> this system in a workload that is 99.9% read-only (a few small
> writes/day, versus countless reads).  This system is an NFS server for
> about 50 compute nodes that continually read its data.
> 
> In a non-degraded state, the system works wonderfully: the md0_raid6
> process uses less than 1% CPU, each drive is around 20% utilization
> (via iostat), no swapping is taking place.  The outbound throughput
> averages around 2.0 GB/sec, with 2.5 GB/sec peaks.
> 
> However, we had a disk fail, and the throughput dropped considerably,
> with the md0_raid6 process pegged at 100% CPU.
> 
> I understand that data from the failed disk will need to be
> reconstructed from parity, and this will cause the md0_raid6 process
> to consume considerable CPU.
> 
> What I don't understand is how I can determine what kind of actual MD
> device performance (throughput) I can expect in this state?
> 
> Dmesg seems to give some hints:
> 
> [    6.386820] xor: automatically using best checksumming function:
> [    6.396690]    avx       : 24064.000 MB/sec
> [    6.414706] raid6: sse2x1   gen()  7636 MB/s
> [    6.431725] raid6: sse2x2   gen()  3656 MB/s
> [    6.448742] raid6: sse2x4   gen()  3917 MB/s
> [    6.465753] raid6: avx2x1   gen()  5425 MB/s
> [    6.482766] raid6: avx2x2   gen()  7593 MB/s
> [    6.499773] raid6: avx2x4   gen()  8648 MB/s
> [    6.499773] raid6: using algorithm avx2x4 gen() (8648 MB/s)
> [    6.499774] raid6: using avx2x2 recovery algorithm
> 
> (CPU is: Intel(R) Xeon(R) CPU E5-2620 v3 @ 2.40GHz.)
> 
> Perhaps naively, I would expect that second-to-last line:
> 
> [    6.499773] raid6: using algorithm avx2x4 gen() (8648 MB/s)
> 
> to indicate what kind of throughput I could expect in a degraded
> state, but clearly that is not right---or I have something
> misconfigured.
> 
> So in other words, what does that gen() 8648 MB/s metric mean in terms
> of real-world throughput?  Is there a way I can "convert" that number
> to expected throughput of a degraded array?

In non-degrade mode, raid6 just directly dispatch IO to raid disks, software
involvement is very small. In degrade mode, the data is calculated. There are a
lot of factors impacting the performance:
1. enter the raid6 state machine, which has a long code path. (this is
debatable, if a read doesn't read the faulty disk and it's a small random read,
raid6 doesn't need to run the state machine. Fixing this could hugely improve
the performance)
2. the state machine runs in a single thread, which is a bottleneck. try to
increase group_thread_cnt, which will make the handling multi-thread.
3. stripe cache involves. try to increase stripe_cache_size.
4. the faulty disk data must be calculated, which involves read from other
disks. If this is a numa machine, and each disk interrupts to different
cpus/nodes, there will be big impact (cache, wakeup IPI)
5. the xor calculation overhead. Actually I don't think the impact is big,
mordern cpu can do the calculation fast.

Thanks,
Shaohua
