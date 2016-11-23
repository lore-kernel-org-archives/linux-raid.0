From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [RFC PATCH 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Wed, 23 Nov 2016 17:05:04 +0800
Message-ID: <58355BC0.9030907@suse.com>
References: <1479765241-15528-1-git-send-email-colyli@suse.de>
 <20161122213541.btgw4cpoly5j4jpc@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161122213541.btgw4cpoly5j4jpc@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-raid.ids



On 11/23/2016 05:35 AM, Shaohua Li wrote:
> On Tue, Nov 22, 2016 at 05:54:00AM +0800, Coly Li wrote:
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
>>   - code complexity
>>     Sliding resync window requires several veriables to work collectively,
>>     this is complexed and very hard to make it work correctly. Just grep
>>     "Fixes: 79ef3a8aa1" in kernel git log, there are 8 more patches to fix
>>     the original resync window patch. This is not the end, any further
>>     related modification may easily introduce more regreassion.
>>   - multiple sliding resync windows
>>     Currently raid1 code only has a single sliding resync window, we cannot
>>     do parallel resync with current I/O barrier implementation.
>>     Implementing multiple resync windows are much more complexed, and very
>>     hard to make it correctly.
>>
>> Therefore I decide to implement a much simpler raid1 I/O barrier, by
>> removing resync window code, I believe life will be much easier.
>>
>> The brief idea of the simpler barrier is,
>>   - Do not maintain a logbal unique resync window
>>   - Use multiple hash buckets to reduce I/O barrier conflictions, regular
>>     I/O only has to wait for a resync I/O when both them have same barrier
>>     bucket index, vice versa.
>>   - I/O barrier can be recuded to an acceptable number if there are enought
>>     barrier buckets
>>
>> Here I explain how the barrier buckets are designed,
>>   - BARRIER_UNIT_SECTOR_SIZE
>>     The whole LBA address space of a raid1 device is divided into multiple
>>     barrier units, by the size of BARRIER_UNIT_SECTOR_SIZE.
>>     Bio request won't go across border of barrier unit size, that means
>>     maximum bio size is BARRIER_UNIT_SECTOR_SIZE<<9 in bytes.
>>   - BARRIER_BUCKETS_NR
>>     There are BARRIER_BUCKETS_NR buckets in total, if multiple I/O requests
>>     hit different barrier units, they only need to compete I/O barrier with
>>     other I/Os which hit the same barrier bucket index with each other. The
>>     index of a barrier bucket which a bio should look for is calculated by
>>     get_barrier_bucket_idx(),
>> 	(sector >> BARRIER_UNIT_SECTOR_BITS) % BARRIER_BUCKETS_NR
>>     sector is the start sector number of a bio. align_to_barrier_unit_end()
>>     will make sure the finall bio sent into generic_make_request() won't
>>     exceed border of the barrier unit size.
>>   - RRIER_BUCKETS_NR
>>     Number of barrier buckets is defined by,
>> 	#define BARRIER_BUCKETS_NR	(PAGE_SIZE/sizeof(long))
>>     For 4KB page size, there are 512 buckets for each raid1 device. That
>>     means the propobility of full random I/O barrier confliction may be
>>     reduced down to 1/512.
> Thanks! The idea is awesome and does makes the code easier to understand.

Fully agree!

> Open question:
>   - Need review from md clustring developer, I don't touch related code now.
> Don't think it matters, but please open eyes, Guoqing!

Thanks for reminding, I agree.

Anyway,  I will try to comment it though I am sticking with lvm2 bugs 
now and
run some tests with the two patches applied.

Thanks,
Guoqing
