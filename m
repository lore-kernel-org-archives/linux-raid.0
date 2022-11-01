Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E33DC4332F
	for <linux-raid@archiver.kernel.org>; Tue,  1 Nov 2022 20:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiKAUOA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Nov 2022 16:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiKAUN7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Nov 2022 16:13:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA0C1B9E6
        for <linux-raid@vger.kernel.org>; Tue,  1 Nov 2022 13:13:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B66B6171E
        for <linux-raid@vger.kernel.org>; Tue,  1 Nov 2022 20:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF09C433C1
        for <linux-raid@vger.kernel.org>; Tue,  1 Nov 2022 20:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667333637;
        bh=eZfLQrn55bbqBkXy7T4JcEQsQYENWkaVp/vQx8CuCzI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SGzfnLsDiW2VbdwafFJqidlGnaWS8Eb0Aw8ORilDcygEwM1VxyEg2vEF37nEt/07F
         REi5te8vgRPgvS0LoE1sgKsiMU5RZqtuViLr6BsG55wcbMdnkhd5X9VGwbQD93TDp3
         WqOLehgDOCs4VBRBqoJdXx+tWtd838jWPnJq16WK8/dY9Wk2YotSgNmQgu8qH+kqv5
         2tdQpc5FariCm2d8J/OI6tSsvrHxAACkFqpWGpJK+R6y0HfkmoKgWfUmvFfu+cMKGG
         HKnJAIpDx7QuYPZ3tbPSbAMe3mgqoig/hC/NHPi13d8Y37brqV0OK6jD7jQ6050m+q
         01OswI/FFPp4A==
Received: by mail-ed1-f47.google.com with SMTP id r14so23383487edc.7
        for <linux-raid@vger.kernel.org>; Tue, 01 Nov 2022 13:13:57 -0700 (PDT)
X-Gm-Message-State: ACrzQf3DYIV9gyQyTDLLNVm/CxqhIMObKKU7+wmLoQTu9YHNdIIoLVJT
        4uBxpIG6sDvYHSkOGcdbe7M3f+ufa77imZNimms=
X-Google-Smtp-Source: AMsMyM6AEKgKg2lJjSuDsr/j8jxD+fSYSyjiLJuxlK6wiqdoWTS1o1ntqjHRuXAtvqt6FjbqUwVkrKmOm5Mh66L7RE0=
X-Received: by 2002:a05:6402:1690:b0:45f:d702:9919 with SMTP id
 a16-20020a056402169000b0045fd7029919mr20710102edv.127.1667333635747; Tue, 01
 Nov 2022 13:13:55 -0700 (PDT)
MIME-Version: 1.0
References: <CADb4QcMJXNqkdAgUy8g08QgFwiZqp690h+LUdXD6u_EyHQVKUA@mail.gmail.com>
In-Reply-To: <CADb4QcMJXNqkdAgUy8g08QgFwiZqp690h+LUdXD6u_EyHQVKUA@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 1 Nov 2022 13:13:43 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5=4c5C0gK9460u5xj4OJnN4a-=mufviYSOUdTUzO04Gw@mail.gmail.com>
Message-ID: <CAPhsuW5=4c5C0gK9460u5xj4OJnN4a-=mufviYSOUdTUzO04Gw@mail.gmail.com>
Subject: Re: [PATCH] md/raid1: Fix crash during poweroff
To:     jiang li <jiang.li1388@gmail.com>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 1, 2022 at 5:16 AM jiang li <jiang.li1388@gmail.com> wrote:
>
> fail run raid1 array when we assemble array with the inactive disk in --run mode,
> but the mdx_raid1 thread were not stop,Even if the associated resources have been released.
> it will caused a NULL dereference when we do poweroff.
>
> This causes the following Oops:
>     [  287.587787] BUG: kernel NULL pointer dereference, address: 0000000000000070
>     [  287.594762] #PF: supervisor read access in kernel mode
>     [  287.599912] #PF: error_code(0x0000) - not-present page
>     [  287.605061] PGD 0 P4D 0
>     [  287.607612] Oops: 0000 [#1] SMP NOPTI
>     [  287.611287] CPU: 3 PID: 5265 Comm: md0_raid1 Tainted: G     U            5.10.146 #0
>     [  287.619029] Hardware name: xxxxxxx/To be filled by O.E.M, BIOS 5.19 06/16/2022
>     [  287.626775] RIP: 0010:md_check_recovery+0x57/0x500 [md_mod]
>     [  287.632357] Code: fe 01 00 00 48 83 bb 10 03 00 00 00 74 08 48 89 ......
>     [  287.651118] RSP: 0018:ffffc90000433d78 EFLAGS: 00010202
>     [  287.656347] RAX: 0000000000000000 RBX: ffff888105986800 RCX: 0000000000000000
>     [  287.663491] RDX: ffffc90000433bb0 RSI: 00000000ffffefff RDI: ffff888105986800
>     [  287.670634] RBP: ffffc90000433da0 R08: 0000000000000000 R09: c0000000ffffefff
>     [  287.677771] R10: 0000000000000001 R11: ffffc90000433ba8 R12: ffff888105986800
>     [  287.684907] R13: 0000000000000000 R14: fffffffffffffe00 R15: ffff888100b6b500
>     [  287.692052] FS:  0000000000000000(0000) GS:ffff888277f80000(0000) knlGS:0000000000000000
>     [  287.700149] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     [  287.705897] CR2: 0000000000000070 CR3: 000000000320a000 CR4: 0000000000350ee0
>     [  287.713033] Call Trace:
>     [  287.715498]  raid1d+0x6c/0xbbb [raid1]
>     [  287.719256]  ? __schedule+0x1ff/0x760
>     [  287.722930]  ? schedule+0x3b/0xb0
>     [  287.726260]  ? schedule_timeout+0x1ed/0x290
>     [  287.730456]  ? __switch_to+0x11f/0x400
>     [  287.734219]  md_thread+0xe9/0x140 [md_mod]
>     [  287.738328]  ? md_thread+0xe9/0x140 [md_mod]
>     [  287.742601]  ? wait_woken+0x80/0x80
>     [  287.746097]  ? md_register_thread+0xe0/0xe0 [md_mod]
>     [  287.751064]  kthread+0x11a/0x140
>     [  287.754300]  ? kthread_park+0x90/0x90
>     [  287.757974]  ret_from_fork+0x1f/0x30
>
> In fact, when raid1 array run fail, we
> need to do md_unregister_thread() before raid1_free().
>
> Signed-off-by: lijiang <lijiang@ugreen.com>

The fix looks reasonable. Please improve the commit log and resend.
Specifically, please be clear on what is the failure, reproduce steps,
and what is the fix.

Thanks,
Song

> ---
>  drivers/md/raid1.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 05d8438cfec8..58f705f42948 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3159,6 +3159,7 @@ static int raid1_run(struct mddev *mddev)
>          * RAID1 needs at least one disk in active
>          */
>         if (conf->raid_disks - mddev->degraded < 1) {
> +               md_unregister_thread(&conf->thread);
>                 ret = -EINVAL;
>                 goto abort;
>         }
> --
> 2.17.1
