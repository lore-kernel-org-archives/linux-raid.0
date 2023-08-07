Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00203EB64DD
	for <linux-raid@archiver.kernel.org>; Mon,  7 Aug 2023 06:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjHGGIW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Aug 2023 02:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjHGGIV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Aug 2023 02:08:21 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F64010F9
        for <linux-raid@vger.kernel.org>; Sun,  6 Aug 2023 23:08:19 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4RK5Tl2r7Gz4f3mLG
        for <linux-raid@vger.kernel.org>; Mon,  7 Aug 2023 14:08:11 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgD3hqlMitBk9haEAA--.28992S3;
        Mon, 07 Aug 2023 14:08:14 +0800 (CST)
Subject: Re: NULL pointer dereference with MD write-back journal, where
 journal device is RAID-1
To:     Corey Hickey <bugfood-ml@fatooh.org>,
        Yu Kuai <yukuai1@huaweicloud.com>,
        'Linux RAID' <linux-raid@vger.kernel.org>
Cc:     "yangerkun@huawei.com" <yangerkun@huawei.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <7c57f3a8-36e9-4805-b1ea-a4fd3406f7bb@fatooh.org>
 <f8b858cc-8762-6b53-43ec-7f509a971f16@huaweicloud.com>
 <428ed674-6e8c-471b-93d7-0532549fb218@fatooh.org>
 <d7cf0981-2d7c-5285-ce63-a66caf97e1db@huaweicloud.com>
 <91d3a3b8-572e-b674-9dc2-c2a7af3b9806@huaweicloud.com>
 <cddd7213-3dfd-4ab7-a3ac-edd54d74a626@fatooh.org>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <90f93747-2b16-eb7d-d149-01b98b5e4bcb@huaweicloud.com>
Date:   Mon, 7 Aug 2023 14:08:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <cddd7213-3dfd-4ab7-a3ac-edd54d74a626@fatooh.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3hqlMitBk9haEAA--.28992S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF17uF18XrWkuF1xAFWkZwb_yoW8uw13pF
        WktFW3CrWDuw1kCF4UZr17ZF9Yqw1Uuay7JryrX3WkAa1Uuryjqr4UWryvgF90qF48GFyU
        XFy3XryDur1UJr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkK14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbrMaU
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/08/07 12:51, Corey Hickey 写道:
> On 2023-08-06 19:46, Yu Kuai wrote:
>> can you test the following patch?
>>
>> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
>> index 51a68fbc241c..a85ea19fcf14 100644
>> --- a/drivers/md/raid5-cache.c
>> +++ b/drivers/md/raid5-cache.c
>> @@ -1266,9 +1266,8 @@ static void r5l_log_flush_endio(struct bio *bio)
>>           list_for_each_entry(io, &log->flushing_ios, log_sibling)
>>                   r5l_io_run_stripes(io);
>>           list_splice_tail_init(&log->flushing_ios, &log->finished_ios);
>> -       spin_unlock_irqrestore(&log->io_list_lock, flags);
>> -
>>           bio_uninit(bio);
>> +       spin_unlock_irqrestore(&log->io_list_lock, flags);
>>    }
>>
>>    /*
> 
> My patch utility didn't like it for some reason, but I applied the 
> changes manually to get what I think is the same thing. I'll paste the 
> diff here just in case.
> 
> --- drivers/md/raid5-cache.c.orig    2023-08-06 20:26:10.386665042 -0700
> +++ drivers/md/raid5-cache.c    2023-08-06 20:31:33.290688590 -0700
> @@ -1265,9 +1265,8 @@
>       list_for_each_entry(io, &log->flushing_ios, log_sibling)
>           r5l_io_run_stripes(io);
>       list_splice_tail_init(&log->flushing_ios, &log->finished_ios);
> -    spin_unlock_irqrestore(&log->io_list_lock, flags);
> -
>       bio_uninit(bio);
> +    spin_unlock_irqrestore(&log->io_list_lock, flags);
>   }

Yes, this is what I expected.
> 
>   /*
> 
> 
> With a new kernel including this change, I can now no longer reproduce 
> the problem; 12 successful runs seems pretty definitive given the 
> failure rate I was seeing before.
> 
> This was on a newly-recreated RAID-5, and I double-checked that I did 
> indeed re-enable write-back.

Thanks for the test, I'll send a patch with your tested-by tag soon.
> 
> Thank you for this! I wasn't expecting such a fast response, especially 
> on the weekend.

It's Monday for us, actually 😄

Thanks,
Kuai

> 
> -Corey
> .
> 

