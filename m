Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A97EC636CD
	for <linux-raid@archiver.kernel.org>; Tue,  7 Feb 2023 13:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbjBGNuS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Feb 2023 08:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbjBGNuQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Feb 2023 08:50:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADED211B
        for <linux-raid@vger.kernel.org>; Tue,  7 Feb 2023 05:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675777769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X8H4wMmsdEPcw81Ix/QXWluK+Ld4f/1kHLvU82377a0=;
        b=bwgPD/U22ab+ce9vJ54GoA5kZAUInwWhZxygprV8qfG99rTi3aH9NhQqT7QBkjl44BRvEY
        FdpvDxoe/Evu37nSrsk61DzKm/tNOB6o+wuLxuFjKwPPV1atysWzQ+NSvFq3YYJdyfyW1r
        QD7CsMQnTymaQD3Xeg1/eHMbUlgTWdw=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-613-Rz_ZlOdQNHCC28kTIf88rw-1; Tue, 07 Feb 2023 08:49:28 -0500
X-MC-Unique: Rz_ZlOdQNHCC28kTIf88rw-1
Received: by mail-pl1-f197.google.com with SMTP id j18-20020a170903029200b00198aa765a9dso8039595plr.6
        for <linux-raid@vger.kernel.org>; Tue, 07 Feb 2023 05:49:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X8H4wMmsdEPcw81Ix/QXWluK+Ld4f/1kHLvU82377a0=;
        b=MgHehupVH4APL+VEMXgVemHRZ9/tqfFPg2FAz9tdHDXLHOvZoJp9M8iIcYd2k+B7ev
         ZEdqKYQ0KcFvMKQXaBOFl0mp9ToBGebB9eVZ7cI6Bp7arutQqKWbYX61+EjGRyhVCYcW
         oTb/k97e2B3G1SvsTcY0e2YLN7WeCPLUYnb9Aq3DP8yd/n5UHkHea29MAoWJt4kURUuW
         0r+urPd4JZFTSqnDidF41HMphYvhfBsrCFwhFXtvQ2PvEuN0o2MLeJnxNHWytBPd0Jyt
         BlgDjY9ZwYZtcZbxHr/F/H+mQWAPM5A1WwRT0Tt3/3yeMgI8PYpDPkL2ba/DwpKqsnvS
         GSVg==
X-Gm-Message-State: AO0yUKWFY/7kPQLJi8wRpNSx97US3M0VIXQbM+mOV0LP72iaeAvbweLX
        JZsdMIf/46Ro96qf1vThjYfzcm9uEHe14+MvSoR8IBLfKOjN0ZMlok7ZyKel1/KTdSFZrWGH0pf
        UQ1LudJXquk3ywm3vNRQzciF70LHQ/wtWME4Vkw==
X-Received: by 2002:a17:902:7789:b0:198:e1f5:8549 with SMTP id o9-20020a170902778900b00198e1f58549mr790808pll.0.1675777767573;
        Tue, 07 Feb 2023 05:49:27 -0800 (PST)
X-Google-Smtp-Source: AK7set+ssxeKda48e1bCrytMfG/vIKxvToKNbRXpjf+PzAIECWqaTAWuJLgFv0xYAKIk2mvELU4XjBeiv9sESX9A6hc=
X-Received: by 2002:a17:902:7789:b0:198:e1f5:8549 with SMTP id
 o9-20020a170902778900b00198e1f58549mr790797pll.0.1675777767305; Tue, 07 Feb
 2023 05:49:27 -0800 (PST)
MIME-Version: 1.0
References: <20230203051344.19328-1-xni@redhat.com>
In-Reply-To: <20230203051344.19328-1-xni@redhat.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 7 Feb 2023 21:49:16 +0800
Message-ID: <CALTww28SZ+3uP_6+Y058fvQqLC1fc9GjTDAUC440kd++ZnUTcg@mail.gmail.com>
Subject: Re: [PATCH 1/1] md: Increase active_io to count acct_io
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song

