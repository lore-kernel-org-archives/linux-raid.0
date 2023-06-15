Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22CB3EB64D9
	for <linux-raid@archiver.kernel.org>; Thu, 15 Jun 2023 17:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjFORiT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Jun 2023 13:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjFORiS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Jun 2023 13:38:18 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963671BDB
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 10:38:16 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4f849605df4so534597e87.3
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 10:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686850695; x=1689442695;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=db80+Kv10i3SI0CA+YlTJ/kwZZbwYu0kCNUBmHdBL9k=;
        b=UI/wUW+wea1mZ6rW9QYT91SLUka+RsDr52+y1OBOmhfvkcvcY0WkHN3SaTDB7iWo34
         z5cWawwCPMCldbDURdKADXbS+2Ug4G6l0YazfAYVmXf/puiV92TsN/mY0hoP76o4oma6
         nH+h2UxlH41LBReabBTvoVlXeoTZqoLtPeM5jfra60OMF9U/iYUXlK9XWcslgCL9Gjih
         dDf49xR5nLJ3ivOUOYyr0OkXlzQTKZzBQIrpSWa/UGEtEjlb6343eEqL94bT3Y3l+we/
         8uyp2gTLcjAbdd+5bUrJsQnkJJMDbppguAyY7RHtLSoe63MJR0SnHBjkHnLzpZyIgwlF
         +xuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686850695; x=1689442695;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=db80+Kv10i3SI0CA+YlTJ/kwZZbwYu0kCNUBmHdBL9k=;
        b=L0codzzuVfdHwk9/nS9quQIjAf8cQ4WoPQoAPuSzHKGjdzffh9u8RImkGYp/rUR6dp
         N+6psgoSV5u09FvY56atuj58o5s9r6paza15eoiKxF4j2Q0kUt+mAHHGX9KCXQCyqks0
         F0YVunhUMKStRykUYfjWux+6WVLhtxZZKBfHinmAceF5aIvOHu74k3AUlj5tDL9RTJ2V
         ibGyRtlBIY2LnOMV/3o7l2w+iIVOekFSF6DnVU2d7Dq0rokJadI54zS+UQF36nqRYHwO
         JHEIsbFqL9cHDL1enkSz1seURNlZ/R0jg+X8BpeOqK5vwEtB6r8Z+29RF2Ur466uXnv3
         QW9Q==
X-Gm-Message-State: AC+VfDyPhjHbrx+5zrag/3K6dH9y3MZWMaMXOLz0fdsElFAruuqaSzaW
        S/Dp5+FgQJnCZgySr1HYvfY=
X-Google-Smtp-Source: ACHHUZ5JbJ6O+CJPepqsKDWromo+b/O8cdVuuE3ctNCmMsHauyq2/zTgjT71hWKzaYWyM3afJKemuA==
X-Received: by 2002:a19:8c52:0:b0:4f3:baf9:8f8e with SMTP id i18-20020a198c52000000b004f3baf98f8emr9109988lfj.4.1686850694367;
        Thu, 15 Jun 2023 10:38:14 -0700 (PDT)
Received: from lilem.mirepesht ([5.236.100.66])
        by smtp.gmail.com with ESMTPSA id qn27-20020a170907211b00b0096b15e4ffcesm9754928ejb.85.2023.06.15.10.38.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Jun 2023 10:38:12 -0700 (PDT)
Date:   Thu, 15 Jun 2023 21:06:00 +0330
From:   Ali Gholami Rudi <aligrudi@gmail.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, song@kernel.org
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
Message-ID: <20231506210600@laper.mirepesht>
In-Reply-To: <20231506203832@laper.mirepesht>
References: <20231506112411@laper.mirepesht>
        <CALTww29UZ+WewVrvFDSpONqTHY=TR-Q7tobdRrhsTtXKtXvOBg@mail.gmail.com>
        <20231506203832@laper.mirepesht>
