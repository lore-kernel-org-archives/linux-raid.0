Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26A7C433ED
	for <linux-raid@archiver.kernel.org>; Wed, 21 Apr 2021 17:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA59B6113B
	for <linux-raid@archiver.kernel.org>; Wed, 21 Apr 2021 17:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241502AbhDURjC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235434AbhDURjB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Apr 2021 13:39:01 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10069C06174A
        for <linux-raid@vger.kernel.org>; Wed, 21 Apr 2021 10:38:27 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id y14-20020a056830208eb02902a1c9fa4c64so3150997otq.9
        for <linux-raid@vger.kernel.org>; Wed, 21 Apr 2021 10:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=us-sios-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mwFk5JXSHYyEqYSYgfOSJzcXtw6WJfhhXlL/F87HwDs=;
        b=b657FshC5g6mHUkrSaCobeOQUdfBBLuEtCtoyTdHqs/+s3D1TebZnkY0u/2nuOx+gm
         gEAQJqDCjLAuODx0Ewi782f1RIc1gwrhVyGfUd3paj4CDyWu40joLT2zc9KOuBSvAoUk
         gD7P1wKtmjfDhRxgt80dHj5oBSXEv/SV9ICHP+pYoq2Dhs6vwoB+NI1wijygKGgCt3FH
         gpSa9wlB2ui/cMxwGeuvDAZpB/vmpVnVaVaQJEwiFhURGhie53Wmq7FDzuv1FmAEpRjM
         uuKIpYLKxlwbTWDrMC1P3C+FGg+T8QIwNDvkb0anL2KqNnWbJ6fNRg/5ERl4KxSfRDqw
         AZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mwFk5JXSHYyEqYSYgfOSJzcXtw6WJfhhXlL/F87HwDs=;
        b=pAB4Zpo8283MeZexKRqcnzOWA+jPH4J19mn2yAbfLcM5DdizUTLBMLhL30003zv2in
         VIYQE9gzhkP1cLirCVa46G8crCsSh9wH+Jjq2veYgqyZdhZddJMAubWRMOP24eeHhqgL
         KFk6u8D3p5N+j1BE6klkhktqGMmHz+ir7X23rF461xuvSyJM2OzuWFTk+xuS2RPRhEV3
         HH9PqfLaYxqmnzM707h1ekFn3/xr/di6hvEOvesSI94IqoR9o9kcX4tZLMcL5FY3+w03
         QaTgGimgsqKSOo3eKHzWpEdFq2cwaKPCTaHdIqMW8VSdbKg5HDafQN3usgyAivxBeDMO
         DeEw==
X-Gm-Message-State: AOAM533r5xXy0pdnhGZLuzRqm2Nt0kqTTGqssRdlp3jQ59J8xdm/Tux/
        AJdZjj1/ufvMLUyukYZ7EGOve2QkCwC685cBaxTzDxXrbP0=
X-Google-Smtp-Source: ABdhPJw7a7S1FQfbBbybzvI7Ck6azbHhMgpllJ+fKqF8eVU0SXpK7z3+kOg7y+wh3BlV0IU/5yligw5rmn4atQyoTg0=
X-Received: by 2002:a9d:7c8b:: with SMTP id q11mr11629549otn.140.1619026706385;
 Wed, 21 Apr 2021 10:38:26 -0700 (PDT)
MIME-Version: 1.0
References: <607f4fd0.1c69fb81.9f7e7.05ef@mx.google.com> <CAPhsuW4qW_mMfQuf3efn18AAt4xHQz25+YKjuynwDzzDYLY=Pw@mail.gmail.com>
In-Reply-To: <CAPhsuW4qW_mMfQuf3efn18AAt4xHQz25+YKjuynwDzzDYLY=Pw@mail.gmail.com>
From:   Paul Clements <paul.clements@us.sios.com>
Date:   Wed, 21 Apr 2021 13:38:15 -0400
Message-ID: <CAECXXi6iaOStikDmNpzEx+Urd_Y8xvyNEVNQitFr4p0nxtBCxg@mail.gmail.com>
Subject: Re: [PATCH] md/raid1: properly indicate failure when ending a failed
 write request
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Apr 20, 2021, 7:49 PM Song Liu <song@kernel.org> wrote:
> On Tue, Apr 20, 2021 at 3:05 PM Paul Clements <paul.clements@us.sios.com> wrote:
> >
> > This patch addresses a data corruption bug in raid1 arrays using bitmaps.
> > Without this fix, the bitmap bits for the failed I/O end up being cleared.
>
> I think this only happens when we re-add a faulty drive?

Yes, the bitmap gets cleared when the disk is marked faulty or a write
error occurs. Then when the disk is re-added, the bitmap-based resync
is, of course, not accurate.

Is there another way to deal with a transient, transport-based error,
other than this?

For instance, I'm using nbd as one of the mirror legs. In that case,
assuming the failures that lead to the device being marked faulty are
just transport/network issues, then we want the resync to be able to
correctly deal with this. It has always worked this way since a long
time ago. There was a fairly recent commit
(eeba6809d8d58908b5ed1b5ceb5fcb09a98a7cad) that re-arranged the code
(previously all write failures were retried via flagging with
R1BIO_WriteError).

Does the patch present a problem in some other scenario?

Thanks,
Paul
