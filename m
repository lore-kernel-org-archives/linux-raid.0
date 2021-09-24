Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF94C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 24 Sep 2021 21:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B07C60F4C
	for <linux-raid@archiver.kernel.org>; Fri, 24 Sep 2021 21:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347320AbhIXVUT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Sep 2021 17:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233640AbhIXVUS (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 24 Sep 2021 17:20:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05F1E611C8
        for <linux-raid@vger.kernel.org>; Fri, 24 Sep 2021 21:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632518325;
        bh=+wXdREw3pSoXnn/6AlcSoE5wUXbNP+IFp8fvFkxaMDU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CJtUKSweOZ+6v2SGChkGbVryIwgN2GZ0PeKhaB2lp0bDWfTMNkTUp8ydVXCMeA3B1
         K89X5MZEU6erFqmIzSwC83gn6QKcE+VyBf1kiMS7McaYWMx+r/Vcke7N1vh5TAMvfG
         QznblmidpCmy6qXvHi+wcZDUVivJx8RMJ9fpfQLuhACofgFOteVonSwKSIBfmq5+tx
         LPlZF1FDQQ8MSEK/lkdNZleBK83iha6pjMtnxiDyYvMW9Vk24I9Oye1i9+N21LdgW2
         JnDhb+DTL7ZFvzTMH84iSBKTIcCl9OEPZl2Htn4rCTExbO+bpr+WrNCeWh0t0nILDM
         M3CdqRB7CIcfg==
Received: by mail-lf1-f52.google.com with SMTP id g41so45512939lfv.1
        for <linux-raid@vger.kernel.org>; Fri, 24 Sep 2021 14:18:44 -0700 (PDT)
X-Gm-Message-State: AOAM533HiGyNWXTadGnuFljIQZPgRGzvODsjxP59vXfuNIQIJ8aONtXH
        XwWLeOg0fF2Tcn8l6vtvd9XdFR31bHBDOtdNRVY=
X-Google-Smtp-Source: ABdhPJx7ctwvpVTtRZNvxiCjfKy6k4yohP2CjilUpHNQsYSspkCChYgzCvF6nPqqupzJNi5xT4ORvv6BzsoaB6Do5tw=
X-Received: by 2002:a05:651c:1790:: with SMTP id bn16mr13059260ljb.457.1632518323396;
 Fri, 24 Sep 2021 14:18:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210917153452.5593-1-mariusz.tkaczyk@linux.intel.com> <20210917153452.5593-3-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20210917153452.5593-3-mariusz.tkaczyk@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 24 Sep 2021 14:18:32 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6Xi6-haPcX-MNA3EVcPiuLsQ52wVXtubbiswrpMRxGBg@mail.gmail.com>
Message-ID: <CAPhsuW6Xi6-haPcX-MNA3EVcPiuLsQ52wVXtubbiswrpMRxGBg@mail.gmail.com>
Subject: Re: [PATCH 2/2] raid5: introduce MD_BROKEN
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Sep 17, 2021 at 8:35 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Raid456 module had allowed to achieve failed state, distinct from other
> redundant levels. It was fixed by fb73b357fb9 ("raid5: block failing
> device if raid will be failed").
> This fix introduces a bug, now if raid5 fails during IO, it may result
> with a hung task without completion.

It will be great if we can add repro steps and/or hung stack trace here.

> Faulty flag on the device is
> necessary to process all requests and is checked many times, mainly in
> anaylze_stripe().
> Allow to set faulty flag on drive again and set MD_BROKEN if raid is
> failed.
>
> Fixes: fb73b357fb9 ("raid5: block failing device if raid will be failed")
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

For both patches, please provide more information about what is being
fixed and describe the behavior.

Thanks,
Song
