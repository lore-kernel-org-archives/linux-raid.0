Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21809EB64D9
	for <linux-raid@archiver.kernel.org>; Thu, 15 Jun 2023 14:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240990AbjFOODP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Jun 2023 10:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344703AbjFOODK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Jun 2023 10:03:10 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BFA2955
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 07:03:07 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QhkX26GzLz4f4231
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 22:02:58 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgBXwLMTGotkCPgTLw--.26687S3;
        Thu, 15 Jun 2023 22:03:00 +0800 (CST)
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
To:     Ali Gholami Rudi <aligrudi@gmail.com>, linux-raid@vger.kernel.org
Cc:     song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20231506112411@laper.mirepesht>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
Date:   Thu, 15 Jun 2023 22:02:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20231506112411@laper.mirepesht>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBXwLMTGotkCPgTLw--.26687S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJr1rXryfKw47Kr48Gr47XFb_yoW8tFW8pF
        Z8X3yayFnxJr1Igws7Kw12gFykCws0gF13Wr4UWFW7AF1DZ3s2g34UXryfXayUKrsrGr1D
        Zw4kuasxt3WqkFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/06/15 15:54, Ali Gholami Rudi 写道:
> Perf output:
> 
> Samples: 1M of event 'cycles', Event count (approx.): 1158425235997
>    Children      Self  Command  Shared Object           Symbol
> +   97.98%     0.01%  fio      fio                     [.] fio_libaio_commit
> +   97.95%     0.01%  fio      libaio.so.1.0.1         [.] io_submit
> +   97.85%     0.01%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
> -   97.82%     0.01%  fio      [kernel.kallsyms]       [k] io_submit_one
>     - 97.81% io_submit_one
>        - 54.62% aio_write
>           - 54.60% blkdev_write_iter
>              - 36.30% blk_finish_plug
>                 - flush_plug_callbacks
>                    - 36.29% raid1_unplug
>                       - flush_bio_list
>                          - 18.44% submit_bio_noacct
>                             - 18.40% brd_submit_bio
>                                - 18.13% raid1_end_write_request
>                                   - 17.94% raid_end_bio_io
>                                      - 17.82% __wake_up_common_lock
>                                         + 17.79% _raw_spin_lock_irqsave
>                          - 17.79% __wake_up_common_lock
>                             + 17.76% _raw_spin_lock_irqsave
>              + 18.29% __generic_file_write_iter
>        - 43.12% aio_read
>           - 43.07% blkdev_read_iter
>              - generic_file_read_iter
>                 - 43.04% blkdev_direct_IO
>                    - 42.95% submit_bio_noacct
>                       - 42.23% brd_submit_bio
>                          - 41.91% raid1_end_read_request
>                             - 41.70% raid_end_bio_io
>                                - 41.43% __wake_up_common_lock
>                                   + 41.36% _raw_spin_lock_irqsave
>                       - 0.68% md_submit_bio
>                            0.61% md_handle_request
> +   94.90%     0.00%  fio      [kernel.kallsyms]       [k] __wake_up_common_lock
> +   94.86%     0.22%  fio      [kernel.kallsyms]       [k] _raw_spin_lock_irqsave
> +   94.64%    94.64%  fio      [kernel.kallsyms]       [k] native_queued_spin_lock_slowpath
> +   79.63%     0.02%  fio      [kernel.kallsyms]       [k] submit_bio_noacct

This looks familiar... Perhaps can you try to test with raid10 with
latest mainline kernel? I used to optimize spin_lock for raid10, and I
don't do this for raid1 yet... I can try to do the same thing for raid1
if it's valuable.

> 
> 
> FIO configuration file:
> 
> [global]
> name=random reads and writes
> ioengine=libaio
> direct=1
> readwrite=randrw
> rwmixread=70
> iodepth=64
> buffered=0
> #filename=/dev/ram0
> filename=/dev/dm/test
> size=1G
> runtime=30
> time_based
> randrepeat=0
> norandommap
> refill_buffers
> ramp_time=10
> bs=4k
> numjobs=400

400 is too aggressive, I think spin_lock from fast path is probably
causing the problem, same as I met before for raid10...

Thanks,
Kuai

> group_reporting=1
> [job1]
> 
> .
> 

