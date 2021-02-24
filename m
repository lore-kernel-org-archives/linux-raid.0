Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220FCC433DB
	for <linux-raid@archiver.kernel.org>; Wed, 24 Feb 2021 08:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C94C8600CC
	for <linux-raid@archiver.kernel.org>; Wed, 24 Feb 2021 08:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbhBXIrW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Feb 2021 03:47:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234477AbhBXIqF (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 24 Feb 2021 03:46:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60E9460233
        for <linux-raid@vger.kernel.org>; Wed, 24 Feb 2021 08:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614156324;
        bh=rNrPy3GzOT7R5pd5/UBSV4jTwVabBhtV1dX3y9NKmHs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=B+d5K39wdeKpkaT+eXpf6VTPrwk7L8LRHEuUdhvX/uh5kIeGAcCrlfiyH6Ny7AngX
         G/lxJIQbeiUld2iBKti9QcnwA/S5XhzpxOxXm5IbK+mxhWLHcrLsyPg3Si7DCWE9Jf
         QVdM/hpA/wzy3bd3S19B+R2O7/aiYyTEUbrOuoj+IK6tYh3/DpmzA5benOah9iYMog
         MOOoeYGxcPtrVVrn8bDWG6gY2OJpoVYNRwirroGHedx/ifP5NK5RUk2hZ/FWWHonaR
         AQQ5UV4D0TOhfuB3ipQasKSTIcvUDER823awPZmr8xsZsEZFpKjlgK53DauA9yzXHy
         GmReouAjvCQ4A==
Received: by mail-lj1-f181.google.com with SMTP id q23so1467102lji.8
        for <linux-raid@vger.kernel.org>; Wed, 24 Feb 2021 00:45:24 -0800 (PST)
X-Gm-Message-State: AOAM530lucuC/bXWvFbe35X5frfeJoPbUXkG3tB6LvOm98Y9tYYqozuI
        2oZu2i9erfpI1WN8XTwnFBRgdsW18zWsR20NJo0=
X-Google-Smtp-Source: ABdhPJxezxXBo8EvRnhu3wSfgmqrA5PQhwku6viC41R1nuE91D7FAGHxe1nZUr8ly4xB/zT/DCIMCMfyQdXvBKKqZ0g=
X-Received: by 2002:a05:651c:1355:: with SMTP id j21mr16610936ljb.270.1614156322605;
 Wed, 24 Feb 2021 00:45:22 -0800 (PST)
MIME-Version: 1.0
References: <20210201131721.750412-1-hch@lst.de> <656b8eb7-b2a1-b6ac-5620-29cb59fe5def@kernel.dk>
 <60682445-c768-f003-157d-9c768c54983e@linux.intel.com>
In-Reply-To: <60682445-c768-f003-157d-9c768c54983e@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 24 Feb 2021 00:45:11 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7ao2_N0i-N6XYMxN4d3LOz7d+ZkrtEGUpCMOi2fCzgjA@mail.gmail.com>
Message-ID: <CAPhsuW7ao2_N0i-N6XYMxN4d3LOz7d+ZkrtEGUpCMOi2fCzgjA@mail.gmail.com>
Subject: Re: md read-only fixes
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 18, 2021 at 1:31 AM Tkaczyk, Mariusz
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On 01.02.2021 17:35, Jens Axboe wrote:
> > On 2/1/21 6:17 AM, Christoph Hellwig wrote:
> >> Hi all,
> >>
> >> patch 1 fixes a regression in md in for-5.12/block, and patch 2
> >> fixes a little inconsistency in the same area.
> >
> > Applied, thanks.
> >
>
> Hi Song,
> Could you cherry-pick those fixes? The issue blocks our daily tests.

I rebased md-next on top of Linus' master branch. Could you please try the
tests?

Thanks,
Song
