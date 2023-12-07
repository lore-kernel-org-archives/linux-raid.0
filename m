Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FE7D4B
	for <linux-raid@vger.kernel.org>; Wed,  6 Dec 2023 17:31:49 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4SlxZS23wJz4f3kjx
	for <linux-raid@vger.kernel.org>; Thu,  7 Dec 2023 09:31:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 5E9581A04C1
	for <linux-raid@vger.kernel.org>; Thu,  7 Dec 2023 09:31:45 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBXWhB_IHFl1brLCw--.7643S3;
	Thu, 07 Dec 2023 09:31:45 +0800 (CST)
Subject: Re: [PATCH] md: Do not unlock all_mddevs_lock in md_seq_show()
To: Song Liu <song@kernel.org>, Yuya Fujita <fujita.yuya-00@fujitsu.com>
Cc: mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20231206083356.9796-1-fujita.yuya-00@fujitsu.com>
 <CAPhsuW7WE8p+ijAx3rJEeafJV8-EtJ+KOaZayUap0G6JpFpdGg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b705bae8-b0af-eaca-c0ed-7f12891cd962@huaweicloud.com>
Date: Thu, 7 Dec 2023 09:31:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAPhsuW7WE8p+ijAx3rJEeafJV8-EtJ+KOaZayUap0G6JpFpdGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBXWhB_IHFl1brLCw--.7643S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cry8Kr4DGFyxCFWxXr1rtFb_yoW8Ar48pa
	95XFZxArWUXrWkJrnrJws5WFyFqw1xt3yqgr92ka1rur1DXrnxJryagFW0qFnY9ayfWrs8
	ta17Ga45ZrWIgwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2023/12/07 4:38, Song Liu 写道:
> On Wed, Dec 6, 2023 at 12:37 AM Yuya Fujita <fujita.yuya-00@fujitsu.com> wrote:
>>
>> Do not unlock all_mddevs_lock in md_seq_show() and keep the lock until
>> md_seq_stop().
>>
>> The list of all_mddevs may be deleted in md_seq_show() because
>> all_mddevs_lock is temporarily unlocked.
>> The list should not be deleted while iterating over all_mddevs.
>> (Just as the list should not be deleted during list_for_each_entry().)
>>
>> Fixes: cf1b6d4441ff ("md: simplify md_seq_ops")
>> Signed-off-by: Yuya Fujita <fujita.yuya-00@fujitsu.com>
> 
> Looks reasonable to me.
> 
> Yu Kuai, what do you think about this?

I fail to understand what is the problem here if other mddev is deleted
from the list while all_mddevs_lock is released during md_seq_show(),
can you explain more?

Thanks,
Kuai

> 
> Thanks,
> Song
>> ---
>>   drivers/md/md.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index c94373d64f2c..97ef08608848 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -8293,7 +8293,6 @@ static int md_seq_show(struct seq_file *seq, void *v)
>>          if (!mddev_get(mddev))
>>                  return 0;
>>
>> -       spin_unlock(&all_mddevs_lock);
>>          spin_lock(&mddev->lock);
>>          if (mddev->pers || mddev->raid_disks || !list_empty(&mddev->disks)) {
>>                  seq_printf(seq, "%s : %sactive", mdname(mddev),
>> @@ -8364,7 +8363,6 @@ static int md_seq_show(struct seq_file *seq, void *v)
>>                  seq_printf(seq, "\n");
>>          }
>>          spin_unlock(&mddev->lock);
>> -       spin_lock(&all_mddevs_lock);
>>          if (atomic_dec_and_test(&mddev->active))
>>                  __mddev_put(mddev);
>>
>> --
>> 2.31.1
>>
>>
> 
> .
> 

