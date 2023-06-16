Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6E7EB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 06:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242629AbjFPGMr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 02:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbjFPGMp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 02:12:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5B4269E;
        Thu, 15 Jun 2023 23:12:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A35F0622C0;
        Fri, 16 Jun 2023 06:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E064BC433C8;
        Fri, 16 Jun 2023 06:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686895962;
        bh=JiyaFCT5XlQ5cdqxzxNN/QD3/0qLm+DuVjJw4o9ljwQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pUBf/xg8lWvY3+0lGdY5WnLFtxkq7oE3dmIMKdkCq6tsljGxUjfc2/YZCSCodv9yj
         5llG8LKlBHGDIreDK/9G5kKp4q9BMl7he/Mi7P+wOvJrNq2Og4x4eBmTNutf5iPAPa
         fVPLd/OaotbcSwMu+fJOMGRlCwS7WiwhyEFEycJhmL+f9EAAY2yEbrUlVuvj7eDXDQ
         TnC2av6PSpuSWlTepzY9fXUpuAS+Of8fWpD92iJhogBFlFWcWlMpq/5+V4X43LG7kI
         vv/hQT+aB0QoLr6b1HnCymvZO09Q8tB7Z+AjdEnRxuwhXWYyJ12mkY9BY4o/iY14Sr
         LFdfVAkiPuI+A==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2b44d77e56bso7128661fa.1;
        Thu, 15 Jun 2023 23:12:42 -0700 (PDT)
X-Gm-Message-State: AC+VfDw/GzR+16Ck9y8EVcSwsmdIdrik82or2PsMniiLQ5iMxWbC8AR1
        80OD/t9C6s3j9cIt21k5q7GD8tGI2HIeWEq3PoQ=
X-Google-Smtp-Source: ACHHUZ4AA/u7+Ga1juEQ6ZdLwCv/lFl4xR4NDPTHT326ul+mLNEOxL+uAVnKdNgfu/jR9xuhLC6dlFxg8XZ413kt1QQ=
X-Received: by 2002:a2e:9b01:0:b0:2a2:ac00:4de4 with SMTP id
 u1-20020a2e9b01000000b002a2ac004de4mr241405lji.22.1686895960931; Thu, 15 Jun
 2023 23:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230609094320.2397604-1-linan666@huaweicloud.com>
In-Reply-To: <20230609094320.2397604-1-linan666@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 15 Jun 2023 23:12:28 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6imRp9jseup660xQiV7optVwk-vPWz77aG3=4niUrMRQ@mail.gmail.com>
Message-ID: <CAPhsuW6imRp9jseup660xQiV7optVwk-vPWz77aG3=4niUrMRQ@mail.gmail.com>
Subject: Re: [PATCH] md/raid10: Only check QUEUE_FLAG_IO_STAT when issuing io
To:     linan666@huaweicloud.com
Cc:     jgq516@gmail.com, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, linan122@huawei.com,
        yukuai3@huawei.com, yi.zhang@huawei.com, houtao1@huawei.com,
        yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Jun 9, 2023 at 2:47=E2=80=AFAM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> /sys/block/[device]/queue/iostats is used to control whether to count io
> stat. Write 0 to it will clear queue_flags QUEUE_FLAG_IO_STAT which means
> iostats is disabled. If we disable iostats and later endable it, the io
> issued during this period will be counted incorrectly, inflight will be
> decreased to -1.
>
>   //T1 set iostats
>   echo 0 > /sys/block/md0/queue/iostats
>    clear QUEUE_FLAG_IO_STAT
>
>                         //T2 issue io
>                         if (QUEUE_FLAG_IO_STAT) -> false
>                          bio_start_io_acct
>                           inflight++
>
>   echo 1 > /sys/block/md0/queue/iostats
>    set QUEUE_FLAG_IO_STAT
>
>                                         //T3 io end
>                                         if (QUEUE_FLAG_IO_STAT) -> true
>                                          bio_end_io_acct
>                                           inflight--    -> -1
>
> Also, if iostats is enabled while issuing io but disabled while io end,
> inflight will never be decreased.
>
> Fix it by checking start_time when io end. Only check QUEUE_FLAG_IO_STAT
> while issuing io, just like request based devices.
>
> Fixes: 528bc2cf2fcc ("md/raid10: enable io accounting")
> Signed-off-by: Li Nan <linan122@huawei.com>

The subject and commit log is a little confusing. I updated it a little
bit and applied to md-next.

Thanks,
Song


> ---
>  drivers/md/raid10.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 381c21f7fb06..bf9dca5c25c3 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -325,7 +325,7 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
>         if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
>                 bio->bi_status =3D BLK_STS_IOERR;
>
> -       if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
> +       if (r10_bio->start_time)
>                 bio_end_io_acct(bio, r10_bio->start_time);
>         bio_endio(bio);
>         /*
> --
> 2.39.2
>
