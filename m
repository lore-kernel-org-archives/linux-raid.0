Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12AE7EB64D8
	for <linux-raid@archiver.kernel.org>; Wed, 21 Jun 2023 08:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjFUIL2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Jun 2023 04:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjFUILZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Jun 2023 04:11:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B7110D5
        for <linux-raid@vger.kernel.org>; Wed, 21 Jun 2023 01:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687335045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a5JnUh20bi7EB8E+qgvpWoQYsjgCy4v4f18DGO3ImRQ=;
        b=Mm57xRckYCYNwahrGBFuwuKlvRcAzl6723mTMNa1Crnm/2bWNursagBHmF56bJN5tkE3LT
        av0Wd/M9Ov1bfSbVb/S2OIWiQBjImA1BcU932Y7hiZDo62Q/70U6UHYBpI0aSCZfNE5Ose
        8Tjz3Fh/jtMB8riqMRoY/qLHGQOGgxM=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-2UqKtRHxOemx3Fl1uTB4mg-1; Wed, 21 Jun 2023 04:10:43 -0400
X-MC-Unique: 2UqKtRHxOemx3Fl1uTB4mg-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-341de9586d4so45975865ab.2
        for <linux-raid@vger.kernel.org>; Wed, 21 Jun 2023 01:10:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687335043; x=1689927043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a5JnUh20bi7EB8E+qgvpWoQYsjgCy4v4f18DGO3ImRQ=;
        b=Wad+7Tme/lEUPtj1BqXYXh3pVEotymtfvSZsxZkfOVZtldlZCBwSre64aPqHyRZ8wM
         Kdx7N0tSQvogJDgY14yzP0/yyUJr8FGXQYMnWrBJpoVl4q+zSK0zS2cPIfUWMUceiwpB
         +/EFwfvlR3ueh8z0pfpheReOjCrO1ETNtorVHfpKlHwBxgYy89LO1cn3Xm2moKvD2ehP
         UTEfr+ODvcQ4MgGm2l0cXe/2QDx46ZaDjkLxLe5BZfiQZo/wD/iL/xeoOrub5Gc00ZkL
         ZXTgTaWjkPqILOTzy44fBBZAyYW8kyudSIBxbGkKkwrUUgMwkJJoWGGhg+jprrSF9vWb
         zGDg==
X-Gm-Message-State: AC+VfDzrT+8NA7QSU9EI47wQeMD24RPUJME40yOzGkM56pEipcRWYDmy
        BOBQ5chcLEtGEFmeXfLUa30QGM2Ba/h64wikkrfdiaM8AV/ywQg3IFFvYmZvWGjRXNWObSwEwQ8
        2KR1y4HtQz/EtPaZQr/jBgpEvdnekUdb9bzFB2GzYpTn96K7mZoY=
X-Received: by 2002:a05:6e02:804:b0:342:7bea:5f3c with SMTP id u4-20020a056e02080400b003427bea5f3cmr7926092ilm.18.1687335042628;
        Wed, 21 Jun 2023 01:10:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4/aEKKrRTTtYfZvZv1gCh2us9r1PwhzvMOaJVv0IhgmU16ktd6CZvVZHEcJz3N7IveRwxQti/ZpoJA2CULzE0=
X-Received: by 2002:a05:6e02:804:b0:342:7bea:5f3c with SMTP id
 u4-20020a056e02080400b003427bea5f3cmr7926085ilm.18.1687335042327; Wed, 21 Jun
 2023 01:10:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230617052405.305871-1-song@kernel.org>
In-Reply-To: <20230617052405.305871-1-song@kernel.org>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 21 Jun 2023 16:10:31 +0800
Message-ID: <CALTww2-f7vSXugM0kMMMG==YgmDOEqSLk+vLf2U_ZyprDKk2+w@mail.gmail.com>
Subject: Re: [PATCH] md: use mddev->external to select holder in export_rdev()
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song

After applying your patch, there are still warning messages in the
calltrace. It looks like a deadlock. The test case is
10ddf-fail-stop-readd.

