Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77918C4332F
	for <linux-raid@archiver.kernel.org>; Fri, 18 Nov 2022 01:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240936AbiKRBk0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Nov 2022 20:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240876AbiKRBkX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 17 Nov 2022 20:40:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B988463E7
        for <linux-raid@vger.kernel.org>; Thu, 17 Nov 2022 17:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668735568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UoQejq/sCAc6O/A3yc7V0M7FnDLuEpr0howLrgw/OUU=;
        b=Dq0/VeNYTLHgxrb3LCtqpxMLY4fNbXJt8So6mkZ2gx4GOJKisXCXHdwD4L3cbvIhJa+yCE
        S7dvZIICkZ/Xju86EyQl/1VPTIrJVBE3+VEKHOEFKGlIfmN+cYFxY375pYScPBNBL4lGdf
        t2I+LiOzAcIKYcypaBfvSSiCUx4cm2M=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-643-y-FHsOJ0PtC3HIRpo2sXMw-1; Thu, 17 Nov 2022 20:39:26 -0500
X-MC-Unique: y-FHsOJ0PtC3HIRpo2sXMw-1
Received: by mail-pf1-f197.google.com with SMTP id s11-20020a056a00178b00b0056cb4545c3fso2121820pfg.5
        for <linux-raid@vger.kernel.org>; Thu, 17 Nov 2022 17:39:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UoQejq/sCAc6O/A3yc7V0M7FnDLuEpr0howLrgw/OUU=;
        b=z4GmOJkvUp8+uRm0oPXZ5SPvci/pgxbbwhrryaXfa/5zbo216p6Bg93hS01eeIVeqh
         XdPSQc1C9DYg4pg6Ck9CdAgadgQoS2TAi4DLnVunXlIji+KYUBUkIIO9Jdri3CzPccof
         YIkRDEzjAVOrHgwI7pGvQwj3aec3BETMT8PLldbrMpejxlvH6ptZZAMf0iwfC6dnYmAV
         cEA72LRia+AdUwNDVstlaoi4ce7otPZz0At5IcKhblNGeyEcHAnZeiEXrs5gr0izH4NU
         xTh6QY05B74X1B51nokbTDbMVtHcZ702ErUQdomTsfAX9qViMPhhQUvgF/LoL1RDK9D0
         KrZw==
X-Gm-Message-State: ANoB5pneo6Z2hHf65zSEjT6AZLUWK5Y2yS7BiEvBmMvCMxAj7LQPiydL
        2HRhoYaKMVPVmwDKZr6J0D7dMve/lWn7BaHRtiAUlTkemaQoTMYcMeKhHLl6LLCViTH1CpvSAd+
        VayrabexJmVZglI3+lYIITHtNQf1pKZoaumkVvQ==
X-Received: by 2002:a63:356:0:b0:46f:b44b:3522 with SMTP id 83-20020a630356000000b0046fb44b3522mr4520773pgd.288.1668735565663;
        Thu, 17 Nov 2022 17:39:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf754iiqaClAsWf81nZREt3Q9b447a8Y+iiRzUYXvFWRnfO6kCl0mHk2cR/Lxj+Mtu4wmFm18VSPftkrSVJyY08=
X-Received: by 2002:a63:356:0:b0:46f:b44b:3522 with SMTP id
 83-20020a630356000000b0046fb44b3522mr4520761pgd.288.1668735565381; Thu, 17
 Nov 2022 17:39:25 -0800 (PST)
MIME-Version: 1.0
References: <20221024064836.12731-1-xni@redhat.com> <CAPhsuW7-VaWT1SkuT-Tj_2jGgjso3NJ2hN6v8xUgdCHq3NON_g@mail.gmail.com>
 <CALTww28dJes9MSw5S0bS+zqa6vLGsw1AMeqi5UKHwOkbgKMhQw@mail.gmail.com>
 <CALTww2_=vEpbCWHrVchYnoS=ohZUsVUr+6F=TERCQgBKNa=XYg@mail.gmail.com> <CAPhsuW4rkLtYaPQbXPsQn+5kEFNzACYhM4UaAS+sKU1AHurRzw@mail.gmail.com>
