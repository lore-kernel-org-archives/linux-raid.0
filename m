Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852E7EB64D9
	for <linux-raid@archiver.kernel.org>; Thu,  6 Jul 2023 06:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbjGFG3e (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 Jul 2023 02:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbjGFG3d (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 Jul 2023 02:29:33 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52894198B
        for <linux-raid@vger.kernel.org>; Wed,  5 Jul 2023 23:29:31 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-51d91e9b533so477862a12.3
        for <linux-raid@vger.kernel.org>; Wed, 05 Jul 2023 23:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1688624970; x=1691216970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMH4juEqgF2dJrQawY8p2bLhp9NLzp5jVniPZy0hfhQ=;
        b=goDRqOVaJoLOUdYDiNHtjmDre/5vQp0LyxmkrsrMPyGLu3+G8QyYZ/IimD+YMxRqfL
         7vMziWkKqq6bmvy1KGLrrpDLKPcZOMgkBHhyMGPek8gtDVyruQztrVl8Qaoqk1ArsXXf
         JZApADdDa1zuBi2dlkYfTl4UTis7D771wD60eGmgjLeRPxunm2MZIHOydzpKu5g9L0Bp
         vww3Q+CZ5uyhtjTYVyNGY6zzWGQCr7BqiwHVr2V312Awk/9BC4NmRF2llyAMPbXtp0SZ
         c/PBMFzeu0KDX9TcFSZZSV0k7fKaMdsXwYWUfo/IAA26/M94hNIw2nyUgVXSjZHDdDKI
         utuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688624970; x=1691216970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tMH4juEqgF2dJrQawY8p2bLhp9NLzp5jVniPZy0hfhQ=;
        b=LJHGhxCHg4kp2zDckd47Fnbh1T8NLCkFnh7t+zH5/z4zB+2/2yeeP3ORVPXzQVpTjh
         nGXsq9ZF8GNQ6H6H1RToV+Fg9+jRKByrmpvqpHUo3Ie3VNi2jAxDbLEtrad51s+l5iNH
         mxptq6m/0mDZ/osIqXFusmg57q8YZwqcIlrBufSCHbHptX/yIJFvbrqqY4sOAeEfHhuY
         6sZ23l0puIIxIQ5z1zbo7yEULKBKogTGkZ6m0Kh8mhiTBEShA2liAYFCqKs7FN0UEPuU
         rN/1q/uGA6aENn5NfQzxCZY3Eh0AtxfDLsy2GrlLSqYW2diPV517ytMikk5EMsCEeUQq
         9GQQ==
X-Gm-Message-State: ABy/qLY5MZcOJ9b7bG3HL79s7UdSt38uyvOb8umuxCRbaIbALUCaQHFX
        //dld/OQm8DdlVU3JU8TgRefYfGvmfx7bTyfeT3vnA==
X-Google-Smtp-Source: APBJJlEwsASN0cnA/UeF9t0jjR3qtjGooz8b5Q2MkPrXToPZMlZlj6Mxp4d+fqZffhqjtLc50+C77NTRMZqYf8wMQrM=
X-Received: by 2002:aa7:c2d4:0:b0:51e:eba:60ae with SMTP id
 m20-20020aa7c2d4000000b0051e0eba60aemr832640edp.12.1688624969857; Wed, 05 Jul
 2023 23:29:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230705113227.148494-1-jinpu.wang@ionos.com> <04cc9d64-1683-caac-35ff-9275af6ce508@huaweicloud.com>
In-Reply-To: <04cc9d64-1683-caac-35ff-9275af6ce508@huaweicloud.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 6 Jul 2023 08:29:18 +0200
Message-ID: <CAMGffEkQvaR_QqQf8qpb3OiECb1AmFF+0sFbU24zAOpHX6zrNw@mail.gmail.com>
Subject: Re: [PATCHv3] md/raid1: Avoid lock contention from wake_up()
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, song@kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jul 6, 2023 at 8:14=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> =E5=9C=A8 2023/07/05 19:32, Jack Wang =E5=86=99=E9=81=93:
> > wake_up is called unconditionally in a few paths such as make_request()=
,
> > which cause lock contention under high concurrency workload like below
> >      raid1_end_write_request
> >       wake_up
> >        __wake_up_common_lock
> >         spin_lock_irqsave
> >
> > Improve performance by only call wake_up() if waitqueue is not empty
> >
> LGTM
>
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Kuai,
Thank you very much for the review and suggestions!

>
> > Fio test script:
> >
> > [global]
> > name=3Drandom reads and writes
> > ioengine=3Dlibaio
> > direct=3D1
> > readwrite=3Drandrw
> > rwmixread=3D70
> > iodepth=3D64
> > buffered=3D0
> > filename=3D/dev/md0
> > size=3D1G
> > runtime=3D30
> > time_based
> > randrepeat=3D0
> > norandommap
> > refill_buffers
> > ramp_time=3D10
> > bs=3D4k
> > numjobs=3D400
> > group_reporting=3D1
> > [job1]
> >
> > Test result with 2 ramdisk in raid1 on a Intel Broadwell 56 cores serve=
r.
> >
> >       Before this patch       With this patch
> >       READ    BW=3D4621MB/s     BW=3D7337MB/s
> >       WRITE   BW=3D1980MB/s     BW=3D3144MB/s
> >
> > The patch is inspired by Yu Kuai's change for raid10:
> > https://lore.kernel.org/r/20230621105728.1268542-1-yukuai1@huaweicloud.=
com
> >
> > Cc: Yu Kuai <yukuai3@huawei.com>
> > Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> > ---
> > v3: rephrase the commit message, no code change.
> >
> > v2: addressed comments from Kuai
> > * Removed newline
> > * change the missing case in raid1_write_request
> > * I still kept the change for _wait_barrier and wait_read_barrier, as I=
 did
> >   performance tests without them there are still lock contention from
> >   __wake_up_common_lock
> >
> >   drivers/md/raid1.c | 18 ++++++++++++------
> >   1 file changed, 12 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index f834d99a36f6..0c76c36d8cb1 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -789,11 +789,17 @@ static int read_balance(struct r1conf *conf, stru=
ct r1bio *r1_bio, int *max_sect
> >       return best_disk;
> >   }
> >
> > +static void wake_up_barrier(struct r1conf *conf)
> > +{
> > +     if (wq_has_sleeper(&conf->wait_barrier))
> > +             wake_up(&conf->wait_barrier);
> > +}
> > +
> >   static void flush_bio_list(struct r1conf *conf, struct bio *bio)
> >   {
> >       /* flush any pending bitmap writes to disk before proceeding w/ I=
/O */
> >       raid1_prepare_flush_writes(conf->mddev->bitmap);
> > -     wake_up(&conf->wait_barrier);
> > +     wake_up_barrier(conf);
> >
> >       while (bio) { /* submit pending writes */
> >               struct bio *next =3D bio->bi_next;
> > @@ -970,7 +976,7 @@ static bool _wait_barrier(struct r1conf *conf, int =
idx, bool nowait)
> >        * In case freeze_array() is waiting for
> >        * get_unqueued_pending() =3D=3D extra
> >        */
> > -     wake_up(&conf->wait_barrier);
> > +     wake_up_barrier(conf);
> >       /* Wait for the barrier in same barrier unit bucket to drop. */
> >
> >       /* Return false when nowait flag is set */
> > @@ -1013,7 +1019,7 @@ static bool wait_read_barrier(struct r1conf *conf=
, sector_t sector_nr, bool nowa
> >        * In case freeze_array() is waiting for
> >        * get_unqueued_pending() =3D=3D extra
> >        */
> > -     wake_up(&conf->wait_barrier);
> > +     wake_up_barrier(conf);
> >       /* Wait for array to be unfrozen */
> >
> >       /* Return false when nowait flag is set */
> > @@ -1042,7 +1048,7 @@ static bool wait_barrier(struct r1conf *conf, sec=
tor_t sector_nr, bool nowait)
> >   static void _allow_barrier(struct r1conf *conf, int idx)
> >   {
> >       atomic_dec(&conf->nr_pending[idx]);
> > -     wake_up(&conf->wait_barrier);
> > +     wake_up_barrier(conf);
> >   }
> >
> >   static void allow_barrier(struct r1conf *conf, sector_t sector_nr)
> > @@ -1171,7 +1177,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, =
bool from_schedule)
> >               spin_lock_irq(&conf->device_lock);
> >               bio_list_merge(&conf->pending_bio_list, &plug->pending);
> >               spin_unlock_irq(&conf->device_lock);
> > -             wake_up(&conf->wait_barrier);
> > +             wake_up_barrier(conf);
> >               md_wakeup_thread(mddev->thread);
> >               kfree(plug);
> >               return;
> > @@ -1574,7 +1580,7 @@ static void raid1_write_request(struct mddev *mdd=
ev, struct bio *bio,
> >       r1_bio_write_done(r1_bio);
> >
> >       /* In case raid1d snuck in to freeze_array */
> > -     wake_up(&conf->wait_barrier);
> > +     wake_up_barrier(conf);
> >   }
> >
> >   static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
> >
>
