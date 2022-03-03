Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC25C433F5
	for <linux-raid@archiver.kernel.org>; Thu,  3 Mar 2022 00:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiCCAPn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiCCAPk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Mar 2022 19:15:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52091125528;
        Wed,  2 Mar 2022 16:14:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 015C2B8228C;
        Thu,  3 Mar 2022 00:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02D4C004E1;
        Thu,  3 Mar 2022 00:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646266492;
        bh=Omrr4UVBlnEgGplJW0tHhX2OqYY/2pDvfHgG0lt12Mw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CeYKr6j3qkPvTVkNCnHsqDGYrlm1XS8ZgPApdJB5nd32U8QpX0LqUfo0pmE+VpjZP
         IFV4RlCAjQvsADfe+OkLwr1u3l1TjnJoqce3SftVDLZuzmrXXFiHPoYv7mGtjLWtpf
         7cr8+iN2F0ycGeJ2gtvHUKlSfu5KF60B0XJt3iSDAb8ADDKZuAJsldLcRBAhMUF557
         pdUD7xLJGw0q28gHVMLUt33ILsdVhlaJ9sBOtkZ2ky3msvlz4BZaucLPvxLj48eCLO
         uikQO/412IEFmU3Kj+TxvQowZp6EagKR9ZyjMld8JTYndZLmTRyv9FL+djrnMRkJFo
         kk/knuDJiwrzg==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-2dbc48104beso37831167b3.5;
        Wed, 02 Mar 2022 16:14:52 -0800 (PST)
X-Gm-Message-State: AOAM532ZwCFCM0dPBwKh+75meHpEc+SqHhFRByD8XIxufFMNJXXOrvm2
        sqCw0BOxFW5hAgt3RLvgy9q9e4jOOWJrZgMqzgc=
X-Google-Smtp-Source: ABdhPJxaDlPLPWgVCdtWG3IJgVvrUkADWqG+4Fhfrz4QCJHDNa6Km6HdiFyVsn9m0YZFxlXg++DOUBC19xNdP+2lzJw=
X-Received: by 2002:a81:7814:0:b0:2ca:287c:6c2e with SMTP id
 t20-20020a817814000000b002ca287c6c2emr33022815ywc.211.1646266491786; Wed, 02
 Mar 2022 16:14:51 -0800 (PST)
MIME-Version: 1.0
References: <20220228112503.841449-1-hch@lst.de>
In-Reply-To: <20220228112503.841449-1-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Wed, 2 Mar 2022 16:14:40 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7EGxoyc9dkpP0y9AUWrV5V6ZORhew+tX=rFXS+vRm_AA@mail.gmail.com>
Message-ID: <CAPhsuW7EGxoyc9dkpP0y9AUWrV5V6ZORhew+tX=rFXS+vRm_AA@mail.gmail.com>
Subject: Re: raid5 bio handling cleanups
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Feb 28, 2022 at 3:25 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi Song,
>
> this series cleans up the raid5 bio handling to take advantage of
> the bio allocation interface changes in Jens' for-5.18 branches.

Applied to md-next. Thanks!
Song
