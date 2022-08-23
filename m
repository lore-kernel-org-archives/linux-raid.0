Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A22C32772
	for <linux-raid@archiver.kernel.org>; Tue, 23 Aug 2022 19:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiHWTI1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 Aug 2022 15:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiHWTIJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 Aug 2022 15:08:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F0C13492A;
        Tue, 23 Aug 2022 10:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 680B26160B;
        Tue, 23 Aug 2022 17:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A80C433D7;
        Tue, 23 Aug 2022 17:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661276661;
        bh=Ul5bZ380er40qNxMbPejlJJeqU3zD3OVNwa3ZFt/HIo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=C9zBoc5PKmp58NcyygnC6xcVGC6VM2MA3uszmJexg+uHCcrbJ0MX1lMzFwmLesHlz
         FyEHsjikk6au2Q51Ryztu++WlzbTLWFOQttW01f5sdl4u/w6qhKnP37jnTixRrp9FL
         zlq6bnHQk34Qgdy37OdQ2jU+xBnqn11n9AE4Gda2LQWQ+OWI/yOQntH6CxrgHvYo29
         eF24dMainibdHMsjSWGg2yLcrDh2Th11zIOur+y7mpvgEm5aPFCPppIsgcelHHE1Kw
         KaPt9GTdxxXJp6kjj4bwGYco5nwDZXlWK+ftIpqXKpQy+GcyhRDCpxBQmjl7OmtQUE
         yzhWCDDAbKSaw==
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-33387bf0c4aso398390557b3.11;
        Tue, 23 Aug 2022 10:44:21 -0700 (PDT)
X-Gm-Message-State: ACgBeo0SAp8HRqPvHP51DW/A8/QZsbSioXKA6PT4PMd34X3/PeIpSjTu
        /Yx0FVBYNfx0s2aLXoZ3wSHXfLaufIT/aIEGJkA=
X-Google-Smtp-Source: AA6agR79RaYtkRmNjikCF3kqnEzKZQ6FfCWzj8r6LytYF5P1bOwtbDnte6PXDP5blgsV1thflnHhQEUQ8ZFu0DZWeiA=
X-Received: by 2002:a81:63c3:0:b0:323:ce27:4e4d with SMTP id
 x186-20020a8163c3000000b00323ce274e4dmr27052114ywb.472.1661276660744; Tue, 23
 Aug 2022 10:44:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220817092140.4252-1-xupengfei@nfschina.com>
In-Reply-To: <20220817092140.4252-1-xupengfei@nfschina.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 23 Aug 2022 10:44:09 -0700
X-Gmail-Original-Message-ID: <CAPhsuW51y6dEVPs_WatXvXNnELk5UvvKkk8_kLrySUDP_OSUBA@mail.gmail.com>
Message-ID: <CAPhsuW51y6dEVPs_WatXvXNnELk5UvvKkk8_kLrySUDP_OSUBA@mail.gmail.com>
Subject: Re: [PATCH 1/1] md/raid5: Fix spelling mistakes in comments
To:     XU pengfei <xupengfei@nfschina.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Aug 17, 2022 at 2:21 AM XU pengfei <xupengfei@nfschina.com> wrote:
>
> Fix spelling of 'waitting' in comments.
>
> Signed-off-by: XU pengfei <xupengfei@nfschina.com>

Applied to md-next.

Thanks,
Song

> ---
>  drivers/md/raid5-cache.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index f4e1cc1ece43..058d82e7fa13 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1327,9 +1327,9 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
>          * superblock is updated to new log tail. Updating superblock (either
>          * directly call md_update_sb() or depend on md thread) must hold
>          * reconfig mutex. On the other hand, raid5_quiesce is called with
> -        * reconfig_mutex hold. The first step of raid5_quiesce() is waitting
> -        * for all IO finish, hence waitting for reclaim thread, while reclaim
> -        * thread is calling this function and waitting for reconfig mutex. So
> +        * reconfig_mutex hold. The first step of raid5_quiesce() is waiting
> +        * for all IO finish, hence waiting for reclaim thread, while reclaim
> +        * thread is calling this function and waiting for reconfig mutex. So
>          * there is a deadlock. We workaround this issue with a trylock.
>          * FIXME: we could miss discard if we can't take reconfig mutex
>          */
> --
> 2.18.2
>
