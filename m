Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D237C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 15 Dec 2021 20:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhLOUCX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Dec 2021 15:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhLOUCX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Dec 2021 15:02:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF36EC061574
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 12:02:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED388B82041
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 20:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DA2C36AE6
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 20:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639598539;
        bh=oY7NfThbFcc4buCdH6r2veiSmRD6hKN/C1KIHSaMn2E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=g3jE7lntJ3dgILQ2kt0xlDnhUmkvHW33EacRzm82bqwxEM3zy1N9gERklloGXnB2I
         wKVk2b8I9jX1OVF/O4oEreogT5yGX8+w9cE/nKgjxbJUiVPSnEGB9V+W8pZZyDwiAG
         Eov0KRTlfoeMdqeoi7m6Ydzk1jTTKbOjEV0pVQqKDZ5chscW0IBn2HqYWod6N7SbKk
         PvMwocS0q0oqBWeERkN8VO3BLipC+fE8AZaiyH9dNYTFUPMo1Or0nCiEEjcxlkyb+U
         bJPqLBhR/rUseKuya2ss47lyb6heVjuoAZcWA00hxvW/WlwLsNqnQv6gTXpI+EZWi+
         rFNuEbhMZxOxA==
Received: by mail-yb1-f173.google.com with SMTP id g17so58209340ybe.13
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 12:02:19 -0800 (PST)
X-Gm-Message-State: AOAM531modL+SUQ2l65uRS3CLnO1SCp84KGKuY5T9KzDK0nJQd/DwTmr
        OBd552qYsEvxEIn9UP8w7+tZ7yKoUQnm2IgBxss=
X-Google-Smtp-Source: ABdhPJyhlKdkt4qEilNLma9tXIFoQrmch0LQXr8vEUPvEE4XXcUkgnVBuLKw1GTT9G0k9jUq5ndIV5xKwoLBZxNSijo=
X-Received: by 2002:a25:bf8f:: with SMTP id l15mr8305766ybk.670.1639598538799;
 Wed, 15 Dec 2021 12:02:18 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
 <20211215060906.3230-1-vverma@digitalocean.com>
In-Reply-To: <20211215060906.3230-1-vverma@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 15 Dec 2021 12:02:07 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7iiNPR0ED1SO0N4nv9V-KwcAR9UhZ11y0tUctyy9DeTQ@mail.gmail.com>
Message-ID: <CAPhsuW7iiNPR0ED1SO0N4nv9V-KwcAR9UhZ11y0tUctyy9DeTQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] md: add support for REQ_NOWAIT
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rgoldwyn@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Dec 14, 2021 at 10:09 PM Vishal Verma <vverma@digitalocean.com> wrote:
>
[...]
>
> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
> ---
>  drivers/md/md.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7fbf6f0ac01b..5b4c28e0e1db 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -419,6 +419,12 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
>         if (is_suspended(mddev, bio)) {
>                 DEFINE_WAIT(__wait);
>                 for (;;) {
> +                       /* Bail out if REQ_NOWAIT is set for the bio */
> +                       if (bio->bi_opf & REQ_NOWAIT) {
> +                               rcu_read_unlock();
> +                               bio_wouldblock_error(bio);
> +                               return;
> +                       }

I moved this part to before the for (;;) loop. And applied to md-next.

Thanks,
Song
