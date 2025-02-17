Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE9618DB35
	for <linux-raid@vger.kernel.org>; Mon, 17 Feb 2025 12:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739794715; cv=none; b=r8ZezO3/I4StWamt4TQoFZtbePe1u4/YEPIrFru77a9m0m4SW1326e1zhC2Ov3Cbd1LeaxNRysBRrH2eooeJG6EGt9pZ/huC9D0ZoIiJC88IvAIo7ZG9BjarqyLbmb6wPY2TMwfVkDB5/KTo2gF0QaZa4S9LqiElz2u1pxoZ+Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739794715; c=relaxed/simple;
	bh=fgK/OVBIffATLIfItcabLuO5dCdGsfG3yLyL8cZ5Leo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ZfxoS6nLoHqKV5q+PLpAvd1UMeIx8jvv+8MKPaeQxDD4pa3BsyVMxjxk/V/oVr4UNdu1KOuC8yYgTJ1+N231o0Nz4RtTYfr37dLsV57K8xqF1yUsjTjRNxct8E+0+chvBru0z/Kk9W/76qrJx7MrK3FavxDGu3yVKu6kt+Gq6SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YxMB51h9Zz4f3kvv
	for <linux-raid@vger.kernel.org>; Mon, 17 Feb 2025 20:18:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 290AF1A12C9
	for <linux-raid@vger.kernel.org>; Mon, 17 Feb 2025 20:18:28 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2ASKbNnYHdsEA--.7656S3;
	Mon, 17 Feb 2025 20:18:28 +0800 (CST)
Subject: Re: Huge lock contention during raid5 build time
To: Anton Gavriliuk <antosha20xx@gmail.com>, Song Liu <song@kernel.org>
Cc: Shushu Yi <firnyee@gmail.com>, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <CAAiJnjqFwETu8ZwE44jdNWk=UYbdoNJr0W7pjkgjkTy0ff8grA@mail.gmail.com>
 <CAPhsuW56KORS78c-buACrq0TWJ+qewwh+QUmC-ePJO3LVVjeyQ@mail.gmail.com>
 <CAAiJnjpTAXz8TyhKD4DmpgYJ21CRJh-bLEOqZUitWYONumggAw@mail.gmail.com>
 <CAPhsuW7gjyCRdHp3cRFgNxMO2kXAjMOYgW+ekqBMX18d4657Yg@mail.gmail.com>
 <CAAiJnjqLLK5PY84q6Ni_uZYQXwxDcQCum2-_=FAkkxOmh-VCPg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <618a8a56-04de-7ddf-b30e-83380337f8c8@huaweicloud.com>
Date: Mon, 17 Feb 2025 20:18:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAiJnjqLLK5PY84q6Ni_uZYQXwxDcQCum2-_=FAkkxOmh-VCPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnC2ASKbNnYHdsEA--.7656S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GF1rJr1xCrWkGF4kJw43Wrg_yoWfZrWfpr
	13Aa1qqr4rZr40kw4qq3WjkFyfA3s7XFnxGrn0q3yfuw1ktr92vw12qr1fX3yUGrsrKr4I
	q34vqry7Ka4YyrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7I
	JmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/01/27 20:32, Anton Gavriliuk 写道:
>> Yes, group_thread_cnt sometimes (usually?) causes more lock
>> contention and lower performance.
> 
> [root@memverge2 anton]# /home/anton/mdadm/mdadm --version
> mdadm - v4.4-15-g21e4efb1 - 2025-01-27
> 
> /home/anton/mdadm/mdadm --create --verbose /dev/md0 --level=5
> --raid-devices=4 /dev/nvme0n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1
> 
> Without group_thread_cnt (with sync_speed_max=3600000 only) it is not
> 1.4 GB/s, 1 GB/s
> 
> [root@memverge2 anton]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 nvme4n1[4] nvme3n1[2] nvme2n1[1] nvme0n1[0]
>        4688044032 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [UUU_]
>        [>....................]  recovery =  3.2% (50134272/1562681344)
> finish=24.5min speed=1027434K/sec
>        bitmap: 0/12 pages [0KB], 65536KB chunk
> 
>> Could you please run perf-report on the perf.data? I won't be
>> able to see all the symbols without your kernel.
> 
> [root@memverge2 anton]# perf record -g
> ^C[ perf record: Woken up 36 times to write data ]
> [ perf record: Captured and wrote 9.632 MB perf.data (61989 samples) ]
> 
> [root@memverge2 anton]# perf report
> 
> Samples: 61K of event 'cycles:P', Event count (approx.): 61959249145

