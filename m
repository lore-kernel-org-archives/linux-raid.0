Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7C5EB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 08:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245440AbjFPI2w (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 04:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242529AbjFPI2v (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 04:28:51 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E89013E
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 01:28:45 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-5183101690cso3323882a12.0
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 01:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686904124; x=1689496124;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OlcJXkU/tPZ+2FzLpsFTFFBgb7QY/zBseZPWEMd0pFQ=;
        b=AqK38yMSDbY/dyhX8tNFHU498DWFsjObKvXTrvG+AaXaC8F94iYbzi9fkDuLvkg7XQ
         8NzL0FpYpXKFW6iS6T684d8T56AXOe2Z5nai3uYRsQk2Ud7ANohoba3i4sM41ZpmkW3S
         iOSBQa8TR9M2MkxF8GVS71mrx4vsRO0Af+2dUNKsWqpKqlgBe0V6uaXLy7CDyLEDMRtE
         ti8kw2R7/99g8sUuf761VN8mHZdJdt6D9axY+9aY10+hsDLegycE982uWlKUxVLkZfbu
         TzndC1mVe/5xWrmcAurpzjd1w9oz+8p18+Iir0NVcvOzROSV7nN5/PgMU2Gp0XT41wzU
         F20A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686904124; x=1689496124;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OlcJXkU/tPZ+2FzLpsFTFFBgb7QY/zBseZPWEMd0pFQ=;
        b=UejKqRPMeBdwYzRBMMfTKDwd8DOkEkKBBMLLLN/CcZ7YhstUWPSsaso8xH8HTqzdlH
         u1Dcae3Hp+sdEvlwNbYR4mUyjYRjL6RDlaeqtw7WD0bvJSbC0Ps3KVDcRKplRC/OWDwB
         KvVsEjPhE72rHRQB9BkmxEDEsVg0AP5EVEXLhPGbUsxVglzppJs122PL0nlJS9pZZgXC
         QaZ0O1cacadegSBcCP3E1UuKOFEXf8seVgE02kgA0stXmUW6heYZl2qLaVND31t/5B6N
         enJH3KXe31mj3AeKc+GDDqVuSE3/pFi1UAZf3c/ghY1TH6JuTU3kUMdKY60mAUtNnTzd
         /S9w==
X-Gm-Message-State: AC+VfDwwkFgb+MS3NPk+ze4epCqq+TjdUNgDC0souenWDG1TL5DROoQw
        WfuREUQ3y74wc4dSzqA6oHE=
X-Google-Smtp-Source: ACHHUZ4YiCnCLmNxqM1dgqjrOBuKw1RDBEDDhtkEzClbxYUQd3M/HeM3H8YGQv0exkmmH5A86NvP+A==
X-Received: by 2002:a05:6402:b27:b0:514:9e47:4319 with SMTP id bo7-20020a0564020b2700b005149e474319mr1044615edb.5.1686904123728;
        Fri, 16 Jun 2023 01:28:43 -0700 (PDT)
Received: from lilem.mirepesht ([5.236.100.66])
        by smtp.gmail.com with ESMTPSA id m7-20020a50ef07000000b0051a2edb49b0sm257306eds.63.2023.06.16.01.28.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Jun 2023 01:28:42 -0700 (PDT)
Date:   Fri, 16 Jun 2023 11:51:13 +0330
From:   Ali Gholami Rudi <aligrudi@gmail.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
Message-ID: <20231606115113@laper.mirepesht>
In-Reply-To: <8b288984-396a-6093-bd1f-266303a8d2b6@huaweicloud.com>
References: <20231506112411@laper.mirepesht>
 <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
 <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
 <20231606091224@laper.mirepesht> <20231606110134@laper.mirepesht>
        <8b288984-396a-6093-bd1f-266303a8d2b6@huaweicloud.com>
User-Agent: Neatmail/1.1 (https://github.com/aligrudi/neatmail)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Yu Kuai <yukuai1@huaweicloud.com> wrote:
> > And this is perf's output for raid10:
> > 
> > +   97.33%     0.04%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
> > +   96.96%     0.02%  fio      [kernel.kallsyms]       [k] do_syscall_64
> > +   94.43%     0.03%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
> > -   93.71%     0.04%  fio      [kernel.kallsyms]       [k] io_submit_one
> >     - 93.67% io_submit_one
> >        - 76.03% aio_write
> >           - 75.53% blkdev_write_iter
> >              - 68.95% blk_finish_plug
> >                 - flush_plug_callbacks
> >                    - 68.93% raid10_unplug
> >                       - 64.31% __wake_up_common_lock
> >                          - 64.17% _raw_spin_lock_irqsave
> >                               native_queued_spin_lock_slowpath
> 
> This is unexpected, can you check if your kernel contain following
> patch?
> 
> commit 460af1f9d9e62acce4a21f9bd00b5bcd5963bcd4
> Author: Yu Kuai <yukuai3@huawei.com>
> Date:   Mon May 29 21:11:06 2023 +0800
> 
>      md/raid1-10: limit the number of plugged bio
> 
> If so, can you retest with following patch?
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index d0de8c9fb3cf..6fdd99c3e59a 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -911,7 +911,7 @@ static void flush_pending_writes(struct r10conf *conf)
> 
>                  blk_start_plug(&plug);
>                  raid1_prepare_flush_writes(conf->mddev->bitmap);
> -               wake_up(&conf->wait_barrier);
> +               wake_up_barrier(&conf->wait_barrier);
> 
>                  while (bio) { /* submit pending writes */
>                          struct bio *next = bio->bi_next;

No, this patch was not present.  I applied this one:

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4fcfcb350d2b..52f0c24128ff 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -905,7 +905,7 @@ static void flush_pending_writes(struct r10conf *conf)
 		/* flush any pending bitmap writes to disk
 		 * before proceeding w/ I/O */
 		md_bitmap_unplug(conf->mddev->bitmap);
-		wake_up(&conf->wait_barrier);
+		wake_up_barrier(conf);
 
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;

I get almost the same result as before nevertheless:

Without the patch:
READ:  IOPS=2033k BW=8329MB/s
WRITE: IOPS= 871k BW=3569MB/s

With the patch:
READ:  IOPS=2027K BW=7920MiB/s
WRITE: IOPS= 869K BW=3394MiB/s

Perf:

+   96.23%     0.04%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
+   95.86%     0.02%  fio      [kernel.kallsyms]       [k] do_syscall_64
+   94.30%     0.03%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
-   93.63%     0.04%  fio      [kernel.kallsyms]       [k] io_submit_one
   - 93.58% io_submit_one
      - 76.44% aio_write
         - 75.97% blkdev_write_iter
            - 70.17% blk_finish_plug
               - flush_plug_callbacks
                  - 70.15% raid10_unplug
                     - 66.12% __wake_up_common_lock
                        - 65.97% _raw_spin_lock_irqsave
                             65.57% native_queued_spin_lock_slowpath
                     - 3.85% submit_bio_noacct_nocheck
                        - 3.84% __submit_bio
                           - 2.09% raid10_end_write_request
                              - 0.83% raid_end_bio_io
                                   0.82% allow_barrier
                             1.70% brd_submit_bio
            + 5.59% __generic_file_write_iter
      + 15.71% aio_read
+   88.38%     0.71%  fio      fio                     [.] thread_main
+   87.89%     0.00%  fio      [unknown]               [k] 0xffffffffffffffff
+   87.81%     0.00%  fio      fio                     [.] run_threads
+   87.54%     0.00%  fio      fio                     [.] do_io (inlined)
+   86.79%     0.31%  fio      libc-2.31.so            [.] syscall
+   86.19%     0.54%  fio      fio                     [.] td_io_queue
+   85.79%     0.18%  fio      fio                     [.] fio_libaio_commit
+   85.76%     0.14%  fio      fio                     [.] td_io_commit
+   85.69%     0.14%  fio      libaio.so.1.0.1         [.] io_submit
+   85.66%     0.00%  fio      fio                     [.] io_u_submit (inlined)
+   76.45%     0.01%  fio      [kernel.kallsyms]       [k] aio_write
..

