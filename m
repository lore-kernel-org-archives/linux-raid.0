Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7388C433ED
	for <linux-raid@archiver.kernel.org>; Tue,  4 May 2021 21:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4D98610C8
	for <linux-raid@archiver.kernel.org>; Tue,  4 May 2021 21:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhEDVS5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 4 May 2021 17:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbhEDVS4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 4 May 2021 17:18:56 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208F1C061574
        for <linux-raid@vger.kernel.org>; Tue,  4 May 2021 14:18:01 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id f15so7510276qtv.5
        for <linux-raid@vger.kernel.org>; Tue, 04 May 2021 14:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rtbhouse.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LY7Q+ju2vOARq8bU3c5ob6rnU+r2SqCK9zOtali6U9E=;
        b=V8FZrD0G7nBJ5+8PXNxoGJouwLxbpd75t9mjyJiefkKjgLXd8tGpcem+xcFKH00WJw
         /UVwJzbBqsAeMfJKz+8Xouhw138eVvwiivAyfXVRSBt132oxWNP21HsGzm8YWwungE8U
         6+mv4QAjDDtb8pEhXcXNQOUt1cvrhBqxwv9oiq6FWjq/L86FgRirZ2FdXUp9Zq/7Jjv9
         Jc2Nj2xefUNkNQxCvyTG4GGNFJEA7CQ+VEQcgCCSGB3M2Q80XC+OGG97isUSXfJN+xd4
         McdqxxhA82qVCYeomU1aYlD3EWPuBAjhYe6B5eFqfOB4X8HrQImxyv8RwFyfCMktRv//
         iBLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LY7Q+ju2vOARq8bU3c5ob6rnU+r2SqCK9zOtali6U9E=;
        b=aFQ87YcJhxz3LEY8pX8uXBqo6RfddPjw2sruU/V/XPd1Ng58NIFzr5E1xYBrJu6JbO
         2yOCmDssNiqPXJHRTLoby4gVa8k6bcaZ+uhU2q0z0TgqTmly3D25UwJz1H3Xc9rpNJSh
         6DGm85sN+htpfIfz9lxPaKWTkNG+D9nnUKTt/GgJHXsc1kok/yEcBNJOWHfGILl3sRnU
         IDiOHpIYuf+K0SteAgGg8E/zBtOKeDg0Q803GrR4TyJ0NYUsm01gor8JHRPMWg0nKNdf
         vVJw9nRHBU0h+O2wYSl8YwnJAhIO9YuKgePbV1C1YSZ/vRdgJW1LVTeiWKOBlmXwwipt
         UfDQ==
X-Gm-Message-State: AOAM533bY41NNd16A8JY7koHf3/ifqp35y5LDfXGIOEjRtNGU4+Co1Kl
        FoLsxyzTAnEHRY9xFzEMjdGwRPrsH/qrugLFq9B1IA==
X-Google-Smtp-Source: ABdhPJxV4xqxGBctUAyz2P13FjjpjWfvS5wJfUCYvhVL02ZZ7v0nTRa3nrJLfxt7J4CIvzB/y/h1LMDMJOZ1/WyDlSc=
X-Received: by 2002:a05:622a:1746:: with SMTP id l6mr24214281qtk.318.1620163080222;
 Tue, 04 May 2021 14:18:00 -0700 (PDT)
MIME-Version: 1.0
References: <CADLTsw2OJtc30HyAHCpQVbbUyoD7P9bK-ZfaH+nrdZc+Je4b6g@mail.gmail.com>
 <ddbacea2-13d9-28ca-7ba2-50b581ac658a@gmail.com> <CAPhsuW743nJCFOv1SHyVU-hcOWMCdFhL4-404e0vE+BdTD3=CQ@mail.gmail.com>
In-Reply-To: <CAPhsuW743nJCFOv1SHyVU-hcOWMCdFhL4-404e0vE+BdTD3=CQ@mail.gmail.com>
From:   =?UTF-8?Q?Pawe=C5=82_Wiejacha?= <pawel.wiejacha@rtbhouse.com>
Date:   Tue, 4 May 2021 23:17:44 +0200
Message-ID: <CADLTsw340wuEoX02ad-M6mN_48uDdnkj0dZSJGYMFrjgB+y80Q@mail.gmail.com>
Subject: Re: PROBLEM: double fault in md_end_io
To:     Song Liu <song@kernel.org>
Cc:     Guoqing Jiang <jgq516@gmail.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Guoqing's patch fixes the problem. Here's the actual patch I am using:

