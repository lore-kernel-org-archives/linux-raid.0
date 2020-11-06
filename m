Return-Path: <SRS0=g69Z=EM=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26664C2D0A3
	for <linux-raid@archiver.kernel.org>; Fri,  6 Nov 2020 21:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B24452087E
	for <linux-raid@archiver.kernel.org>; Fri,  6 Nov 2020 21:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604699819;
	bh=CLOm0ZLK99G+kgJq8r1qakTsSje+lm/jMkk7ECSGqEM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=EqI6PeMqmtY6XtKg/9nIbSixE+iUBGXTi3LpRX6pq6jI1vgOExOrn314liJLI/q2d
	 MC3yKBrVYy/VjwJ5qYgSMl9pdDt9PFKmCZ/eNURmqAUc7AJjaTJyvNpp+KkHtFycJm
	 c4x4vTIOosTJHOGuXHpouwndsSc/6YnRybwpDhZw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgKFV47 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 6 Nov 2020 16:56:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728672AbgKFV47 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 6 Nov 2020 16:56:59 -0500
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 086D52087E
        for <linux-raid@vger.kernel.org>; Fri,  6 Nov 2020 21:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604699818;
        bh=CLOm0ZLK99G+kgJq8r1qakTsSje+lm/jMkk7ECSGqEM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1i6hgQNs7XoJqC155M/5FfXpEU6UQSdLfnIo7ECjFgnwRZGAtvnVon6BDsC0B8cjm
         2EGAzyT0x9f3U6FEs/Tw7Japf+9DUn/YsSaBZMLjHjVJp+qeErq8E95Hhh/JrEvGCi
         XWEa9A0M+aUHdJzKJhpdYP4rVnXmyL9Ul1GNm4ZY=
Received: by mail-lf1-f43.google.com with SMTP id r19so1617542lfe.6
        for <linux-raid@vger.kernel.org>; Fri, 06 Nov 2020 13:56:57 -0800 (PST)
X-Gm-Message-State: AOAM533Y3flS+kC+L9v4Efyj83+i0PA65/XYl5kw3AkGENbis0bVH7/G
        ctKmQUCqRFXvW3G71jNqGFlbCVpBgKwqa2Fl2E4=
X-Google-Smtp-Source: ABdhPJzgBwPf01XPJD/v5we9K8qmGZeTyvE5FGnYKX+RQBvJOsSehjXsSksTUbEuVSuLxRRyl8hzmzEW9rnRGJW+2gc=
X-Received: by 2002:a19:c703:: with SMTP id x3mr1513367lff.105.1604699816222;
 Fri, 06 Nov 2020 13:56:56 -0800 (PST)
MIME-Version: 1.0
References: <20201105180746.1149364-1-kvigor@gmail.com>
In-Reply-To: <20201105180746.1149364-1-kvigor@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 6 Nov 2020 13:56:45 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6GqEU7BczF2tpgtEJoU5Fdh4M17N9cobhSMdVY4NPD3w@mail.gmail.com>
Message-ID: <CAPhsuW6GqEU7BczF2tpgtEJoU5Fdh4M17N9cobhSMdVY4NPD3w@mail.gmail.com>
Subject: Re: [PATCH] md/raid10: initialize r10_bio->read_slot before use.
To:     Kevin Vigor <kvigor@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Nov 5, 2020 at 10:08 AM Kevin Vigor <kvigor@gmail.com> wrote:
>
> In __make_request() a new r10bio is allocated and passed to
> raid10_read_request(). The read_slot member of the bio is not
> initialized, and the raid10_read_request() uses it to index an
> array. This leads to occasional panics.
>
> Fix by initializing the field to invalid value and checking for
> valid value in raid10_read_request().
>
> Signed-off-by: Kevin Vigor <kvigor@gmail.com>

Thanks for the fix!

I am having problem apply this patch, could you please rebase against

   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git  md-next

> ---
>  drivers/md/raid10.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 8a1354a08a1a..64b1306b0c4a 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1143,7 +1143,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>         struct md_rdev *err_rdev = NULL;
>         gfp_t gfp = GFP_NOIO;
>
> -       if (r10_bio->devs[slot].rdev) {
> +       if (slot >= 0 && r10_bio->devs[slot].rdev) {

If we set default read_slot = 0, we should not need this change, right?

>                 /*
>                  * This is an error retry, but we cannot
>                  * safely dereference the rdev in the r10_bio,
> @@ -1508,6 +1508,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
>         r10_bio->mddev = mddev;
>         r10_bio->sector = bio->bi_iter.bi_sector;
>         r10_bio->state = 0;
> +       r10_bio->read_slot = -1;
>         memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->copies);
>
>         if (bio_data_dir(bio) == READ)
> --
> 2.26.2
>
