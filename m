Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D13B3C7EE2F
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 15:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234390AbjEaPVa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 May 2023 11:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233666AbjEaPU5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 May 2023 11:20:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A6F107
        for <linux-raid@vger.kernel.org>; Wed, 31 May 2023 08:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685546409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZnX9Gnk7ZK6e1v97vSi/RZM3h6QLWe89mhnvVr8zu8c=;
        b=KwILjF2kxlsdKHM7Ho7agdDylyJ59DjN/vldhZW2dCM1DUlMvzmN27CV3bepNfTOKH5AN/
        wtB/zAm8ucEbWphzjvdpgkrqCwKKJnKTbJS3Z5Gp4jF7rS1CAth2rpkmS4JUDVaPh8BVmk
        zai36xendXGvnrprUrkz40mrDB/0HpU=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-lWm_QLs8P9ykE6IecIv8XQ-1; Wed, 31 May 2023 11:20:06 -0400
X-MC-Unique: lWm_QLs8P9ykE6IecIv8XQ-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1b0427acfc3so19109575ad.0
        for <linux-raid@vger.kernel.org>; Wed, 31 May 2023 08:20:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685546404; x=1688138404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZnX9Gnk7ZK6e1v97vSi/RZM3h6QLWe89mhnvVr8zu8c=;
        b=TVHIt5pbTghY7HNJIJhn0rL/HVkF0gRvh6EyDso0OlmS12dLRJ73i7Lrf4L7eCKWTY
         hG0hkb0APLCLO/8fPdEPy1emdTviP0unAiO0BC/X+0NtTEfgmesepAiTebblkQbJQs+E
         ZzTmPUyDffDRY2z8NVRX8NzEEcryszEoB60f99t/T4rGvNQNQoYaJopP5sHG12azArpY
         fWFjeNsdKqMB77qYsGAu0KtaJeTtMvjac2q2hQAtuyZpqQCq3/jcfh+mKMTyzCsYtZ9j
         ZqxIvI1sNNB6rXAuiWup1mvuWiJZWoj6CjXOK5OCiQ77TdauUDv5ycaBp1u7CPUi8iHH
         bZHw==
X-Gm-Message-State: AC+VfDznvLweKwvqQsTVpcMa/I7MZcGfJPxVQzFg4dqLRKX6cKcWBgo3
        nGh3aFeMnR41OCtW1GPRLU+Iy96LzKM+f29E4YvT3EJDBmXhATrvOBTViZeP5NSpUhyKQDvRFz0
        5rkmYiuk0wtpdNHj857XmwyzpB+0Cg2Bk3L7LiA==
X-Received: by 2002:a17:903:2310:b0:1ae:2013:4bc8 with SMTP id d16-20020a170903231000b001ae20134bc8mr5684781plh.18.1685546404683;
        Wed, 31 May 2023 08:20:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7z6W4n3IIHMxGNSSbs8RTtLgv6LU01UODycwCecNrFbNGE+C3sDnb7JOju+XBBRAtFZo/8V9bVOZfQ5Ozzl5Y=
X-Received: by 2002:a17:903:2310:b0:1ae:2013:4bc8 with SMTP id
 d16-20020a170903231000b001ae20134bc8mr5684759plh.18.1685546404368; Wed, 31
 May 2023 08:20:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230529131106.2123367-1-yukuai1@huaweicloud.com>
 <20230529131106.2123367-5-yukuai1@huaweicloud.com> <CALTww2-mOkQR+Qu0s=TE-TFoR7D0tDaA=gOOJ75r-Z_43X1yEg@mail.gmail.com>
 <0f01b4dc-8eea-f3e9-43a4-c33084fa72a1@huaweicloud.com>
In-Reply-To: <0f01b4dc-8eea-f3e9-43a4-c33084fa72a1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 31 May 2023 23:19:53 +0800
Message-ID: <CALTww29QrNLbKLp6F6d9cx2Abk3y9NT1UmBVgaDM20CTisGHDA@mail.gmail.com>
Subject: Re: [PATCH -next v3 4/7] md/raid1-10: submit write io directly if
 bitmap is not enabled
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

