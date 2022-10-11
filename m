Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B33C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 11 Oct 2022 15:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiJKPwU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Oct 2022 11:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiJKPwB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Oct 2022 11:52:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D094E1156
        for <linux-raid@vger.kernel.org>; Tue, 11 Oct 2022 08:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665503378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zy7/iQNe7aEq5mCNbTqeQVw027bIDpxjtoePNJFgJoA=;
        b=F7H/Ko2Rmh1hgSyRnLOoXsuUxqRnl30ZxqBqeqoRTCI7XaYfXFcSebPRPTolhoK+/ckFAe
        BW9JgWpA5kprxrGMPVnx5/61RUjafsX2hNxTkKKEgbB4BDuW46LfO3KH2qmntT9kVSqKwP
        7IIa3IS5J2gQZL/oM25z/2nMT+G8GyI=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-12-MkDXUhRAPei2dxo17Z8dow-1; Tue, 11 Oct 2022 11:49:37 -0400
X-MC-Unique: MkDXUhRAPei2dxo17Z8dow-1
Received: by mail-pj1-f69.google.com with SMTP id m21-20020a17090a7f9500b0020a88338009so6775999pjl.4
        for <linux-raid@vger.kernel.org>; Tue, 11 Oct 2022 08:49:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zy7/iQNe7aEq5mCNbTqeQVw027bIDpxjtoePNJFgJoA=;
        b=6PlIy9ldic04pDYmtBJPkNbsRVVlKGTI6KUq9GgNCmFwfvcZW0IBvy7eopc80wS11q
         x2j4ebyX75N062wA1D8BNBppUiXuU1/EUnI2j8HA/A1hzJuJGZpw08fsFoe/dvTW9lHn
         DiCzBBIQJQrLEOaNEg38iG2QtAFdvV0zxTQ7RbD54otLf99ALDRnuhTAhB6y2Z1ztMHD
         JD7TLbgtnmkmJtA9HqziVDz9074e5Oev76AqxVxSxls4wbxBgtR3R0yMdOQI3U/HHc7d
         H0Db1FTEgPXqJ2igfB0sshGFXV18FO+eHCbhLrE+62jFa9fmOshlSlpxWI5yZCJL5MAF
         s9kQ==
X-Gm-Message-State: ACrzQf0ewmOcs83A4FntNSU9qs1TO84VOG35nomKK1Oy/lqJHylgJGBZ
        FTMcA1yXgT/tHxSm1BeGv7bFjOt5bweylLivhHckU6r78OqaL639XVxUPa5MmXhgyh0so7CDNEX
        /dif6cow4+9t/dYwtP1qUkl8kO4dPIMzt0iLtrg==
X-Received: by 2002:aa7:958f:0:b0:563:6987:8b88 with SMTP id z15-20020aa7958f000000b0056369878b88mr10711786pfj.31.1665503376341;
        Tue, 11 Oct 2022 08:49:36 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6FtPidc7oKoIIHuEIRtji2p+fWckk3P/I3LcVvGgHiXNadoU0tRTEqgXErO5+7wr4ffuuxaSKuMl9NQvIdQBo=
X-Received: by 2002:aa7:958f:0:b0:563:6987:8b88 with SMTP id
 z15-20020aa7958f000000b0056369878b88mr10711764pfj.31.1665503376028; Tue, 11
 Oct 2022 08:49:36 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww2-EAeM6aKeZbZ2udTwS5RFwNWfF9uag=npewB9j0H51Hw@mail.gmail.com>
 <35f4a626-7f83-56c5-4cad-73ede197ccbf@linux.dev> <CALTww2_jaUVEk-zeobWSn9+yDYfkESKEX6hAKZ+-O+dMzQS+Hg@mail.gmail.com>
 <861e6a43-40f6-a214-a72b-f641f9b6bc29@linux.dev>
In-Reply-To: <861e6a43-40f6-a214-a72b-f641f9b6bc29@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 11 Oct 2022 23:49:24 +0800
Message-ID: <CALTww2_FHYi7nsox4P4Mw+wFwUjZ8KPuuPCWXpwwB-e2XrRK+A@mail.gmail.com>
Subject: Re: Memory leak when raid10 takeover raid0
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid <linux-raid@vger.kernel.org>, Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Oct 11, 2022 at 9:39 PM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> I finally reproduced it with 6.0 kernel, and It is a NULL dereference.

That's cool. Could you share the steps?

> >>>
> >>> The reason is that raid0 doesn't do anything in raid0_quiesce. During
> >>> the level change in level_store, it needs
> >>> to make sure all inflight bios to finish.  We can add a count to do
> >>> this in raid0. Is it a good way?
> >>>
> >>> There is a count mddev->active_io in mddev. But it's decreased in
> >>> md_handle_request rather than in the callback
> >>> endio function. Is it right to decrease active_io in callbcak endio function?
> >>>
> >> I think it is a race between ios and takeover action, since
> >> mddev_suspend called by
> >> level_store should ensure no io is submitted to array at that time by below.
> >>
> >>       wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0)
> >>
> >> However it can't guarantee new io comes after mddev_suspend because the
> >> empty raid0 quiesce.  Maybe we can do something like this.
>
> I was wrong given md_end_io_acct could happen after raid0_make_request,
> so it could
> be the previous io not finished before mddev_suspend, which means we
> need to find a
> way to drain member disk somehow but I doubt it is reasonable.

It's what I wanted to mention in the original email. Sorry for not
describing clearly. The inflight ios
which mentioned in the first email are the bios that submit to the
member disks. Because we introduced
md_end_io_acct now, we need to ensure all the inflight ios come back
and then free the memory.
I put a patch in last email that tried to resolve it.

>
> Also change personality from raid0 seems doesn't obey the second rule.
>
>         /* request to change the personality.  Need to ensure:
>           *  - array is not engaged in resync/recovery/reshape
>           *  - *old personality can be suspended*
>           *  - new personality will access other array.
>           */
>
> And I don't like the idea to add another clone during io path for the
> special case which

That is what my last patch does. I didn't figure out a better way.

> hurts performance. I would just warn user don't change personality from
> raid0 unless
> QUEUE_FLAG_IO_STAT flag is cleared for a while. Or do something like.
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 729be2c5296c..55e975233f66 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3979,6 +3979,12 @@ level_store(struct mddev *mddev, const char *buf,
> size_t len)
>                  goto out_unlock;
>          }
>
> +       if (blk_queue_io_stat(mddev->queue)) {
> +               blk_queue_flag_clear(QUEUE_FLAG_IO_STAT, mddev->queue);
> +               /* We want the previous bio is finished */
> +               msleep(1000);
> +       }
> +
>          /* Looks like we have a winner */
>          mddev_suspend(mddev);
>          mddev_detach(mddev);
> @@ -4067,6 +4073,7 @@ level_store(struct mddev *mddev, const char *buf,
> size_t len)
>          pers->run(mddev);
>          set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>          mddev_resume(mddev);
> +       blk_queue_flag_set(QUEUE_FLAG_IO_STAT, mddev->queue);
>
> If you really want to fix it, maybe we have to ensure all inflight IOs
> is finished by increase
> inflight num in md_account_bio, then decrease it in md_end_io_acct after
> add a new
> inflight_num in mddev and also add "struct mddev *mddev" in md_io_acct,
> just FYI.

I thought about this method too. But then I thought it's only raid0 problem. So
I didn't choose this method.

Thanks for all the suggestions.

Best Regards
Xiao

