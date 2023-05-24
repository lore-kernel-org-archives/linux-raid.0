Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B499C7EE23
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 09:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240232AbjEXJFv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 05:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234293AbjEXJFu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 05:05:50 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6136C97
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 02:05:48 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QR4zC2Mtlz4f41BQ
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 17:05:43 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAHvbBn021k+O5oKA--.15245S3;
        Wed, 24 May 2023 17:05:45 +0800 (CST)
Subject: Re: [PATCH tests 2/5] tests: add a new test for rdev lifetime
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de, logang@deltatee.com, song@kernel.org,
        yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
 <20230523133900.3149123-3-yukuai1@huaweicloud.com>
 <20230524103301.00007195@linux.intel.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <fab68598-229a-f914-f09e-6ecaa4a88ba4@huaweicloud.com>
Date:   Wed, 24 May 2023 17:05:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230524103301.00007195@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAHvbBn021k+O5oKA--.15245S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw4UuFWfur4fZFWrZF1UKFg_yoW8ury3pF
        W2qwnxKr4kZF1fGw1xtr18u3s0ka1furyrGF13GrnrAw15JFyavryxKw45uFW3Zr9F9342
        9a109asaga12vaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
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

ÔÚ 2023/05/24 16:33, Mariusz Tkaczyk Ð´µÀ:
> On Tue, 23 May 2023 21:38:57 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> This test add and remove a underlying disk to raid concurretly, verify
>> that the following problem is fixed:
> 
> As in previous patch, feel free to move it into separate directory.
> 
> This test is limited only to this particular problem you resolved because you
> are verifying error message in dmesg. It has no additional value because
> probability that this issue will ever more occur in the same shape is
> minimal.
> 
> IMO you should check how "remove" and "add" are handled, if errors are
> returned, if there is no trace in dmesg or if processes are not blocked in
> kernel.

It's a litter hard to do that, the problem is that after removing a disk
from array, add it back might fail. But if I follow this order,
it'll be hard to trigger the race, simply based on how quickly kernel
finish queued work. So I just remove and add the disk concurrently, and
return errors is not concerned as long as kernel doesn't WARN.

> You can check for this error message as a additional step at the end of test
> but not as a mandatory test pass criteria.
> 
> In current form it gives as a knowledge that particular kernel doesn't have your
> fix, that is all. Because it is race, probably it is not impacting real life
> scenarios, so that gives a weak motivation to backport the fix (only security
> reasons matters).
> 
> I don't see that this particular scenario requires test. You need to make it
> more valuable for the future.

This is just a regression test for a kerenl problem£¨also for all the
tests in this patchset) that is solved recently, and I write this test
from the kernel perspective, not user, I think this is the main
difference, because I'm not quite familiar how mdadm works, I just know
how to use it. (I still wonder why not these kernel regression tests is
not landed in blktests)

There are more regression tests that I'm planing to add, and is this the
wrong place to add such tests?

Thanks,
Kuai
>   
> Thanks,
> Mariusz
> 
> .
> 

