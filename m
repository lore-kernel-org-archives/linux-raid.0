Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A79C433E6
	for <linux-raid@archiver.kernel.org>; Wed, 27 Jan 2021 08:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19AE520754
	for <linux-raid@archiver.kernel.org>; Wed, 27 Jan 2021 08:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbhA0IOC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Jan 2021 03:14:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234188AbhA0IDn (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 27 Jan 2021 03:03:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 356BD20724
        for <linux-raid@vger.kernel.org>; Wed, 27 Jan 2021 07:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611733954;
        bh=6CGKy2soOdB9reeucEansUVOjXB9IZqASeiHhId8fl4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AmZWyYalTCCX+1Pi8D8R4W/8a6uqSl6es9twsY3ByeFleQxsgPZ9V4vhKq3ZznCBk
         /8OIrRzhr6LzlZ1/WFzwxUg18unp6Mqh7E41d7QiOTL5X6x+4l9ni0z8Isfxb9eChQ
         ZQPzqlxEJe1Za333Tp8c5dZVdgnbtUBl/Yh9RgyJvGjH7fJND8H/x19v0gcgb87Z8A
         uQZKCzzqr6MWDj3JTZrJZ6tpdihxTnP2aZ4V3CQnnnA7JVfRgqTzxWuvUYEO6QByqH
         PwkUSoledW5fLV55EeDuQ4ERV6J4dW73pRIbQLJZWuFQPWJNaR8Y2poYJ6FoSxXSZr
         Tat8DD/QHv5+A==
Received: by mail-lj1-f169.google.com with SMTP id u11so954269ljo.13
        for <linux-raid@vger.kernel.org>; Tue, 26 Jan 2021 23:52:34 -0800 (PST)
X-Gm-Message-State: AOAM532rfoD0N86l6KSqC9i3raSqxE7mwQLIe46ba1K4Lb70MiD6K71E
        vf+qo9dh10ys7AkGuJ38zZLfPFlhwALpjCPMAjA=
X-Google-Smtp-Source: ABdhPJzCOkwfGjsG8InBYJHPG7m7hW0Ze/LA3+/RQNixdTeKaOEKVj/Ey2o7MKgmp8lO/BbeSNkimbVinA494qQWUTc=
X-Received: by 2002:a2e:8e91:: with SMTP id z17mr5046329ljk.506.1611733952410;
 Tue, 26 Jan 2021 23:52:32 -0800 (PST)
MIME-Version: 1.0
References: <20210105150635.2551-1-jakub.radtke@linux.intel.com>
In-Reply-To: <20210105150635.2551-1-jakub.radtke@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 26 Jan 2021 23:52:21 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5TdVgh2RaxxJQkdUAKm2k-Eo11fOdWk1Mti=qsu7ZzUg@mail.gmail.com>
Message-ID: <CAPhsuW5TdVgh2RaxxJQkdUAKm2k-Eo11fOdWk1Mti=qsu7ZzUg@mail.gmail.com>
Subject: Re: [PATCH] md: change bitmap offset verification in write_sb_page
To:     Jakub Radtke <jakub.radtke@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jan 5, 2021 at 7:06 AM Jakub Radtke
<jakub.radtke@linux.intel.com> wrote:
>
> From: Jakub Radtke <jakub.radtke@intel.com>
>
> Removes the code that is correct only for the native metadata.
> Write-intent bitmap support for the other metadata formats is blocked.
>
> rdev->sb_start is used in the calculations.
> The sb_start is only set and used for native metadata format, and
> the bitmap offset check will always fail if it is not set.

Can we use different logic for native and other metadata, so that we can
keep the check for native metadata? Maybe we can use the combination
of mddev->major_version, mddev->minor_version, and rdev->sb_start?

Thanks,
Song

>
> In the case of external metadata, the bitmap can be placed in various
> places e.g. like the PPL between two volumes (the boundary checks are
> performed on the sysfs level and in the mdadm).
>
> Signed-off-by: Jakub Radtke <jakub.radtke@linux.intel.com>
> ---
>  drivers/md/md-bitmap.c | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 200c5d0f08bf..a78b15df4d82 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -236,14 +236,6 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>                  */
>                 if (mddev->external) {
>                         /* Bitmap could be anywhere. */
> -                       if (rdev->sb_start + offset + (page->index
> -                                                      * (PAGE_SIZE/512))
> -                           > rdev->data_offset
> -                           &&
> -                           rdev->sb_start + offset
> -                           < (rdev->data_offset + mddev->dev_sectors
> -                            + (PAGE_SIZE/512)))
> -                               goto bad_alignment;
>                 } else if (offset < 0) {
>                         /* DATA  BITMAP METADATA  */
>                         if (offset
> --
> 2.17.1
>
