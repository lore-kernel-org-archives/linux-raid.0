From: Yufen Yu <yuyufen@huawei.com>
Subject: Re: [PATCH v6 00/15] md/raid5: set STRIPE_SIZE as a configurable
 value
Date: Thu, 16 Jul 2020 22:01:55 +0800
Message-ID: <17e80721-86dc-6be8-5018-222c3b7445a9@huawei.com>
References: <20200715124257.3175816-1-yuyufen@huawei.com>
 <CAPhsuW4ON3U9GXygpMsTxWGfQr8XH1H8GHn-VPUmOBfOqAEWdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW4ON3U9GXygpMsTxWGfQr8XH1H8GHn-VPUmOBfOqAEWdw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids



On 2020/7/16 15:20, Song Liu wrote:
> On Wed, Jul 15, 2020 at 5:42 AM Yufen Yu <yuyufen@huawei.com> wrote:
>>
>> Hi, all
>>
>>   For now, STRIPE_SIZE is equal to the value of PAGE_SIZE. That means, RAID5
>>   will issue each bio to disk at least 64KB when PAGE_SIZE is 64KB in arm64.
>>   However, filesystem usually issue bio in the unit of 4KB. Then, RAID5 may
>>   waste resource of disk bandwidth.
>>
>>   To solve the problem, this patchset try to set stripe_size as a configuare
>>   value. The default value is 4096. We will add a new sysfs entry and set it
>>   by writing a new value, likely:
>>
>>          echo 16384 > /sys/block/md1/md/stripe_size
> 
> [...]
> 
>> V6:
>>   * Convert stripe_size and stripe_sectors from 'unsigned int' to
>>     'unsigned long' avoiding compiler warning.
>>   * Add a new member of stripes_per_page into r5conf, avoiding to
>>     compute each time.
>>   * Cover mddev->private with mddev_lock(mddev) for raid5_store/show_stripe_size().
>>   * Get rid of too many WARN_ON() and BUG_ON().
>>   * Unfold raid5_get_page_index() into raid5_get_dev_page() directly.
> 
> We are running out of time before the upcoming merge window, so we may not
> be able to ship the whole set. How about we ship 01, and 11 in this
> merge window,
> and the rest in the next merge window? Would the array get most of the
> performance benefit with these 2 patches? Do you see other issues with
> this path?
> 

This patchset includes two optimization, dynamically adjust stripe_size to improve
raid array performance and save memory used by stripe_head. If you think we may not
be able to ship the the whole set, I think just ship the first optimization (patch 01
and patch 11) can get better performance.

I will send the first optimization with adopting your suggestion as soon as possible.
Thanks a lot for your review.

Thanks,
Yufen

> Also I would like to minimize changes for PAGE_SIZE==4096 systems. Ideally,
> we can hide these changes from these system in ifdef's, like:
> 
> #if PAGE_SIZE == DEFAULT_STRIPE_SIZE
> #define STRIPE_SIZE            PAGE_SIZE
> #define STRIPE_SHIFT           (PAGE_SHIFT - 9)
> #define STRIPE_SECTORS         (STRIPE_SIZE>>9)
> #endif
> 
> #if PAGE_SIZE != DEFAULT_STRIPE_SIZE
> unsigned long           stripe_size;
> unsigned int            stripe_shift;
> unsigned long           stripe_sectors;
> #endif
> 
> #if PAGE_SIZE != DEFAULT_STRIPE_SIZE
> #define RAID5_STRIPE_SIZE(conf) DEFAULT_STRIPE_SIZE
> #else
> #define RAID5_STRIPE_SIZE(conf) ((conf)->stripe_size)
> #endif
> 
> And then use RAID5_STRIPE_SIZE(conf) in the rest of the code.
> 
> Thanks,
> Song
> .
> 
