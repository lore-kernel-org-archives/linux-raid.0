Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD8A3EB64DC
	for <linux-raid@archiver.kernel.org>; Sat,  1 Jul 2023 11:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjGALcu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 1 Jul 2023 07:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjGALct (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 1 Jul 2023 07:32:49 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1E9B7
        for <linux-raid@vger.kernel.org>; Sat,  1 Jul 2023 04:32:47 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-98e39784a85so492283566b.1
        for <linux-raid@vger.kernel.org>; Sat, 01 Jul 2023 04:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688211166; x=1690803166;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/fsjmcwfzXR3daLNTzKyk2UAB664FQjJaN7bAnmeRXM=;
        b=rMSMlUDVMy3bCtNI3UpNNrzJSsmc7Xk5d+CTtFDWEf0yEYGxptdfRY0nPjL9GmArMI
         ywrzVTC6ISRjZdguX3F0oCHH9b+OvyaPuDdvblBkUU6DyjQGH3zNCXWAL80T5AK2esxC
         0vyg3qfJ+TeEdosSCfno7BBdwuE+zG0VeY7189SBbmPNaJqgA40ldT9ModCcf6mNEgd6
         l5gbDnSLdDSMGOXM5EA+QI80K5n1VSpnGOGSgrVllHmtJNw/iiqyEGLLSmf3YEduJn3x
         JreYvcD8R89cq9rnkbpDoKYBofwI4nZz9xTZOFoF92WYrZymFjLDOEDx6kE3cokGBfcP
         7MPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688211166; x=1690803166;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/fsjmcwfzXR3daLNTzKyk2UAB664FQjJaN7bAnmeRXM=;
        b=mG4vhxUMZlHdS/WItrdkLl4C3LazhEgtubXrKuSfOFgndTf6szwTYuoxVqWYw0GlCn
         5/8FK94+qO2TI7Vyn4QcQuEp8BNRNDhWeNNWDbJ3FeFxJ7X5AQdRVnap0YLwi7AL3U+X
         r3Qa+AlIp5yRe7I311e1Rl8giAIERmSyTB/JQ3ezPPJ+H9zrvmgUqbeSGwGJgM+w7sRh
         j4YEEev6ahq6KAr/woAHmQekD70VcC8pfAMsKz/yzNTtydq5AG9o7U2x5Y8vHxsU4ao/
         m95IC24eDCybe/vH03To+b24ffnmxy9plHypY36mCXruxL088braGEF1dAYJpzNvDMn1
         zDlQ==
X-Gm-Message-State: AC+VfDzQvdCTOPFDtI1aQ0dUhbkpVkUYPgo2FKUf8/AfUWaIsxUZKOeM
        Hm1TCx1DmidbHVCELZ3nw6E=
X-Google-Smtp-Source: ACHHUZ5A1FYZFteNrAz+iMdaKNGh9Iu52cLu5P1f9V9tN2sZImon2Fk+MsZfeKauuzuDsoz5tKqgKA==
X-Received: by 2002:a17:907:3e07:b0:985:259f:6f50 with SMTP id hp7-20020a1709073e0700b00985259f6f50mr9545771ejc.34.1688211166054;
        Sat, 01 Jul 2023 04:32:46 -0700 (PDT)
Received: from lilem.mirepesht ([178.252.149.143])
        by smtp.gmail.com with ESMTPSA id k24-20020a17090627d800b00992e4d8cc89sm1828454ejc.57.2023.07.01.04.32.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 01 Jul 2023 04:32:45 -0700 (PDT)
Date:   Sat, 01 Jul 2023 14:47:43 +0330
From:   Ali Gholami Rudi <aligrudi@gmail.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
Message-ID: <20230107144743@tare.nit>
In-Reply-To: <2311bff8-232c-916b-98b6-7543bd48ecfa@huaweicloud.com>
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
        <2311bff8-232c-916b-98b6-7543bd48ecfa@huaweicloud.com>
User-Agent: Neatmail/1.1 (https://github.com/aligrudi/neatmail)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi,

I repeated the test on a large array (14TB instead of 40GB):

$ cat /proc/mdstat
Personalities : [raid10] [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] 
md3 : active raid10 nvme1n1p5[1] nvme3n1p5[3] nvme0n1p5[0] nvme2n1p5[2]
      14889424896 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]

md0 : active raid10 nvme2n1p2[2] nvme3n1p2[3] nvme0n1p2[0] nvme1n1p2[1]
      2091008 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]

..

I get these results.

On md0 (40GB):
READ:  IOPS=1563K BW=6109MiB/s
WRITE: IOPS= 670K BW=2745MiB/s

