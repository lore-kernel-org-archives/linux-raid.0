Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41C3C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  4 Jan 2022 17:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbiADRk1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 4 Jan 2022 12:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbiADRk0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 4 Jan 2022 12:40:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33F5C061761
        for <linux-raid@vger.kernel.org>; Tue,  4 Jan 2022 09:40:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A7BF61320
        for <linux-raid@vger.kernel.org>; Tue,  4 Jan 2022 17:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94742C36AED
        for <linux-raid@vger.kernel.org>; Tue,  4 Jan 2022 17:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641318025;
        bh=tJa6aS8Ro3Sr+NP2XbYAPQZKd5noa4NknrkidiBVf5Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gd2Dp5XFqv6VitVWEmBlbke/nDkrS6byvClgIaFwgjGKReSkk8/McocgIL5lZdrKQ
         oMIiSuD7L6GE38dmwfHiRWRsFASUAuUfyRdBDotov3h1qqDxjIon0s+/dtUkov82Yq
         Id3pN4sjo/BcTn/wPmu7RO2JUfF0tvlKf2Bv1aUmJTNI6GQpCUfOTYdGbCV8QNmUM+
         Ops+irQJGYdlsJmE87dy6eKxS5Ut4NLaet4z0oBl9TWyPd05a0ky8TAPZhODPuB7Mu
         xEZ5xkzILr+1DscSys3asGtgJLvxT99qMM6u6Y20TbSBwAcs1/qdrCIYygeCq6KTa6
         VVSjtIyHpi4HQ==
Received: by mail-yb1-f171.google.com with SMTP id y130so85771188ybe.8
        for <linux-raid@vger.kernel.org>; Tue, 04 Jan 2022 09:40:25 -0800 (PST)
X-Gm-Message-State: AOAM530a8tszKErfojCI9RVuT3tYtARG2bN9UnbzcceX/j8u0OSCikw7
        SM/wccaFeX6hTZbHAuyF/j1KtBt6jnDZJT1lsAY=
X-Google-Smtp-Source: ABdhPJwJFTJfGR9wedxwiV56tkoWi6UWrBMtJNMk4gySeV14coiORDIRtwPPBuu61DH1Dc1gMny2atcUzrB4MvyuX40=
X-Received: by 2002:a25:8e10:: with SMTP id p16mr52916559ybl.219.1641318024716;
 Tue, 04 Jan 2022 09:40:24 -0800 (PST)
MIME-Version: 1.0
References: <20211229223407.11647-1-dmueller@suse.de> <CAPhsuW7N-_v7ivE6SXphgXiA4An0kruF+W25QrFhO15fkUZYfg@mail.gmail.com>
 <17479780.g37Zg15fLm@magnolia>
In-Reply-To: <17479780.g37Zg15fLm@magnolia>
From:   Song Liu <song@kernel.org>
Date:   Tue, 4 Jan 2022 09:40:13 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6KWinc5+SkPDbE5v4ExZdO7T0YeGTTDgDkb=ULSuxjwQ@mail.gmail.com>
Message-ID: <CAPhsuW6KWinc5+SkPDbE5v4ExZdO7T0YeGTTDgDkb=ULSuxjwQ@mail.gmail.com>
Subject: Re: [PATCH] Skip benchmarking of non-best xor_syndrome functions
To:     =?UTF-8?B?RGlyayBNw7xsbGVy?= <dmueller@suse.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jan 3, 2022 at 5:49 AM Dirk M=C3=BCller <dmueller@suse.de> wrote:
>
> On Sonntag, 2. Januar 2022 00:49:17 CET Song Liu wrote:
>
> > > For x86_64, this removes 8 out of 18 benchmark loops which each take
> > > 16 jiffies, so up to 160 jiffies saved on module load (640ms on a 250=
HZ
> > > kernel).
> > How critical is 160 (or 128?) jiffies saving here?
>
> For my usecase, this initialization codepath is just over 50% of the tota=
l
> runtime of my initrd, so it is significant. this is small initrd for virt=
ual
> environments, using however the standard distribution kernel image (which=
 has
> benchmarking enabled per Kconfig recommendation).

So this kernel has to use the default config? If this is the case, it
doesn't make sense
to add another config.

Thanks,
Song

[...]
