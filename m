Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166DAC5519F
	for <linux-raid@archiver.kernel.org>; Fri, 20 Nov 2020 13:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B97082224C
	for <linux-raid@archiver.kernel.org>; Fri, 20 Nov 2020 13:05:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pzOKyUcE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgKTNFD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 Nov 2020 08:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgKTNFD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 Nov 2020 08:05:03 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C840DC0613CF
        for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2020 05:05:02 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id v22so9424594edt.9
        for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2020 05:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XTv40l/lfzil5RJB2plnV9h3eE+HsTJplgZELLPp9jw=;
        b=pzOKyUcEnalq+O3tqwX21YIh2lF3WXZgQmrPsbM3iwN8dMTdGCD4FdvxWHlfyHCy86
         c1aa8MUv9sdr/NjuEu+fR0sF5nZPhhnzS3779gAz02r7XANk1XeswW5A3lfah+OwF4Rp
         8LlPOvFGZpsQBGAbpLMRhA+awMKYRj7PGJjweDOi5/WTlvqV7nqQHnKEz2T6vhxqoL2l
         62l0KfMzuJJL+iGzEuiI8FX1o4EthxeiG7KzEhb17UJmhpw3uWPYGzwKWtz/VvKmTavh
         WeCyXsI1L3sjg78RdihS2hnm6twxN1crl0HBKH3QXhcXEi0deNg7IcgnjHS6+uUABEhs
         lWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XTv40l/lfzil5RJB2plnV9h3eE+HsTJplgZELLPp9jw=;
        b=gRLwSlDWjfCpWdDlYLdNUeG67K8lu4a3M4MyPJNgo4HnTarL1lmgF3SI/iXhVagOH0
         kLx0pWJ/+6gJliUQ4hEVFNDo4PU7cDHdBuwmCidXhRUKW4ZUcFJ4YwwNJY5Qf/gusC2B
         sqxs6dYXIBktZ7W1LSnMYTOa8jcHgr8+qtOBHp41r1PuofIQHSWSJ6056qHjNWD/doHU
         4LmYTIPi5AuzQZQHaQgZQbFsNWDdQV9KpRu3tNXe3hg0oqeSWWMc1TAcUhFggI1+s5oY
         bQKiCkZ9NRkA9EFJIjX1qgJwCSPSfWR8Ize+WFdmHobpf/bkoM6X3uIKgU2BqqEnK5rr
         sPpg==
X-Gm-Message-State: AOAM532aHl3+142cAeC9mriKUJaQPVHYpEralkwNVPUszpjjAap/Mtv3
        dC6+Q/+6lVE947rxe4rdD4BEAbnR76tJGvBxWgk=
X-Google-Smtp-Source: ABdhPJxmcA8C95rOSm+VLhsO/oll5WZdrDl4LNFyxeLHNFzmOAp0QgcU0ZiHp1q8wf+rhlpgpPW+fvWm7nZvWRV8waQ=
X-Received: by 2002:a50:9f6c:: with SMTP id b99mr18506606edf.90.1605877501500;
 Fri, 20 Nov 2020 05:05:01 -0800 (PST)
MIME-Version: 1.0
References: <5EAED86C53DED2479E3E145969315A23856EEA12@UMECHPA7B.easf.csd.disa.mil>
 <fa14ca859160872fece3e2d3efc0a21c42bb9a4a.camel@oldum.net>
In-Reply-To: <fa14ca859160872fece3e2d3efc0a21c42bb9a4a.camel@oldum.net>
From:   Vitaly Mayatskih <v.mayatskih@gmail.com>
Date:   Fri, 20 Nov 2020 08:04:50 -0500
Message-ID: <CAGF4SLi92kDjgBZ_z9onFexsUpgEdPKgom6smHgsAgQ+23JisA@mail.gmail.com>
Subject: Re: Nr_requests mdraid
To:     Nikolay Kichukov <nikolay@oldum.net>
Cc:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Nov 20, 2020 at 5:43 AM Nikolay Kichukov <nikolay@oldum.net> wrote:

> Would it be possible to implement something similar to the use_blk_mq of
> dm_mod on md_mod?

One day, one day... Converting it to blk-mq with nr_queues=1 would be
more or less easy.
