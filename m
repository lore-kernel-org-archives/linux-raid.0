Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D263C4167E
	for <linux-raid@archiver.kernel.org>; Tue,  1 Nov 2022 23:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiKAX5m (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Nov 2022 19:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiKAX5l (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Nov 2022 19:57:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6811F625
        for <linux-raid@vger.kernel.org>; Tue,  1 Nov 2022 16:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 350DC61767
        for <linux-raid@vger.kernel.org>; Tue,  1 Nov 2022 23:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DC1C433B5
        for <linux-raid@vger.kernel.org>; Tue,  1 Nov 2022 23:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667347059;
        bh=c3ALV3T16hdmwF71nmpN1lrSEaf8BqL8WShyC2LK+7U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JwllUYvGSjotHJ8d6TF5D7eNDPNZn2Eh1s6++gTpTZq70irbK1NocHY/EvzM5s7Nl
         uHVfLGfTvPCqzryPIVDkEWAH0ZZsGbYDYkYbQYER8R7blv8w0+8JRTR/q2r+24JW7G
         lnKPx2Wo3s6w64SVWVbOqlE7tI8MBMVUJk5wGut+A+gL3aML73Lf80XaSQnXbZYrJF
         76zW+viKiyDO4pH1S8oLa8fnZMWwVAEQhRNv2mjsBxjOR6VcV/h3YUgtkOxvpJSfEP
         h1Pen0v/KzvWoEqj5LYRAxvBA7imGVeLC75Q7+cX/5M3A3ZTQUam9MT6HwBUfb6gNc
         6tQOM1iDqKI6Q==
Received: by mail-ej1-f54.google.com with SMTP id f5so19614197ejc.5
        for <linux-raid@vger.kernel.org>; Tue, 01 Nov 2022 16:57:39 -0700 (PDT)
X-Gm-Message-State: ACrzQf13AdvxiFIUr1fjI0okOU6AhYdY+OBH2mzC6476gdBJYCsajNrU
        hp/5M1HlMxq5CeTe7ldYw+jCokHIRze6q0DPEro=
X-Google-Smtp-Source: AMsMyM7ENRwjbvlq7ovKAO8iiQoBPSWD9e1ssXzYGcibibA8MOEUx0yDjzkLy8SzMVT5k01C1qCLRCmzcFJioQOp3MY=
X-Received: by 2002:a17:907:7e87:b0:78e:1a4:130 with SMTP id
 qb7-20020a1709077e8700b0078e01a40130mr21313531ejc.101.1667347057742; Tue, 01
 Nov 2022 16:57:37 -0700 (PDT)
MIME-Version: 1.0
References: <20221101050819.12509-1-xni@redhat.com> <CAPhsuW7QLFpMbsYcisTm32zdeeYEXMT+M76S=Kjn5rurTF8Lpw@mail.gmail.com>
 <CALTww2_CnyCatgr-c4JPubgNjoAXBHTra5WjO6WpFqB4T1e=hg@mail.gmail.com>
In-Reply-To: <CALTww2_CnyCatgr-c4JPubgNjoAXBHTra5WjO6WpFqB4T1e=hg@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 1 Nov 2022 16:57:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7VKjyEiFUNwZo+1AoJuFTBCyJ=FADpaj=h6Mmr31s_vQ@mail.gmail.com>
Message-ID: <CAPhsuW7VKjyEiFUNwZo+1AoJuFTBCyJ=FADpaj=h6Mmr31s_vQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] Don't set discard sectors for request queue
To:     Xiao Ni <xni@redhat.com>
Cc:     yi.zhang@redhat.com, ming.lei@redhat.com,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 1, 2022 at 4:44 PM Xiao Ni <xni@redhat.com> wrote:
>
> On Wed, Nov 2, 2022 at 4:21 AM Song Liu <song@kernel.org> wrote:
> >
> > On Mon, Oct 31, 2022 at 10:08 PM Xiao Ni <xni@redhat.com> wrote:
> >
> > Please update the subject as md/raid0, raid10: xxx.
>
> Sorry for forgetting about this again.
>
> >
> > >
> > > It should use disk_stack_limits to get a proper max_discard_sectors
> > > rather than setting a value by stack drivers.
> > >
> > > And there is a bug. If all member disks are rotational devices,
> > > raid0/raid10 set max_discard_sectors. So the member devices are
> > > not ssd/nvme, but raid0/raid10 export the wrong value. It reports
> > > warning messages in function __blkdev_issue_discard when mkfs.xfs
> >
> > Please provide more information about this bug: the warning message,
> > the impact, etc. in the commit log.
>
> I remember we need to obey a rule to paste the warning/panic messages,
> right? If so, can you tell the position again? I use the keyword
> "warning/panic/calltrace"
> to search in file process/submitting-patches.rst and can't find the
> useful information.
> Or it just needs to paste the calltraces in the patch?

I think we can just paste the call trace in the commit log.

Thanks,
Song
