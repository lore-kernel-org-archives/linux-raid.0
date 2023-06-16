Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107B8EB64DA
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 01:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238975AbjFPByp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Jun 2023 21:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238918AbjFPByn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Jun 2023 21:54:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BA1AC
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 18:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686880435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xoQUiL5SfEgJvYQD1xhbT3fL/XgncTJIeSbtpUcR1uo=;
        b=AabhawJHdEcZqNApiuehOXlAu3bk5F99DS/a/UIfQiqwCozofawolaV67ogReT+o2vTnRs
        jn0okgKv61hTMP8PnRpOnJuL8555fu/hP4i+J2bgbZpLDECBzuws15vwBY7IhSEP34A/b+
        L0XsKKYkDP6ViXmReZGBKA3Mme4dT6s=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290-hf7BxPIIPearvGlzTqG5Mw-1; Thu, 15 Jun 2023 21:53:54 -0400
X-MC-Unique: hf7BxPIIPearvGlzTqG5Mw-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1b52498ece5so2130925ad.1
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 18:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686880433; x=1689472433;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xoQUiL5SfEgJvYQD1xhbT3fL/XgncTJIeSbtpUcR1uo=;
        b=b6ohukSDH/gqNz/OksKCNomKzcSOlH2nSq3NOYpwZS3o34To/x0PlyuOXVz4yCHoGp
         9tO2+Jt+EsrfaBtnxSnhmRWmkJ33n0uGsbosecPfwqID1jaJ7HDkDAu+hkn+vMWgs2F0
         uJri9Zlo+pEGFI6jiaXIUNKS4PIQPyWHxiAs9JgtxBxGuW0j/je7+uoYQCXDJKIqrMPp
         a4xKpJfkxj+sXnQaU07TEcpKg2qDx7hs145WlMF8aFSHGRmwzj17WxBxD41oCKRgQSyy
         T7L5UJhJaVQujdsA9Wz/oeM80A5octzvSfxCkRDG2YyMJ6zHZwGeUGehn7baQv7sxP9O
         pk5Q==
X-Gm-Message-State: AC+VfDySQukm2GhA6AJinF/LL+2sFOsyflYvr3E9n3TSbNLBGjFKvhWg
        CT+FHuSfbQvzUVPHRkRO9OiGmpV5dBqp2nwr134QNgYlbH4gyD8fCK+KZD6oXVO1s6M5j9yUvi8
        hQe5qqU5OHMxGWm1843BcmUER+2XjubXtZ4NGh+26Kes2a8ndJ0k=
X-Received: by 2002:a17:902:7689:b0:1b4:ff2a:24e5 with SMTP id m9-20020a170902768900b001b4ff2a24e5mr600825pll.43.1686880433025;
        Thu, 15 Jun 2023 18:53:53 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ46cL8oNCQLkhdjEumTRcJliMahnIEqkkP2nHStDFrFft0g/5nRYe10oi1K1gnr4S+bH7RBhHAS4gJMjU2TFYE=
X-Received: by 2002:a17:902:7689:b0:1b4:ff2a:24e5 with SMTP id
 m9-20020a170902768900b001b4ff2a24e5mr600817pll.43.1686880432742; Thu, 15 Jun
 2023 18:53:52 -0700 (PDT)
MIME-Version: 1.0
References: <20231506112411@laper.mirepesht> <CALTww29UZ+WewVrvFDSpONqTHY=TR-Q7tobdRrhsTtXKtXvOBg@mail.gmail.com>
 <20231506203832@laper.mirepesht> <20231506210600@laper.mirepesht>
In-Reply-To: <20231506210600@laper.mirepesht>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 16 Jun 2023 09:53:41 +0800
Message-ID: <CALTww2-HamETu5UppBiz079PZUP+rDRtQkaRA+03=s3wSQGRKA@mail.gmail.com>
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
To:     Ali Gholami Rudi <aligrudi@gmail.com>
Cc:     linux-raid@vger.kernel.org, song@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Jun 16, 2023 at 1:38=E2=80=AFAM Ali Gholami Rudi <aligrudi@gmail.co=
m> wrote:
>
>
> Ali Gholami Rudi <aligrudi@gmail.com> wrote:
> > Xiao Ni <xni@redhat.com> wrote:
> > > Because it can be reproduced easily in your environment. Can you try
> > > with the latest upstream kernel? If the problem doesn't exist with
> > > latest upstream kernel. You can use git bisect to find which patch ca=
n
> > > fix this problem.
> >
> > I just tried the upstream.  I get almost the same result with 1G ramdis=
ks.
> >
> > Without RAID (writing to /dev/ram0)
> > READ:  IOPS=3D15.8M BW=3D60.3GiB/s
> > WRITE: IOPS=3D 6.8M BW=3D27.7GiB/s
> >
> > RAID1 (writing to /dev/md/test)
> > READ:  IOPS=3D518K BW=3D2028MiB/s
> > WRITE: IOPS=3D222K BW=3D 912MiB/s