[  381.825307] INFO: task md126_raid1:1896 blocked for more than 122 second=
s.
[  381.825722]       Tainted: G           OE      6.4.0-rc2+ #1
[  381.826626] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  381.827080] task:md126_raid1     state:D stack:0     pid:1896
ppid:2      flags:0x00004000
[  381.827864] Call Trace:
[  381.828013]  <TASK>
[  381.828514]  __schedule+0x2ad/0x7c0
[  381.829126]  schedule+0x5a/0xd0
[  381.829733]  schedule_preempt_disabled+0x11/0x20
[  381.830396]  __mutex_lock+0x5c8/0xcc0
[  381.830627]  ? mddev_unlock+0xa0/0x1c0 [md_mod]
[  381.831338]  ? mddev_unlock+0xa0/0x1c0 [md_mod]
[  381.832152]  mddev_unlock+0xa0/0x1c0 [md_mod]
[  381.833604]  raid1d+0x41/0x3f0 [raid1]
[  381.833870]  ? lock_acquired+0xdc/0x100
[  381.834093]  ? _raw_spin_lock_irqsave+0x5a/0x90
[  381.834752]  md_thread+0xb1/0x160 [md_mod]
[  381.835009]  ? __pfx_autoremove_wake_function+0x10/0x10
[  381.835308]  ? __pfx_md_thread+0x10/0x10 [md_mod]
[  381.835986]  kthread+0xe5/0x120
[  381.836605]  ? __pfx_kthread+0x10/0x10
[  381.837016]  ret_from_fork+0x2c/0x50
[  381.837580]  </TASK>
[  381.837758] INFO: task mdmon:1900 blocked for more than 122 seconds.
[  381.838088]       Tainted: G           OE      6.4.0-rc2+ #1
[  381.838775] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  381.839193] task:mdmon           state:D stack:0     pid:1900
ppid:1      flags:0x00004002
[  381.839600] Call Trace:
[  381.839737]  <TASK>
[  381.840255]  __schedule+0x2ad/0x7c0
[  381.840873]  schedule+0x5a/0xd0
[  381.841439]  schedule_preempt_disabled+0x11/0x20
[  381.842070]  __mutex_lock+0x5c8/0xcc0
[  381.842302]  ? lock_release+0xd2/0xf0
[  381.842547]  ? _raw_spin_unlock+0x1f/0x40
[  381.842832]  ? mddev_unlock+0xa0/0x1c0 [md_mod]
[  381.843502]  ? mddev_unlock+0xa0/0x1c0 [md_mod]
[  381.845024]  mddev_unlock+0xa0/0x1c0 [md_mod]
[  381.845725]  rdev_attr_store+0xab/0x140 [md_mod]
[  381.846400]  kernfs_fop_write_iter+0x15b/0x210
[  381.847104]  vfs_write+0x2fc/0x4a0
[  381.933063]  ksys_write+0x68/0xf0
[  381.947838]  do_syscall_64+0x5c/0x90
[  381.948253]  ? do_syscall_64+0x69/0x90
[  381.948809]  ? syscall_exit_work+0x121/0x150
[  381.949462]  ? trace_hardirqs_on_prepare+0x7f/0x90
[  381.950143]  ? do_syscall_64+0x69/0x90
[  381.950375]  ? trace_hardirqs_on_prepare+0x7f/0x90
[  381.951022]  ? do_syscall_64+0x69/0x90
[  381.951262]  ? exit_to_user_mode_prepare+0x12a/0x140
[  381.951549]  ? trace_hardirqs_on_prepare+0x7f/0x90
[  381.952223]  ? do_syscall_64+0x69/0x90
[  381.952447]  ? irq_exit_rcu+0xa/0x20
[  381.952761]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[  381.953050] RIP: 0033:0x7ffa3813ebcf
[  381.953279] RSP: 002b:00007ffa37ffec80 EFLAGS: 00000293 ORIG_RAX:
0000000000000001
[  381.954052] RAX: ffffffffffffffda RBX: 0000000000438d76 RCX: 00007ffa381=
3ebcf
[  381.954843] RDX: 0000000000000008 RSI: 0000000000438d76 RDI: 00000000000=
00008
[  381.955648] RBP: 0000000000000008 R08: 0000000000000000 R09: 00000000000=
00001
[  381.956469] R10: 00000000e236abd6 R11: 0000000000000293 R12: 0000000001e=
10660
[  381.957272] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000001e=
29140
[  382.124033]  </TASK>

