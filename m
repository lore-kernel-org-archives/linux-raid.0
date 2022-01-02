Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B412C433F5
	for <linux-raid@archiver.kernel.org>; Sun,  2 Jan 2022 00:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiABAaW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 1 Jan 2022 19:30:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53062 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiABAaV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 1 Jan 2022 19:30:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC1A7B8076E
        for <linux-raid@vger.kernel.org>; Sun,  2 Jan 2022 00:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC24C36AEA
        for <linux-raid@vger.kernel.org>; Sun,  2 Jan 2022 00:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641083419;
        bh=HP+VcQIcpkzBM5Gg6hYoVa8R1air7C+G2DBOyCyA8AA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eC8kv/9Gj7c9oItW7J0wVIqLGiu5Zo/1ecbFDhkC6IzQu4m8crnBoXPaK2S0YTrnN
         lnt5s/t887UzTj0unYHjp/NKoRSut+XkpyJ54KTk3/1EweEOUiBMgcl5iOPRdIhLh/
         +h1ZacCdxG1ors8FEWxqsN8eOjZgR9kb5R/tV2sQGE/IHiDWw3MySWhgl0IKYnyFB+
         P8vPRqgW9yjVjyVoKxjwKb/BLrz/ToR55CZvPlUMb3t6Fg3aQ92edet1qvqacka4WJ
         l725sSZZukpsCm59XvbmWFbMRDTUCpI78N7j9SucqPoDIoP9Rx1Srxci8Sk1q5F0Dh
         AobiEJmfUR8+Q==
Received: by mail-yb1-f175.google.com with SMTP id o185so62393691ybo.12
        for <linux-raid@vger.kernel.org>; Sat, 01 Jan 2022 16:30:19 -0800 (PST)
X-Gm-Message-State: AOAM532VyFaS1AwnBUaMGoHvqfTBCJtk080NSNjimjS001ysjQqzueM4
        Kmo8mWCuFwVrUNC1SoZoOldMmqriqJHj/FShKIg=
X-Google-Smtp-Source: ABdhPJwJwv5kOP9MnQ1wJKMlmbOfgV/tPKq4fK6PtrzCAERi/TvUNobYbt/1mNK94R3uU6YNIsvuPCW1/7FrTu8qjLU=
X-Received: by 2002:a25:3745:: with SMTP id e66mr5613817yba.208.1641083418715;
 Sat, 01 Jan 2022 16:30:18 -0800 (PST)
MIME-Version: 1.0
References: <20211217092955.24010-1-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20211217092955.24010-1-mariusz.tkaczyk@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Sat, 1 Jan 2022 16:30:07 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4LGpGKOSLLCH2_2m1f_OHCdbyCNStjXswEOL7A2hp0Lw@mail.gmail.com>
Message-ID: <CAPhsuW4LGpGKOSLLCH2_2m1f_OHCdbyCNStjXswEOL7A2hp0Lw@mail.gmail.com>
Subject: Re: [PATCH] md: drop queue limitation for RAID1 and RAID10
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Dec 17, 2021 at 1:30 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> As suggested by Neil Brown[1], this limitation seems to be
> deprecated.
>
> With plugging in use, writes are processed behind the raid thread
> and conf->pending_count is not increased. This limitation occurs only
> if caller doesn't use plugs.
>
> It can be avoided and often it is (with plugging). There are no reports
> that queue is growing to enormous size so remove queue limitation for
> non-plugged IOs too.
>
> [1] https://lore.kernel.org/linux-raid/162496301481.7211.18031090130574610495@noble.neil.brown.name
>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

I applied this patch to md-next, cecause it helps simplify Vishal's patches
for REQ_NOWAIT. However, I think this change is not complete, as we can
now remove pending_count from r1conf and r10conf. Please send patch
on top of md-next to clean up pending_count.

Thanks,
Song
