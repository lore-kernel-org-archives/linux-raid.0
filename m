Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C379EB64D9
	for <linux-raid@archiver.kernel.org>; Mon, 19 Jun 2023 05:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjFSFgK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Jun 2023 01:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjFSFgI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Jun 2023 01:36:08 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA620E50
        for <linux-raid@vger.kernel.org>; Sun, 18 Jun 2023 22:36:03 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-3421fb63796so14309685ab.2
        for <linux-raid@vger.kernel.org>; Sun, 18 Jun 2023 22:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687152963; x=1689744963;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WqD2pTr+ecyPtjdh3PFHjYbH4szDwPYW8DQUrucLUa4=;
        b=rCu0f/r4+ZMc02uBSlyAr8e1yrqMt7xruYQzlk4q6lP6yodX3GPIsd/M5OjkYkSE7y
         esD/fKiWlwEO4YafmlOukG+yvA6owoDvWXWUZIlWqqvdNk27WM2gS+aSVEk155dcl+vP
         RUUB8M9fUw0GuxEl9akvapBY8xLSYQEU09GMV6qqD10zN+JJM8OMfWDmYlxDLdJ3pFkX
         ZS3TD0UGDGMtjLNbdx7A/STokphtwpKBTpdW3yTY09dpbFZ277v5H+1nttnGZ3fbn8nh
         sHqU7UtJHRgUHrrQo0cY+jMFbbJBljnyGKtKCwFXKuCBcUpH7CVr0cc+Qv+8H7dDd9YO
         egmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687152963; x=1689744963;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WqD2pTr+ecyPtjdh3PFHjYbH4szDwPYW8DQUrucLUa4=;
        b=ePlwj0c+aCtkLIqPaqH+QMehrEkp9Bq4HuHNJSrMvawJwVfFUQ6+CMLSXYqg52kg7t
         HAXivbyawwf6QeuNBbOAszRKF9xbxwgOB1/zkrBJElpbejt6qPlWv1OLq8OP9EQ7lyP6
         t5TXVXGbcRuXwi94cTwjZIT5HXT4MpHoLhxNmo6HUKHQTGzHlC0ZbibTZUQTyBgp9v1M
         IhCDGhx+uYe8OW7Ewr+b319LBioughpUiG6ezSvDYbiI2Hq8KgG2AKrEoqR7buYATdY5
         zU0IRTEGzUnTg+vjVlvI8HXiO7qbMQLP9WUbxMcYaryn8MbTqwkhS8z0lplJqJjsbDja
         FX9w==
X-Gm-Message-State: AC+VfDwLfwNypJGc9fNl9zDTiLKE+8cC/inR5KbfkFa/fxiNL6J2LeK3
        Axd/NhAVjJYAljW0wLNpQOQ=
X-Google-Smtp-Source: ACHHUZ7609991W2W6LLneL+SZ8K6ajqFEDsLKhLfrE8TJ4Q9kN/jVixHtq6bceJ4mNcny1D/FMHQgQ==
X-Received: by 2002:a92:c647:0:b0:342:89b4:b8c1 with SMTP id 7-20020a92c647000000b0034289b4b8c1mr934206ill.21.1687152962970;
        Sun, 18 Jun 2023 22:36:02 -0700 (PDT)
Received: from lilem.mirepesht ([178.252.149.143])
        by smtp.gmail.com with ESMTPSA id l13-20020a02a88d000000b00418af04e405sm1317685jam.116.2023.06.18.22.35.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 18 Jun 2023 22:36:02 -0700 (PDT)
