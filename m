Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1742C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 14 Sep 2021 07:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0A5961163
	for <linux-raid@archiver.kernel.org>; Tue, 14 Sep 2021 07:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240566AbhINHKc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Sep 2021 03:10:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44033 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240407AbhINHKb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 14 Sep 2021 03:10:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631603354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wPybmw0b7JA71YhkMsZl+aNWwvG6YUaernbLPaOqLFw=;
        b=dpToo9xM9ZFM3dO/EdsOPPS/9cILYmSy9ywpCBALgjfaWF5EHcCUWcKc8nt6TVYXWReiA1
        uAKg6Io0ta7yh5a/wR980RxNBy3m2RVQBUitUpXc6pEWH3qbAHMicVLBovG1tJdxhIedEc
        DguujH/L2WWu+6Vnh7w4w90fcjUMNk8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-4cWyJy9pPSqQtXYsr_1qrA-1; Tue, 14 Sep 2021 03:09:11 -0400
X-MC-Unique: 4cWyJy9pPSqQtXYsr_1qrA-1
Received: by mail-ed1-f70.google.com with SMTP id y17-20020a50e611000000b003d051004603so5574879edm.8
        for <linux-raid@vger.kernel.org>; Tue, 14 Sep 2021 00:09:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wPybmw0b7JA71YhkMsZl+aNWwvG6YUaernbLPaOqLFw=;
        b=rLWcIqXLbziMn7nCHVttIdiSkjNXNt6ASOYlEAue9j8HDNExYwTy4//A9aQ0iEVYs9
         OynmxTYVj7wBPQ9HGcnJNyvf+KeGWJLKSP5gSCN02S++VgII9jiHy4I9LCASVyDvKplR
         V41PNCqA3iqSUQOAI39Iab5opVR0JgR5/YjRFo4Qp+r8qL+5RquD1cgV+eRSaqxyqoB4
         2CM5gfxC0gLYjRoi67qZDeblIKlxGTMNRdughSL4JcIOFwNBS91LL2a6iUXhQy8xaHi3
         5plOatcNR5aUNZ77ZdU0TJUjEu5v4HvnyqJWHo5U4t5VdzSQRpZ1D1b9piwEnLVWlLRS
         gWHg==
X-Gm-Message-State: AOAM530wZn01xkRiTjE8R1SkDb94EGVeCnq9nw45ylf52JSzrveWRaxj
        o10+AmtbtF6vq+T4WCBw09pwKYOK7+xlAeVbt2dhgw4B16Ruyl+vmppe5Qefvd32BKRWYZIpJN+
        liZ/96bC5KQ9p/HVYNcFjXAAMLKXiqtUdzuvqvg==
X-Received: by 2002:a17:906:e105:: with SMTP id gj5mr17185739ejb.408.1631603350076;
        Tue, 14 Sep 2021 00:09:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuTYMYAd2m4gigAhplgNJt0ePIRwJasVmCkftUF99Phk1/igYHzd60DHm4EvUDS58K+P43nC3zUZRrPZPE9QY=
X-Received: by 2002:a17:906:e105:: with SMTP id gj5mr17185729ejb.408.1631603349888;
 Tue, 14 Sep 2021 00:09:09 -0700 (PDT)
MIME-Version: 1.0
References: <7461b27b-2a4b-fbbb-5cfd-8fab416cbc9f@suse.de>
In-Reply-To: <7461b27b-2a4b-fbbb-5cfd-8fab416cbc9f@suse.de>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 14 Sep 2021 15:08:58 +0800
Message-ID: <CALTww29nZV4A1BM_ShrmL1ud4YZC2YTG8q4LvW8pfhZwb=MhVQ@mail.gmail.com>
Subject: Re: [PATCH] mdadm: split off shared library
To:     Hannes Reinecke <hare@suse.de>
Cc:     Jes Sorensen <jsorensen@fb.com>, Coly Li <colyli@suse.de>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Hannes

Thanks for these patches. It's a good idea to make codes more clearly
that which codes belong to which file.
There are many efforts that move codes from mdadm.c and mdadm.h to
specific files. Is it better to put these
patches together? For example, the patches(6, 11, 12, 16, 19, 20, 27,
28) try to clean mdadm.c. Could you put
similar patches together? And there are some rename patches too, they
are sporadic.

For patch03, the argument is name, but it uses optarg in the function
mdadm_get_layout. Is it an error?

By the way, are there some other users who use the library besides mdadm/md=
mon?

And it's good for me if you send patches directly by email to
linux-raid mail list.

Best Regards
Xiao

On Wed, Aug 25, 2021 at 10:35 PM Hannes Reinecke <hare@suse.de> wrote:
>
> Hi all,
>
> this is, contrary to the subject, not a patch, but rather a question on
> how to submit a patchset.
> I've been working on splitting off a shared library from mdadm, with the
> aim that it can be included from other programs.
> Reasoning behind it that I've written a monitor program
> (github.com:/hreinecke/md_monitor) and found it a major pain having to
> exec() mdadm, and then keep fingers crossed that things succeed; error
> recovery from _that_ turned out to be a major drag. And so I figured
> that a shared library is possibly the best way to go.
>
> (And, as a side note: having a shared library would also allow to build
> a python binding, which possibly will have even more use-cases ...)
>
> So I've build a patchset to split off a shared library from mdadm, and
> build mdadm against that:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/hare/mdadm.git
> branch shlib
>
> But as it turns out, these are 30+ patches, and I didn't want to flood
> the mailinglist with that.
> So what are the procedures here?
>
> Are you okay with having the entire patchset on the mailing list?
> Or are there other ways?
>
> Thanks for your help.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                        Kernel Storage Architect
> hare@suse.de                                      +49 911 74053 688
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), GF: Felix Imend=C3=B6rffer
>

