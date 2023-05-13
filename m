Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252A0C77B75
	for <linux-raid@archiver.kernel.org>; Sat, 13 May 2023 01:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241490AbjEMBFi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 12 May 2023 21:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241406AbjEMBFf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 12 May 2023 21:05:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170E37D80;
        Fri, 12 May 2023 18:05:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 996C1659CD;
        Sat, 13 May 2023 01:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024C2C4339E;
        Sat, 13 May 2023 01:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683939933;
        bh=kwpHAJ2wVdqZV0mOlwIPxq/rlX/dObPUyPuEg1ib/uc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iAJD0XOGTXQOOjKjSN/cE5EcIlS3wiZ43KZ/LamnS9mkkxSGiwXf0TAjvZwHbXYb2
         HmRQhfbzKq2zOirTUiXBss7UCGol/RDy6yxWcKyAWklfaQM+5yk/d371NEC9TmKbgi
         byKfQe53i79iUkz7leQ0r6NZ60QK/zN3Ypi9UHcNqqSq2HKqu5aSBhga8m8edNcHPR
         RbOdCfnIA9y+dFCOjOuwHkXA2ukmZoSNp9junSGOzahZ2WdVU2W7Y82LVNV11MHQF8
         ZlF+AIBU2/xutPP0RKYokspMPDstk+L+hEzc4LSWPDkmOpmcUDBpiUHypVZsTP0lbd
         /poDCZu9VjXMw==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2ad714536cfso85974901fa.0;
        Fri, 12 May 2023 18:05:32 -0700 (PDT)
X-Gm-Message-State: AC+VfDxosiaHnttKHDTs99nBw/ZAsrjSgwORubQT/UPjIL6CvYa4jE2z
        Z+vc8h3tvT3TJiLemTmfq8pNX35U0x+WsoFJN7A=
X-Google-Smtp-Source: ACHHUZ5TrTep2N68yW4/1DeDoSuBTwvsYDLCfvr6mZ8x7LPRNOKeUAhP4DZXaCoPSE8wIhKcdeaXmxh5CFSCVeliOUU=
X-Received: by 2002:ac2:554c:0:b0:4ea:f7be:e071 with SMTP id
 l12-20020ac2554c000000b004eaf7bee071mr3570711lfk.46.1683939930972; Fri, 12
 May 2023 18:05:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230506012315.3370489-1-linan666@huaweicloud.com> <20230506012315.3370489-2-linan666@huaweicloud.com>
In-Reply-To: <20230506012315.3370489-2-linan666@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 12 May 2023 18:05:19 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7p=xw41EZ-f+UHMO+o5bLFGirORPE-gfnkYqfpjv-rzw@mail.gmail.com>
Message-ID: <CAPhsuW7p=xw41EZ-f+UHMO+o5bLFGirORPE-gfnkYqfpjv-rzw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] md/raid10: fix slab-out-of-bounds in md_bitmap_get_counter
To:     linan666@huaweicloud.com
Cc:     neilb@suse.de, Rob.Becker@riverbed.com, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, linan122@huawei.com,
        yukuai3@huawei.com, yi.zhang@huawei.com, houtao1@huawei.com,
        yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, May 5, 2023 at 6:24=E2=80=AFPM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> If we write a large number to md/bitmap_set_bits, md_bitmap_checkpage()
> will return -EINVAL because "page >=3D bitmap->pages", but the return val=
ue
> was not checked immediately in md_bitmap_get_counter() in order to set
> *blocks value and slab-out-of-bounds occurs.
>
> Return directly if err is -EINVAL.
>
> Fixes: ef4256733506 ("md/bitmap: optimise scanning of empty bitmaps.")
> Signed-off-by: Li Nan <linan122@huawei.com>
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md-bitmap.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 920bb68156d2..0b41ef422da7 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -1388,6 +1388,8 @@ __acquires(bitmap->lock)
>         int err;
>
>         err =3D md_bitmap_checkpage(bitmap, page, create, 0);
> +       if (err =3D=3D -EINVAL)
> +               return NULL;

This logic is error prone. Since we are on it, let's fix it better.
Specifically, we can move "page >=3D bitmap->pages" check out
of md_bitmap_checkpage(). (and fix the call site in md_bitmap_resize
for clustered md).

Also, could you please add a mdadm test for this issue?

Thanks,
Song

>
>         if (bitmap->bp[page].hijacked ||
>             bitmap->bp[page].map =3D=3D NULL)
> --
> 2.31.1
>
