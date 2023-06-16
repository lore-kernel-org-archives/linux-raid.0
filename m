Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E650EB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 07:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245079AbjFPHfO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 03:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245181AbjFPHe6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 03:34:58 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E1410F7
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 00:34:56 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-51a324beca6so499766a12.1
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 00:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686900895; x=1689492895;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=40ACPS9P/Z4KxhRLP08lip5qlbEBAXHx7PbJvVy/RFs=;
        b=NlMPT5vOSoP+1mn1aRyeXMOOHTlfZbeIf6QJF9m1Dr3SHMLG1eihHwdVNAP1En2taC
         4nAxDzrl4PqkG/v9HZ0GeFxTqyg8ZTkNffRg83JHEFer5xSKVaMPDPA+78QZAzeLHTCp
         B4psHe6RrL6taBIN4cpevcWC8V2zVxcnOtbnheuy91ouiD1vJ903GxTel2tUP4uOOsYO
         eedgoRPHctezqHivT3GhftMF3mP1SNRei4QQXhTUJ+/hrHkWvDxXycWrJIJe49HX4tHY
         3HFYlDLOHu0BFJGcDQkCRsPSZ3h/QVcA1FQ5vFFaNZjOBOet+dXt74WOCMe4iRAB/wMI
         xFdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686900895; x=1689492895;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=40ACPS9P/Z4KxhRLP08lip5qlbEBAXHx7PbJvVy/RFs=;
        b=HYir7Oig+0fOOPY3ckhB28V76qlqoNDDw0scNd6Ez4Y/f+mMD2E2S2eWJqoRrthLnj
         UZ9vxo5CGXrLjch6sk5pcCNJ4m+s4mHEaoLNIwEuIkRpqU9IrwwLu/oxafvdwoJcN0m6
         4rB7aln4E8/BebBKaj5SaFE4igqO69g6BO86XHF4x2H0uTZjmZzjtOx0DJv81BzBXRdl
         UpkQ1p2BqLOm5ZmPlJOhg0ibWALt6kCLUsMnUJp57ZSJzY9Lh5D48ET9LvdzoEQAf6HQ
         qGAmDAxhBPIuu2CJqGKopdpJHzM6QFOsV2qnO7opvybfLNOhTnTmdkvW/wnkMihCpRPV
         6BZA==
X-Gm-Message-State: AC+VfDxwilJKFZ7ntcILnKw1SOeih9vNfFbp3wT7Xvsc39UX8oIcg5rp
        Ayt6Iq6cnbdDCkmE6nxA8mKEHYHlclsTHA==
X-Google-Smtp-Source: ACHHUZ6hpkuP75LaWPvYxgMWR0PNnrgLxIrwlAe9K5Ntq0OWYJsolF84P9ME265MT4FcS4RMzC4J5g==
X-Received: by 2002:aa7:c0c7:0:b0:51a:1e3d:80ac with SMTP id j7-20020aa7c0c7000000b0051a1e3d80acmr609270edp.41.1686900895186;
        Fri, 16 Jun 2023 00:34:55 -0700 (PDT)
Received: from lilem.mirepesht ([5.236.100.66])
        by smtp.gmail.com with ESMTPSA id c8-20020aa7c988000000b005167bb5fc3csm9697347edt.38.2023.06.16.00.34.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Jun 2023 00:34:54 -0700 (PDT)
Date:   Fri, 16 Jun 2023 11:01:34 +0330
From:   Ali Gholami Rudi <aligrudi@gmail.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
Message-ID: <20231606110134@laper.mirepesht>
In-Reply-To: <20231606091224@laper.mirepesht>
References: <20231506112411@laper.mirepesht> <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
        <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
        <20231606091224@laper.mirepesht>
