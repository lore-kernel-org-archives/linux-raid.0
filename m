Return-Path: <SRS0=YfF9=D6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 246FFC388F9
	for <linux-raid@archiver.kernel.org>; Fri, 23 Oct 2020 05:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA8B721534
	for <linux-raid@archiver.kernel.org>; Fri, 23 Oct 2020 05:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603431994;
	bh=oQ6/1NIou2TcFImLpwWF3gr7pTLz587r4JuuStq4BDg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=OSv2AP9eiJpwQOl0PzouIWuXdAUIDf9O5U2vy1Ewv9F8VqI4gXmjUWxMJhpxS0ksj
	 pQfHbbIujfx4oRf/IOQ7zd5+mVr5F0+sVeNooUzCLbqDEAwcv5+lWkgPYbkXt/OTwi
	 ZeQqedFJ85YFym4nCAdR101wO+ajL88/uBqCsh1Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371659AbgJWFqb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Oct 2020 01:46:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S371656AbgJWFqb (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 23 Oct 2020 01:46:31 -0400
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC2C321534;
        Fri, 23 Oct 2020 05:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603431990;
        bh=oQ6/1NIou2TcFImLpwWF3gr7pTLz587r4JuuStq4BDg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rWrQbXab/RpNL5qcRM8r2BFSprfg0tDmdcR+KDPvBmSZ5BlU6YUTXyHINt8n+51qn
         kLjXQWo0zgY2KF3fhzf8jc/p1A1ehzePZcHOKwIpkPeWdX2Ow12ZPBeoADz82fwPYi
         3xpwEERpaFTgU11bAw2we/QGoLBBom7rmY6D2phA=
Received: by mail-lj1-f169.google.com with SMTP id p15so252611ljj.8;
        Thu, 22 Oct 2020 22:46:29 -0700 (PDT)
X-Gm-Message-State: AOAM533MvHmbZQbCBpADUp6uFseeclKfEUjnZd9YR3BEdt9mA5MDcxfU
        Y/zrwCCz3IO+N9z8WMPOsPfJ+twIp0DUE1mHSnA=
X-Google-Smtp-Source: ABdhPJxh2xUjhkn4ZF0KVGTZbpvtIKi9ZZ77ny9krE+BUrRzXL5z+NSujYT05oD42ycloS61Mky7X0imC4zOMwMPdz4=
X-Received: by 2002:a2e:808f:: with SMTP id i15mr201106ljg.10.1603431988136;
 Thu, 22 Oct 2020 22:46:28 -0700 (PDT)
MIME-Version: 1.0
References: <20201023033130.11354-1-cunkel@drivescale.com> <20201023033130.11354-2-cunkel@drivescale.com>
In-Reply-To: <20201023033130.11354-2-cunkel@drivescale.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 22 Oct 2020 22:46:17 -0700
X-Gmail-Original-Message-ID: <CAPhsuW50ON69Z=Wq30fEw0M2mGtXYKQCUNUbDS78AUe--nNZSg@mail.gmail.com>
Message-ID: <CAPhsuW50ON69Z=Wq30fEw0M2mGtXYKQCUNUbDS78AUe--nNZSg@mail.gmail.com>
Subject: Re: [PATCH 1/3] md: align superblock writes to physical blocks
To:     Christopher Unkel <cunkel@drivescale.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Oct 22, 2020 at 8:31 PM Christopher Unkel <cunkel@drivescale.com> wrote:
>
> Writes of the md superblock are aligned to the logical blocks of the
> containing device, but no attempt is made to align them to physical
> block boundaries.  This means that on a "512e" device (4k physical, 512
> logical) every superblock update hits the 512-byte emulation and the
> possible associated performance penalty.
>
> Respect the physical block alignment when possible.
>
> Signed-off-by: Christopher Unkel <cunkel@drivescale.com>
> ---
>  drivers/md/md.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 98bac4f304ae..2b42850acfb3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1732,6 +1732,21 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
>             && rdev->new_data_offset < sb_start + (rdev->sb_size/512))
>                 return -EINVAL;
>
> +       /* Respect physical block size if feasible. */
> +       bmask = queue_physical_block_size(rdev->bdev->bd_disk->queue)-1;
> +       if (!((rdev->sb_start * 512) & bmask) && (rdev->sb_size & bmask)) {
> +               int candidate_size = (rdev->sb_size | bmask) + 1;
> +
> +               if (minor_version) {
> +                       int sectors = candidate_size / 512;
> +
> +                       if (rdev->data_offset >= sb_start + sectors
> +                           && rdev->new_data_offset >= sb_start + sectors)
> +                               rdev->sb_size = candidate_size;
> +               } else if (bmask <= 4095)
> +                       rdev->sb_size = candidate_size;
> +       }

In super_1_load() and super_1_sync(), we have

    bmask = queue_logical_block_size(rdev->bdev->bd_disk->queue)-1;

I think we should replace it with queue_physical_block_size() so the logic is
cleaner. Would this work?

Thanks,
Song
