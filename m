Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1FF0EB64D8
	for <linux-raid@archiver.kernel.org>; Mon, 19 Jun 2023 01:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjFSBW7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 18 Jun 2023 21:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjFSBW6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 18 Jun 2023 21:22:58 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5161B9
        for <linux-raid@vger.kernel.org>; Sun, 18 Jun 2023 18:22:57 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QksT90JTzz4f3n6j
        for <linux-raid@vger.kernel.org>; Mon, 19 Jun 2023 09:22:53 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgD3X7PsrY9kyGQaMA--.2407S3;
        Mon, 19 Jun 2023 09:22:53 +0800 (CST)
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
 <20231906000051@laper.mirepesht>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c9fbb419-ec62-8673-ded2-cc11d3a11d7f@huaweicloud.com>
Date:   Mon, 19 Jun 2023 09:22:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20231906000051@laper.mirepesht>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3X7PsrY9kyGQaMA--.2407S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtw1xGr1rXFWxJFWUCFWkXrb_yoWxXrW3pr
        1DKF4akF4fuw1xKa1IkryqgFs7Gws3Jw13JwsrXr45A3Wxur93uw1DWF1FqayUJr40kwn7
        X34kWFySvasFvFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2023/06/19 4:30, Ali Gholami Rudi 写道:
> Hi,
> 
> I tested raid10 with NVMe disks on Debian 12 (Linux 6.1.0), which
> includes your first patch only.
> 
> The speed was very bad:
> 
> READ:  IOPS=360K BW=1412MiB/s
> WRITE: IOPS=154K BW= 606MiB/s
> 

Can you try to test with --bitmap=none, and --assume-clean(or echo
frozen to sync_action), let's see if spin_lock from wait_barrier() and
from md_bitmap_startwrite is bypassed, how performance will be.

Thanks,
Kuai