User-Agent: Neatmail/1.1 (https://github.com/aligrudi/neatmail)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Ali Gholami Rudi <aligrudi@gmail.com> wrote:
> Xiao Ni <xni@redhat.com> wrote:
> > On Thu, Jun 15, 2023 at 10:06 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
> > > This looks familiar... Perhaps can you try to test with raid10 with
> > > latest mainline kernel? I used to optimize spin_lock for raid10, and I
> > > don't do this for raid1 yet... I can try to do the same thing for raid1
> > > if it's valuable.
> 
> I do get improvements with raid10:
> 
> Without RAID (writing to /dev/ram0)
> READ:  IOPS=15.8M BW=60.3GiB/s
> WRITE: IOPS= 6.8M BW=27.7GiB/s
> 
> RAID1 (writing to /dev/md/test)
> READ:  IOPS=518K BW=2028MiB/s
> WRITE: IOPS=222K BW= 912MiB/s
> 
> RAID10 (writing to /dev/md/test)
> READ:  IOPS=2033k BW=8329MB/s
> WRITE: IOPS= 871k BW=3569MB/s
> 
> raid10 is about four times faster than raid1.

And this is perf's output for raid10:

+   97.33%     0.04%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
+   96.96%     0.02%  fio      [kernel.kallsyms]       [k] do_syscall_64
+   94.43%     0.03%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
-   93.71%     0.04%  fio      [kernel.kallsyms]       [k] io_submit_one
   - 93.67% io_submit_one
      - 76.03% aio_write
         - 75.53% blkdev_write_iter
            - 68.95% blk_finish_plug
               - flush_plug_callbacks
                  - 68.93% raid10_unplug
                     - 64.31% __wake_up_common_lock
                        - 64.17% _raw_spin_lock_irqsave
                             native_queued_spin_lock_slowpath
                     - 4.43% submit_bio_noacct_nocheck
                        - 4.42% __submit_bio
                           - 2.28% raid10_end_write_request
                              - 0.82% raid_end_bio_io
                                   0.82% allow_barrier
                             2.09% brd_submit_bio
            - 6.41% __generic_file_write_iter
               - 6.08% generic_file_direct_write
                  - 5.64% __blkdev_direct_IO_async
                     - 4.72% submit_bio_noacct_nocheck
                        - 4.69% __submit_bio
                           - 4.67% md_handle_request
                              - 4.66% raid10_make_request
                                   2.59% raid10_write_one_disk
      - 16.14% aio_read
         - 15.07% blkdev_read_iter
            - 14.16% __blkdev_direct_IO_async
               - 11.36% submit_bio_noacct_nocheck
                  - 11.17% __submit_bio
                     - 5.89% md_handle_request
                        - 5.84% raid10_make_request
                           + 4.18% raid10_read_request
                     - 3.74% raid10_end_read_request
                        - 2.04% raid_end_bio_io
                             1.46% allow_barrier
                          0.55% mempool_free
                       1.39% brd_submit_bio
               - 1.33% bio_iov_iter_get_pages
                  - 1.00% iov_iter_get_pages
                     - __iov_iter_get_pages_alloc
                        - 0.85% get_user_pages_fast
                             0.75% internal_get_user_pages_fast
                 0.93% bio_alloc_bioset
              0.65% filemap_write_and_wait_range
+   88.31%     0.86%  fio      fio                     [.] thread_main
+   87.69%     0.00%  fio      [unknown]               [k] 0xffffffffffffffff
+   87.60%     0.00%  fio      fio                     [.] run_threads
+   87.31%     0.00%  fio      fio                     [.] do_io (inlined)
+   86.60%     0.32%  fio      libc-2.31.so            [.] syscall
+   85.87%     0.52%  fio      fio                     [.] td_io_queue
+   85.49%     0.18%  fio      fio                     [.] fio_libaio_commit
+   85.45%     0.14%  fio      fio                     [.] td_io_commit
+   85.37%     0.11%  fio      libaio.so.1.0.1         [.] io_submit
+   85.35%     0.00%  fio      fio                     [.] io_u_submit (inlined)
+   76.04%     0.01%  fio      [kernel.kallsyms]       [k] aio_write
+   75.54%     0.01%  fio      [kernel.kallsyms]       [k] blkdev_write_iter
+   68.96%     0.00%  fio      [kernel.kallsyms]       [k] blk_finish_plug
+   68.95%     0.00%  fio      [kernel.kallsyms]       [k] flush_plug_callbacks
+   68.94%     0.13%  fio      [kernel.kallsyms]       [k] raid10_unplug
+   64.41%     0.03%  fio      [kernel.kallsyms]       [k] _raw_spin_lock_irqsave
+   64.32%     0.01%  fio      [kernel.kallsyms]       [k] __wake_up_common_lock
+   64.05%    63.85%  fio      [kernel.kallsyms]       [k] native_queued_spin_lock_slowpath
+   21.05%     1.51%  fio      [kernel.kallsyms]       [k] submit_bio_noacct_nocheck
+   20.97%     1.18%  fio      [kernel.kallsyms]       [k] __blkdev_direct_IO_async
+   20.29%     0.03%  fio      [kernel.kallsyms]       [k] __submit_bio
+   16.15%     0.02%  fio      [kernel.kallsyms]       [k] aio_read
..

Thanks,
Ali

