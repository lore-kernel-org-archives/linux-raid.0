Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2908DE7734B
	for <linux-raid@archiver.kernel.org>; Fri, 29 Sep 2023 23:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjI2Xn7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 29 Sep 2023 19:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjI2Xn6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 29 Sep 2023 19:43:58 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD965EB
        for <linux-raid@vger.kernel.org>; Fri, 29 Sep 2023 16:43:55 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1c723f1c80fso45213605ad.1
        for <linux-raid@vger.kernel.org>; Fri, 29 Sep 2023 16:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696031035; x=1696635835; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XxXRgVO4X0oKRg65wlMjf/8hMDTc8L5/nBKtcjEkozU=;
        b=Hmj/u6JX3APrdAtp+lWft1v2b2K7cwvLYfnu+z8b3s1WYhckbuHMr1IBmkzPir84R3
         OAavnQIx9fgd/xcemBXRDE/upbNAdSLRlMyRXMsxKRzbg/ZLzjopNvNYTGqGeiPnE0in
         MNE9wzIU6E9nvj8sf2u8oxRs7Br/+50ZuWb9U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696031035; x=1696635835;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XxXRgVO4X0oKRg65wlMjf/8hMDTc8L5/nBKtcjEkozU=;
        b=ljAR4i0+cMDqG/OAsPW8x1PZFnt02kZ5T5bT0pr9ysz5ade0UxwjVnZy9TZVirnW3Q
         I56RLt8Sy+GDvXByFt4rV2ceMSxWU61XSPmts1gjoB3I53K6Qdcw9r2vDfbnv8JFWuRq
         2Fe1UWjIqjotOEi/hrTPHSr56uK+ugrh5sNn5delNp6CX7GbCmLqMgV96Fa275I8zaMj
         bQp7THHM4aVVVEfvZVdNF+UVyDLf0wZnAd4V7OlQ5h7hm2fT46BvDGsOM+Zu7m5yjq4k
         Hdp0oUmCVxkBzMJTtc07HLKzq+NtLlr6gQ5XHIAlNiDOmnyzCW6Dc2EDaKnTama8yY8K
         Be+Q==
X-Gm-Message-State: AOJu0YwZmhMLHt5YpdZDeEWPkvM1zvmhrWVor/rewpZEKA373+5pq6Cp
        eZMRfbzUYh5BmzwcQ4HhAC03jA==
X-Google-Smtp-Source: AGHT+IFoyjufbN/+tXciMnWrLm1gtDSKSS/anCouRumZaJShGMHHhX6IW7ptFVzMTxsQrVkg++m9jw==
X-Received: by 2002:a17:903:25d4:b0:1c6:112f:5d02 with SMTP id jc20-20020a17090325d400b001c6112f5d02mr4765528plb.55.1696031035416;
        Fri, 29 Sep 2023 16:43:55 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id f9-20020a170902ce8900b001c5076ae6absm17466616plg.126.2023.09.29.16.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Sep 2023 16:43:54 -0700 (PDT)
Date:   Fri, 29 Sep 2023 16:43:53 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Song Liu <song@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] md/md-linear: Annotate struct linear_conf with
 __counted_by
Message-ID: <202309291643.BF67044DA@keescook>
References: <20230915200328.never.064-kees@kernel.org>
 <169601526973.3013632.16756928162777602693.b4-ty@chromium.org>
 <CAPhsuW6RfCryssufHjWHRdUGCh2DywnNNtidZ-UxEWvwo4gcbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW6RfCryssufHjWHRdUGCh2DywnNNtidZ-UxEWvwo4gcbQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Sep 29, 2023 at 04:40:13PM -0700, Song Liu wrote:
> On Fri, Sep 29, 2023 at 12:21 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Fri, 15 Sep 2023 13:03:28 -0700, Kees Cook wrote:
> > > Prepare for the coming implementation by GCC and Clang of the __counted_by
> > > attribute. Flexible array members annotated with __counted_by can have
> > > their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> > > (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> > > functions).
> > >
> > > As found with Coccinelle[1], add __counted_by for struct linear_conf.
> > > Additionally, since the element count member must be set before accessing
> > > the annotated flexible array member, move its initialization earlier.
> > >
> > > [...]
> >
> > Applied to for-next/hardening, thanks!
> >
> > [1/1] md/md-linear: Annotate struct linear_conf with __counted_by
> >       https://git.kernel.org/kees/c/9add7681e09b
> 
> Hmm..
> 
> Jens pulled this into his for-next branch and for-6.7/block branch
> earlier today:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=for-next&id=e887544d7620f1d3cef017e45df7bc625182caff
> 
> Do we need to do anything about this (drop one of them)?

Whoops! Sorry, I hadn't seen it picked up. I'll drop it from my tree.
Thanks!

-Kees

-- 
Kees Cook