Is the patch ok? If so, are there chances to merge this into md-next this week?

Regards
Xiao

On Fri, Feb 3, 2023 at 1:16 PM Xiao Ni <xni@redhat.com> wrote:
>
> It has added io_acct_set for raid0/raid5 io accounting and it needs to
> alloc md_io_acct in the i/o path. They are free when the bios come back
> from member disks. Now we don't have a method to monitor if those bios
> are all come back. In the takeover process, it needs to free the raid0
> memory resource including the memory pool for md_io_acct. But maybe some
> bios are still not returned. When those bios are returned, it can cause
> panic bcause of introducing NULL pointer or invalid address.
>
> [ 6973.767999] RIP: 0010:mempool_free+0x52/0x80
> [ 6973.786098] Call Trace:
> [ 6973.786549]  md_end_io_acct+0x31/0x40
> [ 6973.787227]  blk_update_request+0x224/0x380
> [ 6973.787994]  blk_mq_end_request+0x1a/0x130
> [ 6973.788739]  blk_complete_reqs+0x35/0x50
> [ 6973.789456]  __do_softirq+0xd7/0x2c8
> [ 6973.790114]  ? sort_range+0x20/0x20
> [ 6973.790763]  run_ksoftirqd+0x2a/0x40
> [ 6973.791400]  smpboot_thread_fn+0xb5/0x150
> [ 6973.792114]  kthread+0x10b/0x130
> [ 6973.792724]  ? set_kthread_struct+0x50/0x50
> [ 6973.793491]  ret_from_fork+0x1f/0x40
>
> This patch trys to use ->active_io to count acct_io. The regression
> tests have passed. And I did takeover from raid0 to raid5 and from
> raid5 to raid0 while I/O is happening. This patch works well.
>
> Reported-by: Fine Fan <ffan@redhat.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  drivers/md/md.c | 6 ++++++
>  drivers/md/md.h | 7 ++++---
>  2 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index da6370835c47..7f06eb953488 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8627,12 +8627,15 @@ static void md_end_io_acct(struct bio *bio)
>  {
>         struct md_io_acct *md_io_acct = bio->bi_private;
>         struct bio *orig_bio = md_io_acct->orig_bio;
> +       struct mddev *mddev = md_io_acct->mddev;
>
>         orig_bio->bi_status = bio->bi_status;
>
>         bio_end_io_acct(orig_bio, md_io_acct->start_time);
>         bio_put(bio);
>         bio_endio(orig_bio);
> +
> +       percpu_ref_put(&mddev->active_io);
>  }
>
>  /*
> @@ -8648,10 +8651,13 @@ void md_account_bio(struct mddev *mddev, struct bio **bio)
>         if (!blk_queue_io_stat(bdev->bd_disk->queue))
>                 return;
>
> +       percpu_ref_get(&mddev->active_io);
> +
>         clone = bio_alloc_clone(bdev, *bio, GFP_NOIO, &mddev->io_acct_set);
>         md_io_acct = container_of(clone, struct md_io_acct, bio_clone);
>         md_io_acct->orig_bio = *bio;
>         md_io_acct->start_time = bio_start_io_acct(*bio);
> +       md_io_acct->mddev = mddev;
>
>         clone->bi_end_io = md_end_io_acct;
>         clone->bi_private = md_io_acct;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 6335cb86e52e..e148e3c83b0d 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -710,9 +710,10 @@ struct md_thread {
>  };
>
>  struct md_io_acct {
> -       struct bio *orig_bio;
> -       unsigned long start_time;
> -       struct bio bio_clone;
> +       struct mddev    *mddev;
> +       struct bio      *orig_bio;
> +       unsigned long   start_time;
> +       struct bio      bio_clone;
>  };
>
>  #define THREAD_WAKEUP  0
> --
> 2.32.0 (Apple Git-132)
>

