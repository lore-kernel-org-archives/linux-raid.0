Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9847AEB64DB
	for <linux-raid@archiver.kernel.org>; Tue, 20 Jun 2023 09:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjFTJIx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Jun 2023 05:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjFTJIm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Jun 2023 05:08:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E96170C
        for <linux-raid@vger.kernel.org>; Tue, 20 Jun 2023 02:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687252077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u89KDtFujgbOaugYBCeOSK6tTLWa4RqxaoIKqf8zGz0=;
        b=NSzvob5TXn0bnJqGxwNEShSiN3C29NrytHQVP4Qjp0KK9wPuxnvobYHOxnmyGTuGeDTidE
        hqsyB2UkxF/F+83z+CHwcWl9pmx7897vWmnpfujMgbpq5svULRhwlvqm3Csxy5+i55+scN
        pLga8y3K1davmG+sGhvWl9d3ulWa1nE=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-5bdw4TyxO5WNgYTQTp1Bkg-1; Tue, 20 Jun 2023 05:07:55 -0400
X-MC-Unique: 5bdw4TyxO5WNgYTQTp1Bkg-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-39ec7630322so1933852b6e.0
        for <linux-raid@vger.kernel.org>; Tue, 20 Jun 2023 02:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687252075; x=1689844075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u89KDtFujgbOaugYBCeOSK6tTLWa4RqxaoIKqf8zGz0=;
        b=dTDarkytlwexj4gQ9lUb73XPFvRkd6J/XayeCshZYl8U05PrzeXDPxxB50uZ8XgTQ9
         XfgNqPcaR/mPtvy25oDM2pn6N5Vt9qPDviOudPoHUofOzZu54l3THYCDsfmw9wGEFaqF
         hVYTml+F5ZRIgQERpmE/KKOYnILpgPFiNsffTW7N/E1AxkOxoVqHwmfLHNy5wH9KWkxj
         q33GP4SbgSKNfxUcv+uSTfj/ztqbDOX38JtpwrOO3GQAVvnyfprdTSTIKGIGofCCpiaZ
         DoyLPBf1IHrnldhtjLngyDx8gfYs7+tWcfz+yH1OTXHE5I0M3zb+GJBQ2fe16COPIZms
         5OAw==
X-Gm-Message-State: AC+VfDxUK7assvXe0FDXXsVfsiESjWMcCBVFKlbxn7LkTx4b9JzzH/IL
        S3kx2pBQ5rG+ZIXLCyfZ1Jbxc4UAjawBjaHe9xJ3iZvtqRvAaSPei+Lpu7oBCsVcbpro+mvMrcV
        Fj8IOl0ldnNCfWd+ql3aF4OXnmCoDSLm5L8e2gA==
X-Received: by 2002:a05:6808:1901:b0:3a0:3476:ac97 with SMTP id bf1-20020a056808190100b003a03476ac97mr3273661oib.52.1687252075118;
        Tue, 20 Jun 2023 02:07:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6T26dtBdTUdqEBBapqGQKcAxmd3pstGOLPCeF17m31P3jBQvT58Twa1/gT4auFglazfm0AwH0df5je0w2Gykw=
X-Received: by 2002:a05:6808:1901:b0:3a0:3476:ac97 with SMTP id
 bf1-20020a056808190100b003a03476ac97mr3273652oib.52.1687252074859; Tue, 20
 Jun 2023 02:07:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230619204826.755559-1-yukuai1@huaweicloud.com> <20230619204826.755559-5-yukuai1@huaweicloud.com>
In-Reply-To: <20230619204826.755559-5-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 20 Jun 2023 17:07:43 +0800
Message-ID: <CALTww28AYb3Gi0qKHqsRuFrS0_P9-Fo1BYhsvTsrTFKnu084SA@mail.gmail.com>
Subject: Re: [PATCH -next 4/8] md/raid1: switch to use md_account_bio() for io accounting
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, yukuai3@huawei.com,
        yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jun 19, 2023 at 8:49=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Two problems can be fixed this way:
>
> 1) 'active_io' will represent inflight io instead of io that is
> dispatching.
>
> 2) If io accounting is enabled or disabled while io is still inflight,
> bio_start_io_acct() and bio_end_io_acct() is not balanced and io
> inflight counter will be leaked.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/raid1.c | 14 ++++++--------
>  drivers/md/raid1.h |  1 -
>  2 files changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index dd25832eb045..06fa1580501f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -304,8 +304,6 @@ static void call_bio_endio(struct r1bio *r1_bio)
>         if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>                 bio->bi_status =3D BLK_STS_IOERR;
>
> -       if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
> -               bio_end_io_acct(bio, r1_bio->start_time);
>         bio_endio(bio);
>  }
>
> @@ -1303,10 +1301,10 @@ static void raid1_read_request(struct mddev *mdde=
v, struct bio *bio,
>         }
>
>         r1_bio->read_disk =3D rdisk;
> -
> -       if (!r1bio_existed && blk_queue_io_stat(bio->bi_bdev->bd_disk->qu=
eue))
> -               r1_bio->start_time =3D bio_start_io_acct(bio);
> -
> +       if (!r1bio_existed) {
> +               md_account_bio(mddev, &bio);
> +               r1_bio->master_bio =3D bio;
> +       }
>         read_bio =3D bio_alloc_clone(mirror->rdev->bdev, bio, gfp,
>                                    &mddev->bio_set);
>
> @@ -1500,8 +1498,8 @@ static void raid1_write_request(struct mddev *mddev=
, struct bio *bio,
>                 r1_bio->sectors =3D max_sectors;
>         }
>
> -       if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
> -               r1_bio->start_time =3D bio_start_io_acct(bio);
> +       md_account_bio(mddev, &bio);
> +       r1_bio->master_bio =3D bio;
>         atomic_set(&r1_bio->remaining, 1);
>         atomic_set(&r1_bio->behind_remaining, 0);
>
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index 468f189da7a0..14d4211a123a 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -157,7 +157,6 @@ struct r1bio {
>         sector_t                sector;
>         int                     sectors;
>         unsigned long           state;
> -       unsigned long           start_time;
>         struct mddev            *mddev;
>         /*
>          * original bio going to /dev/mdx
> --
> 2.39.2
>

Hi Kuai

After this patch, raid1 will have one more memory allocation in the
I/O path. Not sure if it can affect performance. Beside this, the
patch is good for me.

Reviewed-by: Xiao Ni <xni@redhat.com>

