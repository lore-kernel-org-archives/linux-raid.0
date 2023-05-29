Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CF9C7EE23
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 03:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjE2DLl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 May 2023 23:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjE2DLj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 May 2023 23:11:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EB8B1
        for <linux-raid@vger.kernel.org>; Sun, 28 May 2023 20:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685329847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nv9/BM2DhuQLxyTYsPBgWvEMK5DBpBnK6gBG5KrBckE=;
        b=N9+H99UHaPye4r9FX5B6rOQAH99XA0B3g7uXeod8rvsxSrqfykpG0Bd98QtHCEq4smJIsr
        j/b8Ihp6Qouo2mvWzVHsm7yKWmoSyU/GhWa0PY6sIVvOMgJtUhIJ4seMrRCh9D2Qe8qQ9j
        ++u12rpTdNnDTXnvPoP58esmBG2nYVg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-pFjOtZ9oPzuMbGsM5PmJAg-1; Sun, 28 May 2023 23:10:45 -0400
X-MC-Unique: pFjOtZ9oPzuMbGsM5PmJAg-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1b01d7b3e80so24604465ad.3
        for <linux-raid@vger.kernel.org>; Sun, 28 May 2023 20:10:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685329844; x=1687921844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nv9/BM2DhuQLxyTYsPBgWvEMK5DBpBnK6gBG5KrBckE=;
        b=B7Y1VZ/C5aU+WjVgWB15CItcw1XvjZmZTjf3waXQz4v2je0M8grgEp0SYjjxeEqpEK
         0NcTtKM6s0JLCqDiyBa5Jvsye9yYVKg+tbDu0NS4zCqgYXgatuuPl9gg9jLjl1nAcxBc
         UtveNBDs1CydWty+4zMrnG96HKGkNqbeY4VGKNfYovfvqBkR/5t7iYrCDbZS6f/XSolT
         qbXZmfiO0+W9T9VdQH0k827JqNv3LlNqllYgyxHK8vVg8HC10Dl7HNjfjGi2fKzjLUOM
         G+nLjvXLrClsru4xZ/Awj5XhyMmE1VnAwE+C5tWnPixyhvT1HgLF8oQYDEEnG1dYcvGH
         dOJQ==
X-Gm-Message-State: AC+VfDyoIM6apgfafCW1BjVb7GgoQDpzVUpoWhPBzeYy0PcauykAAPGV
        6vh0aatS6TUaIQ70DawtXQxIbwrfwZY5gqepjcPGsBGMlVri4BRIbB33lDNg/x5kcg7HX1ne1i2
        xBDQVacY1wY6UDx8GP44z3k/f+wlW+GwyNEGVWA==
X-Received: by 2002:a17:902:db0a:b0:1ad:e19f:bb66 with SMTP id m10-20020a170902db0a00b001ade19fbb66mr12094776plx.12.1685329844448;
        Sun, 28 May 2023 20:10:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ61v8U55WOZVKt3tGs9agxz5S+ln2d6aJqiH1aer1bkXPQsfDdIh9OsKb7cbFJ4Ne1BLVU2McfjabaHXYB/K3I=
X-Received: by 2002:a17:902:db0a:b0:1ad:e19f:bb66 with SMTP id
 m10-20020a170902db0a00b001ade19fbb66mr12094764plx.12.1685329844182; Sun, 28
 May 2023 20:10:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230426082031.1299149-1-yukuai1@huaweicloud.com>
 <20230426082031.1299149-8-yukuai1@huaweicloud.com> <CALTww2-yTsHXNFgkAVu0v++HHahZCnvXEUv2qJqbvcGUhKanDw@mail.gmail.com>
 <5e9852fe-0d47-92fc-f6a9-16d028d09ad4@huaweicloud.com>
In-Reply-To: <5e9852fe-0d47-92fc-f6a9-16d028d09ad4@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 29 May 2023 11:10:33 +0800
Message-ID: <CALTww28ur_S0UpGQqq0TubSgkxGG7dicc1ZKrJ3Pno4CpSOWUw@mail.gmail.com>
Subject: Re: [PATCH -next v2 7/7] md/raid1-10: limit the number of plugged bio
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     song@kernel.org, akpm@osdl.org, neilb@suse.de,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, May 29, 2023 at 10:20=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2023/05/29 10:08, Xiao Ni =E5=86=99=E9=81=93:
> > Hi Kuai
> >
> > There is a limitation of the memory in your test. But for most
> > situations, customers should not set this. Can this change introduce a
> > performance regression against other situations?
>
> Noted that this limitation is just to triggered writeback as soon as
> possible in the test, and it's 100% sure real situations can trigger
> dirty pages write back asynchronously and continue to produce new dirty
> pages.

Hi

I'm confused here. If we want to trigger write back quickly, it needs
to set these two values with a smaller number, rather than 0 and 60.
Right?
>
> If a lot of bio is not plugged, then it's the same as before; if a lot
> of bio is plugged, noted that before this patchset, these bio will spent
> quite a long time in plug, and hence I think performance should be
> better.

Hmm, it depends on if it's sequential or not? If it's a big io
request, can it miss the merge opportunity?

Regards
Xiao

