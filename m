Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57AB8CCA489
	for <linux-raid@archiver.kernel.org>; Wed,  8 Jun 2022 01:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351455AbiFHBRr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Jun 2022 21:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588102AbiFGXyG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Jun 2022 19:54:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A618AE77
        for <linux-raid@vger.kernel.org>; Tue,  7 Jun 2022 15:59:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55019609D0
        for <linux-raid@vger.kernel.org>; Tue,  7 Jun 2022 22:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B226DC3411C
        for <linux-raid@vger.kernel.org>; Tue,  7 Jun 2022 22:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654642765;
        bh=wp6pVajhIjhskKi7KKDLZN4rM9HAcDWPaltkDqCDL0Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DDpDfnWdfq2/1vA3i16045TdokfWSqqdvuccpbKITjhO3p7ZZNfnk3BDRko+i/ens
         mKw51bk4C5JaDSFaELn3iDJz7DO+ZYU9XHND9DoOCvDx8f86L4iwuWh/XbNynfJjWl
         YSKkgVZlN7n32IfUwiX4yEoG8GIKmdz94EUZkKwNOyKAq9RoenrPe8Y8B6Hdpgt/0G
         oZPcMG2aWmMGiGZb3o9HhH6V4infyOd4zHp0lCXNaylP7/2ylM9N/riwLstk4T6cd7
         vlNdzJAJCBwWbndfujbAJTuqoZv0jFqPYpriVdqueF7XJzXvFkDA0yMcSCzo/+KOX3
         gh850/kpBaCHg==
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-30c143c41e5so191645457b3.3
        for <linux-raid@vger.kernel.org>; Tue, 07 Jun 2022 15:59:25 -0700 (PDT)
X-Gm-Message-State: AOAM530NDELoyoExYk8c1sVDUCBA4ZRZz0c9GhQiNdwPsO6RUheOMRTx
        jUSoCQ441hbQkkk0QD7+r6CScuI/3w6L13yOPDo=
X-Google-Smtp-Source: ABdhPJxOOiddX7XlB6Xre4wVRYHXoGxRAEQTNGVkgnF3dm27HD1WLlfFfogfhu34JQF/aXOyIxVcvVxRXS8LMIGR6Tw=
X-Received: by 2002:a81:5a87:0:b0:2ec:239:d1e with SMTP id o129-20020a815a87000000b002ec02390d1emr33238094ywb.211.1654642764785;
 Tue, 07 Jun 2022 15:59:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220607020357.14831-1-guoqing.jiang@linux.dev>
 <20220607020357.14831-3-guoqing.jiang@linux.dev> <008f7fe2-b2f6-56bd-913d-966fe7386874@linux.dev>
In-Reply-To: <008f7fe2-b2f6-56bd-913d-966fe7386874@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Tue, 7 Jun 2022 15:59:13 -0700
X-Gmail-Original-Message-ID: <CAPhsuW64cv=gvEy-CzBJqWc7PE9m6hEecdD4pm-8LGVEGPxLjw@mail.gmail.com>
Message-ID: <CAPhsuW64cv=gvEy-CzBJqWc7PE9m6hEecdD4pm-8LGVEGPxLjw@mail.gmail.com>
Subject: Re: [PATCH 2/2] md: unlock mddev before reap sync_thread in action_store
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jun 7, 2022 at 2:46 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> Pls hold on, I will verify it with latest kernel.
>
> Thanks,
> Guoqing
>
> On 6/7/22 10:03 AM, Guoqing Jiang wrote:
> > Since the bug which commit 8b48ec23cc51a ("md: don't unregister sync_thread
> > with reconfig_mutex held") fixed is related with action_store path, other
> > callers which reap sync_thread didn't need to be changed.
> >
> > Let's pull md_unregister_thread from md_reap_sync_thread, then fix previous
> > bug with belows.
> >
> > 1. unlock mddev before md_reap_sync_thread in action_store.
> > 2. save reshape_position before unlock, then restore it to ensure position
> >     not changed accidentally by others.
> >
> > Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>

This version doesn't really work. Maybe we should ship the revert first?

Thanks,
Song
