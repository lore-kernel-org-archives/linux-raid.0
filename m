Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8159BC433FE
	for <linux-raid@archiver.kernel.org>; Wed,  9 Nov 2022 22:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiKIWIl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Nov 2022 17:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiKIWIj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Nov 2022 17:08:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8784D29357
        for <linux-raid@vger.kernel.org>; Wed,  9 Nov 2022 14:08:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21EA361CFE
        for <linux-raid@vger.kernel.org>; Wed,  9 Nov 2022 22:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757F6C433B5
        for <linux-raid@vger.kernel.org>; Wed,  9 Nov 2022 22:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668031717;
        bh=17djljRXVQgc4JIVGAFyInCXzP7sVKY4bSna8DCpQgA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PpgcahIO8ocNIrKW/lro0du45nSy3CUT9iiZhBFp0mdzi93Jln4Gc8ThZJ2mf/XF2
         3HScRxY+oQDdSMTUVOM9n2ciasV9re4Xx1W4McdfA618hulCG9wDSc4KgCfagJl/QJ
         x4cXcGHBaWDIX9ZGByQbmXgDbIQNk9NAcZggWCnPKZHKA6UKspzNj+ywu3C/bfDALQ
         YgxEEbwdd+n7Ho+OQTsoga8SR570p2Or3ELQruLxt7QvySey6ka+u3O33RAzThEgsZ
         ZNnuc/eDXXUXpqRs0qgcv+AeP1ri1apht53Aoh+8iDkGlRX4YS8s2BYLd1L78s6zBL
         FvRdfGeIwslSg==
Received: by mail-ej1-f41.google.com with SMTP id ft34so329626ejc.12
        for <linux-raid@vger.kernel.org>; Wed, 09 Nov 2022 14:08:37 -0800 (PST)
X-Gm-Message-State: ANoB5plzphLafukLeRBDAErzPrY97vbJy06U3iyZ0ahPty7h76nHKfeg
        FKNDBv6MKmJnqsriQ+tEPe5Orcqlqe2kL/hreYQ=
X-Google-Smtp-Source: AA0mqf4w7SisRWOiXYd81FIhtvFpRzYOxt7eSRtpF8VmFnqDZkKWXISX4wCTXt57E/MtCLPL0cBVyrkcOX+OnmXLN0c=
X-Received: by 2002:a17:907:2995:b0:7ae:8956:ab56 with SMTP id
 eu21-20020a170907299500b007ae8956ab56mr4446166ejc.719.1668031715619; Wed, 09
 Nov 2022 14:08:35 -0800 (PST)
