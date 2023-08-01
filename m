Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F59C04A94
	for <linux-raid@archiver.kernel.org>; Tue,  1 Aug 2023 01:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjHABYZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Jul 2023 21:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjHABYY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 31 Jul 2023 21:24:24 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E10D114
        for <linux-raid@vger.kernel.org>; Mon, 31 Jul 2023 18:24:21 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4RFHSv0f20z4f3jHW
        for <linux-raid@vger.kernel.org>; Tue,  1 Aug 2023 09:24:15 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCH77K9Xshk3pIhPQ--.39463S3;
        Tue, 01 Aug 2023 09:24:15 +0800 (CST)
Subject: Re: [PATCH v3 1/3] md/raid1: freeze array more strictly when reshape
To:     Xueshi Hu <xueshi.hu@smartx.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, song@kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
 <20230719070954.3084379-2-xueshi.hu@smartx.com>
 <a3a45aa9-a54c-51ee-8a80-b663a418dc29@huaweicloud.com>
 <c42b56ef-9652-ed41-b675-e972a88e930d@huaweicloud.com>
 <dxzuor2h2rkkzlkmbvgxcipvumsy7xlitxpnmgj4lcm3rclcuv@thwglgsryebj>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1fbbf178-efdb-558e-685e-4e9ac785d5c0@huaweicloud.com>
Date:   Tue, 1 Aug 2023 09:24:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <dxzuor2h2rkkzlkmbvgxcipvumsy7xlitxpnmgj4lcm3rclcuv@thwglgsryebj>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCH77K9Xshk3pIhPQ--.39463S3
X-Coremail-Antispam: 1UD129KBjvJXoW3AF13trW3Ar18XF18Kw13CFg_yoW7GF1kpF
        4ktFWYyrW5Jrn3tr1jqa45GF90yw48Ga4UGr1xXa4UArsrtF1S9r1UXr1qgr1kZr4kJr1j
        q3y5XrZ3uFy5JrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
        UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/07/31 22:02, Xueshi Hu 写道:
> On Thu, Jul 20, 2023 at 09:37:38AM +0800, Yu Kuai wrote:
>> Hi,
>>
>> 在 2023/07/20 9:36, Yu Kuai 写道:
>>> Hi,
>>>
>>> 在 2023/07/19 15:09, Xueshi Hu 写道:
>>>> When an IO error happens, reschedule_retry() will increase
>>>> r1conf::nr_queued, which makes freeze_array() unblocked. However, before
>>>> all r1bio in the memory pool are released, the memory pool should not be
>>>> modified. Introduce freeze_array_totally() to solve the problem. Compared
>>>> to freeze_array(), it's more strict because any in-flight io needs to
>>>> complete including queued io.
>>>>
>>>> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
>>>> ---
>>>>    drivers/md/raid1.c | 35 +++++++++++++++++++++++++++++++++--
>>>>    1 file changed, 33 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>>> index dd25832eb045..5605c9680818 100644
>>>> --- a/drivers/md/raid1.c
>>>> +++ b/drivers/md/raid1.c
>>>> @@ -1072,7 +1072,7 @@ static void freeze_array(struct r1conf *conf,
>>>> int extra)
>>>>        /* Stop sync I/O and normal I/O and wait for everything to
>>>>         * go quiet.
>>>>         * This is called in two situations:
>>>> -     * 1) management command handlers (reshape, remove disk, quiesce).
>>>> +     * 1) management command handlers (remove disk, quiesce).
>>>>         * 2) one normal I/O request failed.
>>>>         * After array_frozen is set to 1, new sync IO will be blocked at
>>>> @@ -1111,6 +1111,37 @@ static void unfreeze_array(struct r1conf *conf)
>>>>        wake_up(&conf->wait_barrier);
>>>>    }
>>>> +/* conf->resync_lock should be held */
>>>> +static int get_pending(struct r1conf *conf)
>>>> +{
>>>> +    int idx, ret;
>>>> +
>>>> +    ret = atomic_read(&conf->nr_sync_pending);
>>>> +    for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
>>>> +        ret += atomic_read(&conf->nr_pending[idx]);
>>>> +
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static void freeze_array_totally(struct r1conf *conf)
>>>> +{
>>>> +    /*
>>>> +     * freeze_array_totally() is almost the same with
>>>> freeze_array() except
>>>> +     * it requires there's no queued io. Raid1's reshape will
>>>> destroy the
>>>> +     * old mempool and change r1conf::raid_disks, which are
>>>> necessary when
>>>> +     * freeing the queued io.
>>>> +     */
>>>> +    spin_lock_irq(&conf->resync_lock);
>>>> +    conf->array_frozen = 1;
>>>> +    raid1_log(conf->mddev, "freeze totally");
>>>> +    wait_event_lock_irq_cmd(
>>>> +            conf->wait_barrier,
>>>> +            get_pending(conf) == 0,
>>>> +            conf->resync_lock,
>>>> +            md_wakeup_thread(conf->mddev->thread));
>>>> +    spin_unlock_irq(&conf->resync_lock);
>>>> +}
>>>> +
>>>>    static void alloc_behind_master_bio(struct r1bio *r1_bio,
>>>>                           struct bio *bio)
>>>>    {
>>>> @@ -3296,7 +3327,7 @@ static int raid1_reshape(struct mddev *mddev)
>>>>            return -ENOMEM;
>>>>        }
>>>> -    freeze_array(conf, 0);
>>>> +    freeze_array_totally(conf);
>>>
>>> I think this is wrong, raid1_reshape() can't be called with
>> Sorry about thi typo, I mean raid1_reshape() can be called with ...
> You're right, this is indeed a deadlock.
> 
> I am wondering whether this approach is viable
> 
> 	if (unlikely(atomic_read(conf->nr_queued))) {
> 		kfree(newpoolinfo);
> 		mempool_exit(&newpool);
> 		unfreeze_array(conf);
> 
> 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> 		md_wakeup_thread(mddev->thread);
> 		return -EBUSY;
> 	}

This is not okay, 'nr_queued' can be incresed at any time when normal io
failed, read it once doesn't mean anything, and you need to
freeze_array() before reading it:

freeze_array
// guarantee new io won't be dispatched
if (atomic_read(conf->nr_queued))
  ...
  unfreeze_array
  return -EBUSY;

Fortunately, I'm working on another patchset to synchronize io with
array configuration, which means all the callers of raid1_reshape() will
suspend the array, and no normal io will be in progress, hence this
problem won't exist as well.

Thanks,
Kuai

> 
> Thanks,
> Hu
> 
>>
>> Thanks,
>> Kuai
>>> 'reconfig_mutex' grabbed, and this will deadlock because failed io need
>>> this lock to be handled by daemon thread.(see details in [1]).
>>>
>>> Be aware that never hold 'reconfig_mutex' to wait for io.
>>>
>>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=md-next&id=c4fe7edfc73f750574ef0ec3eee8c2de95324463
>>>
>>>>        /* ok, everything is stopped */
>>>>        oldpool = conf->r1bio_pool;
>>>>
>>>
>>> .
>>>
>>
> .
> 

