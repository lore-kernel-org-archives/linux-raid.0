Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A50EB64D8
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 11:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344680AbjFPLws (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 07:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344397AbjFPLwr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 07:52:47 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0279F2944
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 04:52:44 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-982acf0a4d2so79351766b.3
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 04:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686916362; x=1689508362;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XBW502AlekhQGQBC6OiMGy387L95HwtD0/l6Qtep8yQ=;
        b=HeaVGsuuc0SiOPJVKxmbIXl8J0XEik6TgYxz3eIdN7VC6n22Mfstj7Pw1bg4SiR2JH
         motDb8zf9PSkyPAhg3ieWLk3l/dj34H3wwrkU68E3V4XDSX7Ufi4rcosVr7UEln/9LEy
         MRZhn2/5gJ2COkPylnOB/+d8lazs0+KDjG/8pH7Vw/8gtSNUK0DIYVBej5A1x1ceAWyu
         z9VpbsmHhSyJO/lal/Sx4qzjJuMRqYBQxLoy3WOHM0Q35nNZSEkt6REdq6Ejd3Kvt58H
         i8pyxKyWSzgtdP6PfkCfG+1se7CfDQLS6mchJTdcC0z1/CSRexHUcouTJaW9LmMUK0o6
         c4rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686916362; x=1689508362;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XBW502AlekhQGQBC6OiMGy387L95HwtD0/l6Qtep8yQ=;
        b=VPxjo26/IPJxOQaRNmmkqlguIMHIuwG/eOQLpa0+pRQf/NLlncgxhITluumYlYMCIG
         99SvNe0tG8iEIimg+OA3gmel7KFrouueorWN51FjNi+B09l8rEhOHGIxvs+ybqLxINXl
         dSmIEl/qHe7meJcgeu2bhyFFnF8fIG8tUiS+v5SD8kP/M5k6/CD8Jvkcz507/smWLEio
         hmWmJuebagjBr1tlhvM2tYiOoXUfNnL/9NSAluyRkaOktJhiK2tNzGsEjtCDPmURmk/J
         AbtGVjc2r9Ga9bnVwfReEI114g+C7IbD75mT5TRmxj4herp7d+ShbhzudW0/+EqK7ZHb
         5jAA==
X-Gm-Message-State: AC+VfDzaWfhicXQoJZgShWqZroIXlOmcQsYR1cf6se1lp85mQOvisl1o
        jPqmXG6nolK1xVf+iYLyil0=
X-Google-Smtp-Source: ACHHUZ42i9QUD47styNIulBqo9ODlU97l/NTGLNN2sgd6WG8yOTkjFtT0BWHGiVjveeng4kDdTkLKg==
X-Received: by 2002:a17:907:16a6:b0:974:5ef9:f4d4 with SMTP id hc38-20020a17090716a600b009745ef9f4d4mr2064673ejc.5.1686916362212;
        Fri, 16 Jun 2023 04:52:42 -0700 (PDT)
Received: from lilem.mirepesht ([5.236.100.66])
        by smtp.gmail.com with ESMTPSA id gz18-20020a170906f2d200b009659ad1072fsm10660506ejb.113.2023.06.16.04.52.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Jun 2023 04:52:41 -0700 (PDT)
Date:   Fri, 16 Jun 2023 15:21:06 +0330
From:   Ali Gholami Rudi <aligrudi@gmail.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
Message-ID: <20231606152106@laper.mirepesht>
In-Reply-To: <20231606122233@laper.mirepesht>
References: <20231506112411@laper.mirepesht>
 <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
 <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
 <20231606091224@laper.mirepesht> <20231606110134@laper.mirepesht>
 <8b288984-396a-6093-bd1f-266303a8d2b6@huaweicloud.com>
 <20231606115113@laper.mirepesht>
        <1117f940-6c7f-5505-f962-a06e3227ef24@huaweicloud.com>
        <20231606122233@laper.mirepesht>
User-Agent: Neatmail/1.1 (https://github.com/aligrudi/neatmail)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Ali Gholami Rudi <aligrudi@gmail.com> wrote:
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> > > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > > index 4fcfcb350d2b..52f0c24128ff 100644
> > > --- a/drivers/md/raid10.c
> > > +++ b/drivers/md/raid10.c
> > > @@ -905,7 +905,7 @@ static void flush_pending_writes(struct r10conf *conf)
> > >   		/* flush any pending bitmap writes to disk
> > >   		 * before proceeding w/ I/O */
> > >   		md_bitmap_unplug(conf->mddev->bitmap);
> > > -		wake_up(&conf->wait_barrier);
> > > +		wake_up_barrier(conf);
> > >   
> > >   		while (bio) { /* submit pending writes */
> > >   			struct bio *next = bio->bi_next;
> > 
> > Thanks for the testing, sorry that I missed one place... Can you try to
> > change wake_up() to wake_up_barrier() from raid10_unplug() and test
> > again?
> 
> OK.  I replaced the second occurrence of wake_up().
> 
> > > Without the patch:
> > > READ:  IOPS=2033k BW=8329MB/s
> > > WRITE: IOPS= 871k BW=3569MB/s
> > > 
> > > With the patch:
> > > READ:  IOPS=2027K BW=7920MiB/s
> > > WRITE: IOPS= 869K BW=3394MiB/s
> 
> With the second patch:
> READ:  IOPS=3642K BW=13900MiB/s
> WRITE: IOPS=1561K BW= 6097MiB/s
> 
> That is impressive.  Great job.

Perf's output:

+   93.79%     0.09%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
+   92.89%     0.05%  fio      [kernel.kallsyms]       [k] do_syscall_64
+   86.59%     0.07%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
-   85.61%     0.10%  fio      [kernel.kallsyms]       [k] io_submit_one
   - 85.51% io_submit_one
      - 47.98% aio_read
         - 46.18% blkdev_read_iter
            - 44.90% __blkdev_direct_IO_async
               - 41.68% submit_bio_noacct_nocheck
                  - 41.50% __submit_bio
                     - 18.76% md_handle_request
                        - 18.71% raid10_make_request
                           - 18.54% raid10_read_request
                                16.54% read_balance
                                1.80% wait_barrier_nolock
                     - 14.18% raid10_end_read_request
                        - 8.16% raid_end_bio_io
                             7.44% allow_barrier
                     - 8.40% brd_submit_bio
                          2.49% __radix_tree_lookup
               - 1.39% bio_iov_iter_get_pages
                  - 1.04% iov_iter_get_pages
                     - __iov_iter_get_pages_alloc
                        - 0.93% get_user_pages_fast
                             0.79% internal_get_user_pages_fast
               - 1.17% bio_alloc_bioset
                    0.59% mempool_alloc
              0.93% filemap_write_and_wait_range
           0.65% security_file_permission
      - 35.21% aio_write
         - 34.53% blkdev_write_iter
            - 18.25% __generic_file_write_iter
               - 17.84% generic_file_direct_write
                  - 17.35% __blkdev_direct_IO_async
                     - 16.34% submit_bio_noacct_nocheck
                        - 16.31% __submit_bio
                           - 16.28% md_handle_request
                              - 16.26% raid10_make_request
                                   9.26% raid10_write_one_disk
                                   2.11% wait_blocked_dev
                                   0.58% wait_barrier_nolock
            - 16.02% blk_finish_plug
               - 16.01% flush_plug_callbacks
                  - 16.00% raid10_unplug
                     - 15.89% submit_bio_noacct_nocheck
                        - 15.84% __submit_bio
                           - 8.66% raid10_end_write_request
                              - 3.55% raid_end_bio_io
                                   3.54% allow_barrier
                                0.72% find_bio_disk.isra.0
                           - 7.04% brd_submit_bio
                                1.38% __radix_tree_lookup
        0.61% kmem_cache_alloc
+   84.41%     0.99%  fio      fio                     [.] thread_main
+   83.79%     0.00%  fio      [unknown]               [.] 0xffffffffffffffff
+   83.60%     0.00%  fio      fio                     [.] run_threads
+   83.32%     0.00%  fio      fio                     [.] do_io (inlined)
+   81.12%     0.43%  fio      libc-2.31.so            [.] syscall
+   76.23%     0.69%  fio      fio                     [.] td_io_queue
+   76.16%     4.66%  fio      [kernel.kallsyms]       [k] submit_bio_noacct_nocheck
+   75.63%     0.25%  fio      fio                     [.] fio_libaio_commit
+   75.57%     0.17%  fio      fio                     [.] td_io_commit
+   75.54%     0.00%  fio      fio                     [.] io_u_submit (inlined)
+   75.33%     0.17%  fio      libaio.so.1.0.1         [.] io_submit
+   73.66%     0.07%  fio      [kernel.kallsyms]       [k] __submit_bio
+   67.30%     5.07%  fio      [kernel.kallsyms]       [k] __blkdev_direct_IO_async
+   48.02%     0.03%  fio      [kernel.kallsyms]       [k] aio_read
+   46.22%     0.05%  fio      [kernel.kallsyms]       [k] blkdev_read_iter
+   35.71%     3.88%  fio      [kernel.kallsyms]       [k] raid10_make_request
+   35.23%     0.02%  fio      [kernel.kallsyms]       [k] aio_write
+   35.08%     0.06%  fio      [kernel.kallsyms]       [k] md_handle_request
+   34.55%     0.02%  fio      [kernel.kallsyms]       [k] blkdev_write_iter
+   20.16%     1.65%  fio      [kernel.kallsyms]       [k] raid10_read_request
+   18.27%     0.01%  fio      [kernel.kallsyms]       [k] __generic_file_write_iter
+   18.02%     3.63%  fio      [kernel.kallsyms]       [k] brd_submit_bio
+   17.86%     0.02%  fio      [kernel.kallsyms]       [k] generic_file_direct_write
+   17.08%    11.16%  fio      [kernel.kallsyms]       [k] read_balance
+   16.24%     0.33%  fio      [kernel.kallsyms]       [k] raid10_unplug
+   16.02%     0.01%  fio      [kernel.kallsyms]       [k] blk_finish_plug
+   16.02%     0.01%  fio      [kernel.kallsyms]       [k] flush_plug_callbacks
+   14.25%     0.26%  fio      [kernel.kallsyms]       [k] raid10_end_read_request
+   12.77%     1.98%  fio      [kernel.kallsyms]       [k] allow_barrier
+   11.74%     0.40%  fio      [kernel.kallsyms]       [k] raid_end_bio_io
+   10.21%     1.99%  fio      [kernel.kallsyms]       [k] raid10_write_one_disk
+    8.85%     1.52%  fio      [kernel.kallsyms]       [k] raid10_end_write_request
     8.06%     6.43%  fio      [kernel.kallsyms]       [k] wait_barrier_nolock
..

Thanks,
Ali

