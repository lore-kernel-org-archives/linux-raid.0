Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6970EC77B7A
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 15:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbjEaPZ0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 May 2023 11:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbjEaPYp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 May 2023 11:24:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF84019F
        for <linux-raid@vger.kernel.org>; Wed, 31 May 2023 08:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685546636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T7n2kTX8ab3RwNgUIAeH+MWr6FizMEgcp6aIosuEsmI=;
        b=MlAkuG40YscmkDf8gMc+6SS86Tl8yTmrLSOuYKnblcdtgIR4/U399PzeLEjDeZAwdJWGFZ
        2iKVrhtaIWY23fRPGvbAk+a96tuKuIgz/R3F2Jl/MmG2MzHk9+F28gcMtgFzqZIN5XWLp5
        FjRpkXi5Fy9LoycnEKFadGo55MafM3s=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-Rk-rMRF5PsiHYj4IhUCJPA-1; Wed, 31 May 2023 11:23:54 -0400
X-MC-Unique: Rk-rMRF5PsiHYj4IhUCJPA-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-518d6f87a47so2960666a12.3
        for <linux-raid@vger.kernel.org>; Wed, 31 May 2023 08:23:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685546633; x=1688138633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T7n2kTX8ab3RwNgUIAeH+MWr6FizMEgcp6aIosuEsmI=;
        b=aJjWYwPf+NoVVg8V0W4/XAZTZhAEOug45U9br7MA8LP1bHEdnewpr+T5Mbz+YRIQWD
         s7t+RXlxoDihOWrpfyTtxjv2RsbI1XYuQCJxe6ELvrd9lp9aQKNbKoIwRNYKZ9MF586K
         7LVgAyMT6eDYdfoI+GPN/l+48zRrbMsXJfLPx6OZKBJfG8RmpSzzAhrKiv4M9Y6K18Ym
         iM4iFmPVcDHHztW/B5nRJ+OVU1VXVdqzcL/nINM0YtigevGPZ9FXrlaiz/pRu5jDmohT
         oFeT6EvgMVw/gKH6u8Q+beVOqHmpuNi+luYy9Qw/4NT6J2PG9PYEqi+FzxOCZcFQJd/8
         G75A==
X-Gm-Message-State: AC+VfDx7iMXt3bS90QI9Fu4pezqT9aexxEJZjwzDiGrCCr80D4/5RE3z
        wJd4nO5+yMdWozeRw2UMbIOv7TMe99zJb3O5U7Ccl+H0wS/5ICBkaGiMQtm/mbtWKHzKQQD0bWl
        zBRyP3BrqgvjuhbS7bdtcWBZu6Ck1J+xuHtag0A==
X-Received: by 2002:a17:903:124a:b0:1ae:57d4:efbc with SMTP id u10-20020a170903124a00b001ae57d4efbcmr4941710plh.13.1685546633622;
        Wed, 31 May 2023 08:23:53 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7KV5Id3KIg954ARS3D8v/eQQuEVgWEGC5d1V4/aTuKB24ZhoY6EbtKcSOAgxi+gnUr5Oxq/oxCiya+H16FMls=
X-Received: by 2002:a17:903:124a:b0:1ae:57d4:efbc with SMTP id
 u10-20020a170903124a00b001ae57d4efbcmr4941694plh.13.1685546633258; Wed, 31
 May 2023 08:23:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230529131106.2123367-1-yukuai1@huaweicloud.com>
 <20230529131106.2123367-7-yukuai1@huaweicloud.com> <CALTww29ixKpcVknNe36D+x=2c1Aw-=z32SP-dJ_Hj8WxL2n4bg@mail.gmail.com>
 <830352e1-ecfa-f5dc-ce7c-349553bd3003@huaweicloud.com> <CALTww28_w3h1_viTp5L9SCytY7WmwmABqkXOmyvH_UD8T5odMg@mail.gmail.com>
 <f5cc14ed-e9d9-42ed-22e1-186973b991b1@huaweicloud.com>
