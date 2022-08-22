Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBAD4C32789
	for <linux-raid@archiver.kernel.org>; Mon, 22 Aug 2022 07:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbiHVHEj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 Aug 2022 03:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiHVHEg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 22 Aug 2022 03:04:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285832ACB
        for <linux-raid@vger.kernel.org>; Mon, 22 Aug 2022 00:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1EFF60FBF
        for <linux-raid@vger.kernel.org>; Mon, 22 Aug 2022 07:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2F3C433D7
        for <linux-raid@vger.kernel.org>; Mon, 22 Aug 2022 07:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661151869;
        bh=7bvfLxOQLFjD77d5gCWuis5asBPZM9Cb4CCxsJ1GFUc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Q5KE1wpLZObdrKNfdWz8tOQomKgSb3l3NW0a6oELqxOgXmJgSzbDMDFqbdyT2fM6u
         K+IFhOO4J1vRnwMLoIWGGPu9DWP4RA12hGkf+k/cKFT9A2Z/i+6CvP5Ep8it/9cnJU
         brULnU88zOVeRE6FPd5CzqDPUbSBEcF/01B0Z62ipkcXBnRQyCjAGRov1kWmi0slBL
         u5bxYPFj7Tx8QSJRsBXpGsdMcgeyAY3AAssN59UTuheUY+F8DhQhDttbTGY+kD5z3H
         ucn89nYAVar5SJ49fBiFx4xtxnKdEd/x6Hi4ytZhyiYeb/tZc22E+ywfa4Noq+JIwn
         gCcZX7Q05jekg==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-333b049f231so268107947b3.1
        for <linux-raid@vger.kernel.org>; Mon, 22 Aug 2022 00:04:29 -0700 (PDT)
X-Gm-Message-State: ACgBeo0Bu+ObPrFG/B/8kBVvIeV9kWcvip5qFTjoCq9yBU8U5JopNWTo
        dxbsvX/PDgByfYz/nXyNmuKMXpfFYhMAD28xVJ4=
X-Google-Smtp-Source: AA6agR7Dz54fdcKxBf7C3ocTDmrgJxt2B/PobqcC0oEi9wRwUypn805WQAcEcKBVQJKzm4e3x/m0mprzJisYnqNCkN4=
X-Received: by 2002:a81:91d0:0:b0:335:10ff:8ee4 with SMTP id
 i199-20020a8191d0000000b0033510ff8ee4mr19098683ywg.73.1661151868144; Mon, 22
 Aug 2022 00:04:28 -0700 (PDT)
MIME-Version: 1.0
References: <e05c4239-41a9-d2f7-3cfa-4aa9d2cea8c1@deltatee.com>
In-Reply-To: <e05c4239-41a9-d2f7-3cfa-4aa9d2cea8c1@deltatee.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 22 Aug 2022 00:04:17 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4=aa08-XGDtoQ3rLb8r-5t9Q7VwwFgGbTTt-xbkzEW8Q@mail.gmail.com>
Message-ID: <CAPhsuW4=aa08-XGDtoQ3rLb8r-5t9Q7VwwFgGbTTt-xbkzEW8Q@mail.gmail.com>
Subject: Re: raid5 Journal Recovery Bug
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Aug 19, 2022 at 3:52 PM Logan Gunthorpe <logang@deltatee.com> wrote:
>
> Hi Song,
>
> I'm wondering if you can help shed some light on a bug I'm trying to
> track down.
>
> We're hitting the BUG_ON in handle_parity_checks5() that tests to ensure
> R5_UPTODATE is set for a failed disk in a stripe[1].
>
> We hit this in our test suite somewhat rarely when the journal is
> enabled doing device removal and recovery tests. We've concocted a test
> that can hit it in under ten minutes.
>
> After some debugging I've found that the stripe that hits the BUG_ON is
> hitting a conditional in handle_stripe_fill() for stripes that are in
> the journal with a failed disk[2]. This check was added in 2017 by your
> patch:
>
>    07e83364845e ("md/r5cache: shift complex rmw from read path to write
> path")
>
> A stripe that hits the bug has one injournal dev, and one failed dev and
> does not have STRIPE_R5C_CACHING set and therefore hits the conditional
> and returns from handle_stripe_fill() without calling fetch_block() or
> doing anything else to change the flow of execution. Normally,
> fetch_block() would set STRIPE_COMPUTE_RUN to recompute the missing
> disk, however that gets skipped for this case. After returning from
> handle_stripe_fill(), handle_stripe() will then call
> handle_parity_checks5() because STRIPE_COMPUTE_RUN was not set and this
> will immediately hit the BUG_ON, because nothing has computed the disk
> and set it UPTODATE yet.
>
> I can't say I fully understand the patch that added this, so I don't
> really understand why that conditional is there or what it's trying to
> accomplish and thus I don't know what the correct solution might be.
>
> Any thoughts?

Could you please add some printk so that we know which condition triggered
handle_stripe_fill() here:

        if (s.to_read || s.non_overwrite
            || (s.to_write && s.failed)
            || (s.syncing && (s.uptodate + s.compute < disks))
            || s.replacing
            || s.expanding)
                handle_stripe_fill(sh, &s, disks);

This would help us narrow down to the exact condition. I guess it is
"(s.to_write && s.failed)", but I am not quite sure.

Thanks,
Song
