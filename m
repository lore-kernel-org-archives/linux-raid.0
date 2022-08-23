Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481AEC32772
	for <linux-raid@archiver.kernel.org>; Tue, 23 Aug 2022 18:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbiHWS72 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 Aug 2022 14:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbiHWS7B (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 Aug 2022 14:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4825F5D0F7
        for <linux-raid@vger.kernel.org>; Tue, 23 Aug 2022 10:28:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 157B461375
        for <linux-raid@vger.kernel.org>; Tue, 23 Aug 2022 17:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75771C433D6
        for <linux-raid@vger.kernel.org>; Tue, 23 Aug 2022 17:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661275559;
        bh=GwhVsTCo8BYtSkDTjWkY7aZTW+47t3KVDrYG0hgLRtY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uEA+oGxAacoHfhzApNdFHlHQUBNP6sWiT/FV9L3oN2Qe3T5Gz/SJQLbM/6tl0ivXU
         khZ2bAo8Vl6/f8aOAOF4D8eYY1tAG7zB5bgYpOZVkSKuVvstWqe+k4xRLWAJzEJijw
         9QcO1aty5fEmVrkjMllnJHkR/80f91J91R0bJFYSAyAd6ggUuJZMrXARw6MtuA5Rba
         i/dvDuIMRkil7yIr7cbMrxCK/f51wBAMp0tw7ByqD7qA6zgN672xnt+TyyZRmgFLrO
         jOFT29r5DF0GeOi4jLHGTzG1kyMfQjfJ7c9VZVkcpvctWiQLipHDhx3YGkmeDLHdIg
         zbza9ANkF72xA==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-335624d1e26so398241747b3.4
        for <linux-raid@vger.kernel.org>; Tue, 23 Aug 2022 10:25:59 -0700 (PDT)
X-Gm-Message-State: ACgBeo2lrPOD+Vfj0Bw1pifV0MDX6VO7iAycYen87IxlHqp9SlRLdzcv
        Xf/rVjKsNNTrt9DsBqByXn9C2NAt0TJjqzrD+FA=
X-Google-Smtp-Source: AA6agR5fpAYgMJhOezdx0g8Pu7eZlXadQdIR4QKKI2wrrlSJmp8meXFs2GHers0t9K+kMiHMGbb0OcIZpEOboYc2qSk=
X-Received: by 2002:a05:6902:110d:b0:670:b10b:d16e with SMTP id
 o13-20020a056902110d00b00670b10bd16emr25377683ybu.259.1661275558542; Tue, 23
 Aug 2022 10:25:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220817120514.5536-1-guoqing.jiang@linux.dev>
In-Reply-To: <20220817120514.5536-1-guoqing.jiang@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Tue, 23 Aug 2022 10:25:47 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7VTipS2zjnuto6OS2vkVKrebpT0cLQwMG7L70009fyHw@mail.gmail.com>
Message-ID: <CAPhsuW7VTipS2zjnuto6OS2vkVKrebpT0cLQwMG7L70009fyHw@mail.gmail.com>
Subject: Re: [PATCH 0/2] fix KASAN issue for dm-raid
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     NeilBrown <neilb@suse.de>, Mikulas Patocka <mpatocka@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Aug 17, 2022 at 5:05 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> Hi,
>
> Let's try another approach to fix the KASAN issue, and to avoid cause
> issue for clustered raid.

Applied to md-fixes.

Thanks,
Song

>
> Thanks,
> Guoqing
>
> Guoqing Jiang (2):
>   Revert "md-raid: destroy the bitmap after destroying the thread"
>   md: call __md_stop_writes in md_stop
>
>  drivers/md/md.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> --
> 2.31.1
>