In-Reply-To: <f5cc14ed-e9d9-42ed-22e1-186973b991b1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 31 May 2023 23:23:41 +0800
Message-ID: <CALTww2_8vcszjZF5emGHjcm+XngHptGV+i11TVs00o8E0fPWGw@mail.gmail.com>
Subject: Re: [PATCH -next v3 6/7] md/raid1-10: don't handle pluged bio by
 daemon thread
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     song@kernel.org, neilb@suse.de, akpm@osdl.org,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, May 31, 2023 at 4:06=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2023/05/31 16:00, Xiao Ni =E5=86=99=E9=81=93:
> > On Wed, May 31, 2023 at 3:55=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2023/05/31 15:50, Xiao Ni =E5=86=99=E9=81=93:
> >>> On Mon, May 29, 2023 at 9:14=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.=
com> wrote:
> >>>>
> >>>> From: Yu Kuai <yukuai3@huawei.com>
> >>>>
> >>>> current->bio_list will be set under submit_bio() context, in this ca=
se
> >>>> bitmap io will be added to the list and wait for current io submissi=
on to
> >>>> finish, while current io submission must wait for bitmap io to be do=
ne.
> >>>> commit 874807a83139 ("md/raid1{,0}: fix deadlock in bitmap_unplug.")=
 fix
