Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C21AC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 23 Jun 2022 04:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbiFWEoq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Jun 2022 00:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344810AbiFWEMy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Jun 2022 00:12:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1F33F894
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 21:12:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33D75B821B5
        for <linux-raid@vger.kernel.org>; Thu, 23 Jun 2022 04:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE50C3411B
        for <linux-raid@vger.kernel.org>; Thu, 23 Jun 2022 04:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655957567;
        bh=iZSMESbD906sXd1NIspv2Lh+3xq2YQdFJfrlIT/G+4k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HYrhAhZAoWE/DJVhLPs6Y6Io5r7hciKttE3Ft+MYekHD68bGzqQWXebIaZ9BIIASp
         VyXwuevkoseM9xISk5+xwO+Ua61NN61FwQ5PmAU8DvPeoA6nvE99AUPz5CqK2hAX1d
         FppKxs9WI6U7PvOh0nuAN3dMbwu9zTJND6ER98IBQ7QxH906IMxnJolefF0UT1A+ZI
         1/rZtwS2MoRnsLSpRWDZYQP//CC2XqBiqpVyB/+Rjdu++vy9NZj1wOTvjUkIgksgXO
         AWSWEHZCQOj6SOr5zcYVK2bkYzhOmIX9GF13F+K7Lln8RkNoowXYG68J4lOtYG46az
         Ye4a7zC9wFT3A==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-3176d94c236so182569857b3.3
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 21:12:47 -0700 (PDT)
X-Gm-Message-State: AJIora9451nSFdMhlfOVsWljI7Gp1iAxgrt2NfrgXYRqPrHa/0md5UfQ
        k3ZK353Q1xa0ncYTVY/DYwBMU9v5NQh831eE0xM=
X-Google-Smtp-Source: AGRyM1sFFLyDLfsl+TujaMmXwDD5iaqvD+AL4g5L9BteRSQ3GG0VV/zFGJuYSuWG0EV7Y88kaTbhi7vq2im9zlixN5A=
X-Received: by 2002:a0d:d688:0:b0:317:b002:4758 with SMTP id
 y130-20020a0dd688000000b00317b0024758mr8556972ywd.460.1655957566959; Wed, 22
 Jun 2022 21:12:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220621031129.24778-1-guoqing.jiang@linux.dev>
 <CAPhsuW5SGxiosMw28km7v7bM9qSDRGbLFvyyH1nsAPg2_RcZgA@mail.gmail.com> <c8fd5b4f-58c7-e85b-f3ba-f3d8a519a059@linux.dev>
In-Reply-To: <c8fd5b4f-58c7-e85b-f3ba-f3d8a519a059@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Wed, 22 Jun 2022 21:12:35 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7T3i9x-s2SuSNgsaLKQOxrWNRgw7XNuvKt1zUe5X1bXg@mail.gmail.com>
Message-ID: <CAPhsuW7T3i9x-s2SuSNgsaLKQOxrWNRgw7XNuvKt1zUe5X1bXg@mail.gmail.com>
Subject: Re: [PATCH V2] md: unlock mddev before reap sync_thread in action_store
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Jun 22, 2022 at 6:30 PM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
>
>
> On 6/23/22 7:32 AM, Song Liu wrote:
> > On Mon, Jun 20, 2022 at 8:11 PM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
> >> Since the bug which commit 8b48ec23cc51a ("md: don't unregister sync_thread
> >> with reconfig_mutex held") fixed is related with action_store path, other
> >> callers which reap sync_thread didn't need to be changed.
> >>
> >> Let's pull md_unregister_thread from md_reap_sync_thread, then fix previous
> >> bug with belows.
> >>
> >> 1. unlock mddev before md_reap_sync_thread in action_store.
> >> 2. save reshape_position before unlock, then restore it to ensure position
> >>     not changed accidentally by others.
> >>
> >> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> >> ---
> >> V2 changes:
> >> 1. add set_bit(MD_RECOVERY_INTR, &mddev->recovery) before unregister sync thread
> >>
> >> And I didn't find regression with this version after run mdadm tests.
> >>
> >>   drivers/md/dm-raid.c |  1 +
> >>   drivers/md/md.c      | 19 +++++++++++++++++--
> >>   2 files changed, 18 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> >> index 9526ccbedafb..d43b8075c055 100644
> >> --- a/drivers/md/dm-raid.c
> >> +++ b/drivers/md/dm-raid.c
> >> @@ -3725,6 +3725,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
> >>          if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
> >>                  if (mddev->sync_thread) {
> >>                          set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> >> +                       md_unregister_thread(&mddev->sync_thread);
> >>                          md_reap_sync_thread(mddev);
> >>                  }
> >>          } else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index c7ecb0bffda0..04bab0511312 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -4830,6 +4830,19 @@ action_store(struct mddev *mddev, const char *page, size_t len)
> >>                          if (work_pending(&mddev->del_work))
> >>                                  flush_workqueue(md_misc_wq);
> >>                          if (mddev->sync_thread) {
> >> +                               sector_t save_rp = mddev->reshape_position;
> >> +
> >> +                               mddev_unlock(mddev);
> >> +                               set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> >> +                               md_unregister_thread(&mddev->sync_thread);
> >> +                               mddev_lock_nointr(mddev);
> >> +                               /*
> >> +                                * set RECOVERY_INTR again and restore reshape
> >> +                                * position in case others changed them after
> >> +                                * got lock, eg, reshape_position_store and
> >> +                                * md_check_recovery.
> >> +                                */
> > Hmm.. do we really need to handle reshape_position changed case? What would
> > break if we don't?
>
> I want to make the behavior consistent with previous code, and
> reshape_position_store
> can change it as said in comment.

I see. I will apply the patch as-is.

Thanks,
Song

>
> Anyway, I didn't see regression with mdadm test with or without setting
> reshape_position,
> so it is a more conservative way to avoid potential issue. I will remove
> it if you think it is
> not necessary.