-static void bio_chain_endio(struct bio *bio)
+void bio_chain_endio(struct bio *bio)
 {
    bio_endio(__bio_chain_endio(bio));
 }
+EXPORT_SYMBOL(bio_chain_endio);

 /**
  * bio_chain - chain bio completions
diff --git drivers/md/md.c drivers/md/md.c
index 04384452a7ab..f157bd6e0478 100644
--- drivers/md/md.c
+++ drivers/md/md.c
@@ -507,7 +507,8 @@ static blk_qc_t md_submit_bio(struct bio *bio)
        return BLK_QC_T_NONE;
    }

-   if (bio->bi_end_io !=3D md_end_io) {
+   if (bio->bi_end_io !=3D md_end_io && bio->bi_end_io !=3D
+                bio_chain_endio) {
        struct md_io *md_io;

        md_io =3D mempool_alloc(&mddev->md_io_pool, GFP_NOIO);
diff --git include/linux/bio.h include/linux/bio.h
index 1edda614f7ce..bfb5bd0be397 100644
--- include/linux/bio.h
+++ include/linux/bio.h
@@ -427,6 +427,7 @@ static inline struct bio *bio_kmalloc(gfp_t
gfp_mask, unsigned int nr_iovecs)
 extern blk_qc_t submit_bio(struct bio *);

 extern void bio_endio(struct bio *);
+extern void bio_chain_endio(struct bio *bio);

Thanks,
Pawe=C5=82 Wiejacha

On Fri, 23 Apr 2021 at 08:44, Song Liu <song@kernel.org> wrote:
>
> On Thu, Apr 22, 2021 at 7:36 PM Guoqing Jiang <jgq516@gmail.com> wrote:
> >
> >
> >
> > On 2021/4/10 =E4=B8=8A=E5=8D=885:40, Pawe=C5=82 Wiejacha wrote:
> > > Hello,
> > >
> > > Two of my machines constantly crash with a double fault like this:
> > >
> > > 1146  <0>[33685.629591] traps: PANIC: double fault, error_code: 0x0
> > > 1147  <4>[33685.629593] double fault: 0000 [#1] SMP NOPTI
> > > 1148  <4>[33685.629594] CPU: 10 PID: 2118287 Comm: kworker/10:0
> > > Tainted: P           OE     5.11.8-051108-generic #202103200636
> > > 1149  <4>[33685.629595] Hardware name: ASUSTeK COMPUTER INC. KRPG-U8
> > > Series/KRPG-U8 Series, BIOS 4201 09/25/2020
> > > 1150  <4>[33685.629595] Workqueue: xfs-conv/md12 xfs_end_io [xfs]
> > > 1151  <4>[33685.629596] RIP: 0010:__slab_free+0x23/0x340
> > > 1152  <4>[33685.629597] Code: 4c fe ff ff 0f 1f 00 0f 1f 44 00 00 55
> > > 48 89 e5 41 57 49 89 cf 41 56 49 89 fe 41 55 41 54 49 89 f4 53 48 83
> > > e4 f0 48 83 ec 70 <48> 89 54 24 28 0f 1f 44 00 00 41 8b 46 28 4d 8b 6=
c
> > > 24 20 49 8b 5c
> > > 1153  <4>[33685.629598] RSP: 0018:ffffa9bc00848fa0 EFLAGS: 00010086
> > > 1154  <4>[33685.629599] RAX: ffff94c04d8b10a0 RBX: ffff94437a34a880
> > > RCX: ffff94437a34a880
> > > 1155  <4>[33685.629599] RDX: ffff94437a34a880 RSI: ffffcec745e8d280
> > > RDI: ffff944300043b00
> > > 1156  <4>[33685.629599] RBP: ffffa9bc00849040 R08: 0000000000000001
> > > R09: ffffffff82a5d6de
> > > 1157  <4>[33685.629600] R10: 0000000000000001 R11: 000000009c109000
> > > R12: ffffcec745e8d280
> > > 1158  <4>[33685.629600] R13: ffff944300043b00 R14: ffff944300043b00
> > > R15: ffff94437a34a880
> > > 1159  <4>[33685.629601] FS:  0000000000000000(0000)
> > > GS:ffff94c04d880000(0000) knlGS:0000000000000000
> > > 1160  <4>[33685.629601] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005=
0033
> > > 1161  <4>[33685.629602] CR2: ffffa9bc00848f98 CR3: 000000014d04e000
> > > CR4: 0000000000350ee0
> > > 1162  <4>[33685.629602] Call Trace:
> > > 1163  <4>[33685.629603]  <IRQ>
> > > 1164  <4>[33685.629603]  ? kfree+0x3bc/0x3e0
> > > 1165  <4>[33685.629603]  ? mempool_kfree+0xe/0x10
> > > 1166  <4>[33685.629603]  ? mempool_kfree+0xe/0x10
> > > 1167  <4>[33685.629604]  ? mempool_free+0x2f/0x80
> > > 1168  <4>[33685.629604]  ? md_end_io+0x4a/0x70
> > > 1169  <4>[33685.629604]  ? bio_endio+0xdc/0x130
> > > 1170  <4>[33685.629605]  ? bio_chain_endio+0x2d/0x40
> > > 1171  <4>[33685.629605]  ? md_end_io+0x5c/0x70
> > > 1172  <4>[33685.629605]  ? bio_endio+0xdc/0x130
> > > 1173  <4>[33685.629605]  ? bio_chain_endio+0x2d/0x40
> > > 1174  <4>[33685.629606]  ? md_end_io+0x5c/0x70
> > > 1175  <4>[33685.629606]  ? bio_endio+0xdc/0x130
> > > 1176  <4>[33685.629606]  ? bio_chain_endio+0x2d/0x40
> > > 1177  <4>[33685.629607]  ? md_end_io+0x5c/0x70
> > > ... repeated ...
> > > 1436  <4>[33685.629677]  ? bio_endio+0xdc/0x130
> > > 1437  <4>[33685.629677]  ? bio_chain_endio+0x2d/0x40
> > > 1438  <4>[33685.629677]  ? md_end_io+0x5c/0x70
> > > 1439  <4>[33685.629677]  ? bio_endio+0xdc/0x130
> > > 1440  <4>[33685.629678]  ? bio_chain_endio+0x2d/0x40
> > > 1441  <4>[33685.629678]  ? md_
> > > 1442  <4>[33685.629679] Lost 357 message(s)!
> > >
> > > This happens on:
> > > 5.11.8-051108-generic #202103200636 SMP Sat Mar 20 11:17:32 UTC 2021
> > > and on 5.8.0-44-generic #50~20.04.1-Ubuntu
> > > (https://changelogs.ubuntu.com/changelogs/pool/main/l/linux/linux_5.8=
.0-44.50/changelog)
> > > which contains backported
> > > https://github.com/torvalds/linux/commit/41d2d848e5c09209bdb57ff9c0ca=
34075e22783d
> > > ("md: improve io stats accounting").
> > > The 5.8.18-050818-generic #202011011237 SMP Sun Nov 1 12:40:15 UTC
> > > 2020 which does not contain above suspected change does not crash.
> > >
> > > If there's a better way/place to report this bug just let me know. If
> > > not, here are steps to reproduce:
> > >
> > > 1. Create a RAID 0 device using three Micron_9300_MTFDHAL7T6TDP disks=
.
> > > mdadm --create --verbose /dev/md12 --level=3Dstripe --raid-devices=3D=
3
> > > /dev/nvme0n1p1 /dev/nvme1n1p1 /dev/nvme2n1p1
> > >
> > > 2. Setup xfs on it:
> > > mkfs.xfs /dev/md12 and mount it
> > >
> > > 3. Write to a file on this filesystem:
> > > while true; do rm -rf /mnt/md12/crash* ; for i in `seq 8`; do dd
> > > if=3D/dev/zero of=3D/mnt/md12/crash$i bs=3D32K count=3D50000000 & don=
e; wait;
> > > done
> > > Wait for a crash (usually less than 20 min).
> > >
> > > I couldn't reproduce it with a single dd process (maybe I have to wai=
t
> > > a little longer), but a single cat
> > > /very/large/file/on/cephfs/over100GbE > /mnt/md12/crash is enough for
> > > this double fault to occur.
> >
> > I guess it is related with bio split, if raid0_make_request calls
> > bio_chain for the split bio, then
> > it's bi_end_io is changed to bio_chain_endio. Could you try this?
> >
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -489,7 +489,7 @@ static blk_qc_t md_submit_bio(struct bio *bio)
> >                  return BLK_QC_T_NONE;
> >          }
> >
> > -       if (bio->bi_end_io !=3D md_end_io) {
> > +       if (bio->bi_end_io !=3D md_end_io && bio->bi_end_io !=3D
> > bio_chain_endio) {
> >
> > If the above works, then we could miss the statistics of split bio from
> > blk_queue_split which is
> > called before hijack bi_end_io, so we may need to move blk_queue_split
> > after hijack bi_end_io.
>
> Thanks Guoqing! This is likely the problem here.
>
> Pawel, please give this a try.
>
> Thanks,
> Song
