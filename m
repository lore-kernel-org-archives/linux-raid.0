Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105DAC4332F
	for <linux-raid@archiver.kernel.org>; Mon, 14 Nov 2022 23:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbiKNXT1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Nov 2022 18:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiKNXT0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Nov 2022 18:19:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0526610EF
        for <linux-raid@vger.kernel.org>; Mon, 14 Nov 2022 15:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668467914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nZ1TaavkAsvdEMrS8p1y/3gkPiaYQfjkmKGHv19QX2M=;
        b=Ahc3z+YaBZA9QXeoQy6eVjbEvx4cSlZ5zfxYjD7cK5zPGOMOy9AfHacIXIaHPpC4Z84Uht
        6c0kb4D94WZ9S31An6p36A4o42mmo6JTqiyZfBdxaxAOUHov9gBdjAhWITxTmV4lUCSEW2
        eZuIkV+GC7hHpmBA+R2MSG4rhvOgxVY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-588-2qoq-VQ3Ml2PjxeyJsNxYg-1; Mon, 14 Nov 2022 18:18:32 -0500
X-MC-Unique: 2qoq-VQ3Ml2PjxeyJsNxYg-1
Received: by mail-pj1-f69.google.com with SMTP id b1-20020a17090a10c100b0020da29fa5e5so6528244pje.2
        for <linux-raid@vger.kernel.org>; Mon, 14 Nov 2022 15:18:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nZ1TaavkAsvdEMrS8p1y/3gkPiaYQfjkmKGHv19QX2M=;
        b=pRrUnUXeTmkzEltU5gKh2SCtxWs5GLWgKfjMzN/YA60MnGViwSZV2V+yT2Ayh5FzGZ
         4NeATUXubzkM7wcU0Vs8wzqWSUtRXZg7TYBaZWz1B3uXw4sBT8xEd2YvzdonkL3yXIGx
         cSwWqqvqyFWLvHxxhGCZc9Q/YzjLs827RP7NgU1gsZ3jG6QbbUxiyZwZgT3aWiiL/YCM
         SSnp1Qg/RMnpTniwHCAg8EieGSJ7mqnbXAN5Yg9v6uldUZ5WfOlWzl0M5+GQ6skT5MkW
         5Vpwx56fRBaWAEl0TSek1PlYN8r6FiGaiCN3JukQR+ypHj2pVhu7mxH9VBt1bnoomqV+
         +92g==
X-Gm-Message-State: ANoB5pnTJq29bsV9h3BcUCXk+Ku8XntEI21+T4gEOwZKwR2cm5Epetjw
        3LNpDgyus76L1GGCV2ETshkiAvlK9aQ8LKN9UBigMiulzTbR4S02HzS4qF4kiZTZ+Ec/Igx81eu
        mU3REvcUg300N1U6LKdsZwaqQrHjCo7qEAylHAg==
X-Received: by 2002:a17:902:c142:b0:186:748e:9379 with SMTP id 2-20020a170902c14200b00186748e9379mr1465126plj.15.1668467910859;
        Mon, 14 Nov 2022 15:18:30 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6OFCYnIX251ENG0/zWPg4brZLYVRk1r2t3y41pYfBrml/RT8jMKFaytydpE8sPEEimaXmvNjFwODEfWrvC+zc=
X-Received: by 2002:a17:902:c142:b0:186:748e:9379 with SMTP id
 2-20020a170902c14200b00186748e9379mr1465094plj.15.1668467910528; Mon, 14 Nov
 2022 15:18:30 -0800 (PST)
MIME-Version: 1.0
References: <20221024064836.12731-1-xni@redhat.com> <CAPhsuW7-VaWT1SkuT-Tj_2jGgjso3NJ2hN6v8xUgdCHq3NON_g@mail.gmail.com>
In-Reply-To: <CAPhsuW7-VaWT1SkuT-Tj_2jGgjso3NJ2hN6v8xUgdCHq3NON_g@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 15 Nov 2022 07:18:19 +0800
Message-ID: <CALTww28dJes9MSw5S0bS+zqa6vLGsw1AMeqi5UKHwOkbgKMhQw@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] Add mddev->io_acct_cnt for raid0_quiesce
To:     Song Liu <song@kernel.org>
Cc:     guoqing.jiang@linux.dev, linux-raid@vger.kernel.org,
        ffan@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song

I'll do a performance test today and give the test result.

Regards
Xiao

