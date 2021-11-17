Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FFAC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 07:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE91663214
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 07:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbhKQHin (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Nov 2021 02:38:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231718AbhKQHin (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 17 Nov 2021 02:38:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E433D63214;
        Wed, 17 Nov 2021 07:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637134544;
        bh=N44w5Os4QL/V+SaWDMbE4P2BjS9zix/hcIm8DmTbf4w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tI7/qYvutIbRLm6HjE7mATlkiMDd8rEspH1CSBuMz4X35HEpBSh28w3MBOEfxver4
         EWozO4fZMoKJM1J8B/Lt9skeTQryS43yz/kG9PIrQkcjo1/j8tSbcPrWSYxmPd+EQK
         pvgYy1a1YIMolFCNwfY1MZat5iksgkcRD6duSh72m32k4lc/mIi0O480DHuXKSJ0RH
         CprGptOGXlPuoxJ2u3AOqqflJraz4XM7u83DLwGursu64gAqnhY52JyjQHYFV21Vbu
         Gb/RmCoa6xoVCBJ5yjjkOjJ2uV0dPb1a8wX/iQAxlTekLzUiGX0Q6dwmCVjFlNtNKJ
         WFevxX0WdqdCw==
Received: by mail-yb1-f173.google.com with SMTP id v7so4951850ybq.0;
        Tue, 16 Nov 2021 23:35:44 -0800 (PST)
X-Gm-Message-State: AOAM533VXgA7JDGVJqvqy+JdK8uke73O2EatsAuRSN9bbKvX49aGWiyG
        qThf9ZcJ3YsT36dsPgrp6M5UnIaWeygNjW0s0E0=
X-Google-Smtp-Source: ABdhPJyRAXtVA2AsIc287lJBREVCHbk2Tc5yT5VRV055qicfQswQHtCzYITZSuFFw2cpR/xRhfcJbygvABhj65sf3rU=
X-Received: by 2002:a25:324d:: with SMTP id y74mr15189196yby.526.1637134544179;
 Tue, 16 Nov 2021 23:35:44 -0800 (PST)
MIME-Version: 1.0
References: <20211116012317.69456-1-dave@stgolabs.net>
In-Reply-To: <20211116012317.69456-1-dave@stgolabs.net>
From:   Song Liu <song@kernel.org>
Date:   Tue, 16 Nov 2021 23:35:33 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7w9e2xNwacStU_Km9Q8evP5DcVatF8fW1DnKxJJ0L3NA@mail.gmail.com>
Message-ID: <CAPhsuW7w9e2xNwacStU_Km9Q8evP5DcVatF8fW1DnKxJJ0L3NA@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: play nice with PREEMPT_RT
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <dbueso@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Nov 15, 2021 at 5:23 PM Davidlohr Bueso <dave@stgolabs.net> wrote:
>
> raid_run_ops() relies on the implicitly disabled preemption for
> its percpu ops, although this is really about CPU locality. This
> breaks RT semantics as it can take regular (and thus sleeping)
> spinlocks, such as stripe_lock.
>
> Add a local_lock such that non-RT does not change and continues
> to be just map to preempt_disable/enable, but makes RT happy as
> the region will use a per-CPU spinlock and thus be preemptible
> and still guarantee CPU locality.
>
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>

Applied to md-next.

Thanks,
Song