[  382.980626] INFO: task mdadm:1961 blocked for more than 124 seconds.
[  382.981343]       Tainted: G           OE      6.4.0-rc2+ #1
[  382.982118] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  382.982597] task:mdadm           state:D stack:0     pid:1961
ppid:1877   flags:0x00000002
[  383.063581] Call Trace:
[  383.144264]  <TASK>
[  383.224618]  __schedule+0x2ad/0x7c0
[  383.332114]  schedule+0x5a/0xd0
[  383.439571]  schedule_preempt_disabled+0x11/0x20
[  383.484497]  __mutex_lock+0x5c8/0xcc0
[  383.484717]  ? mddev_unlock+0xa0/0x1c0 [md_mod]
[  383.485426]  ? mddev_unlock+0xa0/0x1c0 [md_mod]
[  383.486071]  mddev_unlock+0xa0/0x1c0 [md_mod]
[  383.486723]  do_md_stop+0x69/0x580 [md_mod]
[  383.486985]  ? lock_acquire+0x178/0x2b0
[  383.487184]  ? __mutex_lock+0xbb5/0xcc0
[  383.487389]  array_state_store+0x269/0x3c0 [md_mod]
[  383.488044]  md_attr_store+0x8d/0x110 [md_mod]
[  383.488705]  kernfs_fop_write_iter+0x15b/0x210
[  383.489549]  vfs_write+0x2fc/0x4a0
[  383.490127]  ksys_write+0x68/0xf0
[  383.490705]  do_syscall_64+0x5c/0x90
[  383.490940]  ? do_syscall_64+0x69/0x90
[  383.491333]  ? do_syscall_64+0x69/0x90
[  383.492221]  ? trace_hardirqs_on_prepare+0x7f/0x90
[  383.492904]  ? do_syscall_64+0x69/0x90
[  383.493122]  ? trace_hardirqs_off+0x42/0x90
[  383.493342]  ? exc_page_fault+0xda/0x1c0
[  383.493546]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[  383.493835] RIP: 0033:0x7f2b84f3eb97
[  383.494047] RSP: 002b:00007ffdfdb5fa58 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[  383.548204] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f2b84f=
3eb97
[  383.738188] RDX: 0000000000000008 RSI: 000000000046b432 RDI: 00000000000=
00003
[  383.928512] RBP: 000000000046b432 R08: 0000000000000000 R09: 00007ffdfdb=
5f8f0
[  383.995716] R10: 00007f2b84e070e0 R11: 0000000000000246 R12: 00000000fff=
fffff
[  383.996643] R13: 0000000000000019 R14: 0000000000000005 R15: 00000000000=
00000
[  383.997451]  </TASK>
[  383.997779] INFO: lockdep is turned off.

1896  0.0  0.0      0     0 ?        D    03:53   0:00  \_ [md126_raid1]
cat /proc/1896/stack
[<0>] mddev_unlock+0xa0/0x1c0 [md_mod]
[<0>] raid1d+0x41/0x3f0 [raid1]
[<0>] md_thread+0xb1/0x160 [md_mod]
[<0>] kthread+0xe5/0x120
[<0>] ret_from_fork+0x2c/0x50

root        1961  0.0  0.0   3584  2112 pts/0    D+   03:53   0:00  |
                     \_ /root/mdadm/mdadm --quiet -Ss
cat /proc/1961/stack
[<0>] mddev_unlock+0xa0/0x1c0 [md_mod]
[<0>] do_md_stop+0x69/0x580 [md_mod]
[<0>] array_state_store+0x269/0x3c0 [md_mod]
[<0>] md_attr_store+0x8d/0x110 [md_mod]
[<0>] kernfs_fop_write_iter+0x15b/0x210
[<0>] vfs_write+0x2fc/0x4a0
[<0>] ksys_write+0x68/0xf0
[<0>] do_syscall_64+0x5c/0x90
[<0>] entry_SYSCALL_64_after_hwframe+0x72/0xdc

Regards
Xiao

