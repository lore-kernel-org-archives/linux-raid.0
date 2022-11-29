Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E64FBC433FE
	for <linux-raid@archiver.kernel.org>; Tue, 29 Nov 2022 19:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236051AbiK2Tsf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Nov 2022 14:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbiK2Trc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Nov 2022 14:47:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D82F2DEB
        for <linux-raid@vger.kernel.org>; Tue, 29 Nov 2022 11:47:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7FD7B8164E
        for <linux-raid@vger.kernel.org>; Tue, 29 Nov 2022 19:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AABDC433D6
        for <linux-raid@vger.kernel.org>; Tue, 29 Nov 2022 19:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669751240;
        bh=cmyRsjvev2Rxl7pHV88vZgyL/g6i/kTG/L22C6PT1xk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CHtVxflnxN/SLBnIkKm0cUn5QH7ahQPnqT0qfsmUZZXMYCzm+ML4DB2gewjNJdr/O
         6kpCegMbb5F1wME2bvhnxT8JgtEn8jT1v4IxDmJiIboK93B/eDqADCurFAV/OB7Xl4
         rXt4LFrrFzaK8Ngkv0GGqC9bDW1RJpg/Mechgx8wlRwKLXAxcd7Fno0ArBnFr6yBIT
         UjP8A5hK496M9Z3pL2OPrgo+RXPaiTV3+EsmJeWjg7+s6KvApIa1gy9TtSvgyPWZoz
         SESVTR5lGZ/qQAY7SmBMuBkyeIPWUUgyT5CBI2UfaStU0VqMFG9S0D88hw6Gcv+70n
         3CcbjlDoOYGeg==
Received: by mail-ej1-f52.google.com with SMTP id td2so22261544ejc.5
        for <linux-raid@vger.kernel.org>; Tue, 29 Nov 2022 11:47:20 -0800 (PST)
X-Gm-Message-State: ANoB5pk2qjqId/k21YqNQSue0a1SfBpM9JgdyVeigt3wYex/iISNYx8L
        OCIcnkLCJTlVPlcF/rRk2A/B5zWM8Gv+q7g6DDY=
X-Google-Smtp-Source: AA0mqf496lfecGa+Tao38QnNfzV5NsXaFlpLqL3JfLMAxIkZzP7tXSIWcdHZl4z9Y1EExFxG1fGtNNhYjV7+utK70DM=
X-Received: by 2002:a17:906:3954:b0:7bf:852b:e23c with SMTP id
 g20-20020a170906395400b007bf852be23cmr10459199eje.614.1669751238678; Tue, 29
 Nov 2022 11:47:18 -0800 (PST)
MIME-Version: 1.0
References: <20221129133255.8228-1-hch@lst.de>
In-Reply-To: <20221129133255.8228-1-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Tue, 29 Nov 2022 11:47:06 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4k0otCdGFyo_sRpmK9VTUPNvc7f8QdXwvxD1D1KO596g@mail.gmail.com>
Message-ID: <CAPhsuW4k0otCdGFyo_sRpmK9VTUPNvc7f8QdXwvxD1D1KO596g@mail.gmail.com>
Subject: Re: minor md cleanups
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 29, 2022 at 5:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi Song,
>
> this small series has a few random md cleanups.

Applied to md-next. Thanks!

Song

>
> Diffstat:
>  md.c |   97 ++++++++++++++++++++++++-------------------------------------------
>  md.h |    1
>  2 files changed, 36 insertions(+), 62 deletions(-)
