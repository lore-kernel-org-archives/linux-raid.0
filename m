Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85411C433FE
	for <linux-raid@archiver.kernel.org>; Fri, 18 Nov 2022 02:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbiKRChP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Nov 2022 21:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbiKRChP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 17 Nov 2022 21:37:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650358D4A3
        for <linux-raid@vger.kernel.org>; Thu, 17 Nov 2022 18:37:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02BF162311
        for <linux-raid@vger.kernel.org>; Fri, 18 Nov 2022 02:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4ACC43470
        for <linux-raid@vger.kernel.org>; Fri, 18 Nov 2022 02:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668739033;
        bh=uIMQcrW8Ywoc+Sqcdl1ZnaLuqod5UmBACujFHbGd8vA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hZjzLLGWQsmFDeT/jQ9lYMDd5k70QoFOatClrsY4DZmvWyDTW93oxEjz5DXLeOIwY
         k1qWllgR2jEYpx7MAQB+whqH2Zn+bQoiBFhTQzPKPH+6mhFL12dVwvjtfPSaAvOLFa
         ZQ5DRPLBbkK/wMmexoatgJp9+jEVAkv+MA6w9h06zPKgaAMf6tIdEpMDjsrRXVTQfI
         PJXAtfOpa9RL2KhDe0MfI8eOeN4u4lilxbRm7L2OE71SsIbAauQZR9MDx0nvyfXPfG
         eLhA9iLbObcMRGR8KOYxG8utxE0BHsSSmQS8uMwxex5VtPYELJm+pF+GEJ2vXVnoaF
         kw3Nzhlv33e0A==
Received: by mail-ej1-f43.google.com with SMTP id n12so9724290eja.11
        for <linux-raid@vger.kernel.org>; Thu, 17 Nov 2022 18:37:13 -0800 (PST)
X-Gm-Message-State: ANoB5plX20nKzZMzfjQ2in+jkZnoU5QwazisEJzmTDGceh/6fUAlDDWL
        Diwb64DV1Lqha9HvV9scCWilEt7dQZLKXzdC6c0=
X-Google-Smtp-Source: AA0mqf7V1fcXvQtmVlxWjmy3IwDIbu2i2YxAiQYic7834HWg9mfD8fYa2L7N3wAYOlkez9tZqQmj5/YOS5EZzWiGca8=
X-Received: by 2002:a17:907:7e86:b0:7af:bc9:5e8d with SMTP id
 qb6-20020a1709077e8600b007af0bc95e8dmr4395633ejc.3.1668739031541; Thu, 17 Nov
 2022 18:37:11 -0800 (PST)
MIME-Version: 1.0
References: <20221024064836.12731-1-xni@redhat.com> <CAPhsuW7-VaWT1SkuT-Tj_2jGgjso3NJ2hN6v8xUgdCHq3NON_g@mail.gmail.com>
 <CALTww28dJes9MSw5S0bS+zqa6vLGsw1AMeqi5UKHwOkbgKMhQw@mail.gmail.com>
 <CALTww2_=vEpbCWHrVchYnoS=ohZUsVUr+6F=TERCQgBKNa=XYg@mail.gmail.com>
 <CAPhsuW4rkLtYaPQbXPsQn+5kEFNzACYhM4UaAS+sKU1AHurRzw@mail.gmail.com> <CALTww289vzTPAzkPod2PD+gfU3mMG7uN=89ZkF__ztmQmFa+ug@mail.gmail.com>
In-Reply-To: <CALTww289vzTPAzkPod2PD+gfU3mMG7uN=89ZkF__ztmQmFa+ug@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 17 Nov 2022 18:36:59 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4Rv5_n8Zp0REr++UAaOab_fq4nBLHM=5Ai-zFkKknfhg@mail.gmail.com>
Message-ID: <CAPhsuW4Rv5_n8Zp0REr++UAaOab_fq4nBLHM=5Ai-zFkKknfhg@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] Add mddev->io_acct_cnt for raid0_quiesce
To:     Xiao Ni <xni@redhat.com>
Cc:     guoqing.jiang@linux.dev, linux-raid@vger.kernel.org,
        ffan@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Nov 17, 2022 at 5:39 PM Xiao Ni <xni@redhat.com> wrote:
