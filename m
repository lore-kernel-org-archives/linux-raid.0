Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 391BFEB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 09:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240706AbjFPJRw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 05:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjFPJRv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 05:17:51 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17935B3
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 02:17:50 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QjD8T6vpmz4f3lXg
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 17:17:45 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgBH_rG5KIxkhxZRLw--.36139S3;
        Fri, 16 Jun 2023 17:17:46 +0800 (CST)
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
To:     Ali Gholami Rudi <aligrudi@gmail.com>,
        Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20231506112411@laper.mirepesht>
 <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
 <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
 <20231606091224@laper.mirepesht> <20231606110134@laper.mirepesht>
 <8b288984-396a-6093-bd1f-266303a8d2b6@huaweicloud.com>
 <20231606115113@laper.mirepesht>
 <1117f940-6c7f-5505-f962-a06e3227ef24@huaweicloud.com>
 <20231606122233@laper.mirepesht>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5bc8f9bd-2a56-3e80-80de-01f7af24c085@huaweicloud.com>
Date:   Fri, 16 Jun 2023 17:17:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20231606122233@laper.mirepesht>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBH_rG5KIxkhxZRLw--.36139S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uw47WF1xWFyxtrWUZr15XFb_yoW8XFy5pr
        W8ta1F93yDXF9Fgw47Xw4xZ3Wjvr1Dtr95GF95Kw1rAF1YgFyUJF48XFWYkryDZFn5Kw17
        ZF4Y939xCFyYqFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHU
        DUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/06/16 16:52, Ali Gholami Rudi 写道:
> 
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>> index 4fcfcb350d2b..52f0c24128ff 100644
>>> --- a/drivers/md/raid10.c
>>> +++ b/drivers/md/raid10.c
>>> @@ -905,7 +905,7 @@ static void flush_pending_writes(struct r10conf *conf)
>>>    		/* flush any pending bitmap writes to disk
>>>    		 * before proceeding w/ I/O */
>>>    		md_bitmap_unplug(conf->mddev->bitmap);
>>> -		wake_up(&conf->wait_barrier);
>>> +		wake_up_barrier(conf);
>>>    
>>>    		while (bio) { /* submit pending writes */
>>>    			struct bio *next = bio->bi_next;
>>
>> Thanks for the testing, sorry that I missed one place... Can you try to
>> change wake_up() to wake_up_barrier() from raid10_unplug() and test
>> again?
> 
> OK.  I replaced only the second occurrence of wake_up() in raid10_unplug().

I think it's better to change them together.

> 
>>> Without the patch:
>>> READ:  IOPS=2033k BW=8329MB/s
>>> WRITE: IOPS= 871k BW=3569MB/s
>>>
>>> With the patch:
>>> READ:  IOPS=2027K BW=7920MiB/s
>>> WRITE: IOPS= 869K BW=3394MiB/s
> 
> With the second patch:
> READ:  IOPS=3642K BW=13900MiB/s
> WRITE: IOPS=1561K BW= 6097MiB/s
> 
> That is impressive.  Great job.

Good, thanks for testing, can you please show perf result as well, I'd
like to check if there are other obvoius bottleneck.

By the way, I think raid1 can definitly benifit from same optimizations,
I'll look into raid1.

Thanks,
Kuai

> 
> I shall test it more.
> 
> Thanks,
> Ali
> 
> .
> 