> Perf's output:
> 
> +   98.90%     0.00%  fio      [unknown]               [.] 0xffffffffffffffff
> +   98.71%     0.00%  fio      fio                     [.] 0x0000563ae0f62117
> +   97.69%     0.02%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
> +   97.66%     0.02%  fio      [kernel.kallsyms]       [k] do_syscall_64
> +   97.29%     0.00%  fio      fio                     [.] 0x0000563ae0f5fceb
> +   97.29%     0.05%  fio      fio                     [.] td_io_queue
> +   97.20%     0.01%  fio      fio                     [.] td_io_commit
> +   97.20%     0.02%  fio      libc.so.6               [.] syscall
> +   96.94%     0.05%  fio      libaio.so.1.0.2         [.] io_submit
> +   96.94%     0.00%  fio      fio                     [.] 0x0000563ae0f84e5e
> +   96.50%     0.02%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
> -   96.44%     0.03%  fio      [kernel.kallsyms]       [k] io_submit_one
>     - 96.41% io_submit_one
>        - 65.16% aio_read
>           - 65.07% xfs_file_read_iter
>              - 65.06% xfs_file_dio_read
>                 - 60.21% iomap_dio_rw
>                    - 60.21% __iomap_dio_rw
>                       - 49.84% iomap_dio_bio_iter
>                          - 49.39% submit_bio_noacct_nocheck
>                             - 49.08% __submit_bio
>                                - 48.80% md_handle_request
>                                   - 48.40% raid10_make_request
>                                      - 48.14% raid10_read_request
>                                         - 47.63% regular_request_wait
>                                            - 47.62% wait_barrier
>                                               - 44.17% _raw_spin_lock_irq
>                                                    44.14% native_queued_spin_lock_slowpath
>                                               - 2.39% schedule
>                                                  - 2.38% __schedule
>                                                     + 1.99% pick_next_task_fair
>                       - 9.78% iomap_iter
>                          - 9.77% xfs_read_iomap_begin
>                             - 9.30% xfs_ilock_for_iomap
>                                - 9.29% down_read
>                                   - 9.18% rwsem_down_read_slowpath
>                                      - 4.67% schedule_preempt_disabled
>                                         - 4.67% schedule
>                                            - 4.67% __schedule
>                                               - 4.08% pick_next_task_fair
>                                                  - 4.08% newidle_balance
>                                                     - 3.94% load_balance
>                                                        - 3.60% find_busiest_group
>                                                             3.59% update_sd_lb_stats.constprop.0
>                                      - 4.12% _raw_spin_lock_irq
>                                           4.11% native_queued_spin_lock_slowpath
>                 + 4.56% touch_atime
>        - 31.12% aio_write
>           - 31.06% xfs_file_write_iter
>              - 31.00% xfs_file_dio_write_aligned
>                 - 27.41% iomap_dio_rw
>                    - 27.40% __iomap_dio_rw
>                       - 23.29% iomap_dio_bio_iter
>                          - 23.14% submit_bio_noacct_nocheck
>                             - 23.11% __submit_bio
>                                - 23.02% md_handle_request
>                                   - 22.85% raid10_make_request
>                                      - 20.45% regular_request_wait
>                                         - 20.44% wait_barrier
>                                            - 18.97% _raw_spin_lock_irq
>                                                 18.96% native_queued_spin_lock_slowpath
>                                            - 1.02% schedule
>                                               - 1.02% __schedule
>                                                  - 0.85% pick_next_task_fair
>                                                     + 0.84% newidle_balance
>                                      + 1.85% md_bitmap_startwrite
>                       - 3.20% iomap_iter
>                          - 3.19% xfs_direct_write_iomap_begin
>                             - 3.00% xfs_ilock_for_iomap
>                                - 2.99% down_read
>                                   - 2.95% rwsem_down_read_slowpath
>                                      + 1.70% schedule_preempt_disabled
>                                      + 1.13% _raw_spin_lock_irq
>                       + 0.81% blk_finish_plug
>                 + 3.47% xfs_file_write_checks
> +   87.62%     0.01%  fio      [kernel.kallsyms]       [k] iomap_dio_rw
> +   87.61%     0.14%  fio      [kernel.kallsyms]       [k] __iomap_dio_rw
> +   74.85%    74.85%  fio      [kernel.kallsyms]       [k] native_queued_spin_lock_slowpath
> +   73.13%     0.10%  fio      [kernel.kallsyms]       [k] iomap_dio_bio_iter
> +   72.99%     0.11%  fio      [kernel.kallsyms]       [k] _raw_spin_lock_irq
> +   72.76%     0.02%  fio      [kernel.kallsyms]       [k] submit_bio_noacct_nocheck
> +   72.20%     0.01%  fio      [kernel.kallsyms]       [k] __submit_bio
> +   71.82%     0.43%  fio      [kernel.kallsyms]       [k] md_handle_request
> +   71.25%     0.15%  fio      [kernel.kallsyms]       [k] raid10_make_request
> +   68.08%     0.02%  fio      [kernel.kallsyms]       [k] regular_request_wait
> +   68.06%     0.57%  fio      [kernel.kallsyms]       [k] wait_barrier
> +   65.16%     0.01%  fio      [kernel.kallsyms]       [k] aio_read
> +   65.07%     0.01%  fio      [kernel.kallsyms]       [k] xfs_file_read_iter
> +   65.06%     0.01%  fio      [kernel.kallsyms]       [k] xfs_file_dio_read
> +   48.14%     0.12%  fio      [kernel.kallsyms]       [k] raid10_read_request
> 
> Note that in the ramdisk tests, I gate whole ramdisks or raid devices
> to fio.  Here I used files on the filesystem.
> 
> Thanks,
> Ali
> 
> # cat /proc/mdstat:
> Personalities : [raid10] [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4]
> md127 : active raid10 ram1[1] ram0[0]
>        1046528 blocks super 1.2 2 near-copies [2/2] [UU]
> 
> md3 : active raid10 nvme0n1p5[0] nvme1n1p5[1] nvme3n1p5[3] nvme4n1p5[4] nvme6n1p5[6] nvme5n1p5[5] nvme7n1p5[7] nvme2n1p5[2]
>        14887084032 blocks super 1.2 512K chunks 2 near-copies [8/8] [UUUUUUUU]
>        [=======>.............]  resync = 37.2% (5549960960/14887084032) finish=754.4min speed=206272K/sec
>        bitmap: 70/111 pages [280KB], 65536KB chunk
> 
> md1 : active raid10 nvme1n1p3[1] nvme3n1p3[3] nvme0n1p3[0] nvme4n1p3[4] nvme5n1p3[5] nvme6n1p3[6] nvme7n1p3[7] nvme2n1p3[2]
>        41906176 blocks super 1.2 512K chunks 2 near-copies [8/8] [UUUUUUUU]
> 
> md0 : active raid10 nvme1n1p2[1] nvme3n1p2[3] nvme0n1p2[0] nvme6n1p2[6] nvme4n1p2[4] nvme5n1p2[5] nvme7n1p2[7] nvme2n1p2[2]
>        2084864 blocks super 1.2 512K chunks 2 near-copies [8/8] [UUUUUUUU]
> 
> md2 : active (auto-read-only) raid10 nvme4n1p4[4] nvme1n1p4[1] nvme3n1p4[3] nvme0n1p4[0] nvme6n1p4[6] nvme7n1p4[7] nvme5n1p4[5] nvme2n1p4[2]
>        67067904 blocks super 1.2 512K chunks 2 near-copies [8/8] [UUUUUUUU]
>          resync=PENDING
> 
> unused devices: <none>
> 
> # lspci | grep NVM
> 01:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
> 02:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
> 03:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
> 04:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
> 61:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
> 62:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
> 83:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
> 84:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
> #
> 
> .
> 