>
> On Fri, Nov 18, 2022 at 3:57 AM Song Liu <song@kernel.org> wrote:
> >
> > Hi Xiao,
> >
> > Thanks for the results.
> >
> > On Wed, Nov 16, 2022 at 6:03 PM Xiao Ni <xni@redhat.com> wrote:
> > >
> > > Hi Song
> > >
> > > The performance is good.  Please check the result below.
> > >
> > > And for the patch itself, do you think we should add a smp_mb
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index 4d0139cae8b5..3696e3825e27 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -8650,9 +8650,11 @@ static void md_end_io_acct(struct bio *bio)
> > >         bio_put(bio);
> > >         bio_endio(orig_bio);
> > >
> > > -       if (atomic_dec_and_test(&mddev->io_acct_cnt))
> > > +       if (atomic_dec_and_test(&mddev->io_acct_cnt)) {
> > > +               smp_mb();
> > >                 if (unlikely(test_bit(MD_QUIESCE, &mddev->flags)))
> > >                         wake_up(&mddev->wait_io_acct);
> > > +       }
> > >  }
> > >
> > >  /*
> > > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > > index 9d4831ca802c..1818f79bfdf7 100644
> > > --- a/drivers/md/raid0.c
> > > +++ b/drivers/md/raid0.c
> > > @@ -757,6 +757,7 @@ static void raid0_quiesce(struct mddev *mddev, int quiesce)
> > >          * to member disks to avoid memory alloc and performance decrease
> > >          */
> > >         set_bit(MD_QUIESCE, &mddev->flags);
> > > +       smp_mb();
> > >         wait_event(mddev->wait_io_acct, !atomic_read(&mddev->io_acct_cnt));
> > >         clear_bit(MD_QUIESCE, &mddev->flags);
> > >  }
> > >
> > > Test result:
> >
> > I think there is some noise in the result?
> >
> > >
> > >                           without patch    with patch
> > > psync read          100MB/s           101MB/s         job:1 bs:4k
> >
> > For example, this is a small improvement, but
> >
> > >                            1015MB/s         1016MB/s       job:1 bs:128k
> > >                            1359MB/s         1358MB/s       job:1 bs:256k
> > >                            1394MB/s         1393MB/s       job:40 bs:4k
> > >                            4959MB/s         4873MB/s       job:40 bs:128k
> > >                            6166MB/s         6157MB/s       job:40 bs:256k
> > >
> > >                           without patch      with patch
> > > psync write          286MB/s           275MB/s        job:1 bs:4k
> >
> > this is a big regression (~4%).
> >
> > >                             1810MB/s         1808MB/s      job:1 bs:128k
> > >                             1814MB/s         1814MB/s      job:1 bs:256k
> > >                             1802MB/s         1801MB/s      job:40 bs:4k
> > >                             1814MB/s         1814MB/s      job:40 bs:128k
> > >                             1814MB/s         1814MB/s      job:40 bs:256k
> > >
> > >                           without patch
> > > psync randread    39.3MB/s           39.7MB/s      job:1 bs:4k
> > >                              791MB/s            783MB/s       job:1 bs:128k
> > >                             1183MiB/s          1217MB/s     job:1 bs:256k
> > >                             1183MiB/s          1235MB/s     job:40 bs:4k
> > >                             3768MB/s          3705MB/s     job:40 bs:128k
> >
> > And some regression for 128kB but improvement for 4kB.
> >
> > >                             4410MB/s           4418MB/s     job:40 bs:256k
> >
> > So I am not quite convinced by these results.
>
> Thanks for pointing out the problem. Maybe I need to do a precondition before
> the testing.  I'll give the result again.
> >
> > Also, do we really need an extra counter here? Can we use
> > mddev->active_io instead?
>
> At first, I thought of this way too. But active_io is decreased only
> after pers->make_request.
> So it can't be used to wait for all bios to return back.

Ah, that's right.

>
> Can we decrease mddev->active_io in the bi_end_io of each personality?
> Now only mddev_supsend
> uses mddev->active_io. It needs to wait all active io to finish. From
> this point, it should be better
> to decrease acitve_io in bi_end_io. What's your opinion?

I think we can give it a try. It may break some cases though. If mdadm tests
behave the same with the change, we can give it a try.

OTOH, depend on the perf results, we may consider using percpu_ref for
both active_io and io_acct_cnt.

Thanks,
Song