>
> Thanks,
> Kuai
> >
> > Best Regards
> > Xiao
> >
> > On Wed, Apr 26, 2023 at 4:24=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> bio can be added to plug infinitely, and following writeback test can
> >> trigger huge amount of plugged bio:
> >>
> >> Test script:
> >> modprobe brd rd_nr=3D4 rd_size=3D10485760
> >> mdadm -CR /dev/md0 -l10 -n4 /dev/ram[0123] --assume-clean
> >> echo 0 > /proc/sys/vm/dirty_background_ratio
> >> echo 60 > /proc/sys/vm/dirty_ratio
> >> fio -filename=3D/dev/md0 -ioengine=3Dlibaio -rw=3Dwrite -bs=3D4k -numj=
obs=3D1 -iodepth=3D128 -name=3Dtest
> >>
> >> Test result:
> >> Monitor /sys/block/md0/inflight will found that inflight keep increasi=
ng
> >> until fio finish writing, after running for about 2 minutes:
> >>
> >> [root@fedora ~]# cat /sys/block/md0/inflight
> >>         0  4474191
> >>
> >> Fix the problem by limiting the number of plugged bio based on the num=
ber
> >> of copies for original bio.
> >>
> >> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> >> ---
> >>   drivers/md/raid1-10.c | 9 ++++++++-
> >>   drivers/md/raid1.c    | 2 +-
> >>   drivers/md/raid10.c   | 2 +-
> >>   3 files changed, 10 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> >> index 98d678b7df3f..35fb80aa37aa 100644
> >> --- a/drivers/md/raid1-10.c
> >> +++ b/drivers/md/raid1-10.c
> >> @@ -21,6 +21,7 @@
> >>   #define IO_MADE_GOOD ((struct bio *)2)
> >>
> >>   #define BIO_SPECIAL(bio) ((unsigned long)bio <=3D 2)
> >> +#define MAX_PLUG_BIO 32
> >>
> >>   /* for managing resync I/O pages */
> >>   struct resync_pages {
> >> @@ -31,6 +32,7 @@ struct resync_pages {
> >>   struct raid1_plug_cb {
> >>          struct blk_plug_cb      cb;
> >>          struct bio_list         pending;
> >> +       unsigned int            count;
> >>   };
> >>
> >>   static void rbio_pool_free(void *rbio, void *data)
> >> @@ -127,7 +129,7 @@ static inline void md_submit_write(struct bio *bio=
)
> >>   }
> >>
> >>   static inline bool md_add_bio_to_plug(struct mddev *mddev, struct bi=
o *bio,
> >> -                                     blk_plug_cb_fn unplug)
> >> +                                     blk_plug_cb_fn unplug, int copie=
s)
> >>   {
> >>          struct raid1_plug_cb *plug =3D NULL;
> >>          struct blk_plug_cb *cb;
> >> @@ -147,6 +149,11 @@ static inline bool md_add_bio_to_plug(struct mdde=
v *mddev, struct bio *bio,
> >>
> >>          plug =3D container_of(cb, struct raid1_plug_cb, cb);
> >>          bio_list_add(&plug->pending, bio);
> >> +       if (++plug->count / MAX_PLUG_BIO >=3D copies) {
> >> +               list_del(&cb->list);
> >> +               cb->callback(cb, false);
> >> +       }
> >> +
> >>
> >>          return true;
> >>   }
> >> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >> index 639e09cecf01..c6066408a913 100644
> >> --- a/drivers/md/raid1.c
> >> +++ b/drivers/md/raid1.c
> >> @@ -1562,7 +1562,7 @@ static void raid1_write_request(struct mddev *md=
dev, struct bio *bio,
> >>                                                r1_bio->sector);
> >>                  /* flush_pending_writes() needs access to the rdev so=
...*/
> >>                  mbio->bi_bdev =3D (void *)rdev;
> >> -               if (!md_add_bio_to_plug(mddev, mbio, raid1_unplug)) {
> >> +               if (!md_add_bio_to_plug(mddev, mbio, raid1_unplug, dis=
ks)) {
> >>                          spin_lock_irqsave(&conf->device_lock, flags);
> >>                          bio_list_add(&conf->pending_bio_list, mbio);
> >>                          spin_unlock_irqrestore(&conf->device_lock, fl=
ags);
> >> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> >> index bd9e655ca408..7135cfaf75db 100644
> >> --- a/drivers/md/raid10.c
> >> +++ b/drivers/md/raid10.c
> >> @@ -1306,7 +1306,7 @@ static void raid10_write_one_disk(struct mddev *=
mddev, struct r10bio *r10_bio,
> >>
> >>          atomic_inc(&r10_bio->remaining);
> >>
> >> -       if (!md_add_bio_to_plug(mddev, mbio, raid10_unplug)) {
> >> +       if (!md_add_bio_to_plug(mddev, mbio, raid10_unplug, conf->copi=
es)) {
> >>                  spin_lock_irqsave(&conf->device_lock, flags);
> >>                  bio_list_add(&conf->pending_bio_list, mbio);
> >>                  spin_unlock_irqrestore(&conf->device_lock, flags);
> >> --
> >> 2.39.2
> >>
> >
> > .
> >
>

