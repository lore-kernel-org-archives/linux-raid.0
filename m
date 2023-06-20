Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D7DEB64DB
	for <linux-raid@archiver.kernel.org>; Tue, 20 Jun 2023 09:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjFTJPr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Jun 2023 05:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjFTJPZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Jun 2023 05:15:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1611FCF
        for <linux-raid@vger.kernel.org>; Tue, 20 Jun 2023 02:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687252408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NAVkAXb8ZdoRS9PdEG1Q3OrXjJSIDKD/SmD3bUVe+po=;
        b=PA5jh2zvf5Dc4UgWRoscDwY92Wqgi34mhgaUXTfyhWilSXhwdCV4VawRAuBJm4mRWd7IEn
        HFq6HSHoZYWgLLHz92WIeCSj0ZBf+aWoYILI9Lod2xeMd604gA+pBbHnhWjH5854Qk0CU1
        KamezKyhnXZmklZFVAgRPKqf/UQubpE=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-mO9zoiHkNba2kopSVSnBAg-1; Tue, 20 Jun 2023 05:13:26 -0400
X-MC-Unique: mO9zoiHkNba2kopSVSnBAg-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-25f020b30d6so1762244a91.1
        for <linux-raid@vger.kernel.org>; Tue, 20 Jun 2023 02:13:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687252405; x=1689844405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NAVkAXb8ZdoRS9PdEG1Q3OrXjJSIDKD/SmD3bUVe+po=;
        b=c6tcH6vDUP4/hoB0Um2sE0WuiNk+qkXfVRxbrur1DcqdM4PZlpfrLT/EuDwf3ZV+jj
         BaUpGGPR9Ue3PotF4IIgknC5P3s3ECg++JtQhwa8BZzMlZIbuHT2Y2Pt8/diFOTYNpvt
         lzeVyz8hzV5R+IjzLvZU/EMvvdvnFhGPqsDcSClskAGiK08iJ4F8725ESTO/7i7+LOs3
         3OTxdQPdX+WpUNdXbmAKQMSKDxcoHBtM8CFVsy3AtyMSk6yGn2VRDpkRq6vZJYGkGLGF
         3YoLEwEBQrbEnp7Gbt/JHeYGRHVBWVhnzuvvSzmNwR9wUl1tUTGwxQUuMdwacmkbwca2
         ymOw==
X-Gm-Message-State: AC+VfDwzxHGqidyOlFbXIDRCeuvpdRQZsKO6AbYJUrw/ApoYxPI5tIeN
        EfeWGSaOLSurqTe18xoBF9fMYOnthr27oEZN9S/JbBeEDFaofXbTypCnrYhEA65eRDqYGBpLvrO
        oUiqfHdvltUHKRHDCdlU3A4YHbPdk+BcEzxzP8g==
X-Received: by 2002:a17:90a:7064:b0:25e:2db8:cc5f with SMTP id f91-20020a17090a706400b0025e2db8cc5fmr12181218pjk.40.1687252405669;
        Tue, 20 Jun 2023 02:13:25 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7zyp0Fo1BsQtG2HUOps6dAU73J5PL1i+1AcHvwya2p2QUZiJlzTP9D9QVWsqaLxZx1/g1L9jfFZpQbmAUpLBo=
X-Received: by 2002:a17:90a:7064:b0:25e:2db8:cc5f with SMTP id
 f91-20020a17090a706400b0025e2db8cc5fmr12181209pjk.40.1687252405456; Tue, 20
 Jun 2023 02:13:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230619204826.755559-1-yukuai1@huaweicloud.com> <20230619204826.755559-9-yukuai1@huaweicloud.com>
In-Reply-To: <20230619204826.755559-9-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 20 Jun 2023 17:13:14 +0800
Message-ID: <CALTww28zutAQp_fv-H5aFRH2Jtv7+WTiedtjTO1NpmfGnVg1YA@mail.gmail.com>
Subject: Re: [PATCH -next 8/8] md/md-faulty: enable io accounting
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, yukuai3@huawei.com,
        yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jun 19, 2023 at 8:50=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> use md_account_bio() to enable io accounting, also make sure
> mddev_suspend() will wait for all io to be done.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md-faulty.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/md-faulty.c b/drivers/md/md-faulty.c
> index 50ad818978a4..a039e8e20f55 100644
> --- a/drivers/md/md-faulty.c
> +++ b/drivers/md/md-faulty.c
> @@ -204,6 +204,8 @@ static bool faulty_make_request(struct mddev *mddev, =
struct bio *bio)
>                         failit =3D 1;
>                 }
>         }
> +
> +       md_account_bio(mddev, &bio);
>         if (failit) {
>                 struct bio *b =3D bio_alloc_clone(conf->rdev->bdev, bio, =
GFP_NOIO,
>                                                 &mddev->bio_set);
> --
> 2.39.2
>

Reviewed-by: Xiao Ni <xni@redhat.com>

