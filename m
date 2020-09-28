Return-Path: <SRS0=1sSQ=DF=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70BD2C2D0A8
	for <linux-raid@archiver.kernel.org>; Mon, 28 Sep 2020 17:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35E64207E8
	for <linux-raid@archiver.kernel.org>; Mon, 28 Sep 2020 17:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601313360;
	bh=hG45RqUN7XWW7bC3KIY+LiLKb8+Z9wn794xkqf/TRyw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=sgb33GX57GXN6f0hREyf8nakkTEiJ19JfBCLnRNhmOGxi4Npn44qHhd8J0MV7FtOQ
	 jPIYYrQcjafQhmc9IL0S0Bp8/cDDXYVin/LKmvp/WXhrcYIctLkcfRWRGVaaQ59SI4
	 WBhiPAmAfbfrVpEiirKZYHX8xVFcd+uXGRrBj5ro=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgI1RP7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Sep 2020 13:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbgI1RP7 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 28 Sep 2020 13:15:59 -0400
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C41052100A
        for <linux-raid@vger.kernel.org>; Mon, 28 Sep 2020 17:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601313359;
        bh=hG45RqUN7XWW7bC3KIY+LiLKb8+Z9wn794xkqf/TRyw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iDde3y7kPPLo2mXY62QNrCSxx8uqlEHNJ1vf8VdKdB+EXLd3e+uI+zehTkLMnSYzq
         hGdfH/qjDSKoNNAb1Ssg981L3WaCntYdOM6/ORmQtfOPozNDVR+NClvJgWvYLWIzaS
         giRvnf5Z4zjBnSOTCp+XElkKorIX8goesjmFd/M4=
Received: by mail-lf1-f49.google.com with SMTP id b12so2173060lfp.9
        for <linux-raid@vger.kernel.org>; Mon, 28 Sep 2020 10:15:58 -0700 (PDT)
X-Gm-Message-State: AOAM532CyFq0WpSMT+N1NPH2MWM1xsrNTm8vrfzmL9EqKXHAg1T7lPLp
        k0CJc1CJwd4GO9U/D23WfeUpqFvPZerZXD9dVFU=
X-Google-Smtp-Source: ABdhPJzLMoBt9WsGlMfXsiWP5thLW96nZl9Yc7Kcka+HTSe2TV1htnuaHB9rlkNjYR3YHRf20LrOWrROXdLYvI1nGiw=
X-Received: by 2002:a19:8907:: with SMTP id l7mr748538lfd.105.1601313357132;
 Mon, 28 Sep 2020 10:15:57 -0700 (PDT)
MIME-Version: 1.0
References: <6F1A48DB-CA95-433B-91F3-D0051453A8E1@amazon.com>
 <CAPhsuW6q5bLgOUyuTH8MFTo6GSnGqRxne6sV+dsFHRy_qHtxRA@mail.gmail.com> <1600734878242.50073@amazon.com>
In-Reply-To: <1600734878242.50073@amazon.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 28 Sep 2020 10:15:46 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4Q-aYzUQ=Utw6XigjJ0tVbCZOjmn+Wq6hvvjXhvAiwZA@mail.gmail.com>
Message-ID: <CAPhsuW4Q-aYzUQ=Utw6XigjJ0tVbCZOjmn+Wq6hvvjXhvAiwZA@mail.gmail.com>
Subject: Re: RAID5 issue with UBUNTU 20.04.1 on my desktop
To:     "Sung, KoWei" <winders@amazon.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Duan, HanShen" <hansduan@amazon.com>,
        "Tokoyo, Hiroshi" <htokoyo@amazon.co.jp>,
        "Fortin, Mike" <mfortin@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Sep 21, 2020 at 5:34 PM Sung, KoWei <winders@amazon.com> wrote:
>
> Hi, Song Liu:
>
> May I know if you're able to reproduce this issue? Thanks a lot for your help.

Sorry for the delay.

Yes, I was able to reproduce the issue. But I haven't got a proper fix
yet. Hopefully
I will be able to fix it soon.

Thanks,
Song