> >>>> the deadlock by handling plugged bio by daemon thread.
> >>>
> >>> Thanks for the historic introduction. I did a test and printed the
> >>> logs in raid10_unplug. The tools I used are dd and mkfs. from_schedul=
e
> >>> is always true during I/O and it's 0 when io finishes. So I have a
> >>> question here, how can I trigger the condition that from_schedule is =
0
> >>> and current->list is not NULL? In other words, is there really a
> >>> deadlock here? Before your patch it looks like all bios are merged
> >>> into conf->pending_bio_list and are handled by raid10d. It can't
> >>> submit bio directly in the originating process which mentioned in
> >>> 57c67df48866
> >>>
> >> As I mentioned below, after commit a214b949d8e3, this deadlock doesn't
> >> exist anymore, and without this patch, patch 7 will introduce this
> >> scenario again.
> >>
> >> Thanks,
> >> Kuai
> >>>>
> >>>> On the one hand, the deadlock won't exist after commit a214b949d8e3
> >>>> ("blk-mq: only flush requests from the plug in blk_mq_submit_bio"). =
On
> >>>> the other hand, current solution makes it impossible to flush plugge=
d bio
> >>>> in raid1/10_make_request(), because this will cause that all the wri=
tes
> >>>> will goto daemon thread.
> >>>>
> >>>> In order to limit the number of plugged bio, commit 874807a83139
> >>>> ("md/raid1{,0}: fix deadlock in bitmap_unplug.") is reverted, and th=
e
> >>>> deadlock is fixed by handling bitmap io asynchronously.
> >>>>
> >>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> >>>> ---
> >>>>    drivers/md/raid1-10.c | 14 ++++++++++++++
> >>>>    drivers/md/raid1.c    |  4 ++--
> >>>>    drivers/md/raid10.c   |  8 +++-----
> >>>>    3 files changed, 19 insertions(+), 7 deletions(-)
> >>>>
> >>>> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> >>>> index 73cc3cb9154d..17e55c1fd5a1 100644
> >>>> --- a/drivers/md/raid1-10.c
> >>>> +++ b/drivers/md/raid1-10.c
> >>>> @@ -151,3 +151,17 @@ static inline bool raid1_add_bio_to_plug(struct=
 mddev *mddev, struct bio *bio,
> >>>>
> >>>>           return true;
> >>>>    }
> >>>> +
> >>>> +/*
> >>>> + * current->bio_list will be set under submit_bio() context, in thi=
s case bitmap
> >>>> + * io will be added to the list and wait for current io submission =
to finish,
> >>>> + * while current io submission must wait for bitmap io to be done. =
In order to
> >>>> + * avoid such deadlock, submit bitmap io asynchronously.
> >>>> + */
> >>>> +static inline void raid1_prepare_flush_writes(struct bitmap *bitmap=
)
> >>>> +{
> >>>> +       if (current->bio_list)
> >>>> +               md_bitmap_unplug_async(bitmap);
> >>>> +       else
> >>>> +               md_bitmap_unplug(bitmap);
> >>>> +}
> >>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >>>> index 0778e398584c..006620fed595 100644
> >>>> --- a/drivers/md/raid1.c
> >>>> +++ b/drivers/md/raid1.c
> >>>> @@ -794,7 +794,7 @@ static int read_balance(struct r1conf *conf, str=
uct r1bio *r1_bio, int *max_sect
> >>>>    static void flush_bio_list(struct r1conf *conf, struct bio *bio)
> >>>>    {
> >>>>           /* flush any pending bitmap writes to disk before proceedi=
ng w/ I/O */
> >>>> -       md_bitmap_unplug(conf->mddev->bitmap);
> >>>> +       raid1_prepare_flush_writes(conf->mddev->bitmap);
> >>>
> >>> If we unplug bitmap asynchronously, can we make sure the bitmap are
> >>> flushed before the corresponding data?
> >
> > Could you explain this question?
>
> Sorry that I missed this... See the new helper in patch 5,
> md_bitmap_unplug_async() will still wait for bitmap io to finish.
>
> md_bitmap_unplug_async
>   DECLARE_COMPLETION_ONSTACK(done)
>   ...
>   wait_for_completion(&done)

Ah I c. You use this way to avoid putting the bitmap io to
current->bio_list. Thanks for the explanation :)

Regards
Xiao
>
> Thanks,
> Kuai
> >
> > Regards
> > Xiao
> >
> >
> >>>
> >>> Regards
> >>> Xiao
> >>>
> >>>>           wake_up(&conf->wait_barrier);
> >>>>
> >>>>           while (bio) { /* submit pending writes */
> >>>> @@ -1166,7 +1166,7 @@ static void raid1_unplug(struct blk_plug_cb *c=
b, bool from_schedule)
> >>>>           struct r1conf *conf =3D mddev->private;
> >>>>           struct bio *bio;
> >>>>
> >>>> -       if (from_schedule || current->bio_list) {
> >>>> +       if (from_schedule) {
> >>>>                   spin_lock_irq(&conf->device_lock);
> >>>>                   bio_list_merge(&conf->pending_bio_list, &plug->pen=
ding);
> >>>>                   spin_unlock_irq(&conf->device_lock);
> >>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> >>>> index 6640507ecb0d..fb22cfe94d32 100644
> >>>> --- a/drivers/md/raid10.c
> >>>> +++ b/drivers/md/raid10.c
> >>>> @@ -902,9 +902,7 @@ static void flush_pending_writes(struct r10conf =
*conf)
> >>>>                   __set_current_state(TASK_RUNNING);
> >>>>
> >>>>                   blk_start_plug(&plug);
> >>>> -               /* flush any pending bitmap writes to disk
> >>>> -                * before proceeding w/ I/O */
> >>>> -               md_bitmap_unplug(conf->mddev->bitmap);
> >>>> +               raid1_prepare_flush_writes(conf->mddev->bitmap);
> >>>>                   wake_up(&conf->wait_barrier);
> >>>>
> >>>>                   while (bio) { /* submit pending writes */
> >>>> @@ -1108,7 +1106,7 @@ static void raid10_unplug(struct blk_plug_cb *=
cb, bool from_schedule)
> >>>>           struct r10conf *conf =3D mddev->private;
> >>>>           struct bio *bio;
> >>>>
> >>>> -       if (from_schedule || current->bio_list) {
> >>>> +       if (from_schedule) {
> >>>>                   spin_lock_irq(&conf->device_lock);
> >>>>                   bio_list_merge(&conf->pending_bio_list, &plug->pen=
ding);
> >>>>                   spin_unlock_irq(&conf->device_lock);
> >>>> @@ -1120,7 +1118,7 @@ static void raid10_unplug(struct blk_plug_cb *=
cb, bool from_schedule)
> >>>>
> >>>>           /* we aren't scheduling, so we can do the write-out direct=
ly. */
> >>>>           bio =3D bio_list_get(&plug->pending);
> >>>> -       md_bitmap_unplug(mddev->bitmap);
> >>>> +       raid1_prepare_flush_writes(mddev->bitmap);
> >>>>           wake_up(&conf->wait_barrier);
> >>>>
> >>>>           while (bio) { /* submit pending writes */
> >>>> --
> >>>> 2.39.2
> >>>>
> >>>
> >>> .
> >>>
> >>
> >
> > .
> >
>

