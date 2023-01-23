Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13C8C05027
	for <linux-raid@archiver.kernel.org>; Mon, 23 Jan 2023 23:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjAWXv5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 Jan 2023 18:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbjAWXv4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 23 Jan 2023 18:51:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D4530B15
        for <linux-raid@vger.kernel.org>; Mon, 23 Jan 2023 15:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674517868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mJ69GT4ESY0zhtYm4LVdoVH+NBbvjlOrUrtIwjX6Who=;
        b=aDD2OjNDNBMqLvY98+Wd/LwSXaxe8AdQjhDnpW3x3Yf40CKDi2dEskjFHVzglw6sLYj/Zh
        6+Lo1rKSUFpFkwrYmlXBxvroPuX0OLlmRzA1feh166DWo0wCd8OPQo/wNqH2j45iM+Qqj3
        GXA5KlE99A9kMsVvVvF4OWy0EtJ52Yk=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-426-y5ZT5nWGOPiAIp8KncSOhw-1; Mon, 23 Jan 2023 18:51:04 -0500
X-MC-Unique: y5ZT5nWGOPiAIp8KncSOhw-1
Received: by mail-pl1-f200.google.com with SMTP id p15-20020a170902a40f00b00192b2bbb7f8so8031280plq.14
        for <linux-raid@vger.kernel.org>; Mon, 23 Jan 2023 15:51:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mJ69GT4ESY0zhtYm4LVdoVH+NBbvjlOrUrtIwjX6Who=;
        b=An+P9lLIE/wmBbjLNPvMQsUPZezzP/Zu/X7KTlk8oKE3bpSSlkhtIPfn3PK2yTRosv
         c+xV1+WhwgDHrE9iceOQ0LuG53P60Xlon2tgt2AaOJRlQW2UZtFcpkDtWTZEEC4qebxQ
         IrJ6MVOarpLvOx1pNRbulKQbtD4h4xC+CyjBqBtvf9lsyE0LJOxQy/I6dIaHxVizpiHU
         BJvEyVLftcp3ZDzGoLTn4pOSzk9X9gydvAxhvmq7Onz5Kh5UdaOSOID890v6b9AR5P3d
         FN3bXgJtlmbo7oecmWCTKdzUldNJzZJiffWPaTe8ovDuAAf0ZUSOGvDGPEtA8OOaP+5p
         338g==
X-Gm-Message-State: AFqh2kpvXxJaFM2nvejfb+yYceakTnHGkgVpFInlyqcjbp0eyfaKYxUh
        8qNRSE3426/Gx7nvcrwTGxXNA1Gm7lEQ9cwxr9zn6BthjqKFBI8BZBUIewJdWNddvsacx9DgcF9
        FQPRgz8m+E2PMgg6OFMZijt5CcsHatdj55refCA==
X-Received: by 2002:a17:90b:202:b0:22b:b801:5da4 with SMTP id fy2-20020a17090b020200b0022bb8015da4mr1531324pjb.225.1674517862763;
        Mon, 23 Jan 2023 15:51:02 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsDgankBruq9iB9hWFYqzhy3FJUmcjEM1jdDOIkJv0oUEJsTYj3ptmo7y1vTfPIhgMnjZESAHeuNgvi67XPU2c=
X-Received: by 2002:a17:90b:202:b0:22b:b801:5da4 with SMTP id
 fy2-20020a17090b020200b0022bb8015da4mr1531319pjb.225.1674517862498; Mon, 23
 Jan 2023 15:51:02 -0800 (PST)
MIME-Version: 1.0
References: <20230121013937.97576-1-xni@redhat.com> <20230121013937.97576-3-xni@redhat.com>
 <96298b66-5c40-9615-c659-b89b0346d817@molgen.mpg.de>
In-Reply-To: <96298b66-5c40-9615-c659-b89b0346d817@molgen.mpg.de>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 24 Jan 2023 07:50:51 +0800
Message-ID: <CALTww2_jdNOw4AVreXw4uiYuB+-9u+y61d97T6YmGF_V3EAGsQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] md: Change active_io to percpu
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     song@kernel.org, linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jan 23, 2023 at 9:22 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Xiao,
>
>
> Am 21.01.23 um 02:39 schrieb Xiao Ni:
> > Now the type of active_io is atomic. It's used to count how many ios are
> > in the submitting process and it's added and decreased very time. But it
>
> s/very/every/
>
> > only needs to check if it's zero when suspending the raid. So we can
> > switch atomic to percpu to improve the performance.
> >
> > After switching active_io to percpu type, we use the state of active_io
> > to judge if the raid device is suspended. And we don't need to wake up
> > ->sb_wait in md_handle_request anymore. It's done in the callback function
> > which is registered when initing active_io. The argument mddev->suspended
> > is only used to count how many users are trying to set raid to suspend
> > state.
>
> How did you measure the performance impact?

Hi Paul

I used fio to do read/write/randread/randwrite tests on a raid0(nvme ssd hdd).
In my environment, there is no big change about the results.

