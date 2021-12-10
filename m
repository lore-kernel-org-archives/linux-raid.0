Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBB8C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 01:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbhLJBWq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 20:22:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32539 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231239AbhLJBWp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 20:22:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639099151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZiKpbcTFQDja9sWQZtWTyD0sGBkjT2mQhXZuZtJ5LAU=;
        b=M+zteix/69MWYtoFF6IDe2nTXo3wYnHcjUeXlX7YABsBip/tyzq7jpcxn1VXb9jCDTG/CL
        qVaq7+ZgvH+1nSWCz1WW91DSJ8+LyK3TjmEwws9uGW8CN2loiHIOsS+sy1H+HFNmuKY/ju
        6PI+1t+JoX44Sc4O4n3xvR24BZIju0E=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-Yqabr78kN1qxgNBmmVVY5A-1; Thu, 09 Dec 2021 20:19:10 -0500
X-MC-Unique: Yqabr78kN1qxgNBmmVVY5A-1
Received: by mail-ed1-f69.google.com with SMTP id y9-20020aa7c249000000b003e7bf7a1579so6833960edo.5
        for <linux-raid@vger.kernel.org>; Thu, 09 Dec 2021 17:19:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZiKpbcTFQDja9sWQZtWTyD0sGBkjT2mQhXZuZtJ5LAU=;
        b=1+sPIwuqiMPvajDpi+9OrRdJOKhjpBiBTScYoB9vrg60+CAAxDy2o82Tj/FmH3sirj
         rwrKBKKvRAv9VzpW6USTqk2lCg4gOV44Zgm6WTqshM7UPG3OeK3IN9zPHVdDvUFqAfX2
         2HsE45gxzfThisC8CYU0ueOCgcZSslNK5kmJmroa2k0/PenG8S5LtWOA8u6i9J9C7tkZ
         UGNTlHC7VWOpnzdI1zEJYygeJrP1H4AZw/Oo751zx8QHqRIc/X4Q39uJfGO9RFt0SdCp
         FPiofYFshQeAqvdRN/9w1N8jx6zC+ov3hmZX4q1WxJplUjN7ApJX9Wpylaa8H3o7dx+x
         WJ2Q==
X-Gm-Message-State: AOAM532lR5RmZXZNlqmnj491f9YrMZaMoMZWYfXFzhygVs9uoMM74VvG
        jfbi9EXHs4muzTA7Vrk2e/WJ0BKryzOYzx1AxjfFjbQAsLe1BHcH8sVt4nyujBMWX6d99yZ4zoh
        AEUBYz95N7ZfxmtvaPzXjXl6oD5eols6Rn1VPgw==
X-Received: by 2002:a05:6402:278e:: with SMTP id b14mr34275281ede.354.1639099149080;
        Thu, 09 Dec 2021 17:19:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQh3LJD3W0Ld4K91U8rZRIvT2mBEUvV+9kFd4Hz/Hc84FM7xWA2FsQiZKNr0pT5SWHn8yQK7MxeSR6rD292f8=
X-Received: by 2002:a05:6402:278e:: with SMTP id b14mr34275261ede.354.1639099148906;
 Thu, 09 Dec 2021 17:19:08 -0800 (PST)
MIME-Version: 1.0
References: <1639029324-4026-1-git-send-email-xni@redhat.com>
 <1639029324-4026-2-git-send-email-xni@redhat.com> <CAPhsuW48S-L9QTH6q_7+Nq0+MmOfswPu5epMq=bkGokxBRE2ew@mail.gmail.com>
In-Reply-To: <CAPhsuW48S-L9QTH6q_7+Nq0+MmOfswPu5epMq=bkGokxBRE2ew@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 10 Dec 2021 09:18:58 +0800
Message-ID: <CALTww29Q57wDf4eWn31ChaU4dW7A=DehdtVkL-8oyzfxnwZY6w@mail.gmail.com>
Subject: Re: [PATCH 1/2] md/raid0: Free r0conf memory when register integrity failed
To:     Song Liu <song@kernel.org>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Dec 10, 2021 at 2:02 AM Song Liu <song@kernel.org> wrote:
>
> On Wed, Dec 8, 2021 at 9:55 PM Xiao Ni <xni@redhat.com> wrote:
> >
> > It doesn't free memory when register integrity failed. And move
> > free conf codes into a single function.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  drivers/md/raid0.c | 18 +++++++++++++++---
> >  1 file changed, 15 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > index 62c8b6adac70..3fa47df1c60e 100644
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -356,6 +356,7 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
> >         return array_sectors;
> >  }
> >
> > +static void free_conf(struct r0conf *conf);
> >  static void raid0_free(struct mddev *mddev, void *priv);
> >
> >  static int raid0_run(struct mddev *mddev)
> > @@ -413,19 +414,30 @@ static int raid0_run(struct mddev *mddev)
> >         dump_zones(mddev);
> >
> >         ret = md_integrity_register(mddev);
> > +       if (ret)
> > +               goto free;
> >
> >         return ret;
> > +
> > +free:
> > +       free_conf(conf);
>
> Can we just use raid0_free() here? Also, after freeing conf,

At first I used raid0_free too. But it looks strange after adding
acct_bioset_exit
in raid0_free. Because if creating stripe zones failed, it doesn't
need to free conf,
although it doesn't have problems that passes NULL to kfree.

But I'm ok if you want me to use raid0_free here. I'll send the next version.

> we should set mddev->private to NULL.
>

Yes.

Regards
Xiao

