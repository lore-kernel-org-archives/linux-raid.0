Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64681EB64D7
	for <linux-raid@archiver.kernel.org>; Tue, 20 Jun 2023 19:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjFTTvh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Jun 2023 15:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjFTTvg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Jun 2023 15:51:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791FB1726;
        Tue, 20 Jun 2023 12:51:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F191E60F25;
        Tue, 20 Jun 2023 19:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD46C433C9;
        Tue, 20 Jun 2023 19:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687290694;
        bh=FGHLPf7rPF5627/o/BBkzEf0LONNyEAm2DqS1FhfPQI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RAn1lRj8nFZR+tmjFMkdhALx8rayi9uFzgEKOU8SPfQkBCFXwWFxjkT9bPj45V6rL
         N0L+g323OW0pNQqTMd9J6wHUDbuapZv8WDueqTYCTq3bwISHbS4MDY/PNrkqQOLB21
         dYzdHtme1ILeY2xLAijAx0i/lACHCy4h6rHaFQ7WLeZ/t9vPJwJYOD+Y0esjD12und
         ZomcKiPlvX7EQn9bbJ9l+6x9oAJSIGdtGDFNj5i/bAGButqPWPVKf8cRphpXvp3nNb
         WRASAMqTu3t/HwHh3mU3kXU38uKAjaLNJIDFRuOZrbiEyD8HCh6b4RNbqrBc5CCu6l
         wpRkVpBLVP+rg==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-4f954d78bf8so1424926e87.3;
        Tue, 20 Jun 2023 12:51:34 -0700 (PDT)
X-Gm-Message-State: AC+VfDx6sHr9NSUF1gHzmsSLLiEMvFs9wWDBEyYTCxaW1FYJRHqiVhT3
        ie0La4PfH3n1PeU/j82qya11Q2kisJBTTznT0EA=
X-Google-Smtp-Source: ACHHUZ58+70CdCB2RCgmsGRMR1yv/ipSPZZmuIKYR0lgVRyL754txdxlrhEwvuEglWuibB9cPrJaI6YChXpxyTV4dbU=
X-Received: by 2002:a19:8c16:0:b0:4f8:586a:8af6 with SMTP id
 o22-20020a198c16000000b004f8586a8af6mr7623173lfd.4.1687290692393; Tue, 20 Jun
 2023 12:51:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230617052405.305871-1-song@kernel.org> <50217644-7acc-dccd-bada-d31dda2d29a4@kernel.dk>
In-Reply-To: <50217644-7acc-dccd-bada-d31dda2d29a4@kernel.dk>
From:   Song Liu <song@kernel.org>
Date:   Tue, 20 Jun 2023 12:51:19 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4qr2KRG5VUoA6GQVcHAaY6miq=L0-LMpG=M_JXjTsgeA@mail.gmail.com>
Message-ID: <CAPhsuW4qr2KRG5VUoA6GQVcHAaY6miq=L0-LMpG=M_JXjTsgeA@mail.gmail.com>
Subject: Re: [PATCH] md: use mddev->external to select holder in export_rdev()
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jun 20, 2023 at 11:50=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 6/16/23 11:24=E2=80=AFPM, Song Liu wrote:
> > mdadm test "10ddf-create-fail-rebuild" triggers warnings like the follo=
wing
> >
> > [  215.526357] ------------[ cut here ]------------
> > [  215.527243] WARNING: CPU: 18 PID: 1264 at block/bdev.c:617 blkdev_pu=
t+0x269/0x350
> > [  215.528334] Modules linked in:
> > [  215.528806] CPU: 18 PID: 1264 Comm: mdmon Not tainted 6.4.0-rc2+ #76=
8
> > [  215.529863] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS
> > [  215.531464] RIP: 0010:blkdev_put+0x269/0x350
> > [  215.532167] Code: ff ff 49 8d 7d 10 e8 56 bf b8 ff 4d 8b 65 10 49 8d=
 bc
