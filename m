From: Yufen Yu <yuyufen@huawei.com>
Subject: Re: [PATCH v5 12/16] md/raid5: support config stripe_size by sysfs
 entry
Date: Sat, 4 Jul 2020 20:25:03 +0800
Message-ID: <e5096dc3-1a6e-e021-c114-1186607e438c@huawei.com>
References: <20200702120628.777303-1-yuyufen@huawei.com>
 <20200702120628.777303-13-yuyufen@huawei.com>
 <CAPhsuW5rTOwd+hPsBobFWD4TWGO4pWMgwt5BVAt=Fnab71MC=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW5rTOwd+hPsBobFWD4TWGO4pWMgwt5BVAt=Fnab71MC=w@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids



On 2020/7/3 6:38, Song Liu wrote:
> On Thu, Jul 2, 2020 at 5:05 AM Yufen Yu <yuyufen@huawei.com> wrote:
>>
>> After this patch, we can adjust stripe_size by writing value into sysfs
>> entry, likely, set stripe_size as 16KB:
>>
>>            echo 16384 > /sys/block/md1/md/stripe_size
>>
>> Show current stripe_size value:
>>
>>            cat /sys/block/md1/md/stripe_size
>>
>> stripe_size should not be bigger than PAGE_SIZE, and it requires to be
>> multiple of 4096.
> 
> I think we can just merge 02/16 into this one.
> 
>>
>> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
>> ---
>>   drivers/md/raid5.c | 69 +++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 68 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index f0fd01d9122e..a3376a4e4e5c 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -6715,7 +6715,74 @@ raid5_show_stripe_size(struct mddev  *mddev, char *page)
>>   static ssize_t
>>   raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
>>   {
>> -       return -EINVAL;
>> +       struct r5conf *conf = mddev->private;
> 
> We need mddev_lock(mddev) before accessing mddev->private.
>

Thanks to point this bug. I will fix it.

Thanks,
Yufen
