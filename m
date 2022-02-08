Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986F6C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  8 Feb 2022 05:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiBHFqC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Feb 2022 00:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbiBHFqA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Feb 2022 00:46:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918E0C0401EE
        for <linux-raid@vger.kernel.org>; Mon,  7 Feb 2022 21:45:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BF6A615BC
        for <linux-raid@vger.kernel.org>; Tue,  8 Feb 2022 05:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9081FC340EC
        for <linux-raid@vger.kernel.org>; Tue,  8 Feb 2022 05:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644299158;
        bh=uP2+KExIbEsS3U/nJ96RhZDc8j8bqIOFBn6P/y5NOHk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZXo500+SlZHTG7L4QlP4y67OVR/IRb6S4WHfRMLv3QRgwHfViKlA1N8zQsaj0IfSV
         9MEVX5GHWTZ0mXH8FwR+B69ozhx0xPpqj5Wx0KcWzXRNyASjBscdXv3U8o3R5Iks9j
         BIRKrPtot4rZVQkjzQfB7weWiViPQVty2RF8PKN5rcvvSQgmMj6ybvBvppXv87Vsan
         L01qtC133i8aEFHHedU9oH6/Gqw8+1OoH8IxJIF+v/C5W4Zn1AG6V5urwUBnilsjzw
         nHzT+QIE+7D3Kd+XASovYbJDtwVunVgX7Q270c7qGxmWqO3rOqthPXVwxRIMce4wqn
         p2ou0GWDdbrYQ==
Received: by mail-yb1-f180.google.com with SMTP id 192so20578617ybd.10
        for <linux-raid@vger.kernel.org>; Mon, 07 Feb 2022 21:45:58 -0800 (PST)
X-Gm-Message-State: AOAM530KwqsyTrsnLrS3DyqJ62RqVuVUqK6kNUsxoNJy4/lke3jWySVi
        XfekSpgMqFZCtnZzHRhn5dOr12GYmS88+MOmi1s=
X-Google-Smtp-Source: ABdhPJzRt62O6kF0ka9ri10S1ZDahDfmUsiQaSyfZXrmoLyF0yeNvUV5nbVsSsTDvQRl7+DAxiooBMuFb6KguuArhU4=
X-Received: by 2002:a81:980d:: with SMTP id p13mr3419942ywg.130.1644299157592;
 Mon, 07 Feb 2022 21:45:57 -0800 (PST)
MIME-Version: 1.0
References: <20220206205137.21717-1-dmueller@suse.de>
In-Reply-To: <20220206205137.21717-1-dmueller@suse.de>
From:   Song Liu <song@kernel.org>
Date:   Mon, 7 Feb 2022 21:45:45 -0800
X-Gmail-Original-Message-ID: <CAPhsuW58UrCJMgKiW0mRSMbc00UoZtY=944Ut1SvjDHewM+gmA@mail.gmail.com>
Message-ID: <CAPhsuW58UrCJMgKiW0mRSMbc00UoZtY=944Ut1SvjDHewM+gmA@mail.gmail.com>
Subject: Re: [PATCH] fix multiple definition linking error due to missing extern
To:     =?UTF-8?B?RGlyayBNw7xsbGVy?= <dmueller@suse.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Feb 6, 2022 at 12:59 PM Dirk M=C3=BCller <dmueller@suse.de> wrote:
>
> GCC 10+ defaults to -fno-common, which enforces proper declaration of
> external references using "extern". without this change a link would
> fail with:
>
>   lib/raid6/test/algos.c:28: multiple definition of `raid6_call';
>   lib/raid6/test/test.c:22: first defined here
>
> Signed-off-by: Dirk M=C3=BCller <dmueller@suse.de>
> ---
>  lib/raid6/test/test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/raid6/test/test.c b/lib/raid6/test/test.c
> index a3cf071941ab..ab0459150a61 100644
> --- a/lib/raid6/test/test.c
> +++ b/lib/raid6/test/test.c
> @@ -19,7 +19,7 @@
>  #define NDISKS         16      /* Including P and Q */
>
>  const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(PAGE_=
SIZE)));
> -struct raid6_calls raid6_call;
> +extern struct raid6_calls raid6_call;

Can we just remove this line?

Thanks,
Song
