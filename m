Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651E0C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  5 Jan 2022 18:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243227AbiAESzg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 Jan 2022 13:55:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39090 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiAESzg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 5 Jan 2022 13:55:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54173B81CF9
        for <linux-raid@vger.kernel.org>; Wed,  5 Jan 2022 18:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23468C36AE9
        for <linux-raid@vger.kernel.org>; Wed,  5 Jan 2022 18:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641408934;
        bh=MCUqwYQ5pRk97dfSY7McRLlrzBVIVzbDpru5bVBXuJc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=V3+xt/Q4yRSN8UUS1SNL6+cjE0WGRlSM5IW/fA8ChMsWZHh/V/11u098YXzX4Jfre
         S1mUU1RUJyUN4zl5ixrRJlJAuqVvani5+bSm1oYrfbg9nWIKsM6y0OwafHww4ou/Cd
         JKn97BTw72m+Aq3pI4YUGHjmnzkCJLh2EIoUV24ndmgY+97gET5qC6Uv8WDxphZHzU
         y2JtgYnTvCfDiqVLClzhEomDyR2bmfnDSLLto7G9h8ZjA792XYamHFOc9tKX1p4xiJ
         qtVudRDi5wKahNlNzFMrJZB0e/WdbMlrBPL0vX46N8QIBdg5fGiWQUSehkRSFTAc3/
         xhPOXq42oo7lw==
Received: by mail-yb1-f181.google.com with SMTP id g80so776836ybf.0
        for <linux-raid@vger.kernel.org>; Wed, 05 Jan 2022 10:55:34 -0800 (PST)
X-Gm-Message-State: AOAM533gnSf4aVtVLAMhW2+nhBx1XIc0MDcF7kc2dT1PRSnBrgEqhDYd
        dUmSsoLO60AfGWZlWu7U1TQ2fE1DqO9IEfTc36I=
X-Google-Smtp-Source: ABdhPJzXLz+ytk+cFcYHuLnKYpwMydw5eQNSQIIFhrMgFxFeTzKxak8ju+MuJKN8mBcbVEsxxFZcvzLiMLm5prWDas4=
X-Received: by 2002:a25:8690:: with SMTP id z16mr19231317ybk.282.1641408933289;
 Wed, 05 Jan 2022 10:55:33 -0800 (PST)
MIME-Version: 1.0
References: <20220105163847.18592-1-dmueller@suse.de>
In-Reply-To: <20220105163847.18592-1-dmueller@suse.de>
From:   Song Liu <song@kernel.org>
Date:   Wed, 5 Jan 2022 10:55:22 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7i2NxkOTBdtzeXXXGRGWkmDAUswudBBmo80oZmgorG5w@mail.gmail.com>
Message-ID: <CAPhsuW7i2NxkOTBdtzeXXXGRGWkmDAUswudBBmo80oZmgorG5w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] lib/raid6: skip benchmark of non-chosen
 xor_syndrome functions
To:     =?UTF-8?B?RGlyayBNw7xsbGVy?= <dmueller@suse.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Jan 5, 2022 at 8:39 AM Dirk M=C3=BCller <dmueller@suse.de> wrote:
>
> In commit fe5cbc6e06c7 ("md/raid6 algorithms: delta syndrome functions")
> a xor_syndrome() benchmarking was added also to the raid6_choose_gen()
> function. However, the results of that benchmarking were intentionally
> discarded and did not influence the choice. It picked the
> xor_syndrome() variant related to the best performing gen_syndrome().
>
> Reduce runtime of raid6_choose_gen() without modifying its outcome by
> only benchmarking the xor_syndrome() of the best gen_syndrome() variant.
>
> For a HZ=3D250 x86_64 system with avx2 and without avx512 this removes
> 5 out of 6 xor() benchmarks, saving 340ms of raid6 initialization time.
>
> Signed-off-by: Dirk M=C3=BCller <dmueller@suse.de>

Applied both patches to md-next.

Thanks,
Song
