From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH V4 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Sat, 18 Feb 2017 10:56:41 +0800
Message-ID: <fa9ad7e2-4d34-1e96-7a9b-c62b7ab9b0a0@suse.de>
References: <1487358357-123924-1-git-send-email-colyli@suse.de>
 <20170217200036.2ca5iotzhc4oauwa@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170217200036.2ca5iotzhc4oauwa@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On 2017/2/18 上午4:00, Shaohua Li wrote:
> On Sat, Feb 18, 2017 at 03:05:56AM +0800, colyli@suse.de wrote:
[snip]

>> Changelog
>> V4:
>> - Add alloc_r1bio() to remove redundant r1bio memory allocation code.
>> - Fix many typos in patch comments.
>> - Use (PAGE_SHIFT - ilog2(sizeof(int))) to define BARRIER_BUCKETS_NR_BITS.
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
> Thanks, I applied the two patches. For the deadlock issue Neil pointed out, I
> don't want it to hold this patch, we can fix it later after we figured out how
> to fix. The r1bio allocation is guaranteed to success because it's mempool
> allocation, so I deleted the warn statement.

Good to know this, yes please delete the warn message line.

Thanks.

Coly

