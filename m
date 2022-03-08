Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81777C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  8 Mar 2022 01:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344173AbiCHBBY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Mar 2022 20:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbiCHBBY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Mar 2022 20:01:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1662D2AE36
        for <linux-raid@vger.kernel.org>; Mon,  7 Mar 2022 17:00:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7BFE7CE117E
        for <linux-raid@vger.kernel.org>; Tue,  8 Mar 2022 01:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE16AC340F3
        for <linux-raid@vger.kernel.org>; Tue,  8 Mar 2022 01:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646701225;
        bh=79vbyQwVub2BEwx2i62db/Ye4MH6bgHHfnwCrFFoCe4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PW2q+uSkVDaf1w+qwsDB+RsZCmIkxT6kcp8kZasiQ7VKZoy2BUbnPJhamTU7HdmjO
         deZ4I4siVraYJkGqhmZleAIrgTYJWgQZaPZvbmm5mebn6T5Jw4mQewP2P8Gtwoxcpc
         hd2sEtRDotwJGhorNDmHUZoVwCRwuAeyccyYhsbg1ePdW8uEky+ee6RG2ltamEYDJb
         AZ3i2yOzW/EL5RWpqvo/D9V4JH4bXCJNzfUg9xKA0XeSHgnvi0ubHF7fxwSFV0uL62
         gvZ5zVJuu7cknB9kCjwBT600Sp65FRe5hTWZOZLMVx2ziLjUkUnuEugybhmelZSXot
         JXn8JrTYfzbiA==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2dc348dab52so151151027b3.6
        for <linux-raid@vger.kernel.org>; Mon, 07 Mar 2022 17:00:25 -0800 (PST)
X-Gm-Message-State: AOAM531ACdBStxEe/NapfZYs7D4H6r/wVzvHnd0Dy12EBkgxA+goBXIj
        R5XCx9vY+WRb/DeSIz2MW9I+77YlNogvbJ43oOA=
X-Google-Smtp-Source: ABdhPJxcELJ+BTwx9VZ1T/67BEGrkfyBvNfl/aYXdnZECquDNFV4Jzyhn/fui481v4qUTypFMuAyJkmifRvHD+3V364=
X-Received: by 2002:a81:57d5:0:b0:2dc:62b3:1455 with SMTP id
 l204-20020a8157d5000000b002dc62b31455mr10632453ywb.73.1646701224818; Mon, 07
 Mar 2022 17:00:24 -0800 (PST)
MIME-Version: 1.0
References: <0eb91a43-a153-6e29-14b6-65f97b9f3d99@nuclearwinter.com>
In-Reply-To: <0eb91a43-a153-6e29-14b6-65f97b9f3d99@nuclearwinter.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 7 Mar 2022 17:00:14 -0800
X-Gmail-Original-Message-ID: <CAPhsuW68V0ZO55_Un0vnrAt_+XpGRX3yq3nR=35f7P2d5iPvTA@mail.gmail.com>
Message-ID: <CAPhsuW68V0ZO55_Un0vnrAt_+XpGRX3yq3nR=35f7P2d5iPvTA@mail.gmail.com>
Subject: Re: Raid6 check performance regression 5.15 -> 5.16
To:     Larkin Lowrey <llowrey@nuclearwinter.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Mar 7, 2022 at 10:21 AM Larkin Lowrey <llowrey@nuclearwinter.com> wrote:
>
> I am seeing a 'check' speed regression between kernels 5.15 and 5.16.
> One host with a 20 drive array went from 170MB/s to 11MB/s. Another host
> with a 15 drive array went from 180MB/s to 43MB/s. In both cases the
> arrays are almost completely idle. I can flip between the two kernels
> with no other changes and observe the performance changes.
>
> Is this a known issue?

I am not aware of this issue. Could you please share

  mdadm --detail /dev/mdXXXX

output of the array?

Thanks,
Song
