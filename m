From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH V3 2/2] RAID1: avoid unnecessary spin locks in I/O barrier
 code
Date: Sat, 18 Feb 2017 02:42:49 +0800
Message-ID: <901347ef-b018-b351-027c-e64c6ced47ba@suse.de>
References: <1487176523-109075-1-git-send-email-colyli@suse.de>
 <1487176523-109075-2-git-send-email-colyli@suse.de>
 <20170216022526.47zoupqvieetyliw@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170216022526.47zoupqvieetyliw@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Hannes Reinecke <hare@suse.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On 2017/2/16 上午10:25, Shaohua Li wrote:
> On Thu, Feb 16, 2017 at 12:35:23AM +0800, colyli@suse.de wrote:
>> When I run a parallel reading performan testing on a md raid1 device with
>> two NVMe SSDs, I observe very bad throughput in supprise: by fio with 64KB
>> block size, 40 seq read I/O jobs, 128 iodepth, overall throughput is
>> only 2.7GB/s, this is around 50% of the idea performance number.
>>
>> The perf reports locking contention happens at allow_barrier() and
>> wait_barrier() code,
>>  - 41.41%  fio [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
>>    - _raw_spin_lock_irqsave
>>          + 89.92% allow_barrier
>>          + 9.34% __wake_up
>>  - 37.30%  fio [kernel.kallsyms]     [k] _raw_spin_lock_irq
>>    - _raw_spin_lock_irq
>>          - 100.00% wait_barrier
>>
>> The reason is, in these I/O barrier related functions,
>>  - raise_barrier()
>>  - lower_barrier()
>>  - wait_barrier()
>>  - allow_barrier()
>> They always hold conf->resync_lock firstly, even there are only regular
>> reading I/Os and no resync I/O at all. This is a huge performance penalty.
>>
>> The solution is a lockless-like algorithm in I/O barrier code, and only
>> holding conf->resync_lock when it has to.
>>
>> The original idea is from Hannes Reinecke, and Neil Brown provides
>> comments to improve it. I continue to work on it, and make the patch into
>> current form.
>>
>> In the new simpler raid1 I/O barrier implementation, there are two
>> wait barrier functions,
>>  - wait_barrier()
>>    Which calls _wait_barrier(), is used for regular write I/O. If there is
>>    resync I/O happening on the same I/O barrier bucket, or the whole
>>    array is frozen, task will wait until no barrier on same barrier bucket,
>>    or the whold array is unfreezed.
>>  - wait_read_barrier()
>>    Since regular read I/O won't interfere with resync I/O (read_balance()
>>    will make sure only uptodate data will be read out), it is unnecessary
>>    to wait for barrier in regular read I/Os, waiting in only necessary
>>    when the whole array is frozen.
>>
>> The operations on conf->nr_pending[idx], conf->nr_waiting[idx], conf->
>> barrier[idx] are very carefully designed in raise_barrier(),
>> lower_barrier(), _wait_barrier() and wait_read_barrier(), in order to
>> avoid unnecessary spin locks in these functions. Once conf->
>> nr_pengding[idx] is increased, a resync I/O with same barrier bucket index
>> has to wait in raise_barrier(). Then in _wait_barrier() if no barrier
>> raised in same barrier bucket index and array is not frozen, the regular
>> I/O doesn't need to hold conf->resync_lock, it can just increase
>> conf->nr_pending[idx], and return to its caller. wait_read_barrier() is
>> very similar to _wait_barrier(), the only difference is it only waits when
>> array is frozen. For heavy parallel reading I/Os, the lockless I/O barrier
>> code almostly gets rid of all spin lock cost.
>>
>> This patch significantly improves raid1 reading peroformance. From my
>> testing, a raid1 device built by two NVMe SSD, runs fio with 64KB
>> blocksize, 40 seq read I/O jobs, 128 iodepth, overall throughput
>> increases from 2.7GB/s to 4.6GB/s (+70%).
>>
>> Changelog
>> V3:
>> - Add smp_mb__after_atomic() as Shaohua and Neil suggested.
>> - Change conf->nr_queued[] from atomic_t to int.
> 
> I missed this part. In the code, the nr_queued sometimes is protected by
> device_lock, sometimes (raid1d) no protection at all. Can you explain this?

I make a mistake here, integer set is atomic, but integer plus is not.
conf->nr_queued[] must be atomic_t here, otherwise it is racy. I will
fix it in V4 patch.

Thanks for the review.

Coly