MIME-Version: 1.0
References: <alpine.LRH.2.21.2211040952390.19553@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.21.2211040952390.19553@file01.intranet.prod.int.rdu2.redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 9 Nov 2022 14:08:23 -0800
X-Gmail-Original-Message-ID: <CAPhsuW57CN=V+gXH27iE-zTDedVHZbZNnumO8jO6nXCmSnW7hQ@mail.gmail.com>
Message-ID: <CAPhsuW57CN=V+gXH27iE-zTDedVHZbZNnumO8jO6nXCmSnW7hQ@mail.gmail.com>
Subject: Re: [PATCH v2] md: fix a crash in mempool_free
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     NeilBrown <neilb@suse.de>, Guoqing Jiang <guoqing.jiang@linux.dev>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Nov 4, 2022 at 6:53 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> There's a crash in mempool_free when running the lvm test
> shell/lvchange-rebuild-raid.sh.
>
> The reason for the crash is this:
> * super_written calls atomic_dec_and_test(&mddev->pending_writes) and
>   wake_up(&mddev->sb_wait). Then it calls rdev_dec_pending(rdev, mddev)
>   and bio_put(bio).
> * so, the process that waited on sb_wait and that is woken up is racing
>   with bio_put(bio).
> * if the process wins the race, it calls bioset_exit before bio_put(bio)
>   is executed.
> * bio_put(bio) attempts to free a bio into a destroyed bio set - causing
>   a crash in mempool_free.
>
> We fix this bug by moving bio_put before atomic_dec_and_test.
>
> We also move rdev_dec_pending before atomic_dec_and_test as suggested by
> Neil Brown.
>
> The function md_end_flush has a similar bug - we must call bio_put before
> we decrement the number of in-progress bios.
>
>  BUG: kernel NULL pointer dereference, address: 0000000000000000
>  #PF: supervisor write access in kernel mode
>  #PF: error_code(0x0002) - not-present page
>  PGD 11557f0067 P4D 11557f0067 PUD 0
>  Oops: 0002 [#1] PREEMPT SMP
>  CPU: 0 PID: 73 Comm: kworker/0:1 Not tainted 6.1.0-rc3 #5
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/=
01/2014
>  Workqueue: kdelayd flush_expired_bios [dm_delay]
>  RIP: 0010:mempool_free+0x47/0x80
>  Code: 48 89 ef 5b 5d ff e0 f3 c3 48 89 f7 e8 32 45 3f 00 48 63 53 08 48 =
89 c6 3b 53 04 7d 2d 48 8b 43 10 8d 4a 01 48 89 df 89 4b 08 <48> 89 2c d0 e=
8 b0 45 3f 00 48 8d 7b 30 5b 5d 31 c9 ba 01 00 00 00
>  RSP: 0018:ffff88910036bda8 EFLAGS: 00010093
>  RAX: 0000000000000000 RBX: ffff8891037b65d8 RCX: 0000000000000001
>  RDX: 0000000000000000 RSI: 0000000000000202 RDI: ffff8891037b65d8
>  RBP: ffff8891447ba240 R08: 0000000000012908 R09: 00000000003d0900
>  R10: 0000000000000000 R11: 0000000000173544 R12: ffff889101a14000
>  R13: ffff8891562ac300 R14: ffff889102b41440 R15: ffffe8ffffa00d05
>  FS:  0000000000000000(0000) GS:ffff88942fa00000(0000) knlGS:000000000000=
0000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000000 CR3: 0000001102e99000 CR4: 00000000000006b0
>  Call Trace:
>   <TASK>
>   clone_endio+0xf4/0x1c0 [dm_mod]
>   clone_endio+0xf4/0x1c0 [dm_mod]
>   __submit_bio+0x76/0x120
>   submit_bio_noacct_nocheck+0xb6/0x2a0
>   flush_expired_bios+0x28/0x2f [dm_delay]
>   process_one_work+0x1b4/0x300
>   worker_thread+0x45/0x3e0
>   ? rescuer_thread+0x380/0x380
>   kthread+0xc2/0x100
>   ? kthread_complete_and_exit+0x20/0x20
>   ret_from_fork+0x1f/0x30
>   </TASK>
>  Modules linked in: brd dm_delay dm_raid dm_mod af_packet uvesafb cfbfill=
rect cfbimgblt cn cfbcopyarea fb font fbdev tun autofs4 binfmt_misc configf=
s ipv6 virtio_rng virtio_balloon rng_core virtio_net pcspkr net_failover fa=
ilover qemu_fw_cfg button mousedev raid10 raid456 libcrc32c async_raid6_rec=
ov async_memcpy async_pq raid6_pq async_xor xor async_tx raid1 raid0 md_mod=
 sd_mod t10_pi crc64_rocksoft crc64 virtio_scsi scsi_mod evdev psmouse bsg =
scsi_common [last unloaded: brd]
>  CR2: 0000000000000000
>  ---[ end trace 0000000000000000 ]---
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

Applied v2 to md-next. Thanks!
Song

>
> ---
>  drivers/md/md.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> Index: linux-2.6/drivers/md/md.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/md.c      2022-11-03 15:29:02.000000000 +01=
00
> +++ linux-2.6/drivers/md/md.c   2022-11-04 14:29:37.000000000 +0100
> @@ -509,13 +509,14 @@ static void md_end_flush(struct bio *bio
>         struct md_rdev *rdev =3D bio->bi_private;
>         struct mddev *mddev =3D rdev->mddev;
>
> +       bio_put(bio);
> +
>         rdev_dec_pending(rdev, mddev);
>
>         if (atomic_dec_and_test(&mddev->flush_pending)) {
>                 /* The pre-request flush has finished */
>                 queue_work(md_wq, &mddev->flush_work);
>         }
> -       bio_put(bio);
>  }
>
>  static void md_submit_flush_data(struct work_struct *ws);
> @@ -913,10 +914,12 @@ static void super_written(struct bio *bi
>         } else
>                 clear_bit(LastDev, &rdev->flags);
>
> +       bio_put(bio);
> +
> +       rdev_dec_pending(rdev, mddev);
> +
>         if (atomic_dec_and_test(&mddev->pending_writes))
>                 wake_up(&mddev->sb_wait);
> -       rdev_dec_pending(rdev, mddev);
> -       bio_put(bio);
>  }
>
>  void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
>
