From: Coly Li <colyli@suse.de>
Subject: Re: [v2 PATCH 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Mon, 16 Jan 2017 14:08:56 +0800
Message-ID: <0e42163e-a7c3-6743-3f04-5d24db5f93ff@suse.de>
References: <1482853658-82535-1-git-send-email-colyli@suse.de>
 <20170104193500.6d5rsnm5h2a5vfwj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170104193500.6d5rsnm5h2a5vfwj@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On 2017/1/5 上午3:35, Shaohua Li wrote:
> On Tue, Dec 27, 2016 at 11:47:37PM +0800, Coly Li wrote:
>> 'Commit 79ef3a8aa1cb ("raid1: Rewrite the implementation of iobarrier.")'
>> introduces a sliding resync window for raid1 I/O barrier, this idea limits
>> I/O barriers to happen only inside a slidingresync window, for regular
>> I/Os out of this resync window they don't need to wait for barrier any
>> more. On large raid1 device, it helps a lot to improve parallel writing
>> I/O throughput when there are background resync I/Os performing at
>> same time.
>>
>> The idea of sliding resync widow is awesome, but there are several
>> challenges are very difficult to solve,
>>  - code complexity
>>    Sliding resync window requires several veriables to work collectively,
>>    this is complexed and very hard to make it work correctly. Just grep
>>    "Fixes: 79ef3a8aa1" in kernel git log, there are 8 more patches to fix
>>    the original resync window patch. This is not the end, any further
>>    related modification may easily introduce more regreassion.
>>  - multiple sliding resync windows
>>    Currently raid1 code only has a single sliding resync window, we cannot
>>    do parallel resync with current I/O barrier implementation.
>>    Implementing multiple resync windows are much more complexed, and very
>>    hard to make it correctly.
>>
>> Therefore I decide to implement a much simpler raid1 I/O barrier, by
>> removing resync window code, I believe life will be much easier.
>>
>> The brief idea of the simpler barrier is,
>>  - Do not maintain a logbal unique resync window
>>  - Use multiple hash buckets to reduce I/O barrier conflictions, regular
>>    I/O only has to wait for a resync I/O when both them have same barrier
>>    bucket index, vice versa.
>>  - I/O barrier can be recuded to an acceptable number if there are enought
>>    barrier buckets
>>
>> Here I explain how the barrier buckets are designed,
>>  - BARRIER_UNIT_SECTOR_SIZE
>>    The whole LBA address space of a raid1 device is divided into multiple
>>    barrier units, by the size of BARRIER_UNIT_SECTOR_SIZE.
>>    Bio request won't go across border of barrier unit size, that means
>>    maximum bio size is BARRIER_UNIT_SECTOR_SIZE<<9 in bytes.
>>  - BARRIER_BUCKETS_NR
>>    There are BARRIER_BUCKETS_NR buckets in total, which is defined by,
>>         #define BARRIER_BUCKETS_NR_BITS   9
>>         #define BARRIER_BUCKETS_NR        (1<<BARRIER_BUCKETS_NR_BITS)
>>    if multiple I/O requests hit different barrier units, they only need
>>    to compete I/O barrier with other I/Os which hit the same barrier
>>    bucket index with each other. The index of a barrier bucket which a
>>    bio should look for is calculated by,
>>         int idx = hash_long(sector_nr, BARRIER_BUCKETS_NR_BITS)
>>    that sector_nr is the start sector number of a bio. We use function
>>    align_to_barrier_unit_end() to calculate sectors number from sector_nr
>>    to the next barrier unit size boundary, if the requesting bio size
>>    goes across the boundary, we split the bio in raid1_make_request(), to
>>    make sure the finall bio sent into generic_make_request() won't exceed
>>    barrier unit boundary.
>>
>> Comparing to single sliding resync window,
>>  - Currently resync I/O grows linearly, therefore regular and resync I/O
>>    will have confliction within a single barrier units. So it is similar to
>>    single sliding resync window.
>>  - But a barrier unit bucket is shared by all barrier units with identical
>>    barrier uinit index, the probability of confliction might be higher
>>    than single sliding resync window, in condition that writing I/Os
>>    always hit barrier units which have identical barrier bucket index with
>>    the resync I/Os. This is a very rare condition in real I/O work loads,
>>    I cannot imagine how it could happen in practice.
>>  - Therefore we can achieve a good enough low confliction rate with much
>>    simpler barrier algorithm and implementation.
>>
>> If user has a (realy) large raid1 device, for example 10PB size, we may
>> just increase the buckets number BARRIER_BUCKETS_NR. Now this is a macro,
>> it is possible to be a raid1-created-time-defined variable in future.
>>
>> There are two changes should be noticed,
>>  - In raid1d(), I change the code to decrease conf->nr_pending[idx] into
>>    single loop, it looks like this,
>>         spin_lock_irqsave(&conf->device_lock, flags);
>>         conf->nr_queued[idx]--;
>>         spin_unlock_irqrestore(&conf->device_lock, flags);
>>    This change generates more spin lock operations, but in next patch of
>>    this patch set, it will be replaced by a single line code,
>>         atomic_dec(conf->nr_queueud[idx]);
>>    So we don't need to worry about spin lock cost here.
>>  - Original function raid1_make_request() is split into two functions,
>>    - raid1_make_read_request(): handles regular read request and calls
>>      wait_read_barrier() for I/O barrier.
>>    - raid1_make_write_request(): handles regular write request and calls
>>      wait_barrier() for I/O barrier.
>>    The differnece is wait_read_barrier() only waits if array is frozen,
>>    using different barrier function in different code path makes the code
>>    more clean and easy to read.
>>  - align_to_barrier_unit_end() is called to make sure both regular and
>>    resync I/O won't go across a barrier unit boundary.
>>
>> Changelog
>> V1:
>> - Original RFC patch for comments
>> V2:
>> - Use bio_split() to split the orignal bio if it goes across barrier unit
>>   bounday, to make the code more simple, by suggestion from Shaohua and
>>   Neil.
>> - Use hash_long() to replace original linear hash, to avoid a possible
>>   confilict between resync I/O and sequential write I/O, by suggestion from
>>   Shaohua.
>> - Add conf->total_barriers to record barrier depth, which is used to
>>   control number of parallel sync I/O barriers, by suggestion from Shaohua.
>> - In V1 patch the bellowed barrier buckets related members in r1conf are
>>   allocated in memory page. To make the code more simple, V2 patch moves
>>   the memory space into struct r1conf, like this,
>>         -       int                     nr_pending;
>>         -       int                     nr_waiting;
>>         -       int                     nr_queued;
>>         -       int                     barrier;
>>         +       int                     nr_pending[BARRIER_BUCKETS_NR];
>>         +       int                     nr_waiting[BARRIER_BUCKETS_NR];
>>         +       int                     nr_queued[BARRIER_BUCKETS_NR];
>>         +       int                     barrier[BARRIER_BUCKETS_NR];
>>   This change is by the suggestion from Shaohua.
>> - Remove some inrelavent code comments, by suggestion from Guoqing.
>> - Add a missing wait_barrier() before jumping to retry_write, in
>>   raid1_make_write_request().
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Shaohua Li <shli@fb.com>
>> Cc: Neil Brown <neilb@suse.de>
>> Cc: Johannes Thumshirn <jthumshirn@suse.de>
>> Cc: Guoqing Jiang <gqjiang@suse.com>
>> ---
>>  
>> +static sector_t align_to_barrier_unit_end(sector_t start_sector,
>> +					  sector_t sectors)
>> +{
>> +	sector_t len;
>> +
>> +	WARN_ON(sectors == 0);
>> +	/* len is the number of sectors from start_sector to end of the
>> +	 * barrier unit which start_sector belongs to.
>> +	 */
> 
> The correct format for comments is:
> /*
>  * something
>  */
> 

Copied, I will modify this.

> There are some other places with the same issue
> 
>> +	len = ((start_sector + sectors + (1<<BARRIER_UNIT_SECTOR_BITS) - 1) &
>> +	       (~(BARRIER_UNIT_SECTOR_SIZE - 1))) -
>> +	      start_sector;
> 
> This one makes me nervous. shouldn't this be:
>  +	len = ((start_sector +  (1<<BARRIER_UNIT_SECTOR_BITS) - 1) &
>  +	       (~(BARRIER_UNIT_SECTOR_SIZE - 1))) -
>  +	      start_sector;
> 

If start_sector is barrier unit sector size aligned, the above
modification will assign 0 to len. But in this case, len should be
BARRIER_UNIT_SECTOR_SIZE.

> And you can use round_up()

round_up() has similar problem. For example, if we use,
	len = round_up(start_sector, BARRIER_UNIT_SECTOR_SIZE) -
	      start_sector,

and start_sector is 0, round_up will return 0, and len will be 0 as
well. But in this case, correct value of len should be
BARRIER_UNIT_SECTOR_SIZE.

>>  
>> -static void raid1_make_request(struct mddev *mddev, struct bio * bio)
>> +static void raid1_make_read_request(struct mddev *mddev, struct bio *bio)
>>  {
> 
> Please rebase the patches to latest md-next. The raid1_make_request already
> split for read/write code path recently.
> 

Yes, I will do it.

> Otherwise, the patch looks good. After these are fixed, I'll add it for 4.11
> 

I will send out another version, with review comments from you and Neil.

Thanks!

Coly