Best Regards
Xiao
>
>
> Kind regards,
>
> Paul
>
>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/md.c | 40 ++++++++++++++++++++++++----------------
> >   drivers/md/md.h |  2 +-
> >   2 files changed, 25 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index d3627aad981a..04c067cf2f53 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -382,10 +382,7 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
> >
> >   static bool is_md_suspended(struct mddev *mddev)
> >   {
> > -     if (mddev->suspended)
> > -             return true;
> > -     else
> > -             return false;
> > +     return percpu_ref_is_dying(&mddev->active_io);
> >   }
> >   /* Rather than calling directly into the personality make_request function,
> >    * IO requests come here first so that we can check if the device is
> > @@ -412,7 +409,6 @@ static bool is_suspended(struct mddev *mddev, struct bio *bio)
> >   void md_handle_request(struct mddev *mddev, struct bio *bio)
> >   {
> >   check_suspended:
> > -     rcu_read_lock();
> >       if (is_suspended(mddev, bio)) {
> >               DEFINE_WAIT(__wait);
> >               /* Bail out if REQ_NOWAIT is set for the bio */
> > @@ -432,17 +428,15 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
> >               }
> >               finish_wait(&mddev->sb_wait, &__wait);
> >       }
> > -     atomic_inc(&mddev->active_io);
> > -     rcu_read_unlock();
> > +     if (!percpu_ref_tryget_live(&mddev->active_io))
> > +             goto check_suspended;
> >
> >       if (!mddev->pers->make_request(mddev, bio)) {
> > -             atomic_dec(&mddev->active_io);
> > -             wake_up(&mddev->sb_wait);
> > +             percpu_ref_put(&mddev->active_io);
> >               goto check_suspended;
> >       }
> >
> > -     if (atomic_dec_and_test(&mddev->active_io) && is_md_suspended(mddev))
> > -             wake_up(&mddev->sb_wait);
> > +     percpu_ref_put(&mddev->active_io);
> >   }
> >   EXPORT_SYMBOL(md_handle_request);
> >
> > @@ -488,11 +482,10 @@ void mddev_suspend(struct mddev *mddev)
> >       lockdep_assert_held(&mddev->reconfig_mutex);
> >       if (mddev->suspended++)
> >               return;
> > -     synchronize_rcu();
> >       wake_up(&mddev->sb_wait);
> >       set_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
> > -     smp_mb__after_atomic();
> > -     wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
> > +     percpu_ref_kill(&mddev->active_io);
> > +     wait_event(mddev->sb_wait, percpu_ref_is_zero(&mddev->active_io));
> >       mddev->pers->quiesce(mddev, 1);
> >       clear_bit_unlock(MD_ALLOW_SB_UPDATE, &mddev->flags);
> >       wait_event(mddev->sb_wait, !test_bit(MD_UPDATING_SB, &mddev->flags));
> > @@ -510,6 +503,7 @@ void mddev_resume(struct mddev *mddev)
> >       lockdep_assert_held(&mddev->reconfig_mutex);
> >       if (--mddev->suspended)
> >               return;
> > +     percpu_ref_resurrect(&mddev->active_io);
> >       wake_up(&mddev->sb_wait);
> >       mddev->pers->quiesce(mddev, 0);
> >
> > @@ -688,7 +682,6 @@ void mddev_init(struct mddev *mddev)
> >       timer_setup(&mddev->safemode_timer, md_safemode_timeout, 0);
> >       atomic_set(&mddev->active, 1);
> >       atomic_set(&mddev->openers, 0);
> > -     atomic_set(&mddev->active_io, 0);
> >       spin_lock_init(&mddev->lock);
> >       atomic_set(&mddev->flush_pending, 0);
> >       init_waitqueue_head(&mddev->sb_wait);
> > @@ -5765,6 +5758,12 @@ static void md_safemode_timeout(struct timer_list *t)
> >   }
> >
> >   static int start_dirty_degraded;
> > +static void active_io_release(struct percpu_ref *ref)
> > +{
> > +     struct mddev *mddev = container_of(ref, struct mddev, active_io);
> > +
> > +     wake_up(&mddev->sb_wait);
> > +}
> >
> >   int md_run(struct mddev *mddev)
> >   {
> > @@ -5845,10 +5844,15 @@ int md_run(struct mddev *mddev)
> >               nowait = nowait && bdev_nowait(rdev->bdev);
> >       }
> >
> > +     err = percpu_ref_init(&mddev->active_io, active_io_release,
> > +                             PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
> > +     if (err)
> > +             return err;
> > +
> >       if (!bioset_initialized(&mddev->bio_set)) {
> >               err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
> >               if (err)
> > -                     return err;
> > +                     goto exit_active_io;
> >       }
> >       if (!bioset_initialized(&mddev->sync_set)) {
> >               err = bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
> > @@ -6036,6 +6040,8 @@ int md_run(struct mddev *mddev)
> >       bioset_exit(&mddev->sync_set);
> >   exit_bio_set:
> >       bioset_exit(&mddev->bio_set);
> > +exit_active_io:
> > +     percpu_ref_exit(&mddev->active_io);
> >       return err;
> >   }
> >   EXPORT_SYMBOL_GPL(md_run);
> > @@ -6260,6 +6266,7 @@ void md_stop(struct mddev *mddev)
> >        */
> >       __md_stop_writes(mddev);
> >       __md_stop(mddev);
> > +     percpu_ref_exit(&mddev->active_io);
> >       bioset_exit(&mddev->bio_set);
> >       bioset_exit(&mddev->sync_set);
> >   }
> > @@ -7833,6 +7840,7 @@ static void md_free_disk(struct gendisk *disk)
> >       struct mddev *mddev = disk->private_data;
> >
> >       percpu_ref_exit(&mddev->writes_pending);
> > +     percpu_ref_exit(&mddev->active_io);
> >       bioset_exit(&mddev->bio_set);
> >       bioset_exit(&mddev->sync_set);
> >
> > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > index 554a9026669a..6335cb86e52e 100644
> > --- a/drivers/md/md.h
> > +++ b/drivers/md/md.h
> > @@ -315,7 +315,7 @@ struct mddev {
> >       unsigned long                   sb_flags;
> >
> >       int                             suspended;
> > -     atomic_t                        active_io;
> > +     struct percpu_ref               active_io;
> >       int                             ro;
> >       int                             sysfs_active; /* set when sysfs deletes
> >                                                      * are happening, so run/
>

