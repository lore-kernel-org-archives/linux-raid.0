Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A561AC0015E
	for <linux-raid@archiver.kernel.org>; Mon,  3 Jul 2023 12:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjGCMzd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 3 Jul 2023 08:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjGCMzc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 3 Jul 2023 08:55:32 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B88BB3
        for <linux-raid@vger.kernel.org>; Mon,  3 Jul 2023 05:55:30 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-51dff848168so2772587a12.2
        for <linux-raid@vger.kernel.org>; Mon, 03 Jul 2023 05:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1688388929; x=1690980929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sF0jADkyDi/XsopRr0l/IQVrEppSkrlD13NNlT22f4g=;
        b=cY7CS3ylTpxwIWSJ6Xvv2AFRTYpG4KmUlPBWmTcCe0KobNzDJjsGuuqP6AAIEaX/aC
         BTEEF3JHhtCFI92o3+smWlZpEt8+LTHk8CpIP08PtVMzdG0dsqL93oHsd5RaZEK9b9mr
         xPfpLaACrlcqICK/6+tpinL1YC3I5SvUn+qKEVOPfxcWbhjVShkqo+CPlgMbmWfZ9KoJ
         IOmR4W/oDVbJd4D5W/WpbhKa2XmdG3m/0nNhGRfAqPrffar/CtN1UrfFF9uD1Fz2j0NA
         zbpCtMh4Ugp2QbUHe5nRUrQOBNethGBcofSVlvztFBhOMDB527IETJCcB9uct1BlIZGv
         FUcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688388929; x=1690980929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sF0jADkyDi/XsopRr0l/IQVrEppSkrlD13NNlT22f4g=;
        b=axQqSYljwokMROdizrNoKtdXWPhv36lmpItQAwYeVW5t51t8m4kxWbkNGo1KZwDapH
         VOppNc8tyQ70upyldS6XFWwwFVeUk4IrL93u0shJAaL7CsxVJSufKBZKVDcby0ExaC5G
         hkNRuF+RVlCKWL2uGtx2XbriAVG4BlvomA/d1KStzpl6h7Y0RW+x0768786JqZ7AxL04
         opQ6bm3eWYtsBYjfWCfQyNPq4afAvwhwzxdrYLgypep6uYfY5i58M7+GtpT3YPTDS9/h
         rSceLINpVWoCOnU9tClkuVlcdaE9SyQAxRUaeiWYpB4z3DIhq7/dOAopMw4puSVpuvSu
         p21A==
X-Gm-Message-State: ABy/qLb3kYuzSMDyzZ3wsTPq+PIF8N06eoUlFxLjv7gfKFlwq9IU7kN9
        slgYKHSxTJBzoBqQu/8fZ7AD3wpHtCc+dv8VogzpPg==
X-Google-Smtp-Source: APBJJlE8260+zMpVTihgxrzA9S2BZL1eRtdIfjA/Ss3DPefJg0XvBzpuupBAP+TdftzbI5GvujpAUi+GP6W9bGEZrGo=
X-Received: by 2002:aa7:cd4c:0:b0:51d:982d:cb77 with SMTP id
 v12-20020aa7cd4c000000b0051d982dcb77mr7558859edw.33.1688388929122; Mon, 03
 Jul 2023 05:55:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230703080119.11464-1-jinpu.wang@ionos.com> <8f42de3a-4b31-949b-4a00-1537d42d76c0@huawei.com>
In-Reply-To: <8f42de3a-4b31-949b-4a00-1537d42d76c0@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 3 Jul 2023 14:55:17 +0200
Message-ID: <CAMGffEn8j+63MN34_Lc-xAOz_=QCWvtEFnz+vo6dh7tHsxP1Ng@mail.gmail.com>
Subject: Re: [PATCH] raid1: prevent unnecessary call to wake_up() in fast path
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     linux-raid@vger.kernel.org, song@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Kuai,

Thanks for your comment, see reply inline.

