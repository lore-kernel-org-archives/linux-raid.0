Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50687EB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 07:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245128AbjFPHm5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 03:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjFPHmz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 03:42:55 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735C1270C
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 00:42:53 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QjB2t4cyNz4f3tCr
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 15:42:46 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgD3rLB2EoxkdAdMLw--.15416S3;
        Fri, 16 Jun 2023 15:42:48 +0800 (CST)
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
To:     Ali Gholami Rudi <aligrudi@gmail.com>,
        Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20231506112411@laper.mirepesht>
 <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
 <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
 <20231606091224@laper.mirepesht> <20231606110134@laper.mirepesht>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8b288984-396a-6093-bd1f-266303a8d2b6@huaweicloud.com>
Date:   Fri, 16 Jun 2023 15:42:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20231606110134@laper.mirepesht>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3rLB2EoxkdAdMLw--.15416S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJFW8Zr4DCry5Kr1UWF18uFg_yoWruw17pr
        4jqrsIyF4rZ34xKws7tw4j9Fy8JanIqry3JF4kW3yfArnrXrykK3Wjvry5Xayqvr4kG343
        X3s5WrW7t3Wj9FDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbU
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/06/16 15:31, Ali Gholami Rudi 写道:
> 
> Ali Gholami Rudi <aligrudi@gmail.com> wrote:
>> Xiao Ni <xni@redhat.com> wrote:
>>> On Thu, Jun 15, 2023 at 10:06 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>> This looks familiar... Perhaps can you try to test with raid10 with
>>>> latest mainline kernel? I used to optimize spin_lock for raid10, and I
>>>> don't do this for raid1 yet... I can try to do the same thing for raid1
>>>> if it's valuable.
>>
>> I do get improvements with raid10:
>>
>> Without RAID (writing to /dev/ram0)
>> READ:  IOPS=15.8M BW=60.3GiB/s
>> WRITE: IOPS= 6.8M BW=27.7GiB/s
>>
>> RAID1 (writing to /dev/md/test)
>> READ:  IOPS=518K BW=2028MiB/s
>> WRITE: IOPS=222K BW= 912MiB/s
>>
>> RAID10 (writing to /dev/md/test)
>> READ:  IOPS=2033k BW=8329MB/s
>> WRITE: IOPS= 871k BW=3569MB/s
>>
>> raid10 is about four times faster than raid1.
> 
> And this is perf's output for raid10:
> 
> +   97.33%     0.04%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
> +   96.96%     0.02%  fio      [kernel.kallsyms]       [k] do_syscall_64
> +   94.43%     0.03%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
> -   93.71%     0.04%  fio      [kernel.kallsyms]       [k] io_submit_one
>     - 93.67% io_submit_one
>        - 76.03% aio_write
>           - 75.53% blkdev_write_iter
>              - 68.95% blk_finish_plug
>                 - flush_plug_callbacks
>                    - 68.93% raid10_unplug
>                       - 64.31% __wake_up_common_lock
>                          - 64.17% _raw_spin_lock_irqsave
>                               native_queued_spin_lock_slowpath

This is unexpected, can you check if your kernel contain following
patch?

commit 460af1f9d9e62acce4a21f9bd00b5bcd5963bcd4
Author: Yu Kuai <yukuai3@huawei.com>
Date:   Mon May 29 21:11:06 2023 +0800

     md/raid1-10: limit the number of plugged bio

If so, can you retest with following patch?

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d0de8c9fb3cf..6fdd99c3e59a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -911,7 +911,7 @@ static void flush_pending_writes(struct r10conf *conf)

                 blk_start_plug(&plug);
                 raid1_prepare_flush_writes(conf->mddev->bitmap);
-               wake_up(&conf->wait_barrier);
+               wake_up_barrier(&conf->wait_barrier);

                 while (bio) { /* submit pending writes */
                         struct bio *next = bio->bi_next;

Thanks,
Kuai
>                       - 4.43% submit_bio_noacct_nocheck
>                          - 4.42% __submit_bio
>                             - 2.28% raid10_end_write_request
>                                - 0.82% raid_end_bio_io
>                                     0.82% allow_barrier
>                               2.09% brd_submit_bio
>              - 6.41% __generic_file_write_iter
>                 - 6.08% generic_file_direct_write
>                    - 5.64% __blkdev_direct_IO_async
>                       - 4.72% submit_bio_noacct_nocheck
>                          - 4.69% __submit_bio
>                             - 4.67% md_handle_request
>                                - 4.66% raid10_make_request
>                                     2.59% raid10_write_one_disk
>        - 16.14% aio_read
>           - 15.07% blkdev_read_iter
>              - 14.16% __blkdev_direct_IO_async
>                 - 11.36% submit_bio_noacct_nocheck
>                    - 11.17% __submit_bio
>                       - 5.89% md_handle_request
>                          - 5.84% raid10_make_request
>                             + 4.18% raid10_read_request
>                       - 3.74% raid10_end_read_request
>                          - 2.04% raid_end_bio_io
>                               1.46% allow_barrier
>                            0.55% mempool_free
>                         1.39% brd_submit_bio
>                 - 1.33% bio_iov_iter_get_pages
>                    - 1.00% iov_iter_get_pages
>                       - __iov_iter_get_pages_alloc
>                          - 0.85% get_user_pages_fast
>                               0.75% internal_get_user_pages_fast
>                   0.93% bio_alloc_bioset
>                0.65% filemap_write_and_wait_range
> +   88.31%     0.86%  fio      fio                     [.] thread_main
> +   87.69%     0.00%  fio      [unknown]               [k] 0xffffffffffffffff
> +   87.60%     0.00%  fio      fio                     [.] run_threads
> +   87.31%     0.00%  fio      fio                     [.] do_io (inlined)
> +   86.60%     0.32%  fio      libc-2.31.so            [.] syscall
> +   85.87%     0.52%  fio      fio                     [.] td_io_queue
> +   85.49%     0.18%  fio      fio                     [.] fio_libaio_commit
> +   85.45%     0.14%  fio      fio                     [.] td_io_commit
> +   85.37%     0.11%  fio      libaio.so.1.0.1         [.] io_submit
> +   85.35%     0.00%  fio      fio                     [.] io_u_submit (inlined)
> +   76.04%     0.01%  fio      [kernel.kallsyms]       [k] aio_write
> +   75.54%     0.01%  fio      [kernel.kallsyms]       [k] blkdev_write_iter
> +   68.96%     0.00%  fio      [kernel.kallsyms]       [k] blk_finish_plug
> +   68.95%     0.00%  fio      [kernel.kallsyms]       [k] flush_plug_callbacks
> +   68.94%     0.13%  fio      [kernel.kallsyms]       [k] raid10_unplug
> +   64.41%     0.03%  fio      [kernel.kallsyms]       [k] _raw_spin_lock_irqsave
> +   64.32%     0.01%  fio      [kernel.kallsyms]       [k] __wake_up_common_lock
> +   64.05%    63.85%  fio      [kernel.kallsyms]       [k] native_queued_spin_lock_slowpath
> +   21.05%     1.51%  fio      [kernel.kallsyms]       [k] submit_bio_noacct_nocheck
> +   20.97%     1.18%  fio      [kernel.kallsyms]       [k] __blkdev_direct_IO_async
> +   20.29%     0.03%  fio      [kernel.kallsyms]       [k] __submit_bio
> +   16.15%     0.02%  fio      [kernel.kallsyms]       [k] aio_read
> ..
> 
> Thanks,
> Ali
> 
> .
> 

