Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B2EC433FE
	for <linux-raid@archiver.kernel.org>; Fri,  4 Nov 2022 04:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiKDEkz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Nov 2022 00:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiKDEkx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Nov 2022 00:40:53 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB92427913
        for <linux-raid@vger.kernel.org>; Thu,  3 Nov 2022 21:40:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3BA6321887;
        Fri,  4 Nov 2022 04:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667536851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=amytpVocUiVAHGjTEcqYi8EIw48JOYqhWHDcV/zI26s=;
        b=YPd2mdQUaqLA2sLvj+BbALsd1KKclRLKe7g/nK2lPDBWD4fZfJj9NOBb33JcSQQpoAJCPA
        NDxy/Q1qpstYtbX9R/aPsbF9tVgXdn5UwFYj7hzjzqlOUYb4EDzfIybWsdcsS1biJlJ90t
        ipqJrqruiGMCYQTJOCkHPC+aW5SuivI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667536851;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=amytpVocUiVAHGjTEcqYi8EIw48JOYqhWHDcV/zI26s=;
        b=cVbQ1f90yIdoLn0CHbegv/1IL3Pwq4XW58iQV25VQ9TeNV+wZtFN4UrgdpUof+qrR+rSJv
        k6tORoZhSNrFsHDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1C7E51346F;
        Fri,  4 Nov 2022 04:40:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mkyoMNCXZGN5ewAAMHmgww
        (envelope-from <neilb@suse.de>); Fri, 04 Nov 2022 04:40:48 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Mikulas Patocka" <mpatocka@redhat.com>
Cc:     "Song Liu" <song@kernel.org>,
        "Guoqing Jiang" <guoqing.jiang@linux.dev>,
        "Zdenek Kabelac" <zkabelac@redhat.com>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] md: fix a crash in mempool_free
In-reply-to: =?utf-8?q?=3Calpine=2ELRH=2E2=2E21=2E2211031121070=2E18305=40fi?=
 =?utf-8?q?le01=2Eintranet=2Eprod=2Eint=2Erdu2=2Eredhat=2Ecom=3E?=
References: =?utf-8?q?=3Calpine=2ELRH=2E2=2E21=2E2211031121070=2E18305=40fil?=
 =?utf-8?q?e01=2Eintranet=2Eprod=2Eint=2Erdu2=2Eredhat=2Ecom=3E?=
Date:   Fri, 04 Nov 2022 15:40:45 +1100
Message-id: <166753684502.19313.12105294223332649758@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 04 Nov 2022, Mikulas Patocka wrote:
> There's a crash in mempool_free when running the lvm test
> shell/lvchange-rebuild-raid.sh.
>=20
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
>=20
> We fix this bug by moving bio_put before atomic_dec_and_test.
>=20
> The function md_end_flush has a similar bug - we must call bio_put before
> we decrement the number of in-progress bios.
>=20
>  BUG: kernel NULL pointer dereference, address: 0000000000000000
>  #PF: supervisor write access in kernel mode
>  #PF: error_code(0x0002) - not-present page
>  PGD 11557f0067 P4D 11557f0067 PUD 0
>  Oops: 0002 [#1] PREEMPT SMP
>  CPU: 0 PID: 73 Comm: kworker/0:1 Not tainted 6.1.0-rc3 #5
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01=
/2014
>  Workqueue: kdelayd flush_expired_bios [dm_delay]
>  RIP: 0010:mempool_free+0x47/0x80
>  Code: 48 89 ef 5b 5d ff e0 f3 c3 48 89 f7 e8 32 45 3f 00 48 63 53 08 48 89=
 c6 3b 53 04 7d 2d 48 8b 43 10 8d 4a 01 48 89 df 89 4b 08 <48> 89 2c d0 e8 b0=
 45 3f 00 48 8d 7b 30 5b 5d 31 c9 ba 01 00 00 00
>  RSP: 0018:ffff88910036bda8 EFLAGS: 00010093
>  RAX: 0000000000000000 RBX: ffff8891037b65d8 RCX: 0000000000000001
>  RDX: 0000000000000000 RSI: 0000000000000202 RDI: ffff8891037b65d8
>  RBP: ffff8891447ba240 R08: 0000000000012908 R09: 00000000003d0900
>  R10: 0000000000000000 R11: 0000000000173544 R12: ffff889101a14000
>  R13: ffff8891562ac300 R14: ffff889102b41440 R15: ffffe8ffffa00d05
>  FS:  0000000000000000(0000) GS:ffff88942fa00000(0000) knlGS:00000000000000=
00
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
>  Modules linked in: brd dm_delay dm_raid dm_mod af_packet uvesafb cfbfillre=
ct cfbimgblt cn cfbcopyarea fb font fbdev tun autofs4 binfmt_misc configfs ip=
v6 virtio_rng virtio_balloon rng_core virtio_net pcspkr net_failover failover=
 qemu_fw_cfg button mousedev raid10 raid456 libcrc32c async_raid6_recov async=
_memcpy async_pq raid6_pq async_xor xor async_tx raid1 raid0 md_mod sd_mod t1=
0_pi crc64_rocksoft crc64 virtio_scsi scsi_mod evdev psmouse bsg scsi_common =
[last unloaded: brd]
>  CR2: 0000000000000000
>  ---[ end trace 0000000000000000 ]---
>=20
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
>=20
> ---
>  drivers/md/md.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> Index: linux-2.6/drivers/md/md.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/md.c	2022-11-03 15:29:02.000000000 +0100
> +++ linux-2.6/drivers/md/md.c	2022-11-03 15:33:17.000000000 +0100
> @@ -509,13 +509,14 @@ static void md_end_flush(struct bio *bio
>  	struct md_rdev *rdev =3D bio->bi_private;
>  	struct mddev *mddev =3D rdev->mddev;
> =20
> +	bio_put(bio);
> +
>  	rdev_dec_pending(rdev, mddev);
> =20
>  	if (atomic_dec_and_test(&mddev->flush_pending)) {
>  		/* The pre-request flush has finished */
>  		queue_work(md_wq, &mddev->flush_work);
>  	}
> -	bio_put(bio);
>  }
> =20
>  static void md_submit_flush_data(struct work_struct *ws);
> @@ -913,10 +914,11 @@ static void super_written(struct bio *bi
>  	} else
>  		clear_bit(LastDev, &rdev->flags);
> =20
> +	bio_put(bio);
> +
>  	if (atomic_dec_and_test(&mddev->pending_writes))
>  		wake_up(&mddev->sb_wait);
>  	rdev_dec_pending(rdev, mddev);
> -	bio_put(bio);
>  }

Thanks. I think this is a clear improvement.
I think it would be a little better if the rdev_dec_pending were also
move up.
Then both code fragments would be:
  bio_put ; rdev_dec_pending ; atomic_dec_and_test

Thanks,
NeilBrown

