Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C96EB64DA
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 08:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241164AbjFPIfP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 04:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245738AbjFPIe6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 04:34:58 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202042D7E
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 01:34:55 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QjCBy33vGz4f58D9
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 16:34:50 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCXaK+pHoxkn9ROLw--.5626S3;
        Fri, 16 Jun 2023 16:34:51 +0800 (CST)
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
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1117f940-6c7f-5505-f962-a06e3227ef24@huaweicloud.com>
Date:   Fri, 16 Jun 2023 16:34:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20231606115113@laper.mirepesht>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCXaK+pHoxkn9ROLw--.5626S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCr15ur15AF17trykAF1xGrg_yoWrGF43pr
        W7tF1ayFWUXryIqwn7tw4Y9Fy8tanrtry7GF4vg3y5AFnFqFy0gF42qryDArWqvr4kC3yx
        Xa4F9rZrt3WjgFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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

在 2023/06/16 16:21, Ali Gholami Rudi 写道:
> Hi,
> 
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>> And this is perf's output for raid10:
>>>
>>> +   97.33%     0.04%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
>>> +   96.96%     0.02%  fio      [kernel.kallsyms]       [k] do_syscall_64
>>> +   94.43%     0.03%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
>>> -   93.71%     0.04%  fio      [kernel.kallsyms]       [k] io_submit_one
>>>      - 93.67% io_submit_one
>>>         - 76.03% aio_write
>>>            - 75.53% blkdev_write_iter
>>>               - 68.95% blk_finish_plug
>>>                  - flush_plug_callbacks
>>>                     - 68.93% raid10_unplug
>>>                        - 64.31% __wake_up_common_lock
>>>                           - 64.17% _raw_spin_lock_irqsave
>>>                                native_queued_spin_lock_slowpath
>>
>> This is unexpected, can you check if your kernel contain following
>> patch?
>>
>> commit 460af1f9d9e62acce4a21f9bd00b5bcd5963bcd4
>> Author: Yu Kuai <yukuai3@huawei.com>
>> Date:   Mon May 29 21:11:06 2023 +0800
>>
>>       md/raid1-10: limit the number of plugged bio
>>
>> If so, can you retest with following patch?
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index d0de8c9fb3cf..6fdd99c3e59a 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -911,7 +911,7 @@ static void flush_pending_writes(struct r10conf *conf)
>>
>>                   blk_start_plug(&plug);
>>                   raid1_prepare_flush_writes(conf->mddev->bitmap);
>> -               wake_up(&conf->wait_barrier);
>> +               wake_up_barrier(&conf->wait_barrier);
>>
>>                   while (bio) { /* submit pending writes */
>>                           struct bio *next = bio->bi_next;
> 
> No, this patch was not present.  I applied this one:
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 4fcfcb350d2b..52f0c24128ff 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -905,7 +905,7 @@ static void flush_pending_writes(struct r10conf *conf)
>   		/* flush any pending bitmap writes to disk
>   		 * before proceeding w/ I/O */
>   		md_bitmap_unplug(conf->mddev->bitmap);
> -		wake_up(&conf->wait_barrier);
> +		wake_up_barrier(conf);
>   
>   		while (bio) { /* submit pending writes */
>   			struct bio *next = bio->bi_next;

Thanks for the testing, sorry that I missed one place... Can you try to
change wake_up() to wake_up_barrier() from raid10_unplug() and test
again?

Thanks,
Kuai

> 
> I get almost the same result as before nevertheless:
> 
> Without the patch:
> READ:  IOPS=2033k BW=8329MB/s
> WRITE: IOPS= 871k BW=3569MB/s
> 
> With the patch:
> READ:  IOPS=2027K BW=7920MiB/s
> WRITE: IOPS= 869K BW=3394MiB/s
> 
> Perf:
> 
> +   96.23%     0.04%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
> +   95.86%     0.02%  fio      [kernel.kallsyms]       [k] do_syscall_64
> +   94.30%     0.03%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
> -   93.63%     0.04%  fio      [kernel.kallsyms]       [k] io_submit_one
>     - 93.58% io_submit_one
>        - 76.44% aio_write
>           - 75.97% blkdev_write_iter
>              - 70.17% blk_finish_plug
>                 - flush_plug_callbacks
>                    - 70.15% raid10_unplug
>                       - 66.12% __wake_up_common_lock
>                          - 65.97% _raw_spin_lock_irqsave
>                               65.57% native_queued_spin_lock_slowpath
>                       - 3.85% submit_bio_noacct_nocheck
>                          - 3.84% __submit_bio
>                             - 2.09% raid10_end_write_request
>                                - 0.83% raid_end_bio_io
>                                     0.82% allow_barrier
>                               1.70% brd_submit_bio
>              + 5.59% __generic_file_write_iter
>        + 15.71% aio_read
> +   88.38%     0.71%  fio      fio                     [.] thread_main
> +   87.89%     0.00%  fio      [unknown]               [k] 0xffffffffffffffff
> +   87.81%     0.00%  fio      fio                     [.] run_threads
> +   87.54%     0.00%  fio      fio                     [.] do_io (inlined)
> +   86.79%     0.31%  fio      libc-2.31.so            [.] syscall
> +   86.19%     0.54%  fio      fio                     [.] td_io_queue
> +   85.79%     0.18%  fio      fio                     [.] fio_libaio_commit
> +   85.76%     0.14%  fio      fio                     [.] td_io_commit
> +   85.69%     0.14%  fio      libaio.so.1.0.1         [.] io_submit
> +   85.66%     0.00%  fio      fio                     [.] io_u_submit (inlined)
> +   76.45%     0.01%  fio      [kernel.kallsyms]       [k] aio_write
> ..
> 
> .
> 