Hi Ali

I can reproduce this with upstream kernel too.

RAID1
READ: bw=3D3699MiB/s (3879MB/s)
WRITE: bw=3D1586MiB/s (1663MB/s)

ram disk:
READ: bw=3D5720MiB/s (5997MB/s)
WRITE: bw=3D2451MiB/s (2570MB/s)

There is a performance problem. But not like your result. Your result
has a huge gap. I'm not sure the reason. Any thoughts?


>
> And this is perf's output:

I'm not familiar with perf, what's your command that I can use to see
the same output?

Regards
Xiao
>
> +   98.73%     0.01%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_=
64_after_hwframe
> +   98.63%     0.01%  fio      [kernel.kallsyms]       [k] do_syscall_64
> +   97.28%     0.01%  fio      [kernel.kallsyms]       [k] __x64_sys_io_s=
ubmit
> -   97.09%     0.01%  fio      [kernel.kallsyms]       [k] io_submit_one
>    - 97.08% io_submit_one
>       - 53.58% aio_write
>          - 53.42% blkdev_write_iter
>             - 35.28% blk_finish_plug
>                - flush_plug_callbacks
>                   - 35.27% raid1_unplug
>                      - flush_bio_list
>                         - 17.88% submit_bio_noacct_nocheck
>                            - 17.88% __submit_bio
>                               - 17.61% raid1_end_write_request
>                                  - 17.47% raid_end_bio_io
>                                     - 17.41% __wake_up_common_lock
>                                        - 17.38% _raw_spin_lock_irqsave
>                                             native_queued_spin_lock_slowp=
ath
>                         - 17.35% __wake_up_common_lock
>                            - 17.31% _raw_spin_lock_irqsave
>                                 native_queued_spin_lock_slowpath
>             + 18.07% __generic_file_write_iter
>       - 43.00% aio_read
>          - 42.64% blkdev_read_iter
>             - 42.37% __blkdev_direct_IO_async
>                - 41.40% submit_bio_noacct_nocheck
>                   - 41.34% __submit_bio
>                      - 40.68% raid1_end_read_request
>                         - 40.55% raid_end_bio_io
>                            - 40.35% __wake_up_common_lock
>                               - 40.28% _raw_spin_lock_irqsave
>                                    native_queued_spin_lock_slowpath
> +   95.19%     0.32%  fio      fio                     [.] thread_main
> +   95.08%     0.00%  fio      [unknown]               [.] 0xffffffffffff=
ffff
> +   95.03%     0.00%  fio      fio                     [.] run_threads
> +   94.77%     0.00%  fio      fio                     [.] do_io (inlined=
)
> +   94.65%     0.16%  fio      fio                     [.] td_io_queue
> +   94.65%     0.11%  fio      libc-2.31.so            [.] syscall
> +   94.54%     0.07%  fio      fio                     [.] fio_libaio_com=
mit
> +   94.53%     0.05%  fio      fio                     [.] td_io_commit
> +   94.50%     0.00%  fio      fio                     [.] io_u_submit (i=
nlined)
> +   94.47%     0.04%  fio      libaio.so.1.0.1         [.] io_submit
> +   92.48%     0.02%  fio      [kernel.kallsyms]       [k] _raw_spin_lock=
_irqsave
> +   92.48%     0.00%  fio      [kernel.kallsyms]       [k] __wake_up_comm=
on_lock
> +   92.46%    92.32%  fio      [kernel.kallsyms]       [k] native_queued_=
spin_lock_slowpath
> +   76.85%     0.03%  fio      [kernel.kallsyms]       [k] submit_bio_noa=
cct_nocheck
> +   76.76%     0.00%  fio      [kernel.kallsyms]       [k] __submit_bio
> +   60.25%     0.06%  fio      [kernel.kallsyms]       [k] __blkdev_direc=
t_IO_async
> +   58.12%     0.11%  fio      [kernel.kallsyms]       [k] raid_end_bio_i=
o
> ..
>
> Thanks,
> Ali
>

