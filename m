Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E6E7C77B7A
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 09:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240391AbjEXJJT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 05:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240192AbjEXJJS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 05:09:18 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C703FFC
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 02:09:16 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QR53D44Ftz4f4034
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 17:09:12 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgBXwLM51G1kGB1pKA--.414S3;
        Wed, 24 May 2023 17:09:14 +0800 (CST)
Subject: Re: [PATCH tests 1/5] tests: add a new test to check if pluged bio is
 unlimited for raid10
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de, logang@deltatee.com, yangerkun@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
 <20230523133900.3149123-2-yukuai1@huaweicloud.com>
 <20230524095314.000007f9@linux.intel.com>
 <5fdfece6-6a45-7de7-7754-afc16d58145b@huaweicloud.com>
 <20230524110038.00006c2f@linux.intel.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8245a7a9-bcae-e56d-fa70-72a04da2515d@huaweicloud.com>
Date:   Wed, 24 May 2023 17:09:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230524110038.00006c2f@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBXwLM51G1kGB1pKA--.414S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWw17Kr4Dtw15JF1fAw4DXFb_yoW5Gr4rpF
        WxGa13Kw1kZF1fAw1Iqw1xZFySkrZ5Ary5Zrn8tr13A3s0grnIvr4xKw4YkFWFkrsaq3ya
        vw4Fga4xGF45ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUouWlDU
        UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/05/24 17:00, Mariusz Tkaczyk 写道:
> On Wed, 24 May 2023 16:26:45 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> Hi,
>>
>> 在 2023/05/24 15:53, Mariusz Tkaczyk 写道:
>>> On Tue, 23 May 2023 21:38:56 +0800
>>> Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>    
>>>> From: Yu Kuai <yukuai3@huawei.com>
>>>>
>>>> Pluged bio is unlimited means that all submitted bio will be pluged, and
>>>> those bio won't be issued to underlaying disks until blk_finish_plug() or
>>>> blk_flush_plug(). In this case, a lot memory will be used for
>>>> raid10_bio and io latency will be very bad.
>>>>
>>>> This test do some dirty pages writeback for raid10, where plug is used, and
>>>> check if device inflight counter exceed threshold.
>>>>
>>>> This problem is supposed to be fixed by [1].
>>>
>>> The test here is for md, mdadm has nothing to do here. I'm not against it
>>> but please extract it to separate directory because like "md_tests".
>>> We need to start grouping tests.
>>
>> Sorry I don't understand this, currently the test for md is here, I
>> don't see why need a seperate directory, is there a plan to move all
>> these tests into new directory?
> 
> Yes, that how it was in the past, and I would like to change it because
> tests directory is too big and we are still adding new tests.
> 
> Ideally, tests like that should stay with kernel, because repository you are
> contributing now is "mdadm" - userspace application to manage md devices, not
> the driver itself.
> That is why I wanted to highlight that placement is controversial but I'm fine
> with that. As you said, we did that in the past.
> 
> Song, what do you think? Where we should put the test like in the future?

Thanks for the explanation, I know this might require a lot of work, but
maybe it's a good time to migrate these tests to blktests.

Thanks,
Kuai
> 
> 
>>>> +
>>>> +# check if inflight exceed threshold
>>>> +while true; do
>>>> +        tmp=`cat /sys/block/md0/inflight | awk '{printf("%d\n", $1 +
>>>> $2);}'`
>>>> +        if [ $tmp -gt $threshold ]; then
>>>> +                die "inflight is greater than 4096"
>>>
>>> The message here is not meaningful, what 4096 is? Please add comment
>>> describing why value above 4096 causes an error. We need to understand how
>>> the future changes in md may affect this setting (I think that there is a
>>> correlation between the value and MAX_PLUG_BIO).
>>
>> MAX_PLUG_BIO is just limit for one task, I'm not sure if there will only
>> be one task issuing io, that why I choose a much larger value 4096.
> 
> Please add it in comment above the value.
> 
> Thanks,
> Mariusz
> .
> 

