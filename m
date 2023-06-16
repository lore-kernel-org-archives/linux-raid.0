Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51237EB64D9
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 02:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240848AbjFPCeU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Jun 2023 22:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjFPCeT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Jun 2023 22:34:19 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D8D2719
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 19:34:15 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Qj3Bp4LDMz4f3rY3
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 10:34:10 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgBnHbEeyotkNKQ7Lw--.21039S3;
        Fri, 16 Jun 2023 10:34:08 +0800 (CST)
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
To:     Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Ali Gholami Rudi <aligrudi@gmail.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20231506112411@laper.mirepesht>
 <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
 <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9531913b-6d6b-a28a-0a38-5300d7295248@huaweicloud.com>
Date:   Fri, 16 Jun 2023 10:34:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBnHbEeyotkNKQ7Lw--.21039S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFykAr1xtrW8JF4UCr48WFg_yoW5tr4rpF
        WkXayayF45Xr1Ikws7tr1jqay0ywsIqr47XF4DWr4xAF9FvrZag34UXryfuayjqrZ7Gr18
        Z3W8Wa43t3Wj9FDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbU
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/06/16 10:14, Xiao Ni 写道:
> On Thu, Jun 15, 2023 at 10:06 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2023/06/15 15:54, Ali Gholami Rudi 写道:
>>> Perf output:
>>>
>>> Samples: 1M of event 'cycles', Event count (approx.): 1158425235997
>>>     Children      Self  Command  Shared Object           Symbol
>>> +   97.98%     0.01%  fio      fio                     [.] fio_libaio_commit
>>> +   97.95%     0.01%  fio      libaio.so.1.0.1         [.] io_submit
>>> +   97.85%     0.01%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
>>> -   97.82%     0.01%  fio      [kernel.kallsyms]       [k] io_submit_one
>>>      - 97.81% io_submit_one
>>>         - 54.62% aio_write
>>>            - 54.60% blkdev_write_iter
>>>               - 36.30% blk_finish_plug
>>>                  - flush_plug_callbacks
>>>                     - 36.29% raid1_unplug
>>>                        - flush_bio_list
>>>                           - 18.44% submit_bio_noacct
>>>                              - 18.40% brd_submit_bio
>>>                                 - 18.13% raid1_end_write_request
>>>                                    - 17.94% raid_end_bio_io
>>>                                       - 17.82% __wake_up_common_lock
>>>                                          + 17.79% _raw_spin_lock_irqsave
>>>                           - 17.79% __wake_up_common_lock
>>>                              + 17.76% _raw_spin_lock_irqsave
>>>               + 18.29% __generic_file_write_iter
>>>         - 43.12% aio_read
>>>            - 43.07% blkdev_read_iter
>>>               - generic_file_read_iter
>>>                  - 43.04% blkdev_direct_IO
>>>                     - 42.95% submit_bio_noacct
>>>                        - 42.23% brd_submit_bio
>>>                           - 41.91% raid1_end_read_request
>>>                              - 41.70% raid_end_bio_io
>>>                                 - 41.43% __wake_up_common_lock
>>>                                    + 41.36% _raw_spin_lock_irqsave
>>>                        - 0.68% md_submit_bio
>>>                             0.61% md_handle_request
>>> +   94.90%     0.00%  fio      [kernel.kallsyms]       [k] __wake_up_common_lock
>>> +   94.86%     0.22%  fio      [kernel.kallsyms]       [k] _raw_spin_lock_irqsave
>>> +   94.64%    94.64%  fio      [kernel.kallsyms]       [k] native_queued_spin_lock_slowpath
>>> +   79.63%     0.02%  fio      [kernel.kallsyms]       [k] submit_bio_noacct
>>
>> This looks familiar... Perhaps can you try to test with raid10 with
>> latest mainline kernel? I used to optimize spin_lock for raid10, and I
>> don't do this for raid1 yet... I can try to do the same thing for raid1
>> if it's valuable.
> 
> Hi Kuai
> 
> Which patch?

https://lore.kernel.org/lkml/fbf58ad3-2eff-06df-6426-3b4629408e94@linux.dev/T/

> 
> I have a try on raid10. The results are:

Do your create the arry with 4 ramdisk?
> 
> raid10
> READ: bw=3711MiB/s (3892MB/s)
> WRITE: bw=1590MiB/s (1667MB/s)
> 
> raid0
> READ: bw=5610MiB/s (5882MB/s)
> WRITE: bw=2405MiB/s (2521MB/s)
> 
> ram0
> READ: bw=5468MiB/s (5734MB/s)
> WRITE: bw=2343MiB/s (2457MB/s)

I think spin_lock from fastpath in your machine probably doesn't matter
much. I'll be helpful if Ali can try to test raid10...

Thanks,
Kuai
> 
> Because raid10 has a function like raid0. So I did a test on raid0
> too. There is a performance gap between raid10 and ram disk too. The
> strange thing is that raid0 doesn't have a big performance
> improvement.
> 
> Regards
> Xiao
> 
> 
> 
>>
>>>
>>>
>>> FIO configuration file:
>>>
>>> [global]
>>> name=random reads and writes
>>> ioengine=libaio
>>> direct=1
>>> readwrite=randrw
>>> rwmixread=70
>>> iodepth=64
>>> buffered=0
>>> #filename=/dev/ram0
>>> filename=/dev/dm/test
>>> size=1G
>>> runtime=30
>>> time_based
>>> randrepeat=0
>>> norandommap
>>> refill_buffers
>>> ramp_time=10
>>> bs=4k
>>> numjobs=400
>>
>> 400 is too aggressive, I think spin_lock from fast path is probably
>> causing the problem, same as I met before for raid10...
>>
>> Thanks,
>> Kuai
>>
>>> group_reporting=1
>>> [job1]
>>>
>>> .
>>>
>>
> 
> .
> 

