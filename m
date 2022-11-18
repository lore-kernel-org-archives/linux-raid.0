Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E57C433FE
	for <linux-raid@archiver.kernel.org>; Fri, 18 Nov 2022 04:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbiKREZa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Nov 2022 23:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbiKREZ2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 17 Nov 2022 23:25:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60487C00A
        for <linux-raid@vger.kernel.org>; Thu, 17 Nov 2022 20:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668745472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sHn01Ezf0jcMwTytCl72IuHDbDx1bK1iL65g3G1+LJ8=;
        b=AkB4+ukCaVmATCRCmABt3KnaCf//jUUM7CVFXXCW9v2WkLs2h4iVF+HhIaY8TXRvoCwLLZ
        QkzHsBw6xUXuxKwEHEBk7UBcsu9k+k6cive2eDUSbmLkbqRj0udHQxfA8TxifUB6NdRrv8
        mL5ptublVaAGZrWF1IKWllPGXDdlxdk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-403-qNZKC5GQP8iq0cZDwZ9u-w-1; Thu, 17 Nov 2022 23:24:31 -0500
X-MC-Unique: qNZKC5GQP8iq0cZDwZ9u-w-1
Received: by mail-pl1-f198.google.com with SMTP id h16-20020a170902f55000b001871b770a83so2892769plf.9
        for <linux-raid@vger.kernel.org>; Thu, 17 Nov 2022 20:24:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sHn01Ezf0jcMwTytCl72IuHDbDx1bK1iL65g3G1+LJ8=;
        b=3dKRRCY87X90OilIUgpQjrIuBuabSTTRrczpBpFrwNgNRSPdnTMXmkJlAVN9C2oQcU
         ewrJzFJ4b+T9ikgSKY9S0xuE/1cBYe/tkO43P8XyaSXv3ltItfYufjO1Vm6zpE41ZWn5
         nXaG62IC5d+AVWWkZ+0TajuRszmAQHN8Fwezi57qtZBH1OKSte0UlzisxT8dBNCrLZ5i
         CxmOLOwz8i6AExyFytXTZ2DcWHOr4zOq5oZQPtHttPTbprjGV7aojEt/tLt9Qj/9ikDY
         l86n9zuui9PM/so2Jmp+2sHbP3W73NVaaa1NiyzxQbHC2fndOZfpVx4s4+igyD10+IbQ
         TELg==
X-Gm-Message-State: ANoB5plwsrUTdSb6uhiKqrhq1NKmrHg3+HhZQZNiBiRYWhJ+zAYqoZVI
        EhLk3mwjxx57lgkUugVtLPoxYkjGw7McIsM+Faa7YTcWTHCT3ythQEdk8WDr2AzeH/vSjZnyPnl
        RD2skqMtMEnJ+7a4OKGS2hqyUzGNe2AcJtM4Czw==
X-Received: by 2002:a17:90b:3106:b0:218:838f:a33 with SMTP id gc6-20020a17090b310600b00218838f0a33mr2152170pjb.225.1668745470305;
        Thu, 17 Nov 2022 20:24:30 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7Oyzosz6TH9WC+2+s4vkqcCdc5cQYB0Ekjmozx1EYkZ9LeyTosdoMjFPA2Lch5Stf1oRvCSgOZJ7LhoKARsFg=
X-Received: by 2002:a17:90b:3106:b0:218:838f:a33 with SMTP id
 gc6-20020a17090b310600b00218838f0a33mr2152158pjb.225.1668745470007; Thu, 17
 Nov 2022 20:24:30 -0800 (PST)
MIME-Version: 1.0
References: <20221024064836.12731-1-xni@redhat.com> <CAPhsuW7-VaWT1SkuT-Tj_2jGgjso3NJ2hN6v8xUgdCHq3NON_g@mail.gmail.com>
 <CALTww28dJes9MSw5S0bS+zqa6vLGsw1AMeqi5UKHwOkbgKMhQw@mail.gmail.com>
 <CALTww2_=vEpbCWHrVchYnoS=ohZUsVUr+6F=TERCQgBKNa=XYg@mail.gmail.com>
 <CAPhsuW4rkLtYaPQbXPsQn+5kEFNzACYhM4UaAS+sKU1AHurRzw@mail.gmail.com>
 <CALTww289vzTPAzkPod2PD+gfU3mMG7uN=89ZkF__ztmQmFa+ug@mail.gmail.com> <CAPhsuW4Rv5_n8Zp0REr++UAaOab_fq4nBLHM=5Ai-zFkKknfhg@mail.gmail.com>
In-Reply-To: <CAPhsuW4Rv5_n8Zp0REr++UAaOab_fq4nBLHM=5Ai-zFkKknfhg@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 18 Nov 2022 12:24:18 +0800
Message-ID: <CALTww29FEEDB4yQtYRA1ht2TiX8LGiysDD2DSah46Jc7-ShbpA@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] Add mddev->io_acct_cnt for raid0_quiesce
To:     Song Liu <song@kernel.org>
Cc:     guoqing.jiang@linux.dev, linux-raid@vger.kernel.org,
        ffan@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Nov 18, 2022 at 10:37 AM Song Liu <song@kernel.org> wrote:
>
> On Thu, Nov 17, 2022 at 5:39 PM Xiao Ni <xni@redhat.com> wrote:
> >
> > On Fri, Nov 18, 2022 at 3:57 AM Song Liu <song@kernel.org> wrote:
> > >
> > > Hi Xiao,
> > >
> > > Thanks for the results.
> > >
> > > On Wed, Nov 16, 2022 at 6:03 PM Xiao Ni <xni@redhat.com> wrote:
> > > >
> > > > Hi Song
> > > >
> > > > The performance is good.  Please check the result below.
> > > >
> > > > And for the patch itself, do you think we should add a smp_mb
> > > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > > index 4d0139cae8b5..3696e3825e27 100644
> > > > --- a/drivers/md/md.c
> > > > +++ b/drivers/md/md.c
> > > > @@ -8650,9 +8650,11 @@ static void md_end_io_acct(struct bio *bio)
> > > >         bio_put(bio);
> > > >         bio_endio(orig_bio);
> > > >
> > > > -       if (atomic_dec_and_test(&mddev->io_acct_cnt))
> > > > +       if (atomic_dec_and_test(&mddev->io_acct_cnt)) {
> > > > +               smp_mb();
> > > >                 if (unlikely(test_bit(MD_QUIESCE, &mddev->flags)))
> > > >                         wake_up(&mddev->wait_io_acct);
> > > > +       }
> > > >  }
> > > >
> > > >  /*
> > > > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > > > index 9d4831ca802c..1818f79bfdf7 100644
> > > > --- a/drivers/md/raid0.c
> > > > +++ b/drivers/md/raid0.c
> > > > @@ -757,6 +757,7 @@ static void raid0_quiesce(struct mddev *mddev, int quiesce)
> > > >          * to member disks to avoid memory alloc and performance decrease
> > > >          */
> > > >         set_bit(MD_QUIESCE, &mddev->flags);
> > > > +       smp_mb();
> > > >         wait_event(mddev->wait_io_acct, !atomic_read(&mddev->io_acct_cnt));
> > > >         clear_bit(MD_QUIESCE, &mddev->flags);
> > > >  }
> > > >
> > > > Test result:
> > >
> > > I think there is some noise in the result?
> > >
> > > >
> > > >                           without patch    with patch
> > > > psync read          100MB/s           101MB/s         job:1 bs:4k
> > >
> > > For example, this is a small improvement, but
> > >
> > > >                            1015MB/s         1016MB/s       job:1 bs:128k
> > > >                            1359MB/s         1358MB/s       job:1 bs:256k
> > > >                            1394MB/s         1393MB/s       job:40 bs:4k
> > > >                            4959MB/s         4873MB/s       job:40 bs:128k
> > > >                            6166MB/s         6157MB/s       job:40 bs:256k
> > > >
> > > >                           without patch      with patch
> > > > psync write          286MB/s           275MB/s        job:1 bs:4k
> > >
> > > this is a big regression (~4%).
> > >
> > > >                             1810MB/s         1808MB/s      job:1 bs:128k
> > > >                             1814MB/s         1814MB/s      job:1 bs:256k
> > > >                             1802MB/s         1801MB/s      job:40 bs:4k
> > > >                             1814MB/s         1814MB/s      job:40 bs:128k
> > > >                             1814MB/s         1814MB/s      job:40 bs:256k
> > > >
> > > >                           without patch
> > > > psync randread    39.3MB/s           39.7MB/s      job:1 bs:4k
> > > >                              791MB/s            783MB/s       job:1 bs:128k
> > > >                             1183MiB/s          1217MB/s     job:1 bs:256k
> > > >                             1183MiB/s          1235MB/s     job:40 bs:4k
> > > >                             3768MB/s          3705MB/s     job:40 bs:128k
> > >
> > > And some regression for 128kB but improvement for 4kB.
> > >
> > > >                             4410MB/s           4418MB/s     job:40 bs:256k
> > >
> > > So I am not quite convinced by these results.
> >
> > Thanks for pointing out the problem. Maybe I need to do a precondition before
> > the testing.  I'll give the result again.
> > >
> > > Also, do we really need an extra counter here? Can we use
> > > mddev->active_io instead?
> >
> > At first, I thought of this way too. But active_io is decreased only
> > after pers->make_request.
> > So it can't be used to wait for all bios to return back.
>
> Ah, that's right.
>
> >
> > Can we decrease mddev->active_io in the bi_end_io of each personality?
> > Now only mddev_supsend
> > uses mddev->active_io. It needs to wait all active io to finish. From
> > this point, it should be better
> > to decrease acitve_io in bi_end_io. What's your opinion?
>
> I think we can give it a try. It may break some cases though. If mdadm tests
> behave the same with the change, we can give it a try.

What are the cases?

>
> OTOH, depend on the perf results, we may consider using percpu_ref for
> both active_io and io_acct_cnt.

Thanks. I'll have a try with it.

Regards
Xiao