On Tue, Nov 15, 2022 at 2:14 AM Song Liu <song@kernel.org> wrote:
>
> Hi Xiao,
>
> On Sun, Oct 23, 2022 at 11:48 PM Xiao Ni <xni@redhat.com> wrote:
> >
> > It has added io_acct_set for raid0/raid5 io accounting and it needs to
> > alloc md_io_acct in the i/o path. They are free when the bios come back
> > from member disks. Now we don't have a method to monitor if those bios
> > are all come back. In the takeover process, it needs to free the raid0
> > memory resource including the memory pool for md_io_acct. But maybe some
> > bios are still not returned. When those bios are returned, it can cause
> > panic bcause of introducing NULL pointer or invalid address.
> >
> > This patch adds io_acct_cnt. So when stopping raid0, it can use this
> > to wait until all bios come back.
>
> I am very sorry to bring this up late. Have you tested the performance
> impact of this change? I am afraid this may introduce some visible
> performance regression for very high speed arrays.
>
> Thanks,
> Song
>
>
> >
> > Reported-by: Fine Fan <ffan@redhat.com>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> > V2: Move struct mddev* to the start of struct mddev_io_acct
> >  drivers/md/md.c    | 13 ++++++++++++-
> >  drivers/md/md.h    | 11 ++++++++---
> >  drivers/md/raid0.c |  6 ++++++
> >  3 files changed, 26 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 6f3b2c1cb6cd..208f69849054 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -685,6 +685,7 @@ void mddev_init(struct mddev *mddev)
> >         atomic_set(&mddev->flush_pending, 0);
> >         init_waitqueue_head(&mddev->sb_wait);
> >         init_waitqueue_head(&mddev->recovery_wait);
> > +       init_waitqueue_head(&mddev->wait_io_acct);
> >         mddev->reshape_position = MaxSector;
> >         mddev->reshape_backwards = 0;
> >         mddev->last_sync_action = "none";
> > @@ -8618,15 +8619,18 @@ int acct_bioset_init(struct mddev *mddev)
> >  {
> >         int err = 0;
> >
> > -       if (!bioset_initialized(&mddev->io_acct_set))
> > +       if (!bioset_initialized(&mddev->io_acct_set)) {
> > +               atomic_set(&mddev->io_acct_cnt, 0);
> >                 err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
> >                         offsetof(struct md_io_acct, bio_clone), 0);
> > +       }
> >         return err;
> >  }
> >  EXPORT_SYMBOL_GPL(acct_bioset_init);
> >
> >  void acct_bioset_exit(struct mddev *mddev)
> >  {
> > +       WARN_ON(atomic_read(&mddev->io_acct_cnt) != 0);
> >         bioset_exit(&mddev->io_acct_set);
> >  }
> >  EXPORT_SYMBOL_GPL(acct_bioset_exit);
> > @@ -8635,12 +8639,17 @@ static void md_end_io_acct(struct bio *bio)
> >  {
> >         struct md_io_acct *md_io_acct = bio->bi_private;
> >         struct bio *orig_bio = md_io_acct->orig_bio;
> > +       struct mddev *mddev = md_io_acct->mddev;
> >
> >         orig_bio->bi_status = bio->bi_status;
> >
> >         bio_end_io_acct(orig_bio, md_io_acct->start_time);
> >         bio_put(bio);
> >         bio_endio(orig_bio);
> > +
> > +       if (atomic_dec_and_test(&mddev->io_acct_cnt))
> > +               if (unlikely(test_bit(MD_QUIESCE, &mddev->flags)))
> > +                       wake_up(&mddev->wait_io_acct);
> >  }
> >
> >  /*
> > @@ -8660,6 +8669,8 @@ void md_account_bio(struct mddev *mddev, struct bio **bio)
> >         md_io_acct = container_of(clone, struct md_io_acct, bio_clone);
> >         md_io_acct->orig_bio = *bio;
> >         md_io_acct->start_time = bio_start_io_acct(*bio);
> > +       md_io_acct->mddev = mddev;
> > +       atomic_inc(&mddev->io_acct_cnt);
> >
> >         clone->bi_end_io = md_end_io_acct;
> >         clone->bi_private = md_io_acct;
> > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > index b4e2d8b87b61..a7c89ed53be5 100644
> > --- a/drivers/md/md.h
> > +++ b/drivers/md/md.h
> > @@ -255,6 +255,7 @@ struct md_cluster_info;
> >   *                array is ready yet.
> >   * @MD_BROKEN: This is used to stop writes and mark array as failed.
> >   * @MD_DELETED: This device is being deleted
> > + * @MD_QUIESCE: This device is being quiesced. Now only raid0 use this flag
> >   *
> >   * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
> >   */
> > @@ -272,6 +273,7 @@ enum mddev_flags {
> >         MD_NOT_READY,
> >         MD_BROKEN,
> >         MD_DELETED,
> > +       MD_QUIESCE,
> >  };
> >
> >  enum mddev_sb_flags {
> > @@ -513,6 +515,8 @@ struct mddev {
> >                                                    * metadata and bitmap writes
> >                                                    */
> >         struct bio_set                  io_acct_set; /* for raid0 and raid5 io accounting */
> > +       atomic_t                        io_acct_cnt;
> > +       wait_queue_head_t               wait_io_acct;
> >
> >         /* Generic flush handling.
> >          * The last to finish preflush schedules a worker to submit
> > @@ -710,9 +714,10 @@ struct md_thread {
> >  };
> >
> >  struct md_io_acct {
> > -       struct bio *orig_bio;
> > -       unsigned long start_time;
> > -       struct bio bio_clone;
> > +       struct mddev    *mddev;
> > +       struct bio      *orig_bio;
> > +       unsigned long   start_time;
> > +       struct bio      bio_clone;
> >  };
> >
> >  #define THREAD_WAKEUP  0
> > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > index 857c49399c28..aced0ad8cdab 100644
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -754,6 +754,12 @@ static void *raid0_takeover(struct mddev *mddev)
> >
> >  static void raid0_quiesce(struct mddev *mddev, int quiesce)
> >  {
> > +       /* It doesn't use a separate struct to count how many bios are submitted
> > +        * to member disks to avoid memory alloc and performance decrease
> > +        */
> > +       set_bit(MD_QUIESCE, &mddev->flags);
> > +       wait_event(mddev->wait_io_acct, !atomic_read(&mddev->io_acct_cnt));
> > +       clear_bit(MD_QUIESCE, &mddev->flags);
> >  }
> >
> >  static struct md_personality raid0_personality=
> > --
> > 2.32.0 (Apple Git-132)
> >
>

