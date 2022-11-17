Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D26BEC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 17 Nov 2022 02:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbiKQCEI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 16 Nov 2022 21:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiKQCEF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 16 Nov 2022 21:04:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481B968C56
        for <linux-raid@vger.kernel.org>; Wed, 16 Nov 2022 18:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668650587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gPXkUvMETer0t8fF4J5e6kLMYI2ixOxHy4nNLDlDFLQ=;
        b=T3UWftOjw/BqSH+fAIPI5QQ7pNsxTfS5pjb1A9yTcDvdFJ2rImeZ9D8FffZ2oBgbiUXK/D
        HNimqSiKYIQB4yI2gPFetSizVweug7FG487f9yXRMckYeHATPfsZ3qhRSVfwPG3yKP3qrZ
        hRb7BJARaS3Zbv5oHpDPcsnkjn/vYTE=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-551-a1T1PwP0Pd6TH3dPcj130A-1; Wed, 16 Nov 2022 21:03:06 -0500
X-MC-Unique: a1T1PwP0Pd6TH3dPcj130A-1
Received: by mail-pf1-f198.google.com with SMTP id u18-20020a627912000000b0056d93d8b8bdso259397pfc.16
        for <linux-raid@vger.kernel.org>; Wed, 16 Nov 2022 18:03:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gPXkUvMETer0t8fF4J5e6kLMYI2ixOxHy4nNLDlDFLQ=;
        b=ba967p3MbuZbUU7lNysI+I4F5G0vwM4I6xYQyYfkdOBHuFyEX4ZMYNHgCSNZuayCh2
         C9ILKPb0JaDkhrJvxbcUec8aqHQ6xBsQGrIxe36JN/eHdYEeL8VYDgEXSrQpEddopYQE
         vx3u6fpRwOtuPpWC0ziLlMDZgAvojx3NWGupoyROwE+xfvgAkNAlTrS3TQNTQG0pBFMN
         Vq3GEa1zKlbovuCjkJPsxkn5toX4x7r06cntT1FlCyQR4nx8wEXKiDB7OElxjimdxfPt
         KsL6ohw3uHL4V0j2GPrUC90Gj9vbwrZT5ASmFXqX5knK9aIYwflLT0CHEAUF8UTOTBBs
         v0dA==
X-Gm-Message-State: ANoB5pmoGdwe0+gfTp0YhClOez+TK/sxXMZZd91/lO52fQm6cyH9QMDz
        BMAS9WynPqdioQoN1mQJtdpAtzLkXtv19xL3uG3bdde3TbODiZo85UsxnAYQh/s9nDsEvq5fanu
        Wn0rdbnZH7EMAJeW2uvs6K4/mAKzDP2KQc03YZg==
X-Received: by 2002:a17:90b:2309:b0:214:149b:cedd with SMTP id mt9-20020a17090b230900b00214149bceddmr555210pjb.143.1668650584056;
        Wed, 16 Nov 2022 18:03:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6FjPTFFXjHSfKur/um7jGT06FAdhp/gNJAbi22xB2s52FPACgXyWmVQVR0Gtfa09z3IWwXida3L6JpMZ2uBkk=
X-Received: by 2002:a17:90b:2309:b0:214:149b:cedd with SMTP id
 mt9-20020a17090b230900b00214149bceddmr555178pjb.143.1668650583650; Wed, 16
 Nov 2022 18:03:03 -0800 (PST)
MIME-Version: 1.0
References: <20221024064836.12731-1-xni@redhat.com> <CAPhsuW7-VaWT1SkuT-Tj_2jGgjso3NJ2hN6v8xUgdCHq3NON_g@mail.gmail.com>
 <CALTww28dJes9MSw5S0bS+zqa6vLGsw1AMeqi5UKHwOkbgKMhQw@mail.gmail.com>