On Sat, Jun 17, 2023 at 1:26=E2=80=AFPM Song Liu <song@kernel.org> wrote:
>
> mdadm test "10ddf-create-fail-rebuild" triggers warnings like the followi=
ng
>
> [  215.526357] ------------[ cut here ]------------
> [  215.527243] WARNING: CPU: 18 PID: 1264 at block/bdev.c:617 blkdev_put+=
0x269/0x350
> [  215.528334] Modules linked in:
> [  215.528806] CPU: 18 PID: 1264 Comm: mdmon Not tainted 6.4.0-rc2+ #768
> [  215.529863] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S
> [  215.531464] RIP: 0010:blkdev_put+0x269/0x350
> [  215.532167] Code: ff ff 49 8d 7d 10 e8 56 bf b8 ff 4d 8b 65 10 49 8d b=
c
> 24 58 05 00 00 e8 05 be b8 ff 41 83 ac 24 58 05 00 00 01 e9 44 ff ff ff
> <0f> 0b e9 52 fe ff ff 0f 0b e9 6b fe ff ff1
> [  215.534780] RSP: 0018:ffffc900040bfbf0 EFLAGS: 00010283
> [  215.535635] RAX: ffff888174001000 RBX: ffff88810b1c3b00 RCX: ffffffff8=
19a4061
> [  215.536645] RDX: dffffc0000000000 RSI: dffffc0000000000 RDI: ffff88810=
b1c3ba0
> [  215.537657] RBP: ffff88810dbde800 R08: fffffbfff0fca983 R09: fffffbfff=
0fca983
> [  215.538674] R10: ffffc900040bfbf0 R11: fffffbfff0fca982 R12: ffff88810=
b1c3b38
> [  215.539687] R13: ffff88810b1c3b10 R14: ffff88810dbdecb8 R15: ffff88810=
b1c3b00
> [  215.540833] FS:  00007f2aabdff700(0000) GS:ffff888dfb400000(0000) knlG=
S:0000000000000000
> [  215.541961] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  215.542775] CR2: 00007fa19a85d934 CR3: 000000010c076006 CR4: 000000000=
0370ee0
> [  215.543814] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [  215.544840] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [  215.545885] Call Trace:
> [  215.546257]  <TASK>
> [  215.546608]  export_rdev.isra.63+0x71/0xe0
> [  215.547338]  mddev_unlock+0x1b1/0x2d0
> [  215.547898]  array_state_store+0x28d/0x450
> [  215.548519]  md_attr_store+0xd7/0x150
> [  215.549059]  ? __pfx_sysfs_kf_write+0x10/0x10
> [  215.549702]  kernfs_fop_write_iter+0x1b9/0x260
> [  215.550351]  vfs_write+0x491/0x760
> [  215.550863]  ? __pfx_vfs_write+0x10/0x10
> [  215.551445]  ? __fget_files+0x156/0x230
> [  215.552053]  ksys_write+0xc0/0x160
> [  215.552570]  ? __pfx_ksys_write+0x10/0x10
> [  215.553141]  ? ktime_get_coarse_real_ts64+0xec/0x100
> [  215.553878]  do_syscall_64+0x3a/0x90
> [  215.554403]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [  215.555125] RIP: 0033:0x7f2aade11847
> [  215.555696] Code: c3 66 90 41 54 49 89 d4 55 48 89 f5 53 89 fb 48 83 e=
c
> 10 e8 1b fd ff ff 4c 89 e2 48 89 ee 89 df 41 89 c0 b8 01 00 00 00 0f 05
> <48> 3d 00 f0 ff ff 77 35 44 89 c7 48 89 448
> [  215.558398] RSP: 002b:00007f2aabdfeba0 EFLAGS: 00000293 ORIG_RAX: 0000=
000000000001
> [  215.559516] RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00007f2aa=
de11847
> [  215.560515] RDX: 0000000000000005 RSI: 0000000000438b8b RDI: 000000000=
0000010
> [  215.561512] RBP: 0000000000438b8b R08: 0000000000000000 R09: 00007f2aa=
ecf0060
> [  215.562511] R10: 000000000e3ba40b R11: 0000000000000293 R12: 000000000=
0000005
> [  215.563647] R13: 0000000000000000 R14: 0000000000000001 R15: 000000000=
0c70750
> [  215.564693]  </TASK>
> [  215.565029] irq event stamp: 15979
> [  215.565584] hardirqs last  enabled at (15991): [<ffffffff811a7432>] __=
up_console_sem+0x52/0x60
> [  215.566806] hardirqs last disabled at (16000): [<ffffffff811a7417>] __=
up_console_sem+0x37/0x60
> [  215.568022] softirqs last  enabled at (15716): [<ffffffff8277a2db>] __=
do_softirq+0x3eb/0x531
> [  215.569239] softirqs last disabled at (15711): [<ffffffff810d8f45>] ir=
q_exit_rcu+0x115/0x160
> [  215.570434] ---[ end trace 0000000000000000 ]---
>
> This means export_rdev() calls blkdev_put with a different holder than th=
e
> one used by blkdev_get_by_dev(). This is because mddev->major_version =3D=
=3D -2
> is not a good check for external metadata. Fix this by using
> mddev->external instead.
>
> Also, do not clear mddev->external in md_clean(), as the flag might be us=
ed
> later in export_rdev().
>
> Fixes: 2736e8eeb0cc ("block: use the holder as indication for exclusive o=
pens")
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  drivers/md/md.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index cf3733c90c47..8e7cc2e69bc9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2458,7 +2458,7 @@ static void export_rdev(struct md_rdev *rdev, struc=
t mddev *mddev)
>         if (test_bit(AutoDetected, &rdev->flags))
>                 md_autodetect_dev(rdev->bdev->bd_dev);
>  #endif
> -       blkdev_put(rdev->bdev, mddev->major_version =3D=3D -2 ? &claim_rd=
ev : rdev);
> +       blkdev_put(rdev->bdev, mddev->external ? &claim_rdev : rdev);
>         rdev->bdev =3D NULL;
>         kobject_put(&rdev->kobj);
>  }
> @@ -6140,7 +6140,7 @@ static void md_clean(struct mddev *mddev)
>         mddev->resync_min =3D 0;
>         mddev->resync_max =3D MaxSector;
>         mddev->reshape_position =3D MaxSector;
> -       mddev->external =3D 0;
> +       /* we still need mddev->external in export_rdev, do not clear it =
yet */
>         mddev->persistent =3D 0;
>         mddev->level =3D LEVEL_NONE;
>         mddev->clevel[0] =3D 0;
> --
> 2.34.1
>

