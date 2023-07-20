Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A10C001B0
	for <linux-raid@archiver.kernel.org>; Thu, 20 Jul 2023 01:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjGTBhs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Jul 2023 21:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjGTBhr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Jul 2023 21:37:47 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EB71BB
        for <linux-raid@vger.kernel.org>; Wed, 19 Jul 2023 18:37:42 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4R5wKt3Yfrz4f3lVM
        for <linux-raid@vger.kernel.org>; Thu, 20 Jul 2023 09:37:38 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCXaK_ij7hkB1F7OQ--.54326S3;
        Thu, 20 Jul 2023 09:37:39 +0800 (CST)
Subject: Re: [PATCH v3 1/3] md/raid1: freeze array more strictly when reshape
To:     Yu Kuai <yukuai1@huaweicloud.com>,
        Xueshi Hu <xueshi.hu@smartx.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
 <20230719070954.3084379-2-xueshi.hu@smartx.com>
 <a3a45aa9-a54c-51ee-8a80-b663a418dc29@huaweicloud.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c42b56ef-9652-ed41-b675-e972a88e930d@huaweicloud.com>
Date:   Thu, 20 Jul 2023 09:37:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a3a45aa9-a54c-51ee-8a80-b663a418dc29@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCXaK_ij7hkB1F7OQ--.54326S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZw1fKr4rWrW5tryDGry3urg_yoWrJFW5pr
        4ktrW5trWUGrnaqr15Ja4UCFy5Aw18Ga4DGrs7Xa4UAF47JFy0gr4UWrn0gr1DZr4kJr1U
        t345Xr9xuF15JrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkG14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r4j6FyUMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU9189UUU
        UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/07/20 9:36, Yu Kuai 写道:
> Hi,
> 
> 在 2023/07/19 15:09, Xueshi Hu 写道:
>> When an IO error happens, reschedule_retry() will increase
>> r1conf::nr_queued, which makes freeze_array() unblocked. However, before
>> all r1bio in the memory pool are released, the memory pool should not be
>> modified. Introduce freeze_array_totally() to solve the problem. Compared
>> to freeze_array(), it's more strict because any in-flight io needs to
>> complete including queued io.
>>
>> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
>> ---
>>   drivers/md/raid1.c | 35 +++++++++++++++++++++++++++++++++--
>>   1 file changed, 33 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index dd25832eb045..5605c9680818 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1072,7 +1072,7 @@ static void freeze_array(struct r1conf *conf, 
>> int extra)
>>       /* Stop sync I/O and normal I/O and wait for everything to
>>        * go quiet.
>>        * This is called in two situations:
>> -     * 1) management command handlers (reshape, remove disk, quiesce).
>> +     * 1) management command handlers (remove disk, quiesce).
>>        * 2) one normal I/O request failed.
>>        * After array_frozen is set to 1, new sync IO will be blocked at
>> @@ -1111,6 +1111,37 @@ static void unfreeze_array(struct r1conf *conf)
>>       wake_up(&conf->wait_barrier);
>>   }
>> +/* conf->resync_lock should be held */
>> +static int get_pending(struct r1conf *conf)
>> +{
>> +    int idx, ret;
>> +
>> +    ret = atomic_read(&conf->nr_sync_pending);
>> +    for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
>> +        ret += atomic_read(&conf->nr_pending[idx]);
>> +
>> +    return ret;
>> +}
>> +
>> +static void freeze_array_totally(struct r1conf *conf)
>> +{
>> +    /*
>> +     * freeze_array_totally() is almost the same with freeze_array() 
>> except
>> +     * it requires there's no queued io. Raid1's reshape will destroy 
>> the
>> +     * old mempool and change r1conf::raid_disks, which are necessary 
>> when
>> +     * freeing the queued io.
>> +     */
>> +    spin_lock_irq(&conf->resync_lock);
>> +    conf->array_frozen = 1;
>> +    raid1_log(conf->mddev, "freeze totally");
>> +    wait_event_lock_irq_cmd(
>> +            conf->wait_barrier,
>> +            get_pending(conf) == 0,
>> +            conf->resync_lock,
>> +            md_wakeup_thread(conf->mddev->thread));
>> +    spin_unlock_irq(&conf->resync_lock);
>> +}
>> +
>>   static void alloc_behind_master_bio(struct r1bio *r1_bio,
>>                          struct bio *bio)
>>   {
>> @@ -3296,7 +3327,7 @@ static int raid1_reshape(struct mddev *mddev)
>>           return -ENOMEM;
>>       }
>> -    freeze_array(conf, 0);
>> +    freeze_array_totally(conf);
> 
> I think this is wrong, raid1_reshape() can't be called with
Sorry about thi typo, I mean raid1_reshape() can be called with ...

Thanks,
Kuai
> 'reconfig_mutex' grabbed, and this will deadlock because failed io need
> this lock to be handled by daemon thread.(see details in [1]).
> 
> Be aware that never hold 'reconfig_mutex' to wait for io.
> 
> [1] 
> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=md-next&id=c4fe7edfc73f750574ef0ec3eee8c2de95324463 
> 
>>       /* ok, everything is stopped */
>>       oldpool = conf->r1bio_pool;
>>
> 
> .
> 