> > 24 58 05 00 00 e8 05 be b8 ff 41 83 ac 24 58 05 00 00 01 e9 44 ff ff ff
> > <0f> 0b e9 52 fe ff ff 0f 0b e9 6b fe ff ff1
> > [  215.534780] RSP: 0018:ffffc900040bfbf0 EFLAGS: 00010283
> > [  215.535635] RAX: ffff888174001000 RBX: ffff88810b1c3b00 RCX: fffffff=
f819a4061
> > [  215.536645] RDX: dffffc0000000000 RSI: dffffc0000000000 RDI: ffff888=
10b1c3ba0
> > [  215.537657] RBP: ffff88810dbde800 R08: fffffbfff0fca983 R09: fffffbf=
ff0fca983
> > [  215.538674] R10: ffffc900040bfbf0 R11: fffffbfff0fca982 R12: ffff888=
10b1c3b38
> > [  215.539687] R13: ffff88810b1c3b10 R14: ffff88810dbdecb8 R15: ffff888=
10b1c3b00
> > [  215.540833] FS:  00007f2aabdff700(0000) GS:ffff888dfb400000(0000) kn=
lGS:0000000000000000
> > [  215.541961] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  215.542775] CR2: 00007fa19a85d934 CR3: 000000010c076006 CR4: 0000000=
000370ee0
> > [  215.543814] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> > [  215.544840] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
> > [  215.545885] Call Trace:
> > [  215.546257]  <TASK>
> > [  215.546608]  export_rdev.isra.63+0x71/0xe0
> > [  215.547338]  mddev_unlock+0x1b1/0x2d0
> > [  215.547898]  array_state_store+0x28d/0x450
> > [  215.548519]  md_attr_store+0xd7/0x150
> > [  215.549059]  ? __pfx_sysfs_kf_write+0x10/0x10
> > [  215.549702]  kernfs_fop_write_iter+0x1b9/0x260
> > [  215.550351]  vfs_write+0x491/0x760
> > [  215.550863]  ? __pfx_vfs_write+0x10/0x10
> > [  215.551445]  ? __fget_files+0x156/0x230
> > [  215.552053]  ksys_write+0xc0/0x160
> > [  215.552570]  ? __pfx_ksys_write+0x10/0x10
> > [  215.553141]  ? ktime_get_coarse_real_ts64+0xec/0x100
> > [  215.553878]  do_syscall_64+0x3a/0x90
> > [  215.554403]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> > [  215.555125] RIP: 0033:0x7f2aade11847
> > [  215.555696] Code: c3 66 90 41 54 49 89 d4 55 48 89 f5 53 89 fb 48 83=
 ec
> > 10 e8 1b fd ff ff 4c 89 e2 48 89 ee 89 df 41 89 c0 b8 01 00 00 00 0f 05
> > <48> 3d 00 f0 ff ff 77 35 44 89 c7 48 89 448
> > [  215.558398] RSP: 002b:00007f2aabdfeba0 EFLAGS: 00000293 ORIG_RAX: 00=
00000000000001
> > [  215.559516] RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00007f2=
aade11847
> > [  215.560515] RDX: 0000000000000005 RSI: 0000000000438b8b RDI: 0000000=
000000010
> > [  215.561512] RBP: 0000000000438b8b R08: 0000000000000000 R09: 00007f2=
aaecf0060
> > [  215.562511] R10: 000000000e3ba40b R11: 0000000000000293 R12: 0000000=
000000005
> > [  215.563647] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000=
000c70750
> > [  215.564693]  </TASK>
> > [  215.565029] irq event stamp: 15979
> > [  215.565584] hardirqs last  enabled at (15991): [<ffffffff811a7432>] =
__up_console_sem+0x52/0x60
> > [  215.566806] hardirqs last disabled at (16000): [<ffffffff811a7417>] =
__up_console_sem+0x37/0x60
> > [  215.568022] softirqs last  enabled at (15716): [<ffffffff8277a2db>] =
__do_softirq+0x3eb/0x531
> > [  215.569239] softirqs last disabled at (15711): [<ffffffff810d8f45>] =
irq_exit_rcu+0x115/0x160
> > [  215.570434] ---[ end trace 0000000000000000 ]---
> >
> > This means export_rdev() calls blkdev_put with a different holder than =
the
> > one used by blkdev_get_by_dev(). This is because mddev->major_version =
=3D=3D -2
> > is not a good check for external metadata. Fix this by using
> > mddev->external instead.
> >
> > Also, do not clear mddev->external in md_clean(), as the flag might be =
used
> > later in export_rdev().
>
> Want me to grab this one directly, or is it going into a pull request?
>

I will send it in a pull request.

Thanks,
Song