In-Reply-To: <CAPhsuW4rkLtYaPQbXPsQn+5kEFNzACYhM4UaAS+sKU1AHurRzw@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 18 Nov 2022 09:39:14 +0800
Message-ID: <CALTww289vzTPAzkPod2PD+gfU3mMG7uN=89ZkF__ztmQmFa+ug@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] Add mddev->io_acct_cnt for raid0_quiesce
To:     Song Liu <song@kernel.org>
Cc:     guoqing.jiang@linux.dev, linux-raid@vger.kernel.org,
        ffan@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Nov 18, 2022 at 3:57 AM Song Liu <song@kernel.org> wrote:
>
> Hi Xiao,
>
> Thanks for the results.
>
> On Wed, Nov 16, 2022 at 6:03 PM Xiao Ni <xni@redhat.com> wrote:
> >
> > Hi Song
> >
> > The performance is good.  Please check the result below.
> >
> > And for the patch itself, do you think we should add a smp_mb
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 4d0139cae8b5..3696e3825e27 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -8650,9 +8650,11 @@ static void md_end_io_acct(struct bio *bio)
> >         bio_put(bio);
> >         bio_endio(orig_bio);
> >
> > -       if (atomic_dec_and_test(&mddev->io_acct_cnt))
> > +       if (atomic_dec_and_test(&mddev->io_acct_cnt)) {
> > +               smp_mb();
> >                 if (unlikely(test_bit(MD_QUIESCE, &mddev->flags)))
> >                         wake_up(&mddev->wait_io_acct);
> > +       }
> >  }
> >
> >  /*
> > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > index 9d4831ca802c..1818f79bfdf7 100644
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -757,6 +757,7 @@ static void raid0_quiesce(struct mddev *mddev, int quiesce)
> >          * to member disks to avoid memory alloc and performance decrease
> >          */
> >         set_bit(MD_QUIESCE, &mddev->flags);
> > +       smp_mb();
> >         wait_event(mddev->wait_io_acct, !atomic_read(&mddev->io_acct_cnt));
> >         clear_bit(MD_QUIESCE, &mddev->flags);
> >  }
> >
> > Test result:
>
> I think there is some noise in the result?
>
> >
> >                           without patch    with patch
> > psync read          100MB/s           101MB/s         job:1 bs:4k
>
> For example, this is a small improvement, but
>
> >                            1015MB/s         1016MB/s       job:1 bs:128k
> >                            1359MB/s         1358MB/s       job:1 bs:256k
> >                            1394MB/s         1393MB/s       job:40 bs:4k
> >                            4959MB/s         4873MB/s       job:40 bs:128k
> >                            6166MB/s         6157MB/s       job:40 bs:256k
> >
> >                           without patch      with patch
> > psync write          286MB/s           275MB/s        job:1 bs:4k
>
> this is a big regression (~4%).
>
> >                             1810MB/s         1808MB/s      job:1 bs:128k
> >                             1814MB/s         1814MB/s      job:1 bs:256k
> >                             1802MB/s         1801MB/s      job:40 bs:4k
> >                             1814MB/s         1814MB/s      job:40 bs:128k
> >                             1814MB/s         1814MB/s      job:40 bs:256k
> >
> >                           without patch
> > psync randread    39.3MB/s           39.7MB/s      job:1 bs:4k
> >                              791MB/s            783MB/s       job:1 bs:128k
> >                             1183MiB/s          1217MB/s     job:1 bs:256k
> >                             1183MiB/s          1235MB/s     job:40 bs:4k
> >                             3768MB/s          3705MB/s     job:40 bs:128k
>
> And some regression for 128kB but improvement for 4kB.
>
> >                             4410MB/s           4418MB/s     job:40 bs:256k
>
> So I am not quite convinced by these results.

Thanks for pointing out the problem. Maybe I need to do a precondition before
the testing.  I'll give the result again.
>
> Also, do we really need an extra counter here? Can we use
> mddev->active_io instead?

At first, I thought of this way too. But active_io is decreased only
after pers->make_request.
So it can't be used to wait for all bios to return back.

Can we decrease mddev->active_io in the bi_end_io of each personality?
Now only mddev_supsend
uses mddev->active_io. It needs to wait all active io to finish. From
this point, it should be better
to decrease acitve_io in bi_end_io. What's your opinion?

Best Regards
Xiao