Date:   Mon, 19 Jun 2023 08:49:45 +0330
From:   Ali Gholami Rudi <aligrudi@gmail.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
Message-ID: <20231906084945@tare.nit>
In-Reply-To: <20231906000051@laper.mirepesht>
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
User-Agent: Neatmail/1.1 (https://github.com/aligrudi/neatmail)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Yu Kuai <yukuai1@huaweicloud.com> wrote:
> Can you try to test with --bitmap=none, and --assume-clean(or echo
> frozen to sync_action), let's see if spin_lock from wait_barrier() and
> from md_bitmap_startwrite is bypassed, how performance will be.

I did not notice that it was syncing disks in the background.
It is much better now:

READ:  IOPS=1748K BW=6830MiB/s
WRITE: IOPS= 749K BW=2928MiB/s

Perf's output:

+   98.04%     0.00%  fio      [unknown]               [k] 0xffffffffffffffff
+   97.86%     0.00%  fio      fio                     [.] 0x000055ed33e52117
+   94.64%     0.03%  fio      libc.so.6               [.] syscall
+   94.54%     0.09%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
+   94.44%     0.03%  fio      [kernel.kallsyms]       [k] do_syscall_64
+   94.31%     0.00%  fio      fio                     [.] 0x000055ed33e4fceb
+   94.31%     0.07%  fio      fio                     [.] td_io_queue
+   94.15%     0.03%  fio      fio                     [.] td_io_commit
+   93.77%     0.05%  fio      libaio.so.1.0.2         [.] io_submit
+   93.77%     0.00%  fio      fio                     [.] 0x000055ed33e74e5e
+   92.03%     0.04%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
-   91.86%     0.05%  fio      [kernel.kallsyms]       [k] io_submit_one
   - 91.81% io_submit_one
      - 52.43% aio_read
         - 51.94% ext4_file_read_iter
            - 36.03% iomap_dio_rw
               - 36.02% __iomap_dio_rw
                  - 21.56% iomap_dio_bio_iter
                     - 17.72% submit_bio_noacct_nocheck
                        - 17.09% __submit_bio
                           - 14.81% md_handle_request
                              - 8.34% raid10_make_request
                                 - 6.96% raid10_read_request
                                    - 2.76% regular_request_wait
                                         2.58% wait_barrier
                                      0.76% read_balance
                              - 1.07% asm_common_interrupt
                                 - 1.07% common_interrupt
                                    - 1.06% __common_interrupt
                                       + 1.06% handle_edge_irq
                             2.22% md_submit_bio
                          0.51% blk_mq_submit_bio
                  - 10.68% iomap_iter
                     - 10.64% ext4_iomap_begin
                        - 4.07% ext4_map_blocks
                           - 3.80% ext4_es_lookup_extent
                                1.77% _raw_read_lock
                                1.68% _raw_read_unlock
                          3.51% ext4_set_iomap
                        + 0.54% asm_common_interrupt
                  - 1.21% blk_finish_plug
                     - 1.20% __blk_flush_plug
                        - 1.19% blk_mq_flush_plug_list
                           - 1.15% nvme_queue_rqs
                              + 1.01% nvme_prep_rq.part.0
            - 6.04% down_read
               - 1.73% asm_common_interrupt
                  - 1.73% common_interrupt
                     - 1.72% __common_interrupt
                        - 1.71% handle_edge_irq
                           - 1.58% handle_irq_event
                              - 1.57% __handle_irq_event_percpu
                                 - nvme_irq
                                    - 1.46% blk_mq_end_request_batch
                                         0.80% raid10_end_write_request
                                         0.55% raid10_end_read_request
            - 5.43% up_read
               + 0.99% asm_common_interrupt
            - 3.99% touch_atime
               - 3.87% atime_needs_update
                  + 0.68% asm_common_interrupt
      - 39.00% aio_write
         - 38.78% ext4_file_write_iter
            - 28.16% iomap_dio_rw
               - 28.15% __iomap_dio_rw
                  - 14.49% iomap_dio_bio_iter
                     - 12.65% submit_bio_noacct_nocheck
                        - 12.61% __submit_bio
                           - 11.54% md_handle_request
                              - 7.91% raid10_make_request
                                   3.24% raid10_write_one_disk
                                 - 1.21% regular_request_wait
                                      1.13% wait_barrier
                                   1.14% wait_blocked_dev
                              + 0.57% asm_common_interrupt
                             1.04% md_submit_bio
                  - 8.05% blk_finish_plug
                     - 8.04% __blk_flush_plug
                        - 6.42% raid10_unplug
                           - 4.19% __wake_up_common_lock
                              - 3.60% _raw_spin_lock_irqsave
                                   3.40% native_queued_spin_lock_slowpath
                                0.59% _raw_spin_unlock_irqrestore
                           - 1.00% submit_bio_noacct_nocheck
                              + 0.93% blk_mq_submit_bio
                        - 1.59% blk_mq_flush_plug_list
                           - 1.02% blk_mq_sched_insert_requests
                              + 0.98% blk_mq_try_issue_list_directly
                  - 4.53% iomap_iter
                     - 4.51% ext4_iomap_overwrite_begin
                        - 4.51% ext4_iomap_begin
                           - 1.69% ext4_map_blocks
                              - 1.58% ext4_es_lookup_extent
                                   0.72% _raw_read_lock
                                   0.71% _raw_read_unlock
                             1.54% ext4_set_iomap
            - 2.83% up_read
               + 0.92% asm_common_interrupt
            - 2.26% down_read
               + 0.57% asm_common_interrupt
            - 1.81% ext4_map_blocks
               - 1.66% ext4_es_lookup_extent
                    0.81% _raw_read_lock
                    0.70% _raw_read_unlock
            - 1.67% file_modified_flags
                 1.43% inode_needs_update_time.part.0
+   64.19%     0.02%  fio      [kernel.kallsyms]       [k] iomap_dio_rw
+   64.17%     2.41%  fio      [kernel.kallsyms]       [k] __iomap_dio_rw
+   52.43%     0.03%  fio      [kernel.kallsyms]       [k] aio_read
+   51.94%     0.04%  fio      [kernel.kallsyms]       [k] ext4_file_read_iter

Thanks,
Ali

