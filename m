From: Shaohua Li <shli@kernel.org>
Subject: Re: [v2 PATCH 2/2] RAID1: avoid unnecessary spin locks in I/O
 barrier code
Date: Wed, 4 Jan 2017 11:59:55 -0800
Message-ID: <20170104195955.szil3oyatlpanmis@kernel.org>
References: <1482853658-82535-1-git-send-email-colyli@suse.de>
 <1482853658-82535-2-git-send-email-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1482853658-82535-2-git-send-email-colyli@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Hannes Reinecke <hare@suse.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On Tue, Dec 27, 2016 at 11:47:38PM +0800, Coly Li wrote:
> When I run a parallel reading performan testing on a md raid1 device with
> two NVMe SSDs, I observe very bad throughput in supprise: by fio with 64KB
> block size, 40 seq read I/O jobs, 128 iodepth, overall throughput is
> only 2.7GB/s, this is around 50% of the idea performance number.
> 
> The perf reports locking contention happens at allow_barrier() and
> wait_barrier() code,
>  - 41.41%  fio [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
>    - _raw_spin_lock_irqsave
>          + 89.92% allow_barrier
>          + 9.34% __wake_up
>  - 37.30%  fio [kernel.kallsyms]     [k] _raw_spin_lock_irq
>    - _raw_spin_lock_irq
>          - 100.00% wait_barrier
> 
> The reason is, in these I/O barrier related functions,
>  - raise_barrier()
>  - lower_barrier()
>  - wait_barrier()
>  - allow_barrier()
> They always hold conf->resync_lock firstly, even there are only regular
> reading I/Os and no resync I/O at all. This is a huge performance penalty.
> 
> The solution is a lockless-like algorithm in I/O barrier code, and only
> holding conf->resync_lock when it is really necessary.
> 
> The original idea is from Hannes Reinecke, and Neil Brown provides
> comments to improve it. Now I write the patch based on new simpler raid1
> I/O barrier code.
> 
> In the new simpler raid1 I/O barrier implementation, there are two
> wait barrier functions,
>  - wait_barrier()
>    Which in turns calls _wait_barrier(), is used for regular write I/O.
>    If there is resync I/O happening on the same barrier bucket index, or
>    the whole array is frozen, task will wait until no barrier on same
>    bucket index, or the whold array is unfreezed.
>  - wait_read_barrier()
>    Since regular read I/O won't interfere with resync I/O (read_balance()
>    will make sure only uptodate data will be read out), so it is
>    unnecessary to wait for barrier in regular read I/Os, they only have to
>    wait only when the whole array is frozen.
> The operations on conf->nr_pending[idx], conf->nr_waiting[idx], conf->
> barrier[idx] are very carefully designed in raise_barrier(),
> lower_barrier(), _wait_barrier() and wait_read_barrier(), in order to
> avoid unnecessary spin locks in these functions. Once conf->
> nr_pengding[idx] is increased, a resync I/O with same barrier bucket index
> has to wait in raise_barrier(). Then in _wait_barrier() or
> wait_read_barrier() if no barrier raised in same barrier bucket index or
> array is not frozen, the regular I/O doesn't need to hold conf->
> resync_lock, it can just increase conf->nr_pending[idx], and return to its
> caller. For heavy parallel reading I/Os, the lockless I/O barrier code
> almostly gets rid of all spin lock cost.
> 
> This patch significantly improves raid1 reading peroformance. From my
> testing, a raid1 device built by two NVMe SSD, runs fio with 64KB
> blocksize, 40 seq read I/O jobs, 128 iodepth, overall throughput
> increases from 2.7GB/s to 4.6GB/s (+70%).
> 
> Open question:
> Shaohua points out the memory barrier should be added to some atomic
> operations. Now I am reading the document to learn how to add the memory
> barriers correctly. Anyway, if anyone has suggestion, please don't
> hesitate to let me know.

Yes, because the raise_barrier/_wait_barrier depend on the atomic opertions
order, while atomic_inc/atomic_read don't imply a barrier.
 
> @@ -1005,7 +1031,7 @@ static void unfreeze_array(struct r1conf *conf)
>  {
>  	/* reverse the effect of the freeze */
>  	spin_lock_irq(&conf->resync_lock);
> -	conf->array_frozen = 0;
> +	atomic_set(&conf->array_frozen, 0);
>  	wake_up(&conf->wait_barrier);
>  	spin_unlock_irq(&conf->resync_lock);
>  }

Nitpick: This one doesn't need the lock.

Thanks,
Shaohua
