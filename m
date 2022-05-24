Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBB3C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 24 May 2022 18:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbiEXSQe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 May 2022 14:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiEXSQa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 24 May 2022 14:16:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951B26D95D
        for <linux-raid@vger.kernel.org>; Tue, 24 May 2022 11:16:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5225EB817F2
        for <linux-raid@vger.kernel.org>; Tue, 24 May 2022 18:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F074DC34100
        for <linux-raid@vger.kernel.org>; Tue, 24 May 2022 18:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653416187;
        bh=9IWysHPrTdHs8vKQyppxNu+LrDbMAVgBHpj/47RCLP4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fKEK4wUVk+D9gRbI7ZRxnuFtDcVKMMXYpqUBLlFLnbpIHzRAbiOmoE2N/vqsAI5cS
         8dVsRE22HezqQnuUdhEnBpa+GUgdlLww4KQTrvTkDQr71Ii8AhJyYXvd8EEaLlu5D5
         t1tqJjckmgKYHZHRW9SH4BTPECsRPg025yeidvzDLnB1iORa8OLo4lviRY5m3NvJWe
         IRc8/8ui/vv0+QqCaezYLpVkVfHExodhooPWK9pfBxczUBVJReWQ+gq0G+2q26oTB9
         DkmW2duIQYIIJPS4k8EtkMiyxfWoev8sGcJPJQMH40szixcrrs+Dp057dgN3+iDi/q
         iIWy7xnVNU3PA==
Received: by mail-yb1-f182.google.com with SMTP id i187so30084706ybg.6
        for <linux-raid@vger.kernel.org>; Tue, 24 May 2022 11:16:26 -0700 (PDT)
X-Gm-Message-State: AOAM531WB9emSqwprw6l0ZzQMm/9HRtemmwCiHtwM2jUOAqTrGuzpHwl
        5XYLivvt14q2V30ZfbuFSt+FRd0hJco/dEZ7S/Q=
X-Google-Smtp-Source: ABdhPJwWmrTnR22CK2K3XOz/YGhFrWJYvkCXp0BGwzhsNkO4ek5jdfvWRPgCaWDJhQkjH2GSNlqTuCF1YVkEn2XZ1UA=
X-Received: by 2002:a25:d04c:0:b0:655:599e:ee13 with SMTP id
 h73-20020a25d04c000000b00655599eee13mr2351081ybg.449.1653416186055; Tue, 24
 May 2022 11:16:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev> <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev> <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com> <836b2a93-65be-8d6c-8610-18373b88f86d@molgen.mpg.de>
 <5b0584a3-c128-cb53-7c8a-63744c60c667@linux.dev> <4edc9468-d195-6937-f550-211bccbd6756@molgen.mpg.de>
 <7fd20544-40e4-e180-861d-0e9ce27c9e69@deltatee.com>
In-Reply-To: <7fd20544-40e4-e180-861d-0e9ce27c9e69@deltatee.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 24 May 2022 11:16:15 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5AQ017yFyCcPk5uOxYvZf5qF3f5XGb8DJn_NfC8U0oig@mail.gmail.com>
Message-ID: <CAPhsuW5AQ017yFyCcPk5uOxYvZf5qF3f5XGb8DJn_NfC8U0oig@mail.gmail.com>
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, May 24, 2022 at 8:58 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
>
> On 2022-05-22 23:41, Donald Buczek wrote:
> >> Looks like bfq or block issue, will try it from my side.
> >
> > FYI: I've used loop devices on a virtio disk.
> >
> > I later discovered Logans patches [1], which I were not aware of, as I'm not subscribed to the lists.
> >
> > [1]: https://lore.kernel.org/linux-raid/20220519191311.17119-6-logang@deltatee.com/T/#u
> >
> > The series seems to acknowledge that there are open problems and tries to fix them.
> > So I've used his md-bug branch from https://github.com/sbates130272/linux-p2pmem but it didn't look better.
> >
> > So I understand, the mdadm tests *are* supposed to work and every bug I see here is worth analyzing? Or is Logan hunting down everything anyway?
>
> I'm not hunting down everything. There's too much brokenness. I've done
> a bunch of work: there's that series plus an mdadm branch I'll send to
> the list later (just linked it on my previous email). But even after all
> that, I still have ~25 broken tests, but I've marked those tests and
> they shouldn't stop the test script from running everything.

Thanks for your fixes so far. I will work with Jes to look into the remaining
failures and develop plan to fix them.

Song
