Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BABC4338F
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 05:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D5E0619EB
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 05:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbhHPFXb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Aug 2021 01:23:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232972AbhHPFX3 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 16 Aug 2021 01:23:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E173A619EE
        for <linux-raid@vger.kernel.org>; Mon, 16 Aug 2021 05:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629091378;
        bh=8T2vV4aQbCD4eKDsd1v0MNuXfB2Zz1uTHKgbj5qS9LI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NKNydNuSDRueSATTuapFQJsRESiUTLwnD7x6hQfItfZELpNVevkIqVLVwAppR9nN0
         vrSiDqIYHl5je6gHUO8qW9Y9rWogeplA9F0dNGY8WFFsL4yJJjB0EFylGUYyk+KurB
         R0BhExtlaZAFB9My12SgSqViWSLK4H5rWfSgslNiEyye+mn9xnyKW+7yMqhKbysU/T
         9fKITGSh4IefYEQw3dGO15odNW0EYr30Uhl0Qi1Hnpee2OEB7haPZztFRvdPIJe6hR
         BP77qy+boJIu2UPRuTwSXi1VkQK7i4VhczbVc6WGG1FmCQEGTdzew1DV16/GvufPkV
         QTyHRzYyjbpNQ==
Received: by mail-lj1-f176.google.com with SMTP id i28so4044459ljm.7
        for <linux-raid@vger.kernel.org>; Sun, 15 Aug 2021 22:22:58 -0700 (PDT)
X-Gm-Message-State: AOAM531b3mPKBZqMQd56QWWa36hykGR8ukaLWmPGyhn/6IcFhjZIfeF1
        5P1pmRIFwYs2aCvsvDnt8gIaQZCOGp5NxN4/CW4=
X-Google-Smtp-Source: ABdhPJzylGf/ZQdzt1bJWSYnlYXSuLQW6nDzxQKDpe8xAgZCaC3pTD4vF2S2+/gfNQ6jq1uoUhaFhCYAXSYoKxnZ3mU=
X-Received: by 2002:a05:651c:390:: with SMTP id e16mr6475541ljp.344.1629091377208;
 Sun, 15 Aug 2021 22:22:57 -0700 (PDT)
MIME-Version: 1.0
References: <1628481709-3824-1-git-send-email-xni@redhat.com>
 <CAPhsuW6iGBrdso3yStTxxv00qxLbW_gP_2H1CMsi5YzPFU5aqA@mail.gmail.com> <CALTww2-a0jw-LAqsZc8hDY49TqCCEX9KB4J14g2j7tDR3XF+GQ@mail.gmail.com>
In-Reply-To: <CALTww2-a0jw-LAqsZc8hDY49TqCCEX9KB4J14g2j7tDR3XF+GQ@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Sun, 15 Aug 2021 22:22:46 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4Ev3WBqkFBCVE7h4T8mw4N3GyEmT0tp5StdSs+-UpeBw@mail.gmail.com>
Message-ID: <CAPhsuW4Ev3WBqkFBCVE7h4T8mw4N3GyEmT0tp5StdSs+-UpeBw@mail.gmail.com>
Subject: Re: [PATCH 1/1] md/raid10: Remove rcu_dereference when it doesn't
 need rcu lock to protect
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Aug 13, 2021 at 6:34 PM Xiao Ni <xni@redhat.com> wrote:
>
> Hi Song
>
> It can improve the performance. It needs to add rcu lock when calling
> rcu_dereference.
> Now it has a bug. It doesn't use rcu lock to protect. In the second
> loop, it doesn't need
> to use rcu_dereference when getting rdev. So to resolve this bug, we can remove
> rcu_dereference directly.

In the second loop, we only use rdev and rrdev when bio and repl_bio
exists. So we shouldn't trigger the "bug" in any cases, right?

Please:
1) If you do think this is a bug, add a fix tag, so we can back port to stable.
   (while I still think it is not a real bug).
2) move struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev); to
  under "if (r10_bio->devs[disk].bio)"; and the rrdev ... to "if
(repl_bio)". And add
  a comment there so it is more clear in the code.

Thanks,
Song
