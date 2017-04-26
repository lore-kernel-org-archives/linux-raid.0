From: Coly Li <colyli@suse.de>
Subject: Re: [MD PATCH 1/1] Use a new variable to count flighting sync
 requests
Date: Wed, 26 Apr 2017 23:38:31 +0800
Message-ID: <584ea129-d6ad-fa48-6295-806e3f951811@suse.de>
References: <1493213539-15970-1-git-send-email-xni@redhat.com>
 <20170426150850.lxe2ktt4uhljcp5y@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170426150850.lxe2ktt4uhljcp5y@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, ncroxon@redhat.com
List-Id: linux-raid.ids

On 2017/4/26 下午11:08, Shaohua Li wrote:
> On Wed, Apr 26, 2017 at 09:32:19PM +0800, Xiao Ni wrote:
>> In new barrier codes, raise_barrier waits if conf->nr_pending[idx] is not zero.
>> After all the conditions are true, the resync request can go on be handled. But
>> it adds conf->nr_pending[idx] again. The next resync request hit the same bucket
>> idx need to wait the resync request which is submitted before. The performance
>> of resync/recovery is degraded.
>> So we should use a new variable to count sync requests which are in flight.
>>
>> Suggested-by: Shaohua Li <shli@kernel.org>
>> Suggested-by: Coly Li <colyli@suse.de>
>> Signed-off-by: Xiao Ni <xni@redhat.com>
>> ---
>>  drivers/md/raid1.c | 14 +++++++++++---
>>  drivers/md/raid1.h |  1 +
>>  2 files changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index a34f587..3c304ef 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -869,7 +869,7 @@ static void raise_barrier(struct r1conf *conf, sector_t sector_nr)
>>  			     atomic_read(&conf->barrier[idx]) < RESYNC_DEPTH,
>>  			    conf->resync_lock);
>>  
>> -	atomic_inc(&conf->nr_pending[idx]);
>> +	atomic_inc(&conf->nr_sync_pending[idx]);
> 
> Any reason why nr_sync_pending is an array? Looks a single atomic is enough to me.
> 

Yes, you are right. A single atomic works fine :-)


Coly

