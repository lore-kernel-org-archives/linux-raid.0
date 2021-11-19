Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC833C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 19 Nov 2021 04:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A991C61A89
	for <linux-raid@archiver.kernel.org>; Fri, 19 Nov 2021 04:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhKSEKf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Nov 2021 23:10:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232098AbhKSEKe (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 18 Nov 2021 23:10:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8A1F61A70
        for <linux-raid@vger.kernel.org>; Fri, 19 Nov 2021 04:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637294852;
        bh=kVn0CAdVWC6z+mQYh5SuLhSsGjA85I/rW0Wl8xEOGqY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XkBZ6PHd2MoNNKro1HyMQ0uyOBgHc3XiIrh8paD2YhVogIKdiO1YECrLqOu1LhGBN
         g+KLGORV+Km+G3XLgY/9cGCVcCcZ/LoU7ekBjfrPYNQvSist16+IjzGzl7lLwvXtQP
         gZVzmU89gn2HZLooSHT/wz31bEsCW3g4KzFeyBKRhGcSRIEJQClfsMtvuhYLd06jQc
         LJ+zRy5B5+YSsekbbJWQGcKCPlnL8XtOo7ysbuqK8i+smRjM0ePLP1/exNiSGnUBIl
         //eAv2qOfZ1+y1twjglPxKowkLeqyNvnFaAMdzfVKaxNbrOkQ5souB0WFV8HQ85jL4
         OI7o+4WoC/+bQ==
Received: by mail-yb1-f173.google.com with SMTP id q74so24658111ybq.11
        for <linux-raid@vger.kernel.org>; Thu, 18 Nov 2021 20:07:32 -0800 (PST)
X-Gm-Message-State: AOAM530licx2hpqXN5cMEbba59qyCbcrJ9pDotmHl8ZV6qeN3SZoH3Q7
        QRcxnuKzyzvdsHOSYW0EBUaxHDT9m2bBxVOJ7zE=
X-Google-Smtp-Source: ABdhPJw0RN+0wOjgt5seuwr3sok0+m6TT1dDixRZxTHX2hafufZWQ6F1q2n3baWqwt8eni98c+g8QgMwIztt9ZTVxpw=
X-Received: by 2002:a25:69cc:: with SMTP id e195mr34315878ybc.456.1637294851888;
 Thu, 18 Nov 2021 20:07:31 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com> <20211110181441.9263-4-vverma@digitalocean.com>
 <CAPhsuW7=r4AmCqG3M0hU=fps6a-Zu9KF_RnyNf815d=43wTv5A@mail.gmail.com> <f8c2a2bc-a885-8254-2b39-fc0c969ac70d@digitalocean.com>
In-Reply-To: <f8c2a2bc-a885-8254-2b39-fc0c969ac70d@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 18 Nov 2021 20:07:21 -0800
X-Gmail-Original-Message-ID: <CAPhsuW54EJOfAXrE-zVie561n+aF-+jvQz1152rqj=kU5Fk5ug@mail.gmail.com>
Message-ID: <CAPhsuW54EJOfAXrE-zVie561n+aF-+jvQz1152rqj=kU5Fk5ug@mail.gmail.com>
Subject: Re: [RFC PATCH v4 4/4] md: raid456 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Nov 11, 2021 at 10:09 PM Vishal Verma <vverma@digitalocean.com> wrote:
>
> Yes, with raid10 the task hung happened when doing write IO using FIO where FIO just gets stuck  after like 30s or so and no I/O happens afterwards.
> This was on a test nvme based raid10: (tried with both io_uring and aio, same issue)
>
> [ 1818.677686] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1818.685512] task:fio             state:D stack:    0 pid:14314 ppid:     1 flags:0x00020004
> [ 1818.685516] Call Trace:
> [ 1818.685519]  __schedule+0x295/0x840
> [ 1818.685525]  ? wbt_cleanup_cb+0x20/0x20
> [ 1818.685528]  schedule+0x4e/0xb0
> [ 1818.685529]  io_schedule+0x3f/0x70
> [ 1818.685531]  rq_qos_wait+0xb9/0x130
> [ 1818.685535]  ? sysv68_partition+0x280/0x280
> [ 1818.685537]  ? wbt_cleanup_cb+0x20/0x20
> [ 1818.685538]  wbt_wait+0x92/0xc0
> [ 1818.685539]  __rq_qos_throttle+0x25/0x40
> [ 1818.685541]  blk_mq_submit_bio+0xc6/0x5d0
> [ 1818.685544]  ? submit_bio_checks+0x39e/0x5f0
> [ 1818.685547]  __submit_bio+0x1bc/0x1d0
> [ 1818.685549]  submit_bio_noacct+0x256/0x2a0
> [ 1818.685550]  ? bio_associate_blkg+0x29/0x70
> [ 1818.685553]  0xffffffffc028d38a
> [ 1818.685555]  blk_flush_plug+0xc3/0x130
> [ 1818.685558]  blk_finish_plug+0x26/0x40
> [ 1818.685560]  blkdev_write_iter+0xf8/0x160
> [ 1818.685561]  io_write+0x153/0x2e0
> [ 1818.685564]  ? blk_mq_put_tags+0x1d/0x20
> [ 1818.685566]  ? blk_mq_end_request_batch+0x295/0x2e0
> [ 1818.685568]  ? sysvec_apic_timer_interrupt+0x46/0x80
> [ 1818.685570]  io_issue_sqe+0x579/0x1990
> [ 1818.685571]  ? io_req_prep+0x6a9/0xe60
> [ 1818.685573]  ? __fget_files+0x56/0x80
> [ 1818.685576]  ? fget+0x2a/0x30
> [ 1818.685577]  io_submit_sqes+0x28c/0x930
> [ 1818.685578]  ? __io_submit_flush_completions+0xdc/0x150
> [ 1818.685580]  ? ctx_flush_and_put+0x4b/0x70
> [ 1818.685581]  __x64_sys_io_uring_enter+0x1db/0x8e0
> [ 1818.685583]  ? exit_to_user_mode_prepare+0x3e/0x1e0
> [ 1818.685586]  ? exit_to_user_mode_prepare+0x3e/0x1e0
> [ 1818.685588]  do_syscall_64+0x38/0x90
> [ 1818.685591]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1818.685593] RIP: 0033:0x7f8a41c1889d
> [ 1818.685594] RSP: 002b:00007ffe390d5af8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> [ 1818.685596] RAX: ffffffffffffffda RBX: 00007ffe390d5b20 RCX: 00007f8a41c1889d
> [ 1818.685597] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000006
> [ 1818.685597] RBP: 000055de073b6ef0 R08: 0000000000000000 R09: 0000000000000000
> [ 1818.685598] R10: 0000000000000001 R11: 0000000000000246 R12: 00007f8a38400000
> [ 1818.685599] R13: 0000000000000001 R14: 0000000000875bc1 R15: 0000000000000000
>
> For raid456, running into this as soon as I try to create a raid5 volume:
>
> [ 5338.620661] Buffer I/O error on dev md5, logical block 0, async page read
> [ 5338.627457] Buffer I/O error on dev md5, logical block 0, async page read
> [ 5338.634250] Buffer I/O error on dev md5, logical block 0, async page read
> [ 5338.641043] Buffer I/O error on dev md5, logical block 0, async page read
> [ 5338.647836] Buffer I/O error on dev md5, logical block 0, async page read
> [ 5338.654632] Buffer I/O error on dev md5, logical block 0, async page read
> [ 5338.661424] Dev md5: unable to read RDB block 0
> [ 5338.665957] Buffer I/O error on dev md5, logical block 0, async page read
> [ 5338.672746] Buffer I/O error on dev md5, logical block 0, async page read
> [ 5338.679540] Buffer I/O error on dev md5, logical block 3, async page read

I am sorry that I haven't got time to look into this, and I will be on
vacation again from
tomorrow. If you make progress, please share your finding and/or
updated version.
I will try to look into this after Thanksgiving.

Song