On Wed, May 31, 2023 at 4:25=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2023/05/31 15:26, Xiao Ni =E5=86=99=E9=81=93:
> > On Mon, May 29, 2023 at 9:14=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> Commit 6cce3b23f6f8 ("[PATCH] md: write intent bitmap support for raid=
10")
> >> add bitmap support, and it changed that write io is submitted through
> >> daemon thread because bitmap need to be updated before write io. And
> >> later, plug is used to fix performance regression because all the writ=
e io
> >> will go to demon thread, which means io can't be issued concurrently.
> >>
> >> However, if bitmap is not enabled, the write io should not go to daemo=
n
> >> thread in the first place, and plug is not needed as well.
> >>
> >> Fixes: 6cce3b23f6f8 ("[PATCH] md: write intent bitmap support for raid=
10")
> >> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> >> ---
> >>   drivers/md/md-bitmap.c |  4 +---
> >>   drivers/md/md-bitmap.h |  7 +++++++
> >>   drivers/md/raid1-10.c  | 13 +++++++++++--
> >>   3 files changed, 19 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> >> index ad5a3456cd8a..3ee590cf12a7 100644
> >> --- a/drivers/md/md-bitmap.c
> >> +++ b/drivers/md/md-bitmap.c
> >> @@ -1016,7 +1016,6 @@ static int md_bitmap_file_test_bit(struct bitmap=
 *bitmap, sector_t block)
> >>          return set;
> >>   }
> >>
> >> -
> >>   /* this gets called when the md device is ready to unplug its underl=
ying
> >>    * (slave) device queues -- before we let any writes go down, we nee=
d to
> >>    * sync the dirty pages of the bitmap file to disk */
> >> @@ -1026,8 +1025,7 @@ void md_bitmap_unplug(struct bitmap *bitmap)
> >>          int dirty, need_write;
> >>          int writing =3D 0;
> >>
> >> -       if (!bitmap || !bitmap->storage.filemap ||
> >> -           test_bit(BITMAP_STALE, &bitmap->flags))
> >> +       if (!md_bitmap_enabled(bitmap))
> >>                  return;
> >>
> >>          /* look at each page to see if there are any set bits that ne=
ed to be
> >> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> >> index cfd7395de8fd..3a4750952b3a 100644
> >> --- a/drivers/md/md-bitmap.h
> >> +++ b/drivers/md/md-bitmap.h
> >> @@ -273,6 +273,13 @@ int md_bitmap_copy_from_slot(struct mddev *mddev,=
 int slot,
> >>                               sector_t *lo, sector_t *hi, bool clear_b=
its);
> >>   void md_bitmap_free(struct bitmap *bitmap);
> >>   void md_bitmap_wait_behind_writes(struct mddev *mddev);
> >> +
> >> +static inline bool md_bitmap_enabled(struct bitmap *bitmap)
> >> +{
> >> +       return bitmap && bitmap->storage.filemap &&
> >> +              !test_bit(BITMAP_STALE, &bitmap->flags);
> >> +}
> >> +
> >>   #endif
> >>
> >>   #endif
> >> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> >> index 506299bd55cb..73cc3cb9154d 100644
> >> --- a/drivers/md/raid1-10.c
> >> +++ b/drivers/md/raid1-10.c
> >> @@ -131,9 +131,18 @@ static inline bool raid1_add_bio_to_plug(struct m=
ddev *mddev, struct bio *bio,
> >>                                        blk_plug_cb_fn unplug)
> >>   {
> >>          struct raid1_plug_cb *plug =3D NULL;
> >> -       struct blk_plug_cb *cb =3D blk_check_plugged(unplug, mddev,
> >> -                                                  sizeof(*plug));
> >> +       struct blk_plug_cb *cb;
> >> +
> >> +       /*
> >> +        * If bitmap is not enabled, it's safe to submit the io direct=
ly, and
> >> +        * this can get optimal performance.
> >> +        */
> >> +       if (!md_bitmap_enabled(mddev->bitmap)) {
> >> +               raid1_submit_write(bio);
> >> +               return true;
> >> +       }
> >
> > Can we check this out of raid1_add_bio_to_plug and call
> > raid1_submit_write directly in make_request function?
>
> Of course we can, I'm trying to avoid redundant code here...

I know. But it doesn't fit the name of the function.

Regards
Xiao
>
> Thanks,
> Kuai
> >
> > Regards
> > Xiao
> >>
> >> +       cb =3D blk_check_plugged(unplug, mddev, sizeof(*plug));
> >>          if (!cb)
> >>                  return false;
> >>
> >> --
> >> 2.39.2
> >>
> >
> > .
> >
>

