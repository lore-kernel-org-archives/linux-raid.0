Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B27C07E96
	for <linux-raid@archiver.kernel.org>; Thu,  8 Jul 2021 05:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 903D961CDF
	for <linux-raid@archiver.kernel.org>; Thu,  8 Jul 2021 05:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhGHFVD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Jul 2021 01:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhGHFVC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Jul 2021 01:21:02 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A0BC061574
        for <linux-raid@vger.kernel.org>; Wed,  7 Jul 2021 22:18:20 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id k16-20020a05600c1c90b02901f4ed0fcfe7so3113532wms.5
        for <linux-raid@vger.kernel.org>; Wed, 07 Jul 2021 22:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8D3kCpp8FwbnI6L46V3ylmrbBBHI/QtWBsUm+oVBIUQ=;
        b=ghSBM8z7jGzgVkg4rcHR3QbAQjNRGR3wWTwOKE3Y5NGZMgwIwJR/wgkinhNg8KLcHz
         jNL9xgBSbB6eNYPBGyeJeTI/A/FP3ppQP9UlxMeIMb/Hb7v8VW18+8Aew/z7JgXmcMWN
         NegOxWVGA3OIbah90mfzpScrgShCCmOtj90/cHwOxu/jQfjsI3CNIQY0xeLtTWd2Rgpl
         YrihcFVBV6CJl6r+t511lrD/yWJvRDpAPsWAp4RCRB2Sh8Ntu0S+ZAMI2uSJ3NflFJiJ
         22rR3q34fu6HGh+hsPna6rp2JgJg/k/0SAlZQuQg1o44igRdIv1FcXERh+1fyAfc6uds
         kUfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8D3kCpp8FwbnI6L46V3ylmrbBBHI/QtWBsUm+oVBIUQ=;
        b=sbeUYS9fh0uhgT7XYCysRBbWL7lsbMKW78T7OzwJgN9IySkPlSPLC/3SWOrvBcTIzW
         m+zOxt1JRlzzg62kqdEXhUH+MSIJctORUeVf8kk1BS19eLQsc592MnGm2E3W0FtFjQ45
         v+Q7Ewp/DBMv5bLfY2WOX6fwscH/OCS1Wi/HXzfkjfGVccH5//fUTBhqBRlaByKp70KP
         lBX5o2q5obZP0VL81pxwzrcMbKk5V3F/dprw3waHgAPJ9sP/mW2xINJ0CBFSV2o91b7q
         V4stSfCZMu+w+hQSB3iQrNOdswA/m8SeM9t2O3Y+S3RcBC+YlpbF3tTMv02CF8RuBVwl
         NbTA==
X-Gm-Message-State: AOAM532zU/6wSXhOFdzZKNO9QAJhDDd7lRMcfuebCyr7qhW3tW7mkX7d
        zXysrzb/w/YL5jrzS8FfXsJVBOzuZdSP2enTdXg=
X-Google-Smtp-Source: ABdhPJwy0I8sLAth9kC9fHgaBJ/1ZenOGjnOFzxG1g8qbQV1BlfQdhiqZ1/wrmJQYOU8DX/rnT9eTZZHgTEoYPq4GPk=
X-Received: by 2002:a05:600c:2ca4:: with SMTP id h4mr12946514wmc.37.1625721499159;
 Wed, 07 Jul 2021 22:18:19 -0700 (PDT)
MIME-Version: 1.0
References: <CADcL3SDfzw+PZHWabN0mrHFuyt1gVtD6Owf_bNpFT=xV-JrVVA@mail.gmail.com>
 <CAOaDVC6yNDOVAvMu4gBuc+sTH50UrXD3z4sODa1NtFsV9SEZ9Q@mail.gmail.com>
 <CADcL3SBwbiZJgXVOOTqV2UPqTg=eJwG=ZDCwgzTd9Ez8FH5D6w@mail.gmail.com> <162569672750.31036.1684525188878933981@noble.neil.brown.name>
In-Reply-To: <162569672750.31036.1684525188878933981@noble.neil.brown.name>
From:   BW <m40636067@gmail.com>
Date:   Thu, 8 Jul 2021 07:18:07 +0200
Message-ID: <CADcL3SAWbA8C5c41MeuBczatmikUu0NMPY+1jjoy54AyObJVJA@mail.gmail.com>
Subject: Re: --detail --export doesn't show all properties
To:     NeilBrown <neilb@suse.de>
Cc:     Fine Fan <ffan@redhat.com>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

1: Just because the array is inactive doesn't mean the information is
not valuable, actually it's even more,  as your most likely needs your
attention
2: The information is available and is printed when not doing --export
3: I'm aware of --examine, but why use it when the kernel already read
the superblocks when the disks were initialize, the information is
already there

In my view I don't see any argument for not including the raid level
etc. when the raid is inactive.

I'm building a administration-system where the use of --export is very
handy. I can do work-around calling additional commands to get the
info, but it would be nice if --export just provided the information
in the first place.

On Thu, Jul 8, 2021 at 12:25 AM NeilBrown <neilb@suse.de> wrote:
>
> On Wed, 07 Jul 2021, BW wrote:
> > I'm using ver. mdadm-4.1-24.3.1.x86_64 / openSUSE kernel 15.3
> >
> > It's only when the array is active you get a raid-level, if the array
> > is inactive, as in my example, you will not get the raid-level (and
> > State, Persistence).
> >
>
> Yes, that is correct.
> When the array is inactive, it is not an active array.  It has no level
> or state.  It is just a bunch of drives.
>
> If you want to see what might happen when you activate the array, you
> need to --examine the indiividual drives.
>
> NeilBrown
