Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9546CC00144
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jul 2022 23:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239965AbiGZXQ4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jul 2022 19:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiGZXQy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Jul 2022 19:16:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3251180F
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 16:16:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58D0D616D4
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 23:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF36C4347C
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 23:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658877411;
        bh=wlpVRNxrp/2oSwuoR14smduQ8A5njSua1xU41ONjV/c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ghTxxjjkujTNm/pKTkoLeoiZnVtV4lfq3ZcFB6tnhxE9SutrtWaQUXj2O6M5K9+Bf
         aVul4EGokrDR4dLrSqM6Eda+klO3kGxqVvTJnO631D0LARIY9vSA5aka4B6UKsetPY
         GzYd2s9w1+Dxcbd9SImsq/Rm0va7v7r42tA+9rhHPjtRbRGVx/DKHKJXfA4nqST6YN
         yh7n6K03tLE2PCdaguwIHvBbWSoZg1AB/krHLdKGbROA5g6QYqgMj88RsbRcrCLGlg
         TQCZ0rNWlQaEobQEKMrwRsnLPADeF8kArHjloLIbH1DFREIWXA9tYxin+22QsXOXLd
         QwepIm163rGyw==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-31f1d1c82c8so65362537b3.8
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 16:16:51 -0700 (PDT)
X-Gm-Message-State: AJIora8j4VwtGN4EZ4Ep46XVWydwKITQNbYKyGuOzbYyukXnXH+PUGJ5
        wmQ63UJIj23qKKtLWQVmPAZlZVgxhE+mW7xjF3I=
X-Google-Smtp-Source: AGRyM1vWZE5OhW9j5XLeV/tHLepeKUf7YRkdVjPZyWkLiCISpShi/wvs0On2FAmaT/BvqdOMeMhMXYxDPKDGbbkAHyo=
X-Received: by 2002:a0d:f746:0:b0:31e:80dc:725f with SMTP id
 h67-20020a0df746000000b0031e80dc725fmr17254605ywf.460.1658877410696; Tue, 26
 Jul 2022 16:16:50 -0700 (PDT)
MIME-Version: 1.0
References: <035EEBB9-EAF5-4D48-9836-70E1FDEE8F13@fb.com> <5be77989-c2a7-cb23-8387-2daf1f562a06@kernel.dk>
In-Reply-To: <5be77989-c2a7-cb23-8387-2daf1f562a06@kernel.dk>
From:   Song Liu <song@kernel.org>
Date:   Tue, 26 Jul 2022 16:16:39 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5UnKXjQT0Vata4OG0+pi_=7SB0OkjrAb+5os=Uo_=6bw@mail.gmail.com>
Message-ID: <CAPhsuW5UnKXjQT0Vata4OG0+pi_=7SB0OkjrAb+5os=Uo_=6bw@mail.gmail.com>
Subject: Re: [GIT PULL] md-next 20220726
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Yang Li <yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jul 26, 2022 at 4:07 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/26/22 4:27 PM, Song Liu wrote:
> > Hi Jens,
> >
> > Please consider the following changes for md-next on top of your
> > for-5.20/drivers-post branch. The major change is
> >
> > 1. Refactoring md_alloc(), by Chrstioph.
> >
> > Thanks,
> > Song
> >
> > The following changes since commit 2dc9e74e37124f1b43ea60157e5990fd490c6e8f:
> >
> >   remove the sx8 block driver (2022-07-25 17:25:18 -0600)
> >
> > are available in the Git repository at:
> >
> >   ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
>
> I fixed up Christoph's name and I think you used the wrong pull
> location, used https://git.kernel.org/pub/scm/linux/kernel/git/song/md
> md-next as per usual and the diffstats match up.

I am really sorry for the mistakes. And thanks for the fix-up.

Song