In-Reply-To: <CALTww28dJes9MSw5S0bS+zqa6vLGsw1AMeqi5UKHwOkbgKMhQw@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 17 Nov 2022 10:02:52 +0800
Message-ID: <CALTww2_=vEpbCWHrVchYnoS=ohZUsVUr+6F=TERCQgBKNa=XYg@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] Add mddev->io_acct_cnt for raid0_quiesce
To:     Song Liu <song@kernel.org>
Cc:     guoqing.jiang@linux.dev, linux-raid@vger.kernel.org,
        ffan@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song

The performance is good.  Please check the result below.

And for the patch itself, do you think we should add a smp_mb
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4d0139cae8b5..3696e3825e27 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8650,9 +8650,11 @@ static void md_end_io_acct(struct bio *bio)
        bio_put(bio);
        bio_endio(orig_bio);

-       if (atomic_dec_and_test(&mddev->io_acct_cnt))
+       if (atomic_dec_and_test(&mddev->io_acct_cnt)) {
+               smp_mb();
                if (unlikely(test_bit(MD_QUIESCE, &mddev->flags)))
                        wake_up(&mddev->wait_io_acct);
+       }
 }

 /*
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 9d4831ca802c..1818f79bfdf7 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -757,6 +757,7 @@ static void raid0_quiesce(struct mddev *mddev, int quiesce)
         * to member disks to avoid memory alloc and performance decrease
         */
        set_bit(MD_QUIESCE, &mddev->flags);
+       smp_mb();
        wait_event(mddev->wait_io_acct, !atomic_read(&mddev->io_acct_cnt));
        clear_bit(MD_QUIESCE, &mddev->flags);
 }

Test result:

                          without patch    with patch
psync read          100MB/s           101MB/s         job:1 bs:4k
                           1015MB/s         1016MB/s       job:1 bs:128k
                           1359MB/s         1358MB/s       job:1 bs:256k
                           1394MB/s         1393MB/s       job:40 bs:4k
                           4959MB/s         4873MB/s       job:40 bs:128k
                           6166MB/s         6157MB/s       job:40 bs:256k

                          without patch      with patch
psync write          286MB/s           275MB/s        job:1 bs:4k
                            1810MB/s         1808MB/s      job:1 bs:128k
                            1814MB/s         1814MB/s      job:1 bs:256k
                            1802MB/s         1801MB/s      job:40 bs:4k
                            1814MB/s         1814MB/s      job:40 bs:128k
                            1814MB/s         1814MB/s      job:40 bs:256k

                          without patch
psync randread    39.3MB/s           39.7MB/s      job:1 bs:4k
                             791MB/s            783MB/s       job:1 bs:128k
                            1183MiB/s          1217MB/s     job:1 bs:256k
                            1183MiB/s          1235MB/s     job:40 bs:4k
                            3768MB/s          3705MB/s     job:40 bs:128k
                            4410MB/s           4418MB/s     job:40 bs:256k

                          without patch
psync randwrite.   281MB/s            272MB/s       job:1 bs:4k
                            1708MB/s           1706MB/s     job:1 bs:128k
                            1658MB/s           1644MB/s     job:1 bs:256k
                           1796MB/s            1796MB/s     job:40 bs:4k
                           1818MB/s            1818MB/s     job:40 bs:128k
                           1820MB/s            1820MB/s     job:40 bs:256k

depth:128         without patch       with patch
aio read             1294MB/s            1270MB/s      job:1 bs:4k depth:128
                          3956MB/s            4000MB/s     job:1
bs:128k depth:128
                          3955MB/s            4000MB/s     job:1
bs:256k depth:128

aio write            1255MB/s             1241MB/s       job:1 bs:4k depth:128
                         1813MB/s             1814MB/s       job:1
bs:128k depth:128
                         1814MB/s             1814MB/s       job:1
bs:256k depth:128

aio randread     1112MB/s             1117MB/s        job:1 bs:4k depth:128
                         3875MB/s             3975MB/s       job:1
