Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040B7C32774
	for <linux-raid@archiver.kernel.org>; Mon, 22 Aug 2022 19:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238351AbiHVTNl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238446AbiHVTNO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 22 Aug 2022 15:13:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECC7AE7C
        for <linux-raid@vger.kernel.org>; Mon, 22 Aug 2022 12:13:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0932D61206
        for <linux-raid@vger.kernel.org>; Mon, 22 Aug 2022 19:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636FAC433C1
        for <linux-raid@vger.kernel.org>; Mon, 22 Aug 2022 19:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661195584;
        bh=sVpQlpsKcEJLDbDmccEmJaNM6j3NBex3vuWCBWLR2FY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fWAE3VZtu0BWtiTEW68AGZSNrFXW6IUKsdo08Uc5YTi2kG05bOVj7yrypAPD00gBq
         8QC68ZufIbv6wijlGUxX5FpN52ImHeC3D6LDMih+KF4OIZoT1CTbRg1qjFPGugiRcf
         FfUK0PFXCThPMfR/AYeXgU/9RgQsZjZ+ynN22Tfd4GDpd3MGs3IzyzeRSeBWoW1qKv
         ziXgHAF56FVyHcDQo2+YBZKm7TZ0E4eflRsM9LkOZ6JnO+YulnbdeqoMStQvB7+lCW
         UF6dDVezqtsDbMOFYLo/27DByg84kMP6UDf4GvB+h71vOxTXS2nzsd7EMqZ/iou11I
         66KoN12ml35Hg==
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-3375488624aso291854047b3.3
        for <linux-raid@vger.kernel.org>; Mon, 22 Aug 2022 12:13:04 -0700 (PDT)
X-Gm-Message-State: ACgBeo0ChCwr81fRiYagTpJewDnCim7zEF2Gi2mekeZ9eOEfc9+fkKi2
        PU1F2zzvt87AtHCtC7VkojrrLmgHVGB/Rn5h0Bg=
X-Google-Smtp-Source: AA6agR5eIz3eQxnBIUMHemHVZfVRA+zbfCIiY32fH3/EpGFKqcdL0k4HcSwrN7Qkh1bXKDZHA967lGxC74cf8Joudu8=
X-Received: by 2002:a81:910d:0:b0:330:23a8:bec4 with SMTP id
 i13-20020a81910d000000b0033023a8bec4mr22237441ywg.148.1661195583405; Mon, 22
 Aug 2022 12:13:03 -0700 (PDT)
MIME-Version: 1.0
References: <e05c4239-41a9-d2f7-3cfa-4aa9d2cea8c1@deltatee.com>
 <CAPhsuW4=aa08-XGDtoQ3rLb8r-5t9Q7VwwFgGbTTt-xbkzEW8Q@mail.gmail.com> <b4e29397-3150-8580-86aa-f23cee893ee6@deltatee.com>
In-Reply-To: <b4e29397-3150-8580-86aa-f23cee893ee6@deltatee.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 22 Aug 2022 12:12:52 -0700
X-Gmail-Original-Message-ID: <CAPhsuW40XFwAQVwkH6bgT3fe45pZDwASEzt+R=SsqMywrTKcdA@mail.gmail.com>
Message-ID: <CAPhsuW40XFwAQVwkH6bgT3fe45pZDwASEzt+R=SsqMywrTKcdA@mail.gmail.com>
Subject: Re: raid5 Journal Recovery Bug
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Aug 22, 2022 at 9:28 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
>
> On 2022-08-22 01:04, Song Liu wrote:
> > Could you please add some printk so that we know which condition triggered
> > handle_stripe_fill() here:
> >
> >         if (s.to_read || s.non_overwrite
> >             || (s.to_write && s.failed)
> >             || (s.syncing && (s.uptodate + s.compute < disks))
> >             || s.replacing
> >             || s.expanding)
> >                 handle_stripe_fill(sh, &s, disks);
> >
> > This would help us narrow down to the exact condition. I guess it is
> > "(s.to_write && s.failed)", but I am not quite sure.
>
> Ok, I hit this bug on a stripe and got these values for the call:
>
>   to_read       = 0
>   non_overwrite = 0
>   to_write      = 0
>   failed        = 1
>   syncing       = 1
>   uptodate      = 2
>   compute       = 0
>   disks         = 3
>   replacing     = 0
>   expanding     = 0
>
> So it's actually the "(s.syncing && (s.uptodate + s.compute < disks))"
> condition that is getting hit.

Thanks for the information! So the stripe is syncing. Could you please
try whether the following fixes the issue?

Thanks,
Song

diff --git i/drivers/md/raid5.c w/drivers/md/raid5.c
index 5cabdbbac48b..0580ebb11801 100644
--- i/drivers/md/raid5.c
+++ w/drivers/md/raid5.c
@@ -3952,7 +3952,7 @@ static void handle_stripe_fill(struct stripe_head *sh,
                 * back cache (prexor with orig_page, and then xor with
                 * page) in the read path
                 */
-               if (s->injournal && s->failed) {
+               if (s->to_read && s->injournal && s->failed) {
                        if (test_bit(STRIPE_R5C_CACHING, &sh->state))
                                r5c_make_stripe_write_out(sh);
                        goto out;
