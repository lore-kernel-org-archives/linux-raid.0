Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF55C05027
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 06:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjBBG6E (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Feb 2023 01:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjBBG6C (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Feb 2023 01:58:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8418559DF
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 22:57:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38658B82048
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 06:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FABC433EF
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 06:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675321074;
        bh=h16YqGYKLhI5NXlnvMTYQ2QDRE4kkd0gSO0V0a0m+1I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WRQ/x1h4V1ioV6zzFh4z7JgHWL2AcOremAtqy2IQKmq9udRNEHMZiX3iTPScOJTeJ
         X+qeLrnJ5I6egkKU+Nvt/rRhBq69XCvxlynfjzNxuM4XRcDCeY96bkN5kU/mpMWKu+
         AnmT4W6TJFS2kEk7clM71PxhPBJUYBTap8CuMsF4rtcqVvgqAh+Zfx0CjsofssfjqP
         Y243yQBaWencXgh0pP9TnjRAHxMbKQUCwfNkNinLmHbTjlQd76eXRV/T2fBs+Hq2bd
         RFPsFlovy7nob8uM4ZT6mBJjLszJWM5voCv46Ws6KytfqbjB+06KZsjlsPzv4kz+6e
         Q2R/X2DX5XfpA==
Received: by mail-lf1-f49.google.com with SMTP id b3so1613780lfv.2
        for <linux-raid@vger.kernel.org>; Wed, 01 Feb 2023 22:57:54 -0800 (PST)
X-Gm-Message-State: AO0yUKVx65SPD804acLTvuaMl1h5fUP8QdmRcTJkT27mH5hZ7TK53tFc
        SFuvgZpLaW4GroyezbP90Zs110B/5x1noEL4qBQ=
X-Google-Smtp-Source: AK7set+lWkmVkoET1cFRzhrlDgp6QvvgVdys4+DHpfJP5TXPpdntn0MjLSaws3NaFcuRV+gCugQ27UB8ephDtTz3O4Q=
X-Received: by 2002:ac2:5441:0:b0:4d8:7740:47d2 with SMTP id
 d1-20020ac25441000000b004d8774047d2mr780798lfn.87.1675321072958; Wed, 01 Feb
 2023 22:57:52 -0800 (PST)
MIME-Version: 1.0
References: <20230201124640.3749-1-xni@redhat.com> <CAPhsuW7MCSVREMp48CoO-qE-HfMonxhJn-+HfRUxvHfBXL0Nug@mail.gmail.com>
 <CALTww2_cLaULw4+QwwkjhhmBwjcP9GBTxNOR=WsZXAnPJaUakg@mail.gmail.com> <CALTww2-Df5LZODnur7Mq9e+Q1bv_aDr_P+q3Y4Ded2tUnsNFTQ@mail.gmail.com>
In-Reply-To: <CALTww2-Df5LZODnur7Mq9e+Q1bv_aDr_P+q3Y4Ded2tUnsNFTQ@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 1 Feb 2023 22:57:40 -0800
X-Gmail-Original-Message-ID: <CAPhsuW59msX0RaLKnkVT03epWhpUN2Z_8U_zx9cpRAK+Qfn0wA@mail.gmail.com>
Message-ID: <CAPhsuW59msX0RaLKnkVT03epWhpUN2Z_8U_zx9cpRAK+Qfn0wA@mail.gmail.com>
Subject: Re: [PATCH V3 1/1] md/raid0: Add mddev->io_acct_cnt for raid0_quiesce
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Feb 1, 2023 at 4:41 PM Xiao Ni <xni@redhat.com> wrote:
>
> On Thu, Feb 2, 2023 at 8:23 AM Xiao Ni <xni@redhat.com> wrote:
> >
> > On Thu, Feb 2, 2023 at 2:00 AM Song Liu <song@kernel.org> wrote:
> > >
> > > On Wed, Feb 1, 2023 at 4:46 AM Xiao Ni <xni@redhat.com> wrote:
> > > >
> > > > It has added io_acct_set for raid0/raid5 io accounting and it needs to
> > > > alloc md_io_acct in the i/o path. They are free when the bios come back
> > > > from member disks. Now we don't have a method to monitor if those bios
> > > > are all come back. In the takeover process, it needs to free the raid0
> > > > memory resource including the memory pool for md_io_acct. But maybe some
> > > > bios are still not returned. When those bios are returned, it can cause
> > > > panic bcause of introducing NULL pointer or invalid address. Something
> > > > like this:
> > >
> > > Can we use mddev->active_io for this? If not, please explain the reason
> > > in the comments (in the code).
> >
> > Hi Song
> >
> > At first, we thought this way. Now ->acitve_io is used to wait all
> > submit processes to exit.
> > If we use ->active_io to count acct_bio, it means we change the usage
> > of ->active_io.
> > In mddev_suspend, first it waits for all submit processes to finish,
> > then it calls ->quiesce
> > to wait all inflight io to come back. For raid0, it's ok to use
> > ->acitve_io to count acct_bio.
> > But for raid5, not sure if it's ok. What's your opinion?
>
> Hi Song
>
> I've sent V4. If you think ->active_io is a better way to count acct_io,
> I'll re-write the patch to use ->active_io

I haven't thought about all the details. But we should try very hard to
avoid adding another percpu_ref. So let's try to use active_io to count
acct_io.

Thanks,
Song
