Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73393C28D13
	for <linux-raid@archiver.kernel.org>; Mon, 22 Aug 2022 21:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237963AbiHVVMm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 Aug 2022 17:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237919AbiHVVMg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 22 Aug 2022 17:12:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA935283D
        for <linux-raid@vger.kernel.org>; Mon, 22 Aug 2022 14:12:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 09A7CCE1702
        for <linux-raid@vger.kernel.org>; Mon, 22 Aug 2022 21:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D2BC433C1
        for <linux-raid@vger.kernel.org>; Mon, 22 Aug 2022 21:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661202751;
        bh=mPBnu0wN22OjOpiM6ZZp70OnLqtsC3Bd8juDbuYzPMY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NAplP3mD1TLIfV4EPkajoGWjQB/B9TMtVVfwFmvdlrANjLD33GI2KfB3oRgDTy6pF
         y7/iTA60lzKtHoVd2imKlS0AN0dYgWMq5LolpDjcaSvwVns5TXkIxqBOe97lCDjJUt
         UHxgdrlz0c+tmITiVWuV5KESBzCkCYl2ymGe5sY2gpAPbkixvzsh2iDa3Y6pKDgg+t
         h55JPCYGw2VwoypqutUQ0HGSJFUwlEwYsRFcVbJiI6gX5JhW7f8XmD/IpW3bPAE47x
         dUYuz/3DPKccVIzffPIBytORrEHYZyDamoj0L6mNwhhim6gZ4bXRd6lLa4LMwCaeEX
         8Km7Wx+mU+9+w==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-3375488624aso299988087b3.3
        for <linux-raid@vger.kernel.org>; Mon, 22 Aug 2022 14:12:31 -0700 (PDT)
X-Gm-Message-State: ACgBeo3YiDGhQU1jLGwJ3NyTCC6R9gLWCk1DRqJsEOyfciC4WmH36gLV
        SGRsIOIcWwHxUEwzOVJLYZ/FJCpvoxYlcuLTGu4=
X-Google-Smtp-Source: AA6agR6jgXq4iY73SMUXq2yhNPi5XTdF3OVglnGAEJWQscdS9B4x3BJe4adhncwmxUwpQ0P8fD8b//ccVLMTC+wq4D0=
X-Received: by 2002:a81:6143:0:b0:335:3076:168e with SMTP id
 v64-20020a816143000000b003353076168emr21734078ywb.460.1661202750942; Mon, 22
 Aug 2022 14:12:30 -0700 (PDT)
MIME-Version: 1.0
References: <e05c4239-41a9-d2f7-3cfa-4aa9d2cea8c1@deltatee.com>
 <CAPhsuW4=aa08-XGDtoQ3rLb8r-5t9Q7VwwFgGbTTt-xbkzEW8Q@mail.gmail.com>
 <b4e29397-3150-8580-86aa-f23cee893ee6@deltatee.com> <CAPhsuW40XFwAQVwkH6bgT3fe45pZDwASEzt+R=SsqMywrTKcdA@mail.gmail.com>
 <6d311960-017e-8b45-2860-26c802546b5e@deltatee.com>
In-Reply-To: <6d311960-017e-8b45-2860-26c802546b5e@deltatee.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 22 Aug 2022 14:12:20 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4rsXFSBczbA=WbqM5sVhNRXUQm0J5o2WH1bppDvKwJKA@mail.gmail.com>
Message-ID: <CAPhsuW4rsXFSBczbA=WbqM5sVhNRXUQm0J5o2WH1bppDvKwJKA@mail.gmail.com>
Subject: Re: raid5 Journal Recovery Bug
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Aug 22, 2022 at 1:40 PM Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
>
> On 2022-08-22 13:12, Song Liu wrote:
> > On Mon, Aug 22, 2022 at 9:28 AM Logan Gunthorpe <logang@deltatee.com> wrote:
> >>
> >>
> >>
> >> On 2022-08-22 01:04, Song Liu wrote:
> >>> Could you please add some printk so that we know which condition triggered
> >>> handle_stripe_fill() here:
> >>>
> >>>         if (s.to_read || s.non_overwrite
> >>>             || (s.to_write && s.failed)
> >>>             || (s.syncing && (s.uptodate + s.compute < disks))
> >>>             || s.replacing
> >>>             || s.expanding)
> >>>                 handle_stripe_fill(sh, &s, disks);
> >>>
> >>> This would help us narrow down to the exact condition. I guess it is
> >>> "(s.to_write && s.failed)", but I am not quite sure.
> >>
> >> Ok, I hit this bug on a stripe and got these values for the call:
> >>
> >>   to_read       = 0
> >>   non_overwrite = 0
> >>   to_write      = 0
> >>   failed        = 1
> >>   syncing       = 1
> >>   uptodate      = 2
> >>   compute       = 0
> >>   disks         = 3
> >>   replacing     = 0
> >>   expanding     = 0
> >>
> >> So it's actually the "(s.syncing && (s.uptodate + s.compute < disks))"
> >> condition that is getting hit.
> >
> > Thanks for the information! So the stripe is syncing. Could you please
> > try whether the following fixes the issue?
>
> Yup, thanks! Looks like that fixes my test case. I can do more general
> testing on it later this week.

Awesome! Could you please run more tests and submit the patch?

Thanks,
Song
