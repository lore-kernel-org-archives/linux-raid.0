From: Doug Dumitru <doug@easyco.com>
Subject: Fwd: kernel checksumming performance vs actual raid device performance
Date: Wed, 13 Jul 2016 09:52:08 -0700
Message-ID: <CAFx4rwQ6rmxBnmHwQA2fyd9e27ZGUNGYQOg2HHPk2=rHqx25mA@mail.gmail.com>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <CAFx4rwQj3_JTNiS0zsQjp_sPXWkrp0ggjg_UiR7oJ8u0X9PQVA@mail.gmail.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwQj3_JTNiS0zsQjp_sPXWkrp0ggjg_UiR7oJ8u0X9PQVA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

---------- Forwarded message ----------
From: Doug Dumitru <doug@easyco.com>
Date: Tue, Jul 12, 2016 at 7:10 PM
Subject: Re: kernel checksumming performance vs actual raid device performance
To: Matt Garman <matthew.garman@gmail.com>


Mr. Garman,

If you only lose a single drive in a raid-6 array, then only XOR
parity needs to be re-computed.  The "first" parity drive in RAID-6
array is actually a RAID-5 parity drive.  The CPU "parity calc"
overhead for re-computing a missing raid-5 drive is very cheap and
should run at > 5GB/sec.

The raid-6 "test" numbers are the performance of calculating the
raid-6 parity "syndrome".  The overhead of calculating a missing disk
with raid-6 is higher.

In terms of performance overhead, most people look at long linear
write performance.  In this case, raid-6 calc does matter especially
in that the raid "thread" is singular, so the calcs will saturate a
single thread.

I suspect you are seeing something other than the parity math.  I have
24 SSDs in an array here and will need to try this.

You might want to try running "perf" on your system while it is
degraded and see where the thread is churning.  I would love to see
those results.  I would not be surprised to see that the thread is
literally "spinning".  If so, then the 100% cpu is probably fixable,
but it won't actually help performance.

In term of single drive missing performance with short reads, you are
mostly at the mercy of short read IOPS.  If you array is reading 8K
blocks at 2GB/sec, this is at 250,000 IOPS and you kill off a drive,
it will jump to 500,000 IOPS.  Reading from the good drives remains as
single reads, but read from the missing drives require reads from all
of the others (with raid-5, all but one).  I am not sure how the
recovery thread issues these recovery read.  Hopefully, it blasts them
at the array with abandon (ie, submit all 22 requests concurrently),
but the code might be less aggressive in deference to hard disks.
SSDs love deep queue depths.

Regardless, 500K IOPS as reads is not that easy.  A lot of disk HBAs
start to saturate around there.

A couple of "design" points I would consider, if this is a system that
you need to duplicate.

1)  Consider a single CPU socket solution, like an E6-1650 v3.
Multi-socked CPU introduce NUMA and a whole slew of "interesting"
system contention issues.
2)  Use good HBA that are direct connected to the disks.  I like LSI
3008 and the newer 16-port version, although you need to use only 12
ports with 6GBit SATA/SAS to keep from over-running the PCI-e slot
bandwidth.
3)  Do everything you can to hammer deep queue depths.
4)  Setup IRQ affinity so that the HBAs spread their IRQ requests across cores.


Doug Dumitru
WildFire Storage




On Tue, Jul 12, 2016 at 2:09 PM, Matt Garman <matthew.garman@gmail.com> wrote:
>
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
>
>
> Thanks,
> Matt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




-- 
Doug Dumitru
EasyCo LLC



-- 
Doug Dumitru
EasyCo LLC
