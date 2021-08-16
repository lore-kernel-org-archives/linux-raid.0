Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B22C4338F
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 08:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CBEF61B46
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 08:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbhHPI7i (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Aug 2021 04:59:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33577 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235108AbhHPI7i (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 16 Aug 2021 04:59:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629104346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I3V73uT3Esk+djgcGxa63VZjWvbLs+nOS6+01Mnfpo8=;
        b=edgMQ6bYjZITM+UtAIqRtm+9C1iZXbyYEWivQQxNTIBRP3di0JTUNj7A9fIH8SnXgfBox0
        zZ40Zo4lR0eeiTQ38vljqBSgJr2X48oj6dSoM2uWA2AeR2fY0i1b0kqOQT98qWsx1JYuhw
        o/fespTD0RmJktJwEgMOIpODTTx+NT8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-D2Jl-PzEOvaAnPANjG3EKg-1; Mon, 16 Aug 2021 04:59:05 -0400
X-MC-Unique: D2Jl-PzEOvaAnPANjG3EKg-1
Received: by mail-ej1-f71.google.com with SMTP id nb40-20020a1709071ca8b02905992266c319so4404367ejc.21
        for <linux-raid@vger.kernel.org>; Mon, 16 Aug 2021 01:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I3V73uT3Esk+djgcGxa63VZjWvbLs+nOS6+01Mnfpo8=;
        b=A+O2jByGT5O8oiFQHq5HfsGYEHkEe+vFhHqnU3nfqLwa3UAbFXxgXNR6NrtvRiW8J/
         /OL4cb6lmPvv78NXVsYXZtRnmuiMDBHcBRllcjLnEA80E75FazFNplBP5zjH2BKRGIIy
         A1XVZIZNuLUcyJRqIzxIF5uX6s4IHk5VUXSM68M6+ylPQ65lsT5rvdYp6Aw6oe9K4uJ3
         Uyfq3cMn3S31SfWXGit5fwKsQNzuV9iDU0gPTPf2xfu89fXMCFglvWynl53JyRtC0YO/
         tSMCOG3JIRPVJVoL1nf0actyUQ/fshEjaOqkkDJa2GroRv7Nr/X2K7DZduE4RcjPGbsW
         UqoQ==
X-Gm-Message-State: AOAM533HPIXeRQ8EQxALWZ07sn4mCSEJJeuUsdPlVqg25HALouZCkTLj
        Vq1cGLIQkd1OZ8KUKTxoYRxsbkv+o4cIVnEo9uRGzjbPFI08/Fz6K7im06phAqlJPz9K5RVzM0E
        jtAnRtY0PBdZx1kJImL6eglrgtMR/Zcj7LjlquQ==
X-Received: by 2002:aa7:c347:: with SMTP id j7mr19146034edr.316.1629104344332;
        Mon, 16 Aug 2021 01:59:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdm4Q22tSrgddLQ2Lq5ecf1L41Wc5hFQHPjKvEE/P5kAsmxS2pBlREdhHfE8+YlOitoSXEAxuMlUBsaqQQKAQ=
X-Received: by 2002:aa7:c347:: with SMTP id j7mr19146024edr.316.1629104344173;
 Mon, 16 Aug 2021 01:59:04 -0700 (PDT)
MIME-Version: 1.0
References: <1628481709-3824-1-git-send-email-xni@redhat.com>
 <CAPhsuW6iGBrdso3yStTxxv00qxLbW_gP_2H1CMsi5YzPFU5aqA@mail.gmail.com>
 <CALTww2-a0jw-LAqsZc8hDY49TqCCEX9KB4J14g2j7tDR3XF+GQ@mail.gmail.com> <CAPhsuW4Ev3WBqkFBCVE7h4T8mw4N3GyEmT0tp5StdSs+-UpeBw@mail.gmail.com>
In-Reply-To: <CAPhsuW4Ev3WBqkFBCVE7h4T8mw4N3GyEmT0tp5StdSs+-UpeBw@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 16 Aug 2021 16:58:53 +0800
Message-ID: <CALTww2-mgBfiM8oMs8dE=F32d8oUTZwOiixFmVP=f+oCwmM=Lg@mail.gmail.com>
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

On Mon, Aug 16, 2021 at 1:23 PM Song Liu <song@kernel.org> wrote:
>
> On Fri, Aug 13, 2021 at 6:34 PM Xiao Ni <xni@redhat.com> wrote:
> >
> > Hi Song
> >
> > It can improve the performance. It needs to add rcu lock when calling
> > rcu_dereference.
> > Now it has a bug. It doesn't use rcu lock to protect. In the second
> > loop, it doesn't need
> > to use rcu_dereference when getting rdev. So to resolve this bug, we can remove
> > rcu_dereference directly.
>
> In the second loop, we only use rdev and rrdev when bio and repl_bio
> exists. So we shouldn't trigger the "bug" in any cases, right?

Hi Song

Sorry for not describing this problem clearly. It triggers a warning like this:

[  695.110751] =============================
[  695.131439] WARNING: suspicious RCU usage
[  695.151389] 4.18.0-319.el8.x86_64+debug #1 Not tainted
[  695.174413] -----------------------------
[  695.192603] drivers/md/raid10.c:1776 suspicious
rcu_dereference_check() usage!
[  695.225107]
               other info that might help us debug this:

[  695.260940]
               rcu_scheduler_active = 2, debug_locks = 1
[  695.290157] no locks held by mkfs.xfs/10186.

>
> Please:
> 1) If you do think this is a bug, add a fix tag, so we can back port to stable.
>    (while I still think it is not a real bug).
> 2) move struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev); to
>   under "if (r10_bio->devs[disk].bio)"; and the rrdev ... to "if
> (repl_bio)". And add
>   a comment there so it is more clear in the code.

ok, I'll fix these two places.

Regards
Xiao