User-Agent: Neatmail/1.1 (https://github.com/aligrudi/neatmail)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Ali Gholami Rudi <aligrudi@gmail.com> wrote:
> Xiao Ni <xni@redhat.com> wrote:
> > Because it can be reproduced easily in your environment. Can you try
> > with the latest upstream kernel? If the problem doesn't exist with
> > latest upstream kernel. You can use git bisect to find which patch can
> > fix this problem.
> 
> I just tried the upstream.  I get almost the same result with 1G ramdisks.
> 
> Without RAID (writing to /dev/ram0)
> READ:  IOPS=15.8M BW=60.3GiB/s
> WRITE: IOPS= 6.8M BW=27.7GiB/s
> 
> RAID1 (writing to /dev/md/test)
> READ:  IOPS=518K BW=2028MiB/s
> WRITE: IOPS=222K BW= 912MiB/s

And this is perf's output:

+   98.73%     0.01%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
+   98.63%     0.01%  fio      [kernel.kallsyms]       [k] do_syscall_64
+   97.28%     0.01%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
-   97.09%     0.01%  fio      [kernel.kallsyms]       [k] io_submit_one
   - 97.08% io_submit_one
      - 53.58% aio_write
         - 53.42% blkdev_write_iter
            - 35.28% blk_finish_plug
               - flush_plug_callbacks
                  - 35.27% raid1_unplug
                     - flush_bio_list
                        - 17.88% submit_bio_noacct_nocheck
                           - 17.88% __submit_bio
                              - 17.61% raid1_end_write_request
                                 - 17.47% raid_end_bio_io
                                    - 17.41% __wake_up_common_lock
                                       - 17.38% _raw_spin_lock_irqsave
                                            native_queued_spin_lock_slowpath
                        - 17.35% __wake_up_common_lock
                           - 17.31% _raw_spin_lock_irqsave
                                native_queued_spin_lock_slowpath
            + 18.07% __generic_file_write_iter
      - 43.00% aio_read
         - 42.64% blkdev_read_iter
            - 42.37% __blkdev_direct_IO_async
               - 41.40% submit_bio_noacct_nocheck
                  - 41.34% __submit_bio
                     - 40.68% raid1_end_read_request
                        - 40.55% raid_end_bio_io
                           - 40.35% __wake_up_common_lock
                              - 40.28% _raw_spin_lock_irqsave
                                   native_queued_spin_lock_slowpath
+   95.19%     0.32%  fio      fio                     [.] thread_main
+   95.08%     0.00%  fio      [unknown]               [.] 0xffffffffffffffff
+   95.03%     0.00%  fio      fio                     [.] run_threads
+   94.77%     0.00%  fio      fio                     [.] do_io (inlined)
+   94.65%     0.16%  fio      fio                     [.] td_io_queue
+   94.65%     0.11%  fio      libc-2.31.so            [.] syscall
+   94.54%     0.07%  fio      fio                     [.] fio_libaio_commit
+   94.53%     0.05%  fio      fio                     [.] td_io_commit
+   94.50%     0.00%  fio      fio                     [.] io_u_submit (inlined)
+   94.47%     0.04%  fio      libaio.so.1.0.1         [.] io_submit
+   92.48%     0.02%  fio      [kernel.kallsyms]       [k] _raw_spin_lock_irqsave
+   92.48%     0.00%  fio      [kernel.kallsyms]       [k] __wake_up_common_lock
+   92.46%    92.32%  fio      [kernel.kallsyms]       [k] native_queued_spin_lock_slowpath
+   76.85%     0.03%  fio      [kernel.kallsyms]       [k] submit_bio_noacct_nocheck
+   76.76%     0.00%  fio      [kernel.kallsyms]       [k] __submit_bio
+   60.25%     0.06%  fio      [kernel.kallsyms]       [k] __blkdev_direct_IO_async
+   58.12%     0.11%  fio      [kernel.kallsyms]       [k] raid_end_bio_io
..

Thanks,
Ali

