Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD632C64EC7
	for <linux-raid@archiver.kernel.org>; Tue, 21 Feb 2023 05:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbjBUF2S (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Feb 2023 00:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbjBUF2P (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Feb 2023 00:28:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7CE10A95
        for <linux-raid@vger.kernel.org>; Mon, 20 Feb 2023 21:28:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DEED60F71
        for <linux-raid@vger.kernel.org>; Tue, 21 Feb 2023 05:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC5FC433D2
        for <linux-raid@vger.kernel.org>; Tue, 21 Feb 2023 05:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676957293;
        bh=DvkvRRPf+g78DOq61gD7dQSMSf9S3LpsMkVOq6xUle0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qo54WX0W51bN7oIlH8o8sdHZtPZ8/y/aw5GIE8THzy7huD5CH9GaBY+4/kb2PsoX6
         FWJlr6k477hSf3cZDPerBM4v3QQTfcHXDovUweGxxC6eAS38royTa/l4eFtMZQ/ear
         SZeBTr3zC0S8SH6W9/m58m3un13qFJk66bJaxLVaTH1rI/hv7BSdZ7z5LCXZvRk6Nm
         NtuFBEQd+TKV/rd6F+2hz6J5ySf5YPh//B5GhzrL+HjOrzAklGpmBf9XGCZWx/fFHm
         huxhyPc4RHqrzP3zckQoVG6bTxpvT+LqGhAdoSbb3/S9GP1/NMSPUXkBj5La8Upfnj
         VlX7w4Fd4ku9A==
Received: by mail-lj1-f175.google.com with SMTP id t14so400233ljd.5
        for <linux-raid@vger.kernel.org>; Mon, 20 Feb 2023 21:28:13 -0800 (PST)
X-Gm-Message-State: AO0yUKUhZsw49GLPHLf2rigzQXc6H51F0YBYlaGnm8cRxVTMmrtmEO2V
        snQI7cTlnBAZnzzSwLHwAGvAEfc5b8Nc1Epf924=
X-Google-Smtp-Source: AK7set9maONtGNCoruD0TutqUrpiaIBgR7dopwCS/L9dTBtfk6Nlf5G1U2vhurfTIm13lld12mYfiM+hDytQKnsIka8=
X-Received: by 2002:a05:651c:1699:b0:294:6f14:235b with SMTP id
 bd25-20020a05651c169900b002946f14235bmr1290864ljb.5.1676957291691; Mon, 20
 Feb 2023 21:28:11 -0800 (PST)
MIME-Version: 1.0
References: <20230118005319.147-1-jonathan.derrick@linux.dev>
 <80812f87-a743-2deb-3d43-d07fcc4ce895@linux.dev> <CAPhsuW65Qai4Dq-wzrcMbCR-s7J9astse1K8U8TwoAuxD4FyzQ@mail.gmail.com>
 <850848e9-77db-8c93-d921-ba0be3ba7c38@linux.dev>
In-Reply-To: <850848e9-77db-8c93-d921-ba0be3ba7c38@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Mon, 20 Feb 2023 21:27:59 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5ycSfw0KW6Oyud1ZCTSsvYKeVMQPynHyOwdTwSZ0wjtA@mail.gmail.com>
Message-ID: <CAPhsuW5ycSfw0KW6Oyud1ZCTSsvYKeVMQPynHyOwdTwSZ0wjtA@mail.gmail.com>
Subject: Re: [PATCH] md: Use optimal I/O size for last bitmap page
To:     Jonathan Derrick <jonathan.derrick@linux.dev>
Cc:     linux-raid@vger.kernel.org,
        Sushma Kalakota <sushma.kalakota@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 16, 2023 at 3:52 PM Jonathan Derrick
<jonathan.derrick@linux.dev> wrote:
>
>
>
> On 2/10/2023 10:32 AM, Song Liu wrote:
> > Hi Jonathan,
> >
> > On Thu, Feb 9, 2023 at 12:38 PM Jonathan Derrick
> > <jonathan.derrick@linux.dev> wrote:
> >>
> >> Hi Song,
> >>
> >> Any thoughts on this?
> >
> > I am really sorry that I missed this patch.
> >
> >>
> >> On 1/17/2023 5:53 PM, Jonathan Derrick wrote:
> >>> From: Jon Derrick <jonathan.derrick@linux.dev>
> >>>
> >>> If the bitmap space has enough room, size the I/O for the last bitmap
> >>> page write to the optimal I/O size for the storage device. The expanded
> >>> write is checked that it won't overrun the data or metadata.
> >>>
> >>> This change helps increase performance by preventing unnecessary
> >>> device-side read-mod-writes due to non-atomic write unit sizes.
> >>>
> >>> Ex biosnoop log. Device lba size 512, optimal size 4k:
> >>> Before:
> >>> Time        Process        PID     Device      LBA        Size      Lat
> >>> 0.843734    md0_raid10     5267    nvme0n1   W 24         3584      1.17
> >>> 0.843933    md0_raid10     5267    nvme1n1   W 24         3584      1.36
> >>> 0.843968    md0_raid10     5267    nvme1n1   W 14207939968 4096      0.01
> >>> 0.843979    md0_raid10     5267    nvme0n1   W 14207939968 4096      0.02
> >>>
> >>> After:
> >>> Time        Process        PID     Device      LBA        Size      Lat
> >>> 18.374244   md0_raid10     6559    nvme0n1   W 24         4096      0.01
> >>> 18.374253   md0_raid10     6559    nvme1n1   W 24         4096      0.01
> >>> 18.374300   md0_raid10     6559    nvme0n1   W 11020272296 4096      0.01
> >>> 18.374306   md0_raid10     6559    nvme1n1   W 11020272296 4096      0.02
> >
> > Do we see significant improvements from io benchmarks?
> Yes. With lbaf=512, optimal i/o size=4k:
>
> Without patch:
>   write: IOPS=1570, BW=6283KiB/s (6434kB/s)(368MiB/60001msec); 0 zone resets
> With patch:
>   write: IOPS=59.7k, BW=233MiB/s (245MB/s)(13.7GiB/60001msec); 0 zone resets

The difference is much bigger than I expected. Given this big improvements, I
think we should ship this improvement. Unfortunately, we are too late for 6.3.
Let's plan to ship this in the 6.4 release. I am on vacation this
week. I will work
on this afterwards.

Thanks,
Song
