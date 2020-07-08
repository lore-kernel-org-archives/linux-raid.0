From: Yufen Yu <yuyufen@huawei.com>
Subject: Re: [PATCH v5 01/16] md/raid456: covert macro define of STRIPE_* as
 members of struct r5conf
Date: Wed, 8 Jul 2020 10:22:33 +0800
Message-ID: <a90dd862-3eef-c2db-0ea3-a1049139f9f0@huawei.com>
References: <20200702120628.777303-1-yuyufen@huawei.com>
 <20200702120628.777303-2-yuyufen@huawei.com>
 <84277307-fc0a-44e2-8564-699651a7ff47@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84277307-fc0a-44e2-8564-699651a7ff47@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, houtao1@huawei.com
List-Id: linux-raid.ids



On 2020/7/6 17:09, Guoqing Jiang wrote:
> On 7/2/20 2:06 PM, Yufen Yu wrote:
>> @@ -2509,10 +2532,11 @@ static void raid5_end_read_request(struct bio * bi)
>>                */
>>               pr_info_ratelimited(
>>                   "md/raid:%s: read error corrected (%lu sectors at %llu on %s)\n",
>> -                mdname(conf->mddev), STRIPE_SECTORS,
>> +                mdname(conf->mddev),
>> +                conf->stripe_sectors,
> 
> The conf->stripe_sectors is printed with %lu format.
> 
>> ot allow a suitable chunk size */
>>           return ERR_PTR(-EINVAL);
>> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
>> index f90e0704bed9..e36cf71e8465 100644
>> --- a/drivers/md/raid5.h
>> +++ b/drivers/md/raid5.h
>> @@ -472,32 +472,12 @@ struct disk_info {
>>    */
>>   #define NR_STRIPES        256
>> -#define STRIPE_SIZE        PAGE_SIZE
>> -#define STRIPE_SHIFT        (PAGE_SHIFT - 9)
>> -#define STRIPE_SECTORS        (STRIPE_SIZE>>9)
>>   #define    IO_THRESHOLD        1
>>   #define BYPASS_THRESHOLD    1
>>   #define NR_HASH            (PAGE_SIZE / sizeof(struct hlist_head))
>>   #define HASH_MASK        (NR_HASH - 1)
>>   #define MAX_STRIPE_BATCH    8
> 
> [...]
> 
>>     return NULL;
>> -}
>> -
>>   /* NOTE NR_STRIPE_HASH_LOCKS must remain below 64.
>>    * This is because we sometimes take all the spinlocks
>>    * and creating that much locking depth can cause
>> @@ -574,6 +554,9 @@ struct r5conf {
>>       int            raid_disks;
>>       int            max_nr_stripes;
>>       int            min_nr_stripes;
>> +    unsigned int    stripe_size;
>> +    unsigned int    stripe_shift;
>> +    unsigned int    stripe_sectors;
> 
> So you need to define it with "unsigned long".

Yes, I will revise it.

Thanks,
Yufen
