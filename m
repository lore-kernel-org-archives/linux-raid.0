Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C36EB64D9
	for <linux-raid@archiver.kernel.org>; Mon, 19 Jun 2023 06:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjFSGxf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Jun 2023 02:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjFSGxe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Jun 2023 02:53:34 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700DBC6
        for <linux-raid@vger.kernel.org>; Sun, 18 Jun 2023 23:53:32 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Ql0pb4Mpdz4f42Rh
        for <linux-raid@vger.kernel.org>; Mon, 19 Jun 2023 14:53:27 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCHK59o+49kTVMrMA--.7532S3;
        Mon, 19 Jun 2023 14:53:29 +0800 (CST)
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
 <20231606122233@laper.mirepesht> <20231606152106@laper.mirepesht>
 <cbc45f91-c341-2207-b3ec-81701a8651b5@huaweicloud.com>
 <20231906000051@laper.mirepesht> <20231906084945@tare.nit>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <195f60f8-5c61-3aa3-806c-997457a1dbe0@huaweicloud.com>
Date:   Mon, 19 Jun 2023 14:53:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20231906084945@tare.nit>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCHK59o+49kTVMrMA--.7532S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCr15Wry5ArWDCFy3XFWkZwb_yoWrCFW7pa
        yDKFsIqF4rWw1Igw4xtF90vrWkCws0qw17Jr4xW3y3Cr1qqr9293WxWF1aqayDKrs7Gw47
        Xwn5Zry7J3WqyFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2023/06/19 13:19, Ali Gholami Rudi 写道:
> Hi,
> 
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
>> Can you try to test with --bitmap=none, and --assume-clean(or echo
>> frozen to sync_action), let's see if spin_lock from wait_barrier() and
>> from md_bitmap_startwrite is bypassed, how performance will be.
> 
> I did not notice that it was syncing disks in the background.
> It is much better now:
> 
> READ:  IOPS=1748K BW=6830MiB/s
> WRITE: IOPS= 749K BW=2928MiB/s
> 

This looks good, and cost from spin_lock() from raid10_unplug() is about
4%, this can also be avoided, however, performance should not be
improved obviously.

