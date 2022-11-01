Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE0BC4332F
	for <linux-raid@archiver.kernel.org>; Tue,  1 Nov 2022 23:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiKAXpS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Nov 2022 19:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKAXpQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Nov 2022 19:45:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1A81D644
        for <linux-raid@vger.kernel.org>; Tue,  1 Nov 2022 16:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667346256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k4zfyqt+78m6nMjBTYfUbfSj9Ttrp6eDPKSXytRcgls=;
        b=QvLsVQOoVvduMTU2vyIAKSLCvy6TVJSuVlB9slfxS9Wu/kTcbQT7ihzda9YAerT/yVW+xJ
        f7CjG7L8r6YWEee9GlBQkcUqwHbu3Bqm/i1AFfHgZ5rFxKW4JF2QqS43niW86IEqX2FFQb
        P2/G8fRBCbwGu3qYpQBGgpKM1l2fZt0=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-135-CJAEBjwvMBmrXs_YoLDObg-1; Tue, 01 Nov 2022 19:44:15 -0400
X-MC-Unique: CJAEBjwvMBmrXs_YoLDObg-1
Received: by mail-pg1-f198.google.com with SMTP id s82-20020a632c55000000b0046b2491aa95so8440566pgs.7
        for <linux-raid@vger.kernel.org>; Tue, 01 Nov 2022 16:44:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k4zfyqt+78m6nMjBTYfUbfSj9Ttrp6eDPKSXytRcgls=;
        b=wyqeAgN0RFnnU+JLIxDJX3mLrVEflt0iFJ33RISSeN1nLF58s2kTLamUODiFntJSae
         vd9Py2/B5FOC0stXUcvVRDb4q5ucEHNILGrEyZJXFUNZXxAvRQHdqRKYA9RnLlvWTSw8
         7uBEh1xe1UpjIS7euuEjDylPeyeJYMeETVpgHtVb8xSHYUWy7W3UTez2Cd4a1ku8uznA
         pb83zd/fvYx63EjzmVSKvUgKAWtoonG38nX4mr0baE8UKKICCTwstxR1wX09wW80DdW6
         prdBVdUO0Wr9Zjjqq5gZBoq1d/zsug+jyPiVj/2hTHfoGoQcmSt7qr98q3HNaW8tFZ1f
         GDoQ==
X-Gm-Message-State: ACrzQf2OyN+8Q/INm+7gnGO4DmofRGxoyfZSJSXf45ayrCsW0a1LJtQb
        UqSw/QjgSimqNoPItw8f/XHRupLWVNqVwtROydS0aUy9dwfL+PNXnh5YGzy1LTIVzjpNcEPmlWC
        r3O7TD/XPlwg4rKW0qcxLY4L/5nGQDyWgDtXztA==
X-Received: by 2002:a17:90b:1c82:b0:1ee:eb41:b141 with SMTP id oo2-20020a17090b1c8200b001eeeb41b141mr23220150pjb.143.1667346253767;
        Tue, 01 Nov 2022 16:44:13 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7Q0pm40av8URmmxgQgP54F9+auA+0ADDvPi+gjDzyJGsr6zMQRblSxP7NOCSCgjwLgNRMUFDk5gxaTEVRqbHM=
X-Received: by 2002:a17:90b:1c82:b0:1ee:eb41:b141 with SMTP id
 oo2-20020a17090b1c8200b001eeeb41b141mr23220133pjb.143.1667346253484; Tue, 01
 Nov 2022 16:44:13 -0700 (PDT)
MIME-Version: 1.0
References: <20221101050819.12509-1-xni@redhat.com> <CAPhsuW7QLFpMbsYcisTm32zdeeYEXMT+M76S=Kjn5rurTF8Lpw@mail.gmail.com>
In-Reply-To: <CAPhsuW7QLFpMbsYcisTm32zdeeYEXMT+M76S=Kjn5rurTF8Lpw@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 2 Nov 2022 07:44:02 +0800
Message-ID: <CALTww2_CnyCatgr-c4JPubgNjoAXBHTra5WjO6WpFqB4T1e=hg@mail.gmail.com>
Subject: Re: [PATCH 1/1] Don't set discard sectors for request queue
To:     Song Liu <song@kernel.org>
Cc:     yi.zhang@redhat.com, ming.lei@redhat.com,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Nov 2, 2022 at 4:21 AM Song Liu <song@kernel.org> wrote:
>
> On Mon, Oct 31, 2022 at 10:08 PM Xiao Ni <xni@redhat.com> wrote:
>
> Please update the subject as md/raid0, raid10: xxx.

Sorry for forgetting about this again.

>
> >
> > It should use disk_stack_limits to get a proper max_discard_sectors
> > rather than setting a value by stack drivers.
> >
> > And there is a bug. If all member disks are rotational devices,
> > raid0/raid10 set max_discard_sectors. So the member devices are
> > not ssd/nvme, but raid0/raid10 export the wrong value. It reports
> > warning messages in function __blkdev_issue_discard when mkfs.xfs
>
> Please provide more information about this bug: the warning message,
> the impact, etc. in the commit log.

I remember we need to obey a rule to paste the warning/panic messages,
right? If so, can you tell the position again? I use the keyword
"warning/panic/calltrace"
to search in file process/submitting-patches.rst and can't find the
useful information.
Or it just needs to paste the calltraces in the patch?

Regards
Xiao
>
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > Reported-by: Yi Zhang <yi.zhang@redhat.com>
>
> Thanks,
> Song
>
> > ---
> >  drivers/md/raid0.c  | 1 -
> >  drivers/md/raid10.c | 2 --
> >  2 files changed, 3 deletions(-)
> >
> > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > index aced0ad8cdab..9d4831ca802c 100644
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -398,7 +398,6 @@ static int raid0_run(struct mddev *mddev)
> >
> >                 blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
> >                 blk_queue_max_write_zeroes_sectors(mddev->queue, mddev->chunk_sectors);
> > -               blk_queue_max_discard_sectors(mddev->queue, UINT_MAX);
> >
> >                 blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
> >                 blk_queue_io_opt(mddev->queue,
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index 3aa8b6e11d58..9a6503f5cb98 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -4145,8 +4145,6 @@ static int raid10_run(struct mddev *mddev)
> >         conf->thread = NULL;
> >
> >         if (mddev->queue) {
> > -               blk_queue_max_discard_sectors(mddev->queue,
> > -                                             UINT_MAX);
> >                 blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
> >                 blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
> >                 raid10_set_io_opt(conf);
> > --
> > 2.32.0 (Apple Git-132)
> >
>

