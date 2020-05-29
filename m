From: Yufen Yu <yuyufen@huawei.com>
Subject: Re: [PATCH v3 01/11] md/raid5: add CONFIG_MD_RAID456_STRIPE_SHIFT to
 set STRIPE_SIZE
Date: Fri, 29 May 2020 16:42:58 +0800
Message-ID: <7eb45e9f-c99c-cb78-9362-8f1b7513292f@huawei.com>
References: <20200527131933.34400-1-yuyufen@huawei.com>
 <20200527131933.34400-2-yuyufen@huawei.com>
 <CAPhsuW7JLcWDEwEcN-6c+NHhMD1qrPtPNPa-k8y9SX3bVX_FzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW7JLcWDEwEcN-6c+NHhMD1qrPtPNPa-k8y9SX3bVX_FzA@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Coly Li <colyli@suse.de>, Xiao Ni <xni@redhat.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids



On 2020/5/28 22:23, Song Liu wrote:
> On Wed, May 27, 2020 at 6:20 AM Yufen Yu <yuyufen@huawei.com> wrote:
>>
> [...]
>> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
>> index f90e0704bed9..b25f107dafc7 100644
>> --- a/drivers/md/raid5.h
>> +++ b/drivers/md/raid5.h
>> @@ -472,7 +472,9 @@ struct disk_info {
>>    */
>>
>>   #define NR_STRIPES             256
>> -#define STRIPE_SIZE            PAGE_SIZE
>> +#define CONFIG_STRIPE_SIZE     (CONFIG_MD_RAID456_STRIPE_SHIFT << 9)
>> +#define STRIPE_SIZE            \
>> +       (CONFIG_STRIPE_SIZE > PAGE_SIZE ? PAGE_SIZE : CONFIG_STRIPE_SIZE)
>>   #define STRIPE_SHIFT           (PAGE_SHIFT - 9)
> 
> I think we also need to update STRIPE_SHIFT.
> 
Yeah, I forgot to update it. Thanks for catching this.

Thanks,
Yufen