On md3 (14TB):
READ:  IOPS=1177K BW=4599MiB/s
WRITE: IOPS= 505K BW=1972MiB/s

On md3 but disabling mdadm bitmap (mdadm --grow --bitmap=none /dev/md3):
READ:  IOPS=1351K BW=5278MiB/s
WRITE: IOPS= 579K BW=2261MiB/s

The tests are performed on Debian-12 (kernel version 6.1).

Any room for improvement?

Thanks,
Ali

This is perf's output; there are lock contentions.

+   95.25%     0.00%  fio      [unknown]               [k] 0xffffffffffffffff
+   95.00%     0.00%  fio      fio                     [.] 0x000055e073fcd117
+   93.68%     0.13%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
+   93.54%     0.03%  fio      [kernel.kallsyms]       [k] do_syscall_64
+   92.38%     0.03%  fio      libc.so.6               [.] syscall
+   92.18%     0.00%  fio      fio                     [.] 0x000055e073fcaceb
+   92.18%     0.08%  fio      fio                     [.] td_io_queue
+   92.04%     0.02%  fio      fio                     [.] td_io_commit
+   91.76%     0.00%  fio      fio                     [.] 0x000055e073fefe5e
-   91.76%     0.05%  fio      libaio.so.1.0.2         [.] io_submit
   - 91.71% io_submit
      - 91.69% syscall
         - 91.58% entry_SYSCALL_64_after_hwframe
            - 91.55% do_syscall_64
               - 91.06% __x64_sys_io_submit
                  - 90.93% io_submit_one
                     - 48.85% aio_write
                        - 48.77% ext4_file_write_iter
                           - 39.86% iomap_dio_rw
                              - 39.85% __iomap_dio_rw
                                 - 22.55% blk_finish_plug
                                    - 22.55% __blk_flush_plug
                                       - 21.67% raid10_unplug
                                          - 16.54% submit_bio_noacct_nocheck
                                             - 16.44% blk_mq_submit_bio
                                                - 16.17% __rq_qos_throttle
                                                   - 16.01% wbt_wait
                                                      - 15.93% rq_qos_wait
                                                         - 14.52% prepare_to_wait_exclusive
                                                            - 11.50% _raw_spin_lock_irqsave
                                                                 11.49% native_queued_spin_lock_slowpath
                                                            - 3.01% _raw_spin_unlock_irqrestore
                                                               - 2.29% asm_common_interrupt
                                                                  - 2.29% common_interrupt
                                                                     - 2.28% __common_interrupt
                                                                        - 2.28% handle_edge_irq
                                                                           - 2.26% handle_irq_event
                                                                              - 2.26% __handle_irq_event_percpu
                                                                                 - nvme_irq
                                                                                    - 2.23% blk_mq_end_request_batch
                                                                                       - 1.41% __rq_qos_done
                                                                                          - wbt_done
                                                                                             - 1.38% __wake_up_common_lock
                                                                                                - 1.36% _raw_spin_lock_irqsave
                                                                                                     native_queued_spin_lock_slowpath
                                                                                         0.51% raid10_end_read_request
                                                               - 0.61% asm_sysvec_apic_timer_interrupt
                                                                  - sysvec_apic_timer_interrupt
                                                                     - 0.57% __irq_exit_rcu
                                                                        - 0.56% __softirqentry_text_start
                                                                           - 0.55% asm_common_interrupt
                                                                              - common_interrupt
                                                                                 - 0.55% __common_interrupt
                                                                                    - 0.55% handle_edge_irq
                                                                                       - 0.54% handle_irq_event
                                                                                          - 0.54% __handle_irq_event_percpu
                                                                                             - nvme_irq
                                                                                                  0.54% blk_mq_end_request_batch
                                                         - 0.87% io_schedule
                                                            - 0.85% schedule
                                                               - 0.84% __schedule
                                                                  - 0.62% pick_next_task_fair
                                                                     - 0.61% newidle_balance
                                                                        - 0.60% load_balance
                                                                             0.50% find_busiest_group
                                          - 3.98% __wake_up_common_lock
                                             - 3.21% _raw_spin_lock_irqsave
                                                  3.02% native_queued_spin_lock_slowpath
                                             - 0.77% _raw_spin_unlock_irqrestore
                                                - 0.64% asm_common_interrupt
                                                   - common_interrupt
                                                      - 0.63% __common_interrupt
                                                         - 0.63% handle_edge_irq
                                                            - 0.60% handle_irq_event
                                                               - 0.59% __handle_irq_event_percpu
                                                                  - nvme_irq
                                                                       0.58% blk_mq_end_request_batch
                                         0.84% blk_mq_flush_plug_list
                                 - 12.50% iomap_dio_bio_iter
                                    - 10.79% submit_bio_noacct_nocheck
                                       - 10.73% __submit_bio
                                          - 9.77% md_handle_request
                                             - 7.14% raid10_make_request
                                                - 2.98% raid10_write_one_disk
                                                   - 0.52% asm_common_interrupt
                                                      - common_interrupt
                                                         - 0.51% __common_interrupt
                                                              0.51% handle_edge_irq
                                                  1.16% wait_blocked_dev
                                                - 0.83% regular_request_wait
                                                     0.82% wait_barrier
                                            0.95% md_submit_bio
                                 - 3.54% iomap_iter
                                    - 3.52% ext4_iomap_overwrite_begin
                                       - 3.52% ext4_iomap_begin
                                            1.80% ext4_set_iomap
                           - 2.19% file_modified_flags
                                2.16% inode_needs_update_time.part.0
                             1.82% up_read
                             1.61% down_read
                           - 0.88% ext4_generic_write_checks
                                0.57% generic_write_checks
                     - 41.78% aio_read
                        - 41.64% ext4_file_read_iter
                           - 31.62% iomap_dio_rw
                              - 31.61% __iomap_dio_rw
                                 - 19.92% iomap_dio_bio_iter
                                    - 16.26% submit_bio_noacct_nocheck
                                       - 15.60% __submit_bio
                                          - 13.31% md_handle_request
                                             - 7.50% raid10_make_request
                                                - 6.14% raid10_read_request
                                                   - 1.94% regular_request_wait
                                                        1.92% wait_barrier
                                                     1.12% read_balance
                                                   - 0.53% asm_common_interrupt
                                                      - 0.53% common_interrupt
                                                         - 0.53% __common_interrupt
                                                            - 0.53% handle_edge_irq
                                                                 0.50% handle_irq_event
                                             - 1.14% asm_common_interrupt
                                                - 1.14% common_interrupt
                                                   - 1.13% __common_interrupt
                                                      - 1.13% handle_edge_irq
                                                         - 1.08% handle_irq_event
                                                            - 1.07% __handle_irq_event_percpu
                                                               - nvme_irq
                                                                    1.05% blk_mq_end_request_batch
                                            2.22% md_submit_bio
                                         0.52% blk_mq_submit_bio
                                    - 0.67% asm_common_interrupt
                                       - common_interrupt
                                          - 0.66% __common_interrupt
                                             - 0.66% handle_edge_irq
                                                - 0.62% handle_irq_event
                                                   - 0.62% __handle_irq_event_percpu
                                                      - nvme_irq
                                                           0.61% blk_mq_end_request_batch
                                 - 8.90% iomap_iter
                                    - 8.86% ext4_iomap_begin
                                       - 4.24% ext4_set_iomap
                                          - 0.86% asm_common_interrupt
                                             - 0.86% common_interrupt
                                                - 0.85% __common_interrupt
                                                   - 0.85% handle_edge_irq
                                                      - 0.81% handle_irq_event
                                                         - 0.80% __handle_irq_event_percpu
                                                            - nvme_irq
                                                                 0.79% blk_mq_end_request_batch
                                       - 0.88% ext4_map_blocks
                                            0.68% ext4_es_lookup_extent
                                       - 0.81% asm_common_interrupt
                                          - 0.81% common_interrupt
                                             - 0.81% __common_interrupt
                                                - 0.81% handle_edge_irq
                                                   - 0.77% handle_irq_event
                                                      - 0.76% __handle_irq_event_percpu
                                                         - nvme_irq
                                                              0.75% blk_mq_end_request_batch
                           - 4.53% down_read
                              - 0.87% asm_common_interrupt
                                 - 0.86% common_interrupt
                                    - 0.86% __common_interrupt
                                       - 0.86% handle_edge_irq
                                          - 0.81% handle_irq_event
                                             - 0.81% __handle_irq_event_percpu
                                                - nvme_irq
                                                     0.79% blk_mq_end_request_batch
                           - 4.42% up_read
                              - 0.82% asm_common_interrupt
                                 - 0.82% common_interrupt
                                    - 0.81% __common_interrupt
                                       - 0.81% handle_edge_irq
                                          - 0.77% handle_irq_event
                                             - 0.77% __handle_irq_event_percpu
                                                - nvme_irq
                                                     0.75% blk_mq_end_request_batch
                           - 0.86% ext4_dio_alignment
                                0.83% ext4_inode_journal_mode

