Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E7BFEB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 12:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbjFPM1I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 08:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjFPM1H (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 08:27:07 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4431FFF
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 05:27:06 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QjJLs6pQDz4f3pJb
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 20:27:01 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgD3X7MVVYxkjzJbLw--.14074S3;
        Fri, 16 Jun 2023 20:27:02 +0800 (CST)
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
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <cbc45f91-c341-2207-b3ec-81701a8651b5@huaweicloud.com>
Date:   Fri, 16 Jun 2023 20:27:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20231606152106@laper.mirepesht>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3X7MVVYxkjzJbLw--.14074S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWDKw1DKw4rXryxWr4Uurg_yoWrWFWDpr
        4Yqr42yF4rZw1xKw1kK3Wj9Fy8JanxXF43GFWvqrWSkFnFq3s7K3sFv34fXa1j9r18Cw47
        X3s7Wasrt3Wj9FDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
        Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
        UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/06/16 19:51, Ali Gholami Rudi 写道:
> 

Thanks for testing!

> Perf's output:
> 
> +   93.79%     0.09%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
> +   92.89%     0.05%  fio      [kernel.kallsyms]       [k] do_syscall_64
> +   86.59%     0.07%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
> -   85.61%     0.10%  fio      [kernel.kallsyms]       [k] io_submit_one
>     - 85.51% io_submit_one
>        - 47.98% aio_read
>           - 46.18% blkdev_read_iter
>              - 44.90% __blkdev_direct_IO_async
>                 - 41.68% submit_bio_noacct_nocheck
>                    - 41.50% __submit_bio
>                       - 18.76% md_handle_request
>                          - 18.71% raid10_make_request
>                             - 18.54% raid10_read_request
>                                  16.54% read_balance

There is not any spin_lock in fast path anymore. Now, looks like
main cost is raid10 io path now(read_balance looks worth
investigation, 16.54% is too much), and for a real device with ms
io latency, I think latency in io path may not matter.

Thanks,
Kuai
>                                  1.80% wait_barrier_nolock
>                       - 14.18% raid10_end_read_request
>                          - 8.16% raid_end_bio_io
>                               7.44% allow_barrier
>                       - 8.40% brd_submit_bio
>                            2.49% __radix_tree_lookup
>                 - 1.39% bio_iov_iter_get_pages
>                    - 1.04% iov_iter_get_pages
>                       - __iov_iter_get_pages_alloc
>                          - 0.93% get_user_pages_fast
>                               0.79% internal_get_user_pages_fast
>                 - 1.17% bio_alloc_bioset
>                      0.59% mempool_alloc
>                0.93% filemap_write_and_wait_range
>             0.65% security_file_permission
>        - 35.21% aio_write
>           - 34.53% blkdev_write_iter
>              - 18.25% __generic_file_write_iter
>                 - 17.84% generic_file_direct_write
>                    - 17.35% __blkdev_direct_IO_async
>                       - 16.34% submit_bio_noacct_nocheck
>                          - 16.31% __submit_bio
>                             - 16.28% md_handle_request
>                                - 16.26% raid10_make_request
>                                     9.26% raid10_write_one_disk
>                                     2.11% wait_blocked_dev
>                                     0.58% wait_barrier_nolock
>              - 16.02% blk_finish_plug
>                 - 16.01% flush_plug_callbacks
>                    - 16.00% raid10_unplug
>                       - 15.89% submit_bio_noacct_nocheck
>                          - 15.84% __submit_bio
>                             - 8.66% raid10_end_write_request
>                                - 3.55% raid_end_bio_io
>                                     3.54% allow_barrier
>                                  0.72% find_bio_disk.isra.0
>                             - 7.04% brd_submit_bio
>                                  1.38% __radix_tree_lookup
>          0.61% kmem_cache_alloc
> +   84.41%     0.99%  fio      fio                     [.] thread_main
> +   83.79%     0.00%  fio      [unknown]               [.] 0xffffffffffffffff
> +   83.60%     0.00%  fio      fio                     [.] run_threads
> +   83.32%     0.00%  fio      fio                     [.] do_io (inlined)
> +   81.12%     0.43%  fio      libc-2.31.so            [.] syscall
> +   76.23%     0.69%  fio      fio                     [.] td_io_queue
> +   76.16%     4.66%  fio      [kernel.kallsyms]       [k] submit_bio_noacct_nocheck
> +   75.63%     0.25%  fio      fio                     [.] fio_libaio_commit
> +   75.57%     0.17%  fio      fio                     [.] td_io_commit
> +   75.54%     0.00%  fio      fio                     [.] io_u_submit (inlined)
> +   75.33%     0.17%  fio      libaio.so.1.0.1         [.] io_submit
> +   73.66%     0.07%  fio      [kernel.kallsyms]       [k] __submit_bio
> +   67.30%     5.07%  fio      [kernel.kallsyms]       [k] __blkdev_direct_IO_async
> +   48.02%     0.03%  fio      [kernel.kallsyms]       [k] aio_read
> +   46.22%     0.05%  fio      [kernel.kallsyms]       [k] blkdev_read_iter
> +   35.71%     3.88%  fio      [kernel.kallsyms]       [k] raid10_make_request
> +   35.23%     0.02%  fio      [kernel.kallsyms]       [k] aio_write
> +   35.08%     0.06%  fio      [kernel.kallsyms]       [k] md_handle_request
> +   34.55%     0.02%  fio      [kernel.kallsyms]       [k] blkdev_write_iter
> +   20.16%     1.65%  fio      [kernel.kallsyms]       [k] raid10_read_request
> +   18.27%     0.01%  fio      [kernel.kallsyms]       [k] __generic_file_write_iter
> +   18.02%     3.63%  fio      [kernel.kallsyms]       [k] brd_submit_bio
> +   17.86%     0.02%  fio      [kernel.kallsyms]       [k] generic_file_direct_write
> +   17.08%    11.16%  fio      [kernel.kallsyms]       [k] read_balance
> +   16.24%     0.33%  fio      [kernel.kallsyms]       [k] raid10_unplug
> +   16.02%     0.01%  fio      [kernel.kallsyms]       [k] blk_finish_plug
> +   16.02%     0.01%  fio      [kernel.kallsyms]       [k] flush_plug_callbacks
> +   14.25%     0.26%  fio      [kernel.kallsyms]       [k] raid10_end_read_request
> +   12.77%     1.98%  fio      [kernel.kallsyms]       [k] allow_barrier
> +   11.74%     0.40%  fio      [kernel.kallsyms]       [k] raid_end_bio_io
> +   10.21%     1.99%  fio      [kernel.kallsyms]       [k] raid10_write_one_disk
> +    8.85%     1.52%  fio      [kernel.kallsyms]       [k] raid10_end_write_request
>       8.06%     6.43%  fio      [kernel.kallsyms]       [k] wait_barrier_nolock
> ..
> 
> Thanks,
> Ali
> 
> .
> 

