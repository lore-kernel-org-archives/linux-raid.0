From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v5 04/16] md/raid5: add a member of r5pages for struct
 stripe_head
Date: Fri, 3 Jul 2020 09:22:14 +0800
Message-ID: <893dbb00-6b41-d779-781c-d141e5d856c0@huawei.com>
References: <20200702120628.777303-1-yuyufen@huawei.com>
 <20200702120628.777303-5-yuyufen@huawei.com>
 <CAPhsuW4rcsOz49teDi_MzHTir7euoA21sYxZf=jo0_F=aRHcdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW4rcsOz49teDi_MzHTir7euoA21sYxZf=jo0_F=aRHcdg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>, Yufen Yu <yuyufen@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids


在 2020/7/3 6:56, Song Liu 写道:
> On Thu, Jul 2, 2020 at 5:05 AM Yufen Yu <yuyufen@huawei.com> wrote:
>>
>> Since grow_buffers() uses alloc_page() to allocate the buffers for
>> each stripe_head(), means, it will allocate 64K buffers and just use
>> 4K of them, after setting stripe_size as 4096.
>>
>> To avoid wasting memory, we try to contain multiple 'page' of sh->dev
>> into one real page. That means, multiple sh->dev[i].page will point to
>> the only page with different offset. Example of 64K PAGE_SIZE and
>> 4K stripe_size as following:
>>
>>                      64K PAGE_SIZE
>>            +---+---+---+---+------------------------------+
>>            |   |   |   |   |
>>            |   |   |   |   |
>>            +-+-+-+-+-+-+-+-+------------------------------+
>>              ^   ^   ^   ^
>>              |   |   |   +----------------------------+
>>              |   |   |                                |
>>              |   |   +-------------------+            |
>>              |   |                       |            |
>>              |   +----------+            |            |
>>              |              |            |            |
>>              +-+            |            |            |
>>                |            |            |            |
>>          +-----+-----+------+-----+------+-----+------+------+
>> sh      | offset(0) | offset(4K) | offset(8K) | offset(12K) |
>>   +      +-----------+------------+------------+-------------+
>>   +----> dev[0].page  dev[1].page  dev[2].page  dev[3].page
>>
>> After trying to share one page, the users of sh->dev[i].page need to
>> take care:
>>
>>    1) When issue bio into stripe_head, bi_io_vec.bv_page will point to
>>       the page directly. So, we should make sure bv_offset to been set
>>       with correct offset.
>>
>>    2) When compute xor, the page will be passed to computer function.
>>       So, we also need to pass offset of that page to computer. Let it
>>       compute correct location of each sh->dev[i].page.
>>
>> This patch will add a new member of r5pages into stripe_head to manage
>> all pages needed by each sh->dev[i]. We also add 'offset' for each r5dev
>> so that users can get related page offset easily. And add helper function
>> to get page and it's index in r5pages array by disk index.
>>
>> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
>> ---
>>   drivers/md/raid5.h | 61 ++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 61 insertions(+)
>>

[...]

>>
>> +/*
>> + * Return corresponding page index of r5pages array.
>> + */
>> +static inline int raid5_get_page_index(struct stripe_head *sh, int disk_idx)
>> +{
>> +       struct r5conf *conf = sh->raid_conf;
>> +       int cnt;
>> +
>> +       WARN_ON(!sh->pages.page);
>> +       BUG_ON(conf->stripe_size > PAGE_SIZE);
> 
> We have too many of these WARN_ON() and BUG_ON().
> 

Yes. Yufen, please avoid using BUG_ON() becuase we are reducing the 
usage of it and Linus hate it:

https://lkml.org/lkml/2013/5/17/254
https://linuxinsider.com/story/torvalds-blows-stack-over-buggy-new-kernel-83975.html
https://lore.kernel.org/patchwork/patch/568291/


Thanks,
Jason
