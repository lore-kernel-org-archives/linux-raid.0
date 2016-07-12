From: Matt Garman <matthew.garman@gmail.com>
Subject: kernel checksumming performance vs actual raid device performance
Date: Tue, 12 Jul 2016 16:09:25 -0500
Message-ID: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

We have a system with a 24-disk raid6 array, using 2TB SSDs.  We use
this system in a workload that is 99.9% read-only (a few small
writes/day, versus countless reads).  This system is an NFS server for
about 50 compute nodes that continually read its data.

In a non-degraded state, the system works wonderfully: the md0_raid6
process uses less than 1% CPU, each drive is around 20% utilization
(via iostat), no swapping is taking place.  The outbound throughput
averages around 2.0 GB/sec, with 2.5 GB/sec peaks.

However, we had a disk fail, and the throughput dropped considerably,
with the md0_raid6 process pegged at 100% CPU.

I understand that data from the failed disk will need to be
reconstructed from parity, and this will cause the md0_raid6 process
to consume considerable CPU.

What I don't understand is how I can determine what kind of actual MD
device performance (throughput) I can expect in this state?

Dmesg seems to give some hints:

[    6.386820] xor: automatically using best checksumming function:
[    6.396690]    avx       : 24064.000 MB/sec
[    6.414706] raid6: sse2x1   gen()  7636 MB/s
[    6.431725] raid6: sse2x2   gen()  3656 MB/s
[    6.448742] raid6: sse2x4   gen()  3917 MB/s
[    6.465753] raid6: avx2x1   gen()  5425 MB/s
[    6.482766] raid6: avx2x2   gen()  7593 MB/s
[    6.499773] raid6: avx2x4   gen()  8648 MB/s
[    6.499773] raid6: using algorithm avx2x4 gen() (8648 MB/s)
[    6.499774] raid6: using avx2x2 recovery algorithm

(CPU is: Intel(R) Xeon(R) CPU E5-2620 v3 @ 2.40GHz.)

Perhaps naively, I would expect that second-to-last line:

[    6.499773] raid6: using algorithm avx2x4 gen() (8648 MB/s)

to indicate what kind of throughput I could expect in a degraded
state, but clearly that is not right---or I have something
misconfigured.

So in other words, what does that gen() 8648 MB/s metric mean in terms
of real-world throughput?  Is there a way I can "convert" that number
to expected throughput of a degraded array?


Thanks,
Matt
