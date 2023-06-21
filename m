Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6600EB64D7
	for <linux-raid@archiver.kernel.org>; Wed, 21 Jun 2023 08:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjFUI06 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Jun 2023 04:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjFUI04 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Jun 2023 04:26:56 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3A7DD
        for <linux-raid@vger.kernel.org>; Wed, 21 Jun 2023 01:26:54 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QmGnQ675vz4f3n6h
        for <linux-raid@vger.kernel.org>; Wed, 21 Jun 2023 16:26:50 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgBnHbFKtJJkfP3DMA--.4360S3;
        Wed, 21 Jun 2023 16:26:51 +0800 (CST)
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
To:     Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Ali Gholami Rudi <aligrudi@gmail.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20231506112411@laper.mirepesht>
 <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
 <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
 <20231606091224@laper.mirepesht> <20231606110134@laper.mirepesht>
 <8b288984-396a-6093-bd1f-266303a8d2b6@huaweicloud.com>
 <20231606115113@laper.mirepesht>
 <1117f940-6c7f-5505-f962-a06e3227ef24@huaweicloud.com>
 <20231606122233@laper.mirepesht> <20231606152106@laper.mirepesht>
 <cbc45f91-c341-2207-b3ec-81701a8651b5@huaweicloud.com>
 <CALTww2-Wkvxo3C2OCFrG9Wr_7RynjxnBMtPwR4GppbArZYNzsQ@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2311bff8-232c-916b-98b6-7543bd48ecfa@huaweicloud.com>
Date:   Wed, 21 Jun 2023 16:26:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALTww2-Wkvxo3C2OCFrG9Wr_7RynjxnBMtPwR4GppbArZYNzsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBnHbFKtJJkfP3DMA--.4360S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww47CFy3Zr13CF1fXFykGrg_yoW8XrWrpF
        4Yqa4akFs8WrWIv3Z2qr4UuF48twsrXr15JF4ktrWSy3ZFvF93Wa1jqrySkayUGF4DC34U
        Xa4vqwnxX3W5CFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZa9
        -UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/06/21 16:05, Xiao Ni 写道:
> On Fri, Jun 16, 2023 at 8:27 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2023/06/16 19:51, Ali Gholami Rudi 写道:
>>>
>>
>> Thanks for testing!
>>
>>> Perf's output:
>>>
>>> +   93.79%     0.09%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
>>> +   92.89%     0.05%  fio      [kernel.kallsyms]       [k] do_syscall_64
>>> +   86.59%     0.07%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
>>> -   85.61%     0.10%  fio      [kernel.kallsyms]       [k] io_submit_one
>>>      - 85.51% io_submit_one
>>>         - 47.98% aio_read
>>>            - 46.18% blkdev_read_iter
>>>               - 44.90% __blkdev_direct_IO_async
>>>                  - 41.68% submit_bio_noacct_nocheck
>>>                     - 41.50% __submit_bio
>>>                        - 18.76% md_handle_request
>>>                           - 18.71% raid10_make_request
>>>                              - 18.54% raid10_read_request
>>>                                   16.54% read_balance
>>
>> There is not any spin_lock in fast path anymore. Now, looks like
>> main cost is raid10 io path now(read_balance looks worth
>> investigation, 16.54% is too much), and for a real device with ms
>> io latency, I think latency in io path may not matter.
> 
> Hi Kuai
> 
> Cool. And I noticed you mentioned 'fast path' in many places. What's
> the meaning of 'fast path'? Does it mean the path that i/os are
> submitting?

Yes, and fast path means the case all resources is available and io can
be submitted to device without blocking.

There should be no spin_lock or atomic ops in fast path, otherwise io
performance will be affected.

Thanks,
Kuai
> 
> Regards
> Xiao
> 
> 
> .
> 

