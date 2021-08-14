Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FA1C4338F
	for <linux-raid@archiver.kernel.org>; Sat, 14 Aug 2021 01:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF22F6056C
	for <linux-raid@archiver.kernel.org>; Sat, 14 Aug 2021 01:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbhHNBet (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Aug 2021 21:34:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47925 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236128AbhHNBes (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 13 Aug 2021 21:34:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628904860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cBo5fKwwKm7dwRaJXMhZa8XBwq6FwwGj/FJ4BpFCmAo=;
        b=b95zZpii2Cy8sQx+/TgWFy2V5K8y2UpF0ebeL8nqX9GpYsewxHC7RoItx4R5i5ChcIZqzZ
        r8TTumXQiGEDOdJ8dnId155QLOTlAbhDUGkI1VW47ZvdetM26UMWc0pwGmKByTXhI3E0om
        IXJGCZStdJoSoSbL6ocUp+zujkXvNK0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522--t50Gt6UOOOMaNLq6Fh1Cw-1; Fri, 13 Aug 2021 21:34:19 -0400
X-MC-Unique: -t50Gt6UOOOMaNLq6Fh1Cw-1
Received: by mail-ed1-f69.google.com with SMTP id a23-20020a50ff170000b02903b85a16b672so5694982edu.1
        for <linux-raid@vger.kernel.org>; Fri, 13 Aug 2021 18:34:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cBo5fKwwKm7dwRaJXMhZa8XBwq6FwwGj/FJ4BpFCmAo=;
        b=Hrq4S1981ChluGJjpTQfccVku3qPvwFUFeUQhA1Kg2VUW5mBMKIOJEDjiIl4QXTtl2
         bpVhjhCCcX6kPg5TiYSEalzCjZCEI2NpfvGyBvZLlXqDUfThr9pNj8FsWjvl/hKErh4Z
         wRJh6C4Vblb1p/ayfZNh30ZaCU2NLZ/wrAoaaPVeLI+eleUwP0TIO2SvLUW5bjR0MTPF
         YDocF0X8amfegvgVSHQC0v2VaLrpqIcVAGBgIhNGoRQyolqxe5trQDgs8cnCWridDxT6
         3M7kb77e/0+jON/abhesdbFJuk+x264KTmHQEX2pAqeYaibTQ0DtILJh8TJsiiTEdxhg
         T2JQ==
X-Gm-Message-State: AOAM532bsFNlMFiM7SGzwdXrJXrhsBt4yaGQ841IA3DSQcYEfatnGLj7
        tpU6Ys7okBh9tCTG1IFCm/fQRrMbUrEB1n5KS90W1gh5Aba+hQO/oEINhXo308FK6nWlNkNlvbT
        xnA/90UsX5X/Q6q7Xmj/0T5pPp6qIyRE61FuwiA==
X-Received: by 2002:a05:6402:3113:: with SMTP id dc19mr2538653edb.29.1628904858379;
        Fri, 13 Aug 2021 18:34:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwP+lfIKQLsyGHF5ZEpFzHV0d5uczj5EteBqavoVsm6tKd9wGSudFj+gIOtI/KRbnwpgndzw0rKcTW/dXq/hyA=
X-Received: by 2002:a05:6402:3113:: with SMTP id dc19mr2538648edb.29.1628904858203;
 Fri, 13 Aug 2021 18:34:18 -0700 (PDT)
MIME-Version: 1.0
References: <1628481709-3824-1-git-send-email-xni@redhat.com> <CAPhsuW6iGBrdso3yStTxxv00qxLbW_gP_2H1CMsi5YzPFU5aqA@mail.gmail.com>
In-Reply-To: <CAPhsuW6iGBrdso3yStTxxv00qxLbW_gP_2H1CMsi5YzPFU5aqA@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Sat, 14 Aug 2021 09:34:07 +0800
Message-ID: <CALTww2-a0jw-LAqsZc8hDY49TqCCEX9KB4J14g2j7tDR3XF+GQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] md/raid10: Remove rcu_dereference when it doesn't
 need rcu lock to protect
To:     Song Liu <song@kernel.org>
Cc:     Song Liu <songliubraving@fb.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song

It can improve the performance. It needs to add rcu lock when calling
rcu_dereference.
Now it has a bug. It doesn't use rcu lock to protect. In the second
loop, it doesn't need
to use rcu_dereference when getting rdev. So to resolve this bug, we can remove
rcu_dereference directly.

Best Regards
Xiao

On Sat, Aug 14, 2021 at 12:50 AM Song Liu <song@kernel.org> wrote:
>
> On Sun, Aug 8, 2021 at 9:02 PM Xiao Ni <xni@redhat.com> wrote:
> >
> > In the first loop of function raid10_handle_discard. It already
> > determines which disk need to handle discard request and add the
> > rdev reference count. So the conf->mirrors will not change until
> > all bios come back from underlayer disks. It doesn't need to use
> > rcu_dereference to get rdev.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
>
> Will we get performance benefits from this change? If not, I would
> prefer to keep the code as-is.
>
> Thanks,
> Song
>
> > ---
> >  drivers/md/raid10.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index 16977e8..cef9869 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -1743,9 +1743,8 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
> >         for (disk = 0; disk < geo->raid_disks; disk++) {
> >                 sector_t dev_start, dev_end;
> >                 struct bio *mbio, *rbio = NULL;
> > -               struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
> > -               struct md_rdev *rrdev = rcu_dereference(
> > -                       conf->mirrors[disk].replacement);
> > +               struct md_rdev *rdev = conf->mirrors[disk].rdev;
> > +               struct md_rdev *rrdev = conf->mirrors[disk].replacement;
> >
> >                 /*
> >                  * Now start to calculate the start and end address for each disk.
> > --
> > 2.7.5
> >
>

