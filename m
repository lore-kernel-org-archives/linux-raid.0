Return-Path: <SRS0=Jo7I=EN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0531BC2D0A3
	for <linux-raid@archiver.kernel.org>; Sat,  7 Nov 2020 00:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D2E920728
	for <linux-raid@archiver.kernel.org>; Sat,  7 Nov 2020 00:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604708812;
	bh=7nh6rlaj84d75XebUKRQkdD4FWYVD2xJfJqKAjkS5DE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ftfNSetDeBjUlI/dpLvnyBUMuHx8Wu1OgiXzbNRPrR2j9Yb8nBaPQtYMATHkMIPQa
	 f+H3K9CZqQbRQm2hGW3ssGZwYOdEbJd4A/kZURhVEG5KK6JtKDFK/1nDYzEh+g/dRa
	 y6sUZMLDTzGZaEkboSAPY+u5mSwK79x53/04BPVE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgKGA0v (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 6 Nov 2020 19:26:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:40672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbgKGA0v (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 6 Nov 2020 19:26:51 -0500
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E54620728
        for <linux-raid@vger.kernel.org>; Sat,  7 Nov 2020 00:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604708810;
        bh=7nh6rlaj84d75XebUKRQkdD4FWYVD2xJfJqKAjkS5DE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kATr3wtu6jlMha2D9NOrvX1NK96c5iK/frQQrZBw2mK9MPl9uIL1U1LhZh+mavT+4
         5Ey6a+xxi+MrPGKbnHpQ0VlIaGPIggImMvPHmKUPoye2HpAe0txO72IYyhCzqSXIxB
         s3WGanSCh9UAup0S34Po0WezKjnE9zVdmvPM6jho=
Received: by mail-lf1-f51.google.com with SMTP id e27so4348608lfn.7
        for <linux-raid@vger.kernel.org>; Fri, 06 Nov 2020 16:26:50 -0800 (PST)
X-Gm-Message-State: AOAM533IORFj8Jjdi1wjsm0vzZyG1D/nm4Rgu/gdrUl2YnC6ENW34uzH
        LfxQ90fR/fWrmqbb9F7ihseBwSMGEKC1djGmhFk=
X-Google-Smtp-Source: ABdhPJw1GIRWEi/JbD+dq1sf6hXA0t9UTjQG/0N5eOC4dqaG0y1J5HHYE0Hhw/ZPAm3obdqO/xDoazvjS5aOPNRz7CM=
X-Received: by 2002:a19:4b45:: with SMTP id y66mr1697790lfa.482.1604708808823;
 Fri, 06 Nov 2020 16:26:48 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6GqEU7BczF2tpgtEJoU5Fdh4M17N9cobhSMdVY4NPD3w@mail.gmail.com>
 <20201106222034.1304830-1-kvigor@gmail.com>
In-Reply-To: <20201106222034.1304830-1-kvigor@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 6 Nov 2020 16:26:37 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5RAB8buLN9FxNX3cnJ8=5eqRpZH+FXL54FpZvjoK7x2w@mail.gmail.com>
Message-ID: <CAPhsuW5RAB8buLN9FxNX3cnJ8=5eqRpZH+FXL54FpZvjoK7x2w@mail.gmail.com>
Subject: Re: [PATCH v2] md/raid10: initialize r10_bio->read_slot before use.
To:     Kevin Vigor <kvigor@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Nov 6, 2020 at 2:21 PM Kevin Vigor <kvigor@gmail.com> wrote:
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
> ---
> v2:
> - rebase onto md-next
> ---
>  drivers/md/raid10.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b7bca6703df8..3153183b7772 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1127,7 +1127,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>         struct md_rdev *err_rdev = NULL;
>         gfp_t gfp = GFP_NOIO;
>
> -       if (r10_bio->devs[slot].rdev) {
> +       if (slot >= 0 && r10_bio->devs[slot].rdev) {

How about we initialize read_slot to 0, and get rid of this check?

Thanks,
Song