bs:128k depth:128
                         4284MB/s             4407MB/s       job:1
bs:256k depth:128

aio randwrite    1080MB/s             1172MB/s       job:1 bs:4k depth:128
                        1814MB/s             1814MB/s       job:1
bs:128k depth:128
                        1816MB/s             1817MB/s       job:1
bs:256k depth:128

Best Regards
Xiao

On Tue, Nov 15, 2022 at 7:18 AM Xiao Ni <xni@redhat.com> wrote:
>
> Hi Song
>
> I'll do a performance test today and give the test result.
>
> Regards
> Xiao
>
> On Tue, Nov 15, 2022 at 2:14 AM Song Liu <song@kernel.org> wrote:
> >
> > Hi Xiao,
> >
> > On Sun, Oct 23, 2022 at 11:48 PM Xiao Ni <xni@redhat.com> wrote:
> > >
> > > It has added io_acct_set for raid0/raid5 io accounting and it needs to
> > > alloc md_io_acct in the i/o path. They are free when the bios come back
> > > from member disks. Now we don't have a method to monitor if those bios
> > > are all come back. In the takeover process, it needs to free the raid0
> > > memory resource including the memory pool for md_io_acct. But maybe some
> > > bios are still not returned. When those bios are returned, it can cause
> > > panic bcause of introducing NULL pointer or invalid address.
> > >
> > > This patch adds io_acct_cnt. So when stopping raid0, it can use this
> > > to wait until all bios come back.
> >
> > I am very sorry to bring this up late. Have you tested the performance
> > impact of this change? I am afraid this may introduce some visible
> > performance regression for very high speed arrays.
> >
> > Thanks,
> > Song
> >
> >
> > >
> > > Reported-by: Fine Fan <ffan@redhat.com>
> > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > ---
> > > V2: Move struct mddev* to the start of struct mddev_io_acct
> > >  drivers/md/md.c    | 13 ++++++++++++-
> > >  drivers/md/md.h    | 11 ++++++++---
> > >  drivers/md/raid0.c |  6 ++++++
> > >  3 files changed, 26 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index 6f3b2c1cb6cd..208f69849054 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -685,6 +685,7 @@ void mddev_init(struct mddev *mddev)
> > >         atomic_set(&mddev->flush_pending, 0);
> > >         init_waitqueue_head(&mddev->sb_wait);
> > >         init_waitqueue_head(&mddev->recovery_wait);
> > > +       init_waitqueue_head(&mddev->wait_io_acct);
> > >         mddev->reshape_position = MaxSector;
> > >         mddev->reshape_backwards = 0;
> > >         mddev->last_sync_action = "none";
> > > @@ -8618,15 +8619,18 @@ int acct_bioset_init(struct mddev *mddev)
> > >  {
> > >         int err = 0;
> > >
> > > -       if (!bioset_initialized(&mddev->io_acct_set))
> > > +       if (!bioset_initialized(&mddev->io_acct_set)) {
> > > +               atomic_set(&mddev->io_acct_cnt, 0);
> > >                 err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
> > >                         offsetof(struct md_io_acct, bio_clone), 0);
> > > +       }
> > >         return err;
> > >  }
> > >  EXPORT_SYMBOL_GPL(acct_bioset_init);
> > >
> > >  void acct_bioset_exit(struct mddev *mddev)
> > >  {
> > > +       WARN_ON(atomic_read(&mddev->io_acct_cnt) != 0);
> > >         bioset_exit(&mddev->io_acct_set);
> > >  }
> > >  EXPORT_SYMBOL_GPL(acct_bioset_exit);
> > > @@ -8635,12 +8639,17 @@ static void md_end_io_acct(struct bio *bio)
> > >  {
> > >         struct md_io_acct *md_io_acct = bio->bi_private;
> > >         struct bio *orig_bio = md_io_acct->orig_bio;
> > > +       struct mddev *mddev = md_io_acct->mddev;
> > >
> > >         orig_bio->bi_status = bio->bi_status;
> > >
> > >         bio_end_io_acct(orig_bio, md_io_acct->start_time);
> > >         bio_put(bio);
> > >         bio_endio(orig_bio);
> > > +
> > > +       if (atomic_dec_and_test(&mddev->io_acct_cnt))
> > > +               if (unlikely(test_bit(MD_QUIESCE, &mddev->flags)))
> > > +                       wake_up(&mddev->wait_io_acct);
> > >  }
> > >
> > >  /*
> > > @@ -8660,6 +8669,8 @@ void md_account_bio(struct mddev *mddev, struct bio **bio)
> > >         md_io_acct = container_of(clone, struct md_io_acct, bio_clone);
> > >         md_io_acct->orig_bio = *bio;
> > >         md_io_acct->start_time = bio_start_io_acct(*bio);
> > > +       md_io_acct->mddev = mddev;
> > > +       atomic_inc(&mddev->io_acct_cnt);
> > >
> > >         clone->bi_end_io = md_end_io_acct;
> > >         clone->bi_private = md_io_acct;
> > > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > > index b4e2d8b87b61..a7c89ed53be5 100644
> > > --- a/drivers/md/md.h
> > > +++ b/drivers/md/md.h
> > > @@ -255,6 +255,7 @@ struct md_cluster_info;
> > >   *                array is ready yet.
> > >   * @MD_BROKEN: This is used to stop writes and mark array as failed.
> > >   * @MD_DELETED: This device is being deleted
> > > + * @MD_QUIESCE: This device is being quiesced. Now only raid0 use this flag
> > >   *
> > >   * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
> > >   */
> > > @@ -272,6 +273,7 @@ enum mddev_flags {
> > >         MD_NOT_READY,
> > >         MD_BROKEN,
> > >         MD_DELETED,
> > > +       MD_QUIESCE,
> > >  };
> > >
> > >  enum mddev_sb_flags {
> > > @@ -513,6 +515,8 @@ struct mddev {
> > >                                                    * metadata and bitmap writes
> > >                                                    */
> > >         struct bio_set                  io_acct_set; /* for raid0 and raid5 io accounting */
> > > +       atomic_t                        io_acct_cnt;
> > > +       wait_queue_head_t               wait_io_acct;
> > >
> > >         /* Generic flush handling.
> > >          * The last to finish preflush schedules a worker to submit
> > > @@ -710,9 +714,10 @@ struct md_thread {
> > >  };
> > >
> > >  struct md_io_acct {
> > > -       struct bio *orig_bio;
> > > -       unsigned long start_time;
> > > -       struct bio bio_clone;
> > > +       struct mddev    *mddev;
> > > +       struct bio      *orig_bio;
> > > +       unsigned long   start_time;
> > > +       struct bio      bio_clone;
> > >  };
> > >
> > >  #define THREAD_WAKEUP  0
> > > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > > index 857c49399c28..aced0ad8cdab 100644
> > > --- a/drivers/md/raid0.c
> > > +++ b/drivers/md/raid0.c
> > > @@ -754,6 +754,12 @@ static void *raid0_takeover(struct mddev *mddev)
> > >
> > >  static void raid0_quiesce(struct mddev *mddev, int quiesce)
> > >  {
> > > +       /* It doesn't use a separate struct to count how many bios are submitted
> > > +        * to member disks to avoid memory alloc and performance decrease
> > > +        */
> > > +       set_bit(MD_QUIESCE, &mddev->flags);
> > > +       wait_event(mddev->wait_io_acct, !atomic_read(&mddev->io_acct_cnt));
> > > +       clear_bit(MD_QUIESCE, &mddev->flags);
> > >  }
> > >
> > >  static struct md_personality raid0_personality=
> > > --
> > > 2.32.0 (Apple Git-132)
> > >
> >

