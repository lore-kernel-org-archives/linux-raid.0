From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH v5 01/16] md/raid456: covert macro define of STRIPE_* as
 members of struct r5conf
Date: Mon, 6 Jul 2020 13:34:07 +0200
Message-ID: <0f99d3f6-ae4e-548d-93c1-32ef4b9d2473@cloud.ionos.com>
References: <20200702120628.777303-1-yuyufen@huawei.com>
 <20200702120628.777303-2-yuyufen@huawei.com>
 <84277307-fc0a-44e2-8564-699651a7ff47@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84277307-fc0a-44e2-8564-699651a7ff47@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, houtao1@huawei.com
List-Id: linux-raid.ids

On 7/6/20 11:09 AM, Guoqing Jiang wrote:
> On 7/2/20 2:06 PM, Yufen Yu wrote:
>> @@ -2509,10 +2532,11 @@ static void raid5_end_read_request(struct bio 
>> * bi)
>>                */
>>               pr_info_ratelimited(
>>                   "md/raid:%s: read error corrected (%lu sectors at 
>> %llu on %s)\n",
>> -                mdname(conf->mddev), STRIPE_SECTORS,
>> +                mdname(conf->mddev),
>> +                conf->stripe_sectors,
>
> The conf->stripe_sectors is printed with %lu format.
>
>> ot allow a suitable chunk size */
>>           return ERR_PTR(-EINVAL);
>>   diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
>> index f90e0704bed9..e36cf71e8465 100644
>> --- a/drivers/md/raid5.h
>> +++ b/drivers/md/raid5.h
>> @@ -472,32 +472,12 @@ struct disk_info {
>>    */
>>     #define NR_STRIPES        256
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
>
> Also, I am wondering if it is cleaner with something like below.
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8dea4398b191..984eea97e77c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6918,6 +6918,7 @@ static struct r5conf *setup_conf(struct mddev 
> *mddev)
>         conf = kzalloc(sizeof(struct r5conf), GFP_KERNEL);
>         if (conf == NULL)
>                 goto abort;
> +       r5conf_set_size(conf, PAGE_SIZE);
>         INIT_LIST_HEAD(&conf->free_list);
>         INIT_LIST_HEAD(&conf->pending_list);
>         conf->pending_data = kcalloc(PENDING_IO_MAX,
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index f90e0704bed9..04fc4c514d54 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -471,10 +471,13 @@ struct disk_info {
>   * Stripe cache
>   */
>
> +static unsigned long stripe_size = PAGE_SIZE;
> +static unsigned long stripe_shift = PAGE_SHIFT - 9;
> +static unsigned long stripe_sectors = PAGE_SIZE>>9;
>  #define NR_STRIPES             256
> -#define STRIPE_SIZE            PAGE_SIZE
> -#define STRIPE_SHIFT           (PAGE_SHIFT - 9)
> -#define STRIPE_SECTORS         (STRIPE_SIZE>>9)
> +#define STRIPE_SIZE            stripe_size
> +#define STRIPE_SHIFT           stripe_shift
> +#define STRIPE_SECTORS         stripe_sectors
>  #define        IO_THRESHOLD            1
>  #define BYPASS_THRESHOLD       1
>  #define NR_HASH                        (PAGE_SIZE / sizeof(struct 
> hlist_head))
> @@ -574,6 +577,9 @@ struct r5conf {
>         int                     raid_disks;
>         int                     max_nr_stripes;
>         int                     min_nr_stripes;
> +       unsigned long           stripe_size;
> +       unsigned long           stripe_shift;
> +       unsigned long           stripe_sectors;
>
>         /* reshape_progress is the leading edge of a 'reshape'
>          * It has value MaxSector when no reshape is happening
> @@ -690,6 +696,12 @@ struct r5conf {
>         struct r5pending_data   *next_pending_data;
>  };
>
> +static inline void r5conf_set_size(struct r5conf *conf, unsigned long 
> size)
> +{
> +       stripe_size = conf->stripe_size = size;
> +       stripe_shift = conf->stripe_shift = ilog2(size) - 9;
> +       stripe_sectors = conf->stripe_sectors = size >> 9;
> +}
>
>  /*
>   * Our supported algorithms

Hmm, I guess it can't support multiple raid5 with different sizes.

Thanks,
Guoqing
