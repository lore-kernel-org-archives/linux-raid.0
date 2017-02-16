From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Fri, 17 Feb 2017 01:05:49 +0800
Message-ID: <b54e3798-4cdc-e1d3-a11e-625290131d37@suse.de>
References: <1487176523-109075-1-git-send-email-colyli@suse.de>
 <20170216022222.73xmrd7lujkpns2x@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170216022222.73xmrd7lujkpns2x@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On 2017/2/16 上午10:22, Shaohua Li wrote:
> On Thu, Feb 16, 2017 at 12:35:22AM +0800, colyli@suse.de wrote:
>> 'Commit 79ef3a8aa1cb ("raid1: Rewrite the implementation of iobarrier.")'
>> introduces a sliding resync window for raid1 I/O barrier, this idea limits
>> I/O barriers to happen only inside a slidingresync window, for regular
>> I/Os out of this resync window they don't need to wait for barrier any
>> more. On large raid1 device, it helps a lot to improve parallel writing
>> I/O throughput when there are background resync I/Os performing at
>> same time.
>>
>> The idea of sliding resync widow is awesome, but code complexity is a
>> challenge. Sliding resync window requires several veriables to work
>> collectively, this is complexed and very hard to make it work correctly.
>> Just grep "Fixes: 79ef3a8aa1" in kernel git log, there are 8 more patches
>> to fix the original resync window patch. This is not the end, any further
>> related modification may easily introduce more regreassion.
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
>>    maximum bio size is BARRIER_UNIT_SECTOR_SIZE<<9 (64MB) in bytes.
>>    For random I/O 64MB is large enough for both read and write requests,
>>    for sequential I/O considering underlying block layer may merge them
>>    into larger requests, 64MB is still good enough.
>>    Neil also points out that for resync operation, "we want the resync to
>>    move from region to region fairly quickly so that the slowness caused
>>    by having to synchronize with the resync is averaged out over a fairly
>>    small time frame". For full speed resync, 64MB should take less then 1
>>    second. When resync is competing with other I/O, it could take up a few
>>    minutes. Therefore 64MB size is fairly good range for resync.
>>
>>  - BARRIER_BUCKETS_NR
>>    There are BARRIER_BUCKETS_NR buckets in total, which is defined by,
>>         #define BARRIER_BUCKETS_NR_BITS   (PAGE_SHIFT - 2)
>>         #define BARRIER_BUCKETS_NR        (1<<BARRIER_BUCKETS_NR_BITS)
>>    this patch makes the bellowed members of struct r1conf from integer
>>    to array of integers,
>>         -       int                     nr_pending;
>>         -       int                     nr_waiting;
>>         -       int                     nr_queued;
>>         -       int                     barrier;
>>         +       int                     *nr_pending;
>>         +       int                     *nr_waiting;
>>         +       int                     *nr_queued;
>>         +       int                     *barrier;
>>    number of the array elements is defined as BARRIER_BUCKETS_NR. For 4KB
>>    kernel space page size, (PAGE_SHIFT - 2) indecates there are 1024 I/O
>>    barrier buckets, and each array of integers occupies single memory page.
>>    1024 means for a request which is smaller than the I/O barrier unit size
>>    has ~0.1% chance to wait for resync to pause, which is quite a small
>>    enough fraction. Also requesting single memory page is more friendly to
>>    kernel page allocator than larger memory size.
>>
>>  - I/O barrier bucket is indexed by bio start sector
>>    If multiple I/O requests hit different I/O barrier units, they only need
>>    to compete I/O barrier with other I/Os which hit the same I/O barrier
>>    bucket index with each other. The index of a barrier bucket which a
>>    bio should look for is calculated by sector_to_idx() which is defined
>>    in raid1.h as an inline function,
>>         static inline int sector_to_idx(sector_t sector)
>>         {
>>                 return hash_long(sector >> BARRIER_UNIT_SECTOR_BITS,
>>                                 BARRIER_BUCKETS_NR_BITS);
>>         }
>>    Here sector_nr is the start sector number of a bio.
>>
>>  - Single bio won't go across boundary of a I/O barrier unit
>>    If a request goes across boundary of barrier unit, it will be split. A
>>    bio may be split in raid1_make_request() or raid1_sync_request(), if
>>    sectors returned by align_to_barrier_unit_end() is small than original
>>    bio size.
>>
>> Comparing to single sliding resync window,
>>  - Currently resync I/O grows linearly, therefore regular and resync I/O
>>    will have confliction within a single barrier units. So the I/O
>>    behavior is similar to single sliding resync window.
>>  - But a barrier unit bucket is shared by all barrier units with identical
>>    barrier uinit index, the probability of confliction might be higher
>>    than single sliding resync window, in condition that writing I/Os
>>    always hit barrier units which have identical barrier bucket indexs with
>>    the resync I/Os. This is a very rare condition in real I/O work loads,
>>    I cannot imagine how it could happen in practice.
>>  - Therefore we can achieve a good enough low confliction rate with much
>>    simpler barrier algorithm and implementation.
>>
>> There are two changes should be noticed,
>>  - In raid1d(), I change the code to decrease conf->nr_pending[idx] into
>>    single loop, it looks like this,
>>         spin_lock_irqsave(&conf->device_lock, flags);
>>         conf->nr_queued[idx]--;
>>         spin_unlock_irqrestore(&conf->device_lock, flags);
>>    This change generates more spin lock operations, but in next patch of
>>    this patch set, it will be replaced by a single line code,
>>         atomic_dec(&conf->nr_queueud[idx]);
>>    So we don't need to worry about spin lock cost here.
>>  - Mainline raid1 code split original raid1_make_request() into
>>    raid1_read_request() and raid1_write_request(). If the original bio
>>    goes across an I/O barrier unit size, this bio will be split before
>>    calling raid1_read_request() or raid1_write_request(),  this change
>>    the code logic more simple and clear.
>>  - In this patch wait_barrier() is moved from raid1_make_request() to
>>    raid1_write_request(). In raid_read_request(), original wait_barrier()
>>    is replaced by raid1_read_request().
>>    The differnece is wait_read_barrier() only waits if array is frozen,
>>    using different barrier function in different code path makes the code
>>    more clean and easy to read.
>> Changelog
>> V3:
>> - Rebase the patch against latest upstream kernel code.
>> - Many fixes by review comments from Neil,
>>   - Back to use pointers to replace arraries in struct r1conf
>>   - Remove total_barriers from struct r1conf
>>   - Add more patch comments to explain how/why the values of
>>     BARRIER_UNIT_SECTOR_SIZE and BARRIER_BUCKETS_NR are decided.
>>   - Use get_unqueued_pending() to replace get_all_pendings() and
>>     get_all_queued()
>>   - Increase bucket number from 512 to 1024
>> - Change code comments format by review from Shaohua.
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
>> V1:
>> - Original RFC patch for comments
> 
> Looks good, two minor issues.
> 
>>  
>> -static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>> -				 struct r1bio *r1_bio)
>> +static void raid1_read_request(struct mddev *mddev, struct bio *bio)
>>  {
>>  	struct r1conf *conf = mddev->private;
>>  	struct raid1_info *mirror;
>> +	struct r1bio *r1_bio;
>>  	struct bio *read_bio;
>>  	struct bitmap *bitmap = mddev->bitmap;
>>  	const int op = bio_op(bio);
>> @@ -1083,7 +1101,34 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>>  	int max_sectors;
>>  	int rdisk;
>>  
>> -	wait_barrier(conf, bio);
>> +	/*
>> +	 * Still need barrier for READ in case that whole
>> +	 * array is frozen.
>> +	 */
>> +	wait_read_barrier(conf, bio->bi_iter.bi_sector);
>> +	bitmap = mddev->bitmap;
>> +
>> +	/*
>> +	 * make_request() can abort the operation when read-ahead is being
>> +	 * used and no empty request is available.
>> +	 *
>> +	 */
>> +	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
>> +	r1_bio->master_bio = bio;
>> +	r1_bio->sectors = bio_sectors(bio);
>> +	r1_bio->state = 0;
>> +	r1_bio->mddev = mddev;
>> +	r1_bio->sector = bio->bi_iter.bi_sector;
> 
> This part looks unnecessary complicated. If you change raid1_make_request to
> something like __raid1_make_reques, add a new raid1_make_request and do bio
> split there, then call __raid1_make_request for each splitted bio, then you
> don't need to duplicate the r1_bio allocation parts for read/write.
> 

Aha, good point! I will do that.

>> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
>> index c52ef42..d3faf30 100644
>> --- a/drivers/md/raid1.h
>> +++ b/drivers/md/raid1.h
>> @@ -1,6 +1,14 @@
>>  #ifndef _RAID1_H
>>  #define _RAID1_H
>>  
>> +/* each barrier unit size is 64MB fow now
>> + * note: it must be larger than RESYNC_DEPTH
>> + */
>> +#define BARRIER_UNIT_SECTOR_BITS	17
>> +#define BARRIER_UNIT_SECTOR_SIZE	(1<<17)
>> +#define BARRIER_BUCKETS_NR_BITS		(PAGE_SHIFT - 2)
> 
> maybe write this as (PAGE_SHIFT - ilog2(sizeof(int)))? To be honest, I don't
> think it really matters if the array is PAGE_SIZE length, maybe just specify a
> const here.

Nice catch! It makes sense, I will do that, and add some comments to
explain why it is sizeof(int).

Thanks.

Coly