On Mon, Jul 3, 2023 at 2:35=E2=80=AFPM Yu Kuai <yukuai3@huawei.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2023/07/03 16:01, Jack Wang =E5=86=99=E9=81=93:
> > wake_up is called unconditionally in fast path such as make_request(),
> > which cause lock contention under high concurrency
> >      raid1_end_write_request
> >       wake_up
> >        __wake_up_common_lock
> >         spin_lock_irqsave
> >
> > Improve performance by only call wake_up() if waitqueue is not empty
> >
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
> > Test result with ramdisk raid1 on a EPYC:
> >
> >       Before this patch       With this patch
> >       READ    BW=3D4621MB/s     BW=3D7337MB/s
> >       WRITE   BW=3D1980MB/s     BW=3D1675MB/s
This was copy mistake, checked the raw output, with patch write BW is 3144M=
B/s.

will fix in next version.

will also adapt the subject with "md/raid1" prefix.


>
> This is weird, I don't understand how write can be worse.
> >
> > The patch is inspired by Yu Kuai's change for raid10:
> > https://lore.kernel.org/r/20230621105728.1268542-1-yukuai1@huaweicloud.=
com
> >
> > Cc: Yu Kuai <yukuai3@huawei.com>
> > Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> > ---
> >   drivers/md/raid1.c | 17 ++++++++++++-----
> >   1 file changed, 12 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index f834d99a36f6..808c91f338e6 100644
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
> > @@ -835,6 +841,7 @@ static void flush_pending_writes(struct r1conf *con=
f)
> >               spin_unlock_irq(&conf->device_lock);
> >   }
> >
> > +
>
> Please remove this new line.
> >   /* Barriers....
> >    * Sometimes we need to suspend IO while we do something else,
> >    * either some resync/recovery, or reconfigure the array.
> > @@ -970,7 +977,7 @@ static bool _wait_barrier(struct r1conf *conf, int =
idx, bool nowait)
> >        * In case freeze_array() is waiting for
> >        * get_unqueued_pending() =3D=3D extra
> >        */
> > -     wake_up(&conf->wait_barrier);
> > +     wake_up_barrier(conf);
>
> This is not fast path, this is only called when array is frozen or
> barrier is grabbed, and this is also called with 'resync_lock' held.

No, this one is call from
raid1_write_request->wait_barrier->_wait_barrier. and it can be seen
via perf.


> >       /* Wait for the barrier in same barrier unit bucket to drop. */
> >
> >       /* Return false when nowait flag is set */
> > @@ -1013,7 +1020,7 @@ static bool wait_read_barrier(struct r1conf *conf=
, sector_t sector_nr, bool nowa
> >        * In case freeze_array() is waiting for
> >        * get_unqueued_pending() =3D=3D extra
> >        */
> > -     wake_up(&conf->wait_barrier);
> > +     wake_up_barrier(conf);
>
> same above.
No, this one is call from raid1_read_request-> wait_read_barrier, it
can be seen via perf results.

> >       /* Wait for array to be unfrozen */
> >
> >       /* Return false when nowait flag is set */
> > @@ -1042,7 +1049,7 @@ static bool wait_barrier(struct r1conf *conf, sec=
tor_t sector_nr, bool nowait)
> >   static void _allow_barrier(struct r1conf *conf, int idx)
> >   {
> >       atomic_dec(&conf->nr_pending[idx]);
> > -     wake_up(&conf->wait_barrier);
> > +     wake_up_barrier(conf);
> >   }
> >
> >   static void allow_barrier(struct r1conf *conf, sector_t sector_nr)
> > @@ -1171,7 +1178,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, =
bool from_schedule)
> >               spin_lock_irq(&conf->device_lock);
> >               bio_list_merge(&conf->pending_bio_list, &plug->pending);
> >               spin_unlock_irq(&conf->device_lock);
> > -             wake_up(&conf->wait_barrier);
> > +             wake_up_barrier(conf);
> >               md_wakeup_thread(mddev->thread);
> >               kfree(plug);
> >               return;
> >
>
> And you missed raid1_write_request().
you meant this one:
1583         /* In case raid1d snuck in to freeze_array */
1584         wake_up(&conf->wait_barrier);
1585 }

perf result doesn't show it, I will add it too.

>
> Thanks,
> Kuai

Thx!
