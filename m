Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F32CE7A89
	for <linux-raid@archiver.kernel.org>; Mon, 25 Sep 2023 07:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjIYHZB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Sep 2023 03:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjIYHZA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Sep 2023 03:25:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C232C0
        for <linux-raid@vger.kernel.org>; Mon, 25 Sep 2023 00:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695626649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rBYVDv59hkrAfmI0h5SRhnoDO8K6NGX5hpGfXWLtREA=;
        b=e9FeroFrdAbBkcz9aJ+sD8Atooyn74KFP5pjkLl9q+OST2sIn7o4yxmGT9xeU+oqpiBI+H
        yQQQJUyphIAdMQLyjl7bRxkZbtm9hPSVrOtackKxQUoKIHTcOEH4bTxKKcc9+nbLWPT9G0
        Oic/cSjEQsm6QllV1fVwJThlZgLDQXQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-mvVq3tfUPHiWHi3K7Z0CMA-1; Mon, 25 Sep 2023 03:24:07 -0400
X-MC-Unique: mvVq3tfUPHiWHi3K7Z0CMA-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-27731a5b94dso1804405a91.1
        for <linux-raid@vger.kernel.org>; Mon, 25 Sep 2023 00:24:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695626646; x=1696231446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rBYVDv59hkrAfmI0h5SRhnoDO8K6NGX5hpGfXWLtREA=;
        b=LIs01fZ4WHi/gSjenu1NvTkUVKJXk2GuDwm98JnHS3Qf9lsrfMV4Xfaqx1rNWnbtd2
         /5KBkma5TM0L6xsaR9Btl0Vw/3h3DxYylZ43XdvBJ6sN8JL6ZROAmPOo6N7Fmj1jVqfP
         6A7q33t2yioYWZMtfTGpLZRnDBhLlrfBhACmnnGLRvKGA0/2B1vaGWfZMo2/oHTJFDq1
         CwWVfLwFpbV3hg5WO+Mh7ukIcJ3m/uT252YWrLHrBTXacrKmKwqJBbCK1qE1FI44yu8D
         iTW9Qtqb8qBSefhEVt7Geh/gZP4qBmsvEqpZjDxxkJiNe36dgi1vrbAL7AV+JgcJf8/C
         NJfg==
X-Gm-Message-State: AOJu0YyAZ1WCkzyp61jrLYjMcFYabHPufWUTz2cPIU3zs3lnJtbuE+HM
        1ERsEPVPd8Dt72eybdfw4Qn8hr8ykYH+CX1glNkT4WkqQs/hn6ww9OkHYoSbR4Ld+C0WM74eic6
        /umlgxElLfQRIUq35IXZW6trrc8xgbD3auiI4nA==
X-Received: by 2002:a17:90a:bc8f:b0:274:6f67:e7a8 with SMTP id x15-20020a17090abc8f00b002746f67e7a8mr3492884pjr.45.1695626646541;
        Mon, 25 Sep 2023 00:24:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhzuwiDu+C3Qa+Azw1g/b0tA+ssVnU7jrLFt/a/nt4NNBzTQg2Ww8KFDbh0FHMsHITpWO2zDNu3lPYhux5+ss=
X-Received: by 2002:a17:90a:bc8f:b0:274:6f67:e7a8 with SMTP id
 x15-20020a17090abc8f00b002746f67e7a8mr3492869pjr.45.1695626646245; Mon, 25
 Sep 2023 00:24:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
 <20230828020021.2489641-4-yukuai1@huaweicloud.com> <CALTww2-5F=C5N6YZ-3weD9xSWhpT6Mx8NkaevfXZWqR6=Bwc4A@mail.gmail.com>
In-Reply-To: <CALTww2-5F=C5N6YZ-3weD9xSWhpT6Mx8NkaevfXZWqR6=Bwc4A@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 25 Sep 2023 15:23:54 +0800
Message-ID: <CALTww2_VHCihAYBj39abNCO+M+HuHybnzVh6T_jf25NiBBLZ-g@mail.gmail.com>
Subject: Re: [PATCH -next v2 03/28] md: add new helpers to suspend/resume array
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
        song@kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, yukuai3@huawei.com,
        yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Sep 25, 2023 at 3:21=E2=80=AFPM Xiao Ni <xni@redhat.com> wrote:
>
> On Mon, Aug 28, 2023 at 10:04=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com=
> wrote:
> >
> > From: Yu Kuai <yukuai3@huawei.com>
> >
> > Advantages for new apis:
> >  - reconfig_mutex is not required;
> >  - the weird logical that suspend array hold 'reconfig_mutex' for
> >    mddev_check_recovery() to update superblock is not needed;
> >  - the specail handling, 'pers->prepare_suspend', for raid456 is not
> >    needed;
> >  - It's safe to be called at any time once mddev is allocated, and it's
> >    designed to be used from slow path where array configuration is chan=
ged;
> >
> > Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> > ---
> >  drivers/md/md.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++--
> >  drivers/md/md.h |  3 ++
> >  2 files changed, 86 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 7fa311a14317..6236e2e395c1 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -443,12 +443,22 @@ void mddev_suspend(struct mddev *mddev)
> >                         lockdep_is_held(&mddev->reconfig_mutex));
> >
> >         WARN_ON_ONCE(thread && current =3D=3D thread->tsk);
> > -       if (mddev->suspended++)
> > +
> > +       /* can't concurrent with __mddev_suspend() and __mddev_resume()=
 */
> > +       mutex_lock(&mddev->suspend_mutex);
> > +       if (mddev->suspended++) {
> > +               mutex_unlock(&mddev->suspend_mutex);
> >                 return;
> > +       }
> > +
> >         wake_up(&mddev->sb_wait);
> >         set_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
> >         percpu_ref_kill(&mddev->active_io);
> >
> > +       /*
> > +        * TODO: cleanup 'pers->prepare_suspend after all callers are r=
eplaced
> > +        * by __mddev_suspend().
> > +        */
> >         if (mddev->pers && mddev->pers->prepare_suspend)
> >                 mddev->pers->prepare_suspend(mddev);
> >
> > @@ -459,14 +469,21 @@ void mddev_suspend(struct mddev *mddev)
> >         del_timer_sync(&mddev->safemode_timer);
> >         /* restrict memory reclaim I/O during raid array is suspend */
> >         mddev->noio_flag =3D memalloc_noio_save();
> > +
> > +       mutex_unlock(&mddev->suspend_mutex);
> >  }
> >  EXPORT_SYMBOL_GPL(mddev_suspend);
> >
> >  void mddev_resume(struct mddev *mddev)
> >  {
> >         lockdep_assert_held(&mddev->reconfig_mutex);
> > -       if (--mddev->suspended)
> > +
> > +       /* can't concurrent with __mddev_suspend() and __mddev_resume()=
 */
> > +       mutex_lock(&mddev->suspend_mutex);
> > +       if (--mddev->suspended) {
> > +               mutex_unlock(&mddev->suspend_mutex);
> >                 return;
> > +       }
> >
> >         /* entred the memalloc scope from mddev_suspend() */
> >         memalloc_noio_restore(mddev->noio_flag);
> > @@ -477,9 +494,72 @@ void mddev_resume(struct mddev *mddev)
> >         set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> >         md_wakeup_thread(mddev->thread);
> >         md_wakeup_thread(mddev->sync_thread); /* possibly kick off a re=
shape */
> > +
> > +       mutex_unlock(&mddev->suspend_mutex);
> >  }
> >  EXPORT_SYMBOL_GPL(mddev_resume);
> >
> > +void __mddev_suspend(struct mddev *mddev)
> > +{
> > +
> > +       /*
> > +        * hold reconfig_mutex to wait for normal io will deadlock, bec=
ause
> > +        * other context can't update super_block, and normal io can re=
ly on
> > +        * updating super_block.
> > +        */
> > +       lockdep_assert_not_held(&mddev->reconfig_mutex);
> > +
> > +       mutex_lock(&mddev->suspend_mutex);
> > +
> > +       if (mddev->suspended) {
> > +               WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
> > +               mutex_unlock(&mddev->suspend_mutex);
> > +               return;
> > +       }
> > +
> > +       percpu_ref_kill(&mddev->active_io);
> > +       wait_event(mddev->sb_wait, percpu_ref_is_zero(&mddev->active_io=
));
> > +
> > +       /*
> > +        * For raid456, io might be waiting for reshape to make progres=
s,
> > +        * allow new reshape to start while waiting for io to be done t=
o
> > +        * prevent deadlock.
> > +        */
> > +       WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
>
> It changes the order of setting suspended and checking active_io.
> suspended is used to stop I/O. Now it checks active_io first and then
> adds suspended, if the i/o doesn't stop, it looks like active_io can't
> be 0. So it will stuck at waiting active_io to be 0?

Ah, I c, you add the state of active_io to judge if a raid is suspended.

Regards
Xiao
>
> Best Regards
> Xiao
>
> > +
> > +       del_timer_sync(&mddev->safemode_timer);
> > +       /* restrict memory reclaim I/O during raid array is suspend */
> > +       mddev->noio_flag =3D memalloc_noio_save();
> > +
> > +       mutex_unlock(&mddev->suspend_mutex);
> > +}
> > +EXPORT_SYMBOL_GPL(__mddev_suspend);
> > +
> > +void __mddev_resume(struct mddev *mddev)
> > +{
> > +       lockdep_assert_not_held(&mddev->reconfig_mutex);
> > +
> > +       mutex_lock(&mddev->suspend_mutex);
> > +       WRITE_ONCE(mddev->suspended, mddev->suspended - 1);
> > +       if (mddev->suspended) {
> > +               mutex_unlock(&mddev->suspend_mutex);
> > +               return;
> > +       }
> > +
> > +       /* entred the memalloc scope from __mddev_suspend() */
> > +       memalloc_noio_restore(mddev->noio_flag);
> > +
> > +       percpu_ref_resurrect(&mddev->active_io);
> > +       wake_up(&mddev->sb_wait);
> > +
> > +       set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > +       md_wakeup_thread(mddev->thread);
> > +       md_wakeup_thread(mddev->sync_thread); /* possibly kick off a re=
shape */
> > +
> > +       mutex_unlock(&mddev->suspend_mutex);
> > +}
> > +EXPORT_SYMBOL_GPL(__mddev_resume);
> > +
> >  /*
> >   * Generic flush handling for md
> >   */
> > @@ -667,6 +747,7 @@ int mddev_init(struct mddev *mddev)
> >         mutex_init(&mddev->open_mutex);
> >         mutex_init(&mddev->reconfig_mutex);
> >         mutex_init(&mddev->sync_mutex);
> > +       mutex_init(&mddev->suspend_mutex);
> >         mutex_init(&mddev->bitmap_info.mutex);
> >         INIT_LIST_HEAD(&mddev->disks);
> >         INIT_LIST_HEAD(&mddev->all_mddevs);
> > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > index fb3b123f16dd..1103e6b08ad9 100644
> > --- a/drivers/md/md.h
> > +++ b/drivers/md/md.h
> > @@ -316,6 +316,7 @@ struct mddev {
> >         unsigned long                   sb_flags;
> >
> >         int                             suspended;
> > +       struct mutex                    suspend_mutex;
> >         struct percpu_ref               active_io;
> >         int                             ro;
> >         int                             sysfs_active; /* set when sysfs=
 deletes
> > @@ -811,6 +812,8 @@ extern void md_rdev_clear(struct md_rdev *rdev);
> >  extern void md_handle_request(struct mddev *mddev, struct bio *bio);
> >  extern void mddev_suspend(struct mddev *mddev);
> >  extern void mddev_resume(struct mddev *mddev);
> > +extern void __mddev_suspend(struct mddev *mddev);
> > +extern void __mddev_resume(struct mddev *mddev);
> >
> >  extern void md_reload_sb(struct mddev *mddev, int raid_disk);
> >  extern void md_update_sb(struct mddev *mddev, int force);
> > --
> > 2.39.2
> >