We're unable to recognize the call trace here, we still don't know where
the lock contention is. Can you try flamegraph here?

https://github.com/brendangregg/FlameGraph

After perf record -a -g
perf script -i perf.data | stackcollapse-perf.pl | flamegraph.pl > perf.svg

I don't think bitmap will be used during the first build, and for read
write test, you can just disable the bitmap to bypass lock contention
from bitmap,

Thanks,
Kuai

>    Children      Self  Command          Shared Object
>            Symbol
> +   79.59%     0.00%  md0_raid5        [kernel.kallsyms]
>            [k] ret_from_fork_asm
> +   79.59%     0.00%  md0_raid5        [kernel.kallsyms]
>            [k] ret_from_fork
> +   79.59%     0.00%  md0_raid5        [kernel.kallsyms]
>            [k] kthread
> +   79.59%     0.00%  md0_raid5        [kernel.kallsyms]
>            [k] md_thread
> +   79.59%     0.06%  md0_raid5        [kernel.kallsyms]
>            [k] raid5d
> +   74.47%     0.67%  md0_raid5        [kernel.kallsyms]
>            [k] handle_active_stripes.isra
> +   68.27%     4.84%  md0_raid5        [kernel.kallsyms]
>            [k] handle_stripe
> +   27.47%     0.11%  md0_raid5        [kernel.kallsyms]
>            [k] raid_run_ops
> +   27.36%     0.25%  md0_raid5        [kernel.kallsyms]
>            [k] ops_run_compute5
> +   27.10%     0.07%  md0_raid5        [kernel.kallsyms]
>            [k] async_xor_offs
> +   26.42%     0.16%  md0_raid5        [kernel.kallsyms]
>            [k] do_sync_xor_offs
> +   21.94%     7.87%  md0_raid5        [kernel.kallsyms]
>            [k] ops_run_io
> +   19.34%    18.19%  md0_raid5        [kernel.kallsyms]
>            [k] xor_avx_4
> +   13.35%     0.00%  md0_resync       [kernel.kallsyms]
>            [k] ret_from_fork_asm
> +   13.35%     0.00%  md0_resync       [kernel.kallsyms]
>            [k] ret_from_fork
> +   13.35%     0.00%  md0_resync       [kernel.kallsyms]
>            [k] kthread
> +   13.35%     0.00%  md0_resync       [kernel.kallsyms]
>            [k] md_thread
> +   13.35%     0.55%  md0_resync       [kernel.kallsyms]
>            [k] md_do_sync.cold
> +   12.41%     0.69%  md0_resync       [kernel.kallsyms]
>            [k] raid5_sync_request
> +   12.18%     0.35%  md0_raid5        [kernel.kallsyms]
>            [k] submit_bio_noacct_nocheck
> +   11.67%     0.54%  md0_raid5        [kernel.kallsyms]
>            [k] __submit_bio
> +   11.06%     0.79%  md0_raid5        [kernel.kallsyms]
>            [k] blk_mq_submit_bio
> +   10.76%     9.83%  md0_raid5        [kernel.kallsyms]
>            [k] analyse_stripe
> +   10.46%     0.29%  md0_resync       [kernel.kallsyms]
>            [k] raid5_get_active_stripe
> +    6.84%     6.49%  md0_raid5        [kernel.kallsyms]
>            [k] memset_orig
> +    6.59%     0.00%  swapper          [kernel.kallsyms]
>            [k] common_startup_64
> +    6.59%     0.01%  swapper          [kernel.kallsyms]
>            [k] cpu_startup_entry
> +    6.58%     0.03%  swapper          [kernel.kallsyms]
>            [k] do_idle
> +    6.44%     0.00%  swapper          [kernel.kallsyms]
>            [k] start_secondary          ▒
> +    5.55%     0.01%  md0_raid5        [kernel.kallsyms]
>            [k] asm_common_interrupt     ▒
> +    5.53%     0.01%  md0_raid5        [kernel.kallsyms]
>            [k] common_interrupt         ▒
> +    5.45%     0.01%  md0_raid5        [kernel.kallsyms]
>            [k] blk_add_rq_to_plug       ▒
> +    5.44%     0.02%  swapper          [kernel.kallsyms]
>            [k] cpuidle_idle_call        ▒
> +    5.44%     0.01%  md0_raid5        [kernel.kallsyms]
>            [k] blk_mq_flush_plug_list   ▒
> +    5.43%     0.17%  md0_raid5        [kernel.kallsyms]
>            [k] blk_mq_dispatch_plug_list▒
> +    5.41%     0.01%  md0_raid5        [kernel.kallsyms]
>            [k] __common_interrupt       ▒
> +    5.40%     0.03%  md0_raid5        [kernel.kallsyms]
>            [k] handle_edge_irq          ▒
> +    5.32%     0.01%  md0_raid5        [kernel.kallsyms]
>            [k] handle_irq_event         ▒
> +    5.25%     0.01%  md0_raid5        [kernel.kallsyms]
>            [k] __handle_irq_event_percpu▒
> +    5.25%     0.01%  md0_raid5        [kernel.kallsyms]
>            [k] nvme_irq                 ▒
> +    5.18%     0.14%  md0_raid5        [kernel.kallsyms]
>            [k] blk_mq_insert_requests   ▒
> +    5.15%     0.00%  swapper          [kernel.kallsyms]
>            [k] cpuidle_enter            ▒
> +    5.15%     0.03%  swapper          [kernel.kallsyms]
>            [k] cpuidle_enter_state      ▒
> +    5.05%     1.29%  md0_raid5        [kernel.kallsyms]
>            [k] release_stripe_list      ▒
> +    5.00%     0.01%  md0_raid5        [kernel.kallsyms]
>            [k] blk_mq_try_issue_list_dir▒
> +    4.98%     0.00%  md0_raid5        [kernel.kallsyms]
>            [k] __blk_mq_issue_directly  ▒
> +    4.97%     0.03%  md0_raid5        [kernel.kallsyms]
>            [k] nvme_queue_rq            ▒
> +    4.86%     1.03%  md0_resync       [kernel.kallsyms]
>            [k] init_stripe              ▒
> +    4.80%     0.07%  md0_raid5        [kernel.kallsyms]
>            [k] nvme_prep_rq.part.0      ▒
> +    4.57%     0.03%  md0_raid5        [kernel.kallsyms]
>            [k] nvme_map_data
> +    4.17%     0.17%  md0_raid5        [kernel.kallsyms]
>            [k] blk_mq_end_request_batch ▒
> +    3.52%     3.49%  swapper          [kernel.kallsyms]
>            [k] poll_idle                ▒
> +    3.51%     1.67%  md0_resync       [kernel.kallsyms]
>            [k] raid5_compute_blocknr    ▒
> +    3.21%     0.47%  md0_raid5        [kernel.kallsyms]
>            [k] blk_attempt_plug_merge   ▒
> +    3.13%     3.13%  md0_resync       [kernel.kallsyms]
>            [k] find_get_stripe          ▒
> +    3.01%     0.01%  md0_raid5        [kernel.kallsyms]
>            [k] __dma_map_sg_attrs       ▒
> +    3.01%     0.00%  md0_raid5        [kernel.kallsyms]
>            [k] dma_map_sgtable          ▒
> +    3.00%     2.37%  md0_raid5        [kernel.kallsyms]
>            [k] dma_direct_map_sg        ▒
> +    2.59%     2.13%  md0_raid5        [kernel.kallsyms]
>            [k] do_release_stripe        ▒
> +    2.45%     1.45%  md0_raid5        [kernel.kallsyms]
>            [k] __get_priority_stripe    ▒
> +    2.15%     2.14%  md0_resync       [kernel.kallsyms]
>            [k] raid5_compute_sector     ▒
> +    2.14%     0.35%  md0_raid5        [kernel.kallsyms]
>            [k] bio_attempt_back_merge   ▒
> +    1.99%     1.93%  md0_raid5        [kernel.kallsyms]
>            [k] raid5_end_read_request   ▒
> +    1.38%     1.00%  md0_raid5        [kernel.kallsyms]
>            [k] fetch_block              ▒
> +    1.35%     0.14%  md0_raid5        [kernel.kallsyms]
>            [k] release_inactive_stripe_l▒
> +    1.35%     0.40%  md0_raid5        [kernel.kallsyms]
>            [k] ll_back_merge_fn         ▒
> +    1.27%     1.25%  md0_resync       [kernel.kallsyms]
>            [k] _raw_spin_lock_irq       ▒
> +    1.11%     1.11%  md0_raid5        [kernel.kallsyms]
>            [k] llist_reverse_order      ▒
> +    1.10%     0.70%  md0_raid5        [kernel.kallsyms]
>            [k] raid5_release_stripe     ▒
> +    1.05%     1.00%  md0_raid5        [kernel.kallsyms]
>            [k] md_wakeup_thread         ▒
> +    1.02%     0.97%  swapper          [kernel.kallsyms]
>            [k] intel_idle_irq           ▒
> +    0.99%     0.01%  md0_raid5        [kernel.kallsyms]
>            [k] __blk_rq_map_sg          ▒
> +    0.97%     0.84%  md0_raid5        [kernel.kallsyms]
>            [k] __blk_bios_map_sg        ▒
> +    0.91%     0.04%  md0_raid5        [kernel.kallsyms]
>            [k] __wake_up                ▒
> +    0.84%     0.74%  md0_raid5        [kernel.kallsyms]
>            [k] _raw_spin_lock_irqsave
> 
> Anton
> 
> пт, 24 янв. 2025 г. в 23:48, Song Liu <song@kernel.org>:
>>
>> On Fri, Jan 24, 2025 at 12:00 AM Anton Gavriliuk <antosha20xx@gmail.com> wrote:
>>>
>>>> We need major work to make it faster so that we can keep up with
>>>> the speed of modern SSDs.
>>>
>>> Glad to know that this in your roadmap.
>>> This is very important for storage server solutions, when you can add
>>> ten's NVMe SSDs Gen 4/5 in 2U server.
>>> I'm not a developer, but I can assist you in the testing as much as required.
>>>
>>>> Could you please do a perf-record with '-g' so that we can see
>>>> which call paths hit the lock contention? This will help us
>>>> understand whether Shushu's bitmap optimization can help.
>>>
>>> default raid5 build performance
>>>
>>> [root@memverge2 ~]# cat /proc/mdstat
>>> Personalities : [raid6] [raid5] [raid4]
>>> md0 : active raid5 nvme0n1[4] nvme2n1[2] nvme3n1[1] nvme4n1[0]
>>>        4688044032 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [UUU_]
>>>        [>....................]  recovery =  0.3% (5601408/1562681344)
>>> finish=125.0min speed=207459K/sec
>>>        bitmap: 0/12 pages [0KB], 65536KB chunk
>>>
>>> after set
>>>
>>> [root@memverge2 md]# echo 8 > group_thread_cnt
>>
>> Yes, group_thread_cnt sometimes (usually?) causes more lock
>> contention and lower performance.
>>
>>> [root@memverge2 md]# echo 3600000 > sync_speed_max
>>>
>>> [root@memverge2 ~]# cat /proc/mdstat
>>> Personalities : [raid6] [raid5] [raid4]
>>> md0 : active raid5 nvme0n1[4] nvme2n1[2] nvme3n1[1] nvme4n1[0]
>>>        4688044032 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [UUU_]
>>>        [=>...................]  recovery =  7.9% (124671408/1562681344)
>>> finish=16.6min speed=1435737K/sec
>>>        bitmap: 0/12 pages [0KB], 65536KB chunk
>>>
>>> perf.data.gz attached.
>>
>> Could you please run perf-report on the perf.data? I won't be
>> able to see all the symbols without your kernel.
>>
>> Thanks,
>> Song
> .
> 

