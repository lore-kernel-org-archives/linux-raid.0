Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AADC4338F
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 01:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50C5F60F38
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 01:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbhHRB4J (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Aug 2021 21:56:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233380AbhHRB4J (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 17 Aug 2021 21:56:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629251734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EM1nHH5NN+DAtSFriY9sgrrbD3ppU2zu52GsYJO9nIg=;
        b=AX/EEutxhAEWK+iQ7dqkFQFAt5Gfq7YlWBslzmD8JHTG6zffV6Q3jDVhOLouLnlv+170TG
        m0xGnPKO0M/rYcp0VMgU2mhVuBUBmENLcg9RgAomm1hvnHxxh47F7rMYemVM+CuZSpGR6y
        kxBnxdMIIQVIPGx5QmkVpcccnyDqzUg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-Z1yfUMHLPByGdIfeHcXfPQ-1; Tue, 17 Aug 2021 21:55:31 -0400
X-MC-Unique: Z1yfUMHLPByGdIfeHcXfPQ-1
Received: by mail-ej1-f69.google.com with SMTP id v19-20020a170906b013b02905b2f1bbf8f3so284822ejy.6
        for <linux-raid@vger.kernel.org>; Tue, 17 Aug 2021 18:55:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EM1nHH5NN+DAtSFriY9sgrrbD3ppU2zu52GsYJO9nIg=;
        b=P1ueZHiqsA65MmkzW/rQJAhF4VygqjXSElY3/9LMl7eCOL7WJq+9dJQb3ww+rZzziU
         qElnB3pZdc83MNPswczq3ANLtv6AJJ0rsjOvgEz3qLMB8ItUi+R9bjasl4ulH7uxMb0/
         sIQLmshKeqLXl3yJFoP6O9GIGrF3zFGzfvyDVAn1qqeikBNIm9h77YYZc7QREjTTG4YE
         n9YemhrRGxJCSkdh1pNpVhRtRgyMT7QUBfeNZl9hUMm1c/gBoZH7QWVK5Ldjy+eOj8mb
         d3XC+PTfpqDamPB5LoLfL056HhYdSw4tWBTcklWxWLYIXsRC/KzPaPhSwb4H7xNg1GNy
         XWTQ==
X-Gm-Message-State: AOAM5306+j0fjxfllk/YpDdGkmum7430V/6Xjy/dmeo0VLgL11tZtV77
        syn5zBnNEl7ov4Qp9lvOCqEhKpoEIRGyzqZP48sbVKwmsadFE+D8Ty+dBlBIZZKdjkN8skqZgwy
        5Xb2IeXYt9GORHSaD14aCtXzzErz115hEoYVRFA==
X-Received: by 2002:aa7:de05:: with SMTP id h5mr7402045edv.174.1629251730144;
        Tue, 17 Aug 2021 18:55:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4GTAACmnJe60sd4LFJX1PSl2D6nADyuqTd9hoO4Avc3qTEmM/ZeZtIdG8gkzG9qm2B0oOtj9d9gvU58A5Ge0=
X-Received: by 2002:aa7:de05:: with SMTP id h5mr7402037edv.174.1629251730019;
 Tue, 17 Aug 2021 18:55:30 -0700 (PDT)
MIME-Version: 1.0
References: <1629250612-4952-1-git-send-email-xni@redhat.com> <b185fb47-eac1-9ae8-3d48-c0def28f85de@linux.dev>
In-Reply-To: <b185fb47-eac1-9ae8-3d48-c0def28f85de@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 18 Aug 2021 09:55:18 +0800
Message-ID: <CALTww2_P03EcJ2VWO-zDs32Pnbt=GLD-wWPyowxnxCthaQ92Wg@mail.gmail.com>
Subject: Re: [PATCH 1/1] md/raid10: Remove rcu_dereference when it doesn't
 need rcu lock to protect
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Song Liu <song@kernel.org>, Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Aug 18, 2021 at 9:44 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
>
>
> On 8/18/21 9:36 AM, Xiao Ni wrote:
> > One warning message is triggered like this:
> > [  695.110751] =============================
> > [  695.131439] WARNING: suspicious RCU usage
> > [  695.151389] 4.18.0-319.el8.x86_64+debug #1 Not tainted
> > [  695.174413] -----------------------------
> > [  695.192603] drivers/md/raid10.c:1776 suspicious
> > rcu_dereference_check() usage!
> > [  695.225107] other info that might help us debug this:
> > [  695.260940] rcu_scheduler_active = 2, debug_locks = 1
> > [  695.290157] no locks held by mkfs.xfs/10186.
> >
> > In the first loop of function raid10_handle_discard. It already
> > determines which disk need to handle discard request and add the
> > rdev reference count rdev->nr_pending. So the conf->mirrors will
> > not change until all bios come back from underlayer disks. It
> > doesn't need to use rcu_dereference to get rdev.
> >
> > Fixes: d30588b2731f ('md/raid10: improve raid10 discard request')
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/raid10.c | 13 +++++++++----
> >   1 file changed, 9 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index 16977e8..1d3ac76 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -1712,6 +1712,10 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
> >       } else
> >               r10_bio->master_bio = (struct bio *)first_r10bio;
> >
> > +     /* first select target devices under rcu_lock and
> > +      * inc refcount on their rdev.  Record them by setting
> > +      * bios[x] to bio
> > +      */
>
> Nit: the comment style is not correct.
Hi Guoqing

        /*
         * first select target devices under rcu_lock and
         * inc refcount on their rdev.  Record them by setting
         * bios[x] to bio
         */

It should be like this, right? If so, I'll send v2 and add your ack in
the patch too.