Thanks,
Kuai
> Perf's output:
> 
> +   98.04%     0.00%  fio      [unknown]               [k] 0xffffffffffffffff
> +   97.86%     0.00%  fio      fio                     [.] 0x000055ed33e52117
> +   94.64%     0.03%  fio      libc.so.6               [.] syscall
> +   94.54%     0.09%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
> +   94.44%     0.03%  fio      [kernel.kallsyms]       [k] do_syscall_64
> +   94.31%     0.00%  fio      fio                     [.] 0x000055ed33e4fceb
> +   94.31%     0.07%  fio      fio                     [.] td_io_queue
> +   94.15%     0.03%  fio      fio                     [.] td_io_commit
> +   93.77%     0.05%  fio      libaio.so.1.0.2         [.] io_submit
> +   93.77%     0.00%  fio      fio                     [.] 0x000055ed33e74e5e
> +   92.03%     0.04%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
> -   91.86%     0.05%  fio      [kernel.kallsyms]       [k] io_submit_one
>     - 91.81% io_submit_one
>        - 52.43% aio_read
>           - 51.94% ext4_file_read_iter
>              - 36.03% iomap_dio_rw
>                 - 36.02% __iomap_dio_rw
>                    - 21.56% iomap_dio_bio_iter
>                       - 17.72% submit_bio_noacct_nocheck
>                          - 17.09% __submit_bio
>                             - 14.81% md_handle_request
>                                - 8.34% raid10_make_request
>                                   - 6.96% raid10_read_request
>                                      - 2.76% regular_request_wait
>                                           2.58% wait_barrier
>                                        0.76% read_balance
>                                - 1.07% asm_common_interrupt
>                                   - 1.07% common_interrupt
>                                      - 1.06% __common_interrupt
>                                         + 1.06% handle_edge_irq
>                               2.22% md_submit_bio
>                            0.51% blk_mq_submit_bio
>                    - 10.68% iomap_iter
>                       - 10.64% ext4_iomap_begin
>                          - 4.07% ext4_map_blocks
>                             - 3.80% ext4_es_lookup_extent
>                                  1.77% _raw_read_lock
>                                  1.68% _raw_read_unlock
>                            3.51% ext4_set_iomap
>                          + 0.54% asm_common_interrupt
>                    - 1.21% blk_finish_plug
>                       - 1.20% __blk_flush_plug
>                          - 1.19% blk_mq_flush_plug_list
>                             - 1.15% nvme_queue_rqs
>                                + 1.01% nvme_prep_rq.part.0
>              - 6.04% down_read
>                 - 1.73% asm_common_interrupt
>                    - 1.73% common_interrupt
>                       - 1.72% __common_interrupt
>                          - 1.71% handle_edge_irq
>                             - 1.58% handle_irq_event
>                                - 1.57% __handle_irq_event_percpu
>                                   - nvme_irq
>                                      - 1.46% blk_mq_end_request_batch
>                                           0.80% raid10_end_write_request
>                                           0.55% raid10_end_read_request
>              - 5.43% up_read
>                 + 0.99% asm_common_interrupt
>              - 3.99% touch_atime
>                 - 3.87% atime_needs_update
>                    + 0.68% asm_common_interrupt
>        - 39.00% aio_write
>           - 38.78% ext4_file_write_iter
>              - 28.16% iomap_dio_rw
>                 - 28.15% __iomap_dio_rw
>                    - 14.49% iomap_dio_bio_iter
>                       - 12.65% submit_bio_noacct_nocheck
>                          - 12.61% __submit_bio
>                             - 11.54% md_handle_request
>                                - 7.91% raid10_make_request
>                                     3.24% raid10_write_one_disk
>                                   - 1.21% regular_request_wait
>                                        1.13% wait_barrier
>                                     1.14% wait_blocked_dev
>                                + 0.57% asm_common_interrupt
>                               1.04% md_submit_bio
>                    - 8.05% blk_finish_plug
>                       - 8.04% __blk_flush_plug
>                          - 6.42% raid10_unplug
>                             - 4.19% __wake_up_common_lock
>                                - 3.60% _raw_spin_lock_irqsave
>                                     3.40% native_queued_spin_lock_slowpath
>                                  0.59% _raw_spin_unlock_irqrestore
>                             - 1.00% submit_bio_noacct_nocheck
>                                + 0.93% blk_mq_submit_bio
>                          - 1.59% blk_mq_flush_plug_list
>                             - 1.02% blk_mq_sched_insert_requests
>                                + 0.98% blk_mq_try_issue_list_directly
>                    - 4.53% iomap_iter
>                       - 4.51% ext4_iomap_overwrite_begin
>                          - 4.51% ext4_iomap_begin
>                             - 1.69% ext4_map_blocks
>                                - 1.58% ext4_es_lookup_extent
>                                     0.72% _raw_read_lock
>                                     0.71% _raw_read_unlock
>                               1.54% ext4_set_iomap
>              - 2.83% up_read
>                 + 0.92% asm_common_interrupt
>              - 2.26% down_read
>                 + 0.57% asm_common_interrupt
>              - 1.81% ext4_map_blocks
>                 - 1.66% ext4_es_lookup_extent
>                      0.81% _raw_read_lock
>                      0.70% _raw_read_unlock
>              - 1.67% file_modified_flags
>                   1.43% inode_needs_update_time.part.0
> +   64.19%     0.02%  fio      [kernel.kallsyms]       [k] iomap_dio_rw
> +   64.17%     2.41%  fio      [kernel.kallsyms]       [k] __iomap_dio_rw
> +   52.43%     0.03%  fio      [kernel.kallsyms]       [k] aio_read
> +   51.94%     0.04%  fio      [kernel.kallsyms]       [k] ext4_file_read_iter
> 
> Thanks,
> Ali
> 
> .
> 

