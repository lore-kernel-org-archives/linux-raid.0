Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE69C433B4
	for <linux-raid@archiver.kernel.org>; Fri, 23 Apr 2021 06:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 493D761406
	for <linux-raid@archiver.kernel.org>; Fri, 23 Apr 2021 06:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbhDWGpF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Apr 2021 02:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231397AbhDWGpF (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 23 Apr 2021 02:45:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B4C7613E1
        for <linux-raid@vger.kernel.org>; Fri, 23 Apr 2021 06:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619160269;
        bh=A3rhkvzZe64FxIrbOUe+ns8mIbIOVUdxo2tyY9dijEA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=usjSACNNzCveInFZkS2gg8Hq4Ik3ZLXttmw+alY6jL6TUYAtiG4iHjKdO/6DRpg+Q
         KZ85AxuurFEM6Lto8UhFN5ULExyAo/glRM7zJQwKISKqkd8d78UKcu+aMxFTbdvR2B
         mziU/HDgHnACBJwem/zUe7xTeNeOXXPf2jvJS43fqRNlZx98/vdE9sqWdz3fBGchYN
         XNLDTk3e7lQYo10jPLEI0ZJn3BNvhN+LFbJGIthsOkY2iqxJnm4CxMHZ2V3xjHXfsW
         CdktzcFleq6QAPVu8Ddpjo0q1Cr55ChzsLKmE4jA59By9YDnRx2h/TcQuRhf+N75TU
         vuVFoaUXHqXnA==
Received: by mail-lf1-f41.google.com with SMTP id g8so75959311lfv.12
        for <linux-raid@vger.kernel.org>; Thu, 22 Apr 2021 23:44:29 -0700 (PDT)
X-Gm-Message-State: AOAM530ECWar/skK9jg7L+K55UYbzjHeJs5LL+ZVkDiGUYQlHWBgp6mc
        AIc0DPeeVbTd0xK9v03QMx94nLtjSUl/T/30Eps=
X-Google-Smtp-Source: ABdhPJz+4rbh1YZAMegAhH8EgiN+2vvsGcS9xjED+NE8KAX9yWbO4dxPV7UGrKdeJq3APq9kUoXh4WhMGNKFJ15Bi4Y=
X-Received: by 2002:a05:6512:38aa:: with SMTP id o10mr1666846lft.261.1619160267272;
 Thu, 22 Apr 2021 23:44:27 -0700 (PDT)
MIME-Version: 1.0
References: <CADLTsw2OJtc30HyAHCpQVbbUyoD7P9bK-ZfaH+nrdZc+Je4b6g@mail.gmail.com>
 <ddbacea2-13d9-28ca-7ba2-50b581ac658a@gmail.com>
In-Reply-To: <ddbacea2-13d9-28ca-7ba2-50b581ac658a@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 22 Apr 2021 23:44:16 -0700
X-Gmail-Original-Message-ID: <CAPhsuW743nJCFOv1SHyVU-hcOWMCdFhL4-404e0vE+BdTD3=CQ@mail.gmail.com>
Message-ID: <CAPhsuW743nJCFOv1SHyVU-hcOWMCdFhL4-404e0vE+BdTD3=CQ@mail.gmail.com>
Subject: Re: PROBLEM: double fault in md_end_io
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     =?UTF-8?Q?Pawe=C5=82_Wiejacha?= <pawel.wiejacha@rtbhouse.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Apr 22, 2021 at 7:36 PM Guoqing Jiang <jgq516@gmail.com> wrote:
>
>
>
> On 2021/4/10 =E4=B8=8A=E5=8D=885:40, Pawe=C5=82 Wiejacha wrote:
> > Hello,
> >
> > Two of my machines constantly crash with a double fault like this:
> >
> > 1146  <0>[33685.629591] traps: PANIC: double fault, error_code: 0x0
> > 1147  <4>[33685.629593] double fault: 0000 [#1] SMP NOPTI
> > 1148  <4>[33685.629594] CPU: 10 PID: 2118287 Comm: kworker/10:0
> > Tainted: P           OE     5.11.8-051108-generic #202103200636
> > 1149  <4>[33685.629595] Hardware name: ASUSTeK COMPUTER INC. KRPG-U8
> > Series/KRPG-U8 Series, BIOS 4201 09/25/2020
> > 1150  <4>[33685.629595] Workqueue: xfs-conv/md12 xfs_end_io [xfs]
> > 1151  <4>[33685.629596] RIP: 0010:__slab_free+0x23/0x340
> > 1152  <4>[33685.629597] Code: 4c fe ff ff 0f 1f 00 0f 1f 44 00 00 55
> > 48 89 e5 41 57 49 89 cf 41 56 49 89 fe 41 55 41 54 49 89 f4 53 48 83
> > e4 f0 48 83 ec 70 <48> 89 54 24 28 0f 1f 44 00 00 41 8b 46 28 4d 8b 6c
> > 24 20 49 8b 5c
> > 1153  <4>[33685.629598] RSP: 0018:ffffa9bc00848fa0 EFLAGS: 00010086
> > 1154  <4>[33685.629599] RAX: ffff94c04d8b10a0 RBX: ffff94437a34a880
> > RCX: ffff94437a34a880
> > 1155  <4>[33685.629599] RDX: ffff94437a34a880 RSI: ffffcec745e8d280
> > RDI: ffff944300043b00
> > 1156  <4>[33685.629599] RBP: ffffa9bc00849040 R08: 0000000000000001
> > R09: ffffffff82a5d6de
> > 1157  <4>[33685.629600] R10: 0000000000000001 R11: 000000009c109000
> > R12: ffffcec745e8d280
> > 1158  <4>[33685.629600] R13: ffff944300043b00 R14: ffff944300043b00
> > R15: ffff94437a34a880
> > 1159  <4>[33685.629601] FS:  0000000000000000(0000)
> > GS:ffff94c04d880000(0000) knlGS:0000000000000000
> > 1160  <4>[33685.629601] CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800500=
33
> > 1161  <4>[33685.629602] CR2: ffffa9bc00848f98 CR3: 000000014d04e000
> > CR4: 0000000000350ee0
> > 1162  <4>[33685.629602] Call Trace:
> > 1163  <4>[33685.629603]  <IRQ>
> > 1164  <4>[33685.629603]  ? kfree+0x3bc/0x3e0
> > 1165  <4>[33685.629603]  ? mempool_kfree+0xe/0x10
> > 1166  <4>[33685.629603]  ? mempool_kfree+0xe/0x10
> > 1167  <4>[33685.629604]  ? mempool_free+0x2f/0x80
> > 1168  <4>[33685.629604]  ? md_end_io+0x4a/0x70
> > 1169  <4>[33685.629604]  ? bio_endio+0xdc/0x130
> > 1170  <4>[33685.629605]  ? bio_chain_endio+0x2d/0x40
> > 1171  <4>[33685.629605]  ? md_end_io+0x5c/0x70
> > 1172  <4>[33685.629605]  ? bio_endio+0xdc/0x130
> > 1173  <4>[33685.629605]  ? bio_chain_endio+0x2d/0x40
> > 1174  <4>[33685.629606]  ? md_end_io+0x5c/0x70
> > 1175  <4>[33685.629606]  ? bio_endio+0xdc/0x130
> > 1176  <4>[33685.629606]  ? bio_chain_endio+0x2d/0x40
> > 1177  <4>[33685.629607]  ? md_end_io+0x5c/0x70
> > ... repeated ...
> > 1436  <4>[33685.629677]  ? bio_endio+0xdc/0x130
> > 1437  <4>[33685.629677]  ? bio_chain_endio+0x2d/0x40
> > 1438  <4>[33685.629677]  ? md_end_io+0x5c/0x70
> > 1439  <4>[33685.629677]  ? bio_endio+0xdc/0x130
> > 1440  <4>[33685.629678]  ? bio_chain_endio+0x2d/0x40
> > 1441  <4>[33685.629678]  ? md_
> > 1442  <4>[33685.629679] Lost 357 message(s)!
> >
> > This happens on:
> > 5.11.8-051108-generic #202103200636 SMP Sat Mar 20 11:17:32 UTC 2021
> > and on 5.8.0-44-generic #50~20.04.1-Ubuntu
> > (https://changelogs.ubuntu.com/changelogs/pool/main/l/linux/linux_5.8.0=
-44.50/changelog)
> > which contains backported
> > https://github.com/torvalds/linux/commit/41d2d848e5c09209bdb57ff9c0ca34=
075e22783d
> > ("md: improve io stats accounting").
> > The 5.8.18-050818-generic #202011011237 SMP Sun Nov 1 12:40:15 UTC
> > 2020 which does not contain above suspected change does not crash.
> >
> > If there's a better way/place to report this bug just let me know. If
> > not, here are steps to reproduce:
> >
> > 1. Create a RAID 0 device using three Micron_9300_MTFDHAL7T6TDP disks.
> > mdadm --create --verbose /dev/md12 --level=3Dstripe --raid-devices=3D3
> > /dev/nvme0n1p1 /dev/nvme1n1p1 /dev/nvme2n1p1
> >
> > 2. Setup xfs on it:
> > mkfs.xfs /dev/md12 and mount it
> >
> > 3. Write to a file on this filesystem:
> > while true; do rm -rf /mnt/md12/crash* ; for i in `seq 8`; do dd
> > if=3D/dev/zero of=3D/mnt/md12/crash$i bs=3D32K count=3D50000000 & done;=
 wait;
> > done
> > Wait for a crash (usually less than 20 min).
> >
> > I couldn't reproduce it with a single dd process (maybe I have to wait
> > a little longer), but a single cat
> > /very/large/file/on/cephfs/over100GbE > /mnt/md12/crash is enough for
> > this double fault to occur.
>
> I guess it is related with bio split, if raid0_make_request calls
> bio_chain for the split bio, then
> it's bi_end_io is changed to bio_chain_endio. Could you try this?
>
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -489,7 +489,7 @@ static blk_qc_t md_submit_bio(struct bio *bio)
>                  return BLK_QC_T_NONE;
>          }
>
> -       if (bio->bi_end_io !=3D md_end_io) {
> +       if (bio->bi_end_io !=3D md_end_io && bio->bi_end_io !=3D
> bio_chain_endio) {
>
> If the above works, then we could miss the statistics of split bio from
> blk_queue_split which is
> called before hijack bi_end_io, so we may need to move blk_queue_split
> after hijack bi_end_io.

Thanks Guoqing! This is likely the problem here.

Pawel, please give this a try.

Thanks,
Song
