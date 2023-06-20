Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 924D7EB64D7
	for <linux-raid@archiver.kernel.org>; Tue, 20 Jun 2023 09:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbjFTJPl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Jun 2023 05:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbjFTJPU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Jun 2023 05:15:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B45A1FD2
        for <linux-raid@vger.kernel.org>; Tue, 20 Jun 2023 02:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687252348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j+DstClbbuIYoLgiuHR0ngP8+VmdOxHjqeCjdjYlEa0=;
        b=YX9MDgCOIsE7cMjKzIwx4EUV/E+VmSf0IdlAiR1OcDNCLbx9f0NLEJEkc+3azOk/NsB6Td
        W+1/i8NXgkaK8SnyA/kp0PBbnCwTfHGbM7SQZQymWb2lYinsa5s5Pi2dd4Np3spQyAfVC0
        3uxAhoPy078ReGbzkSL3YEm1/n9aZ74=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-WS_v7WT0MX-p929cxNCcvw-1; Tue, 20 Jun 2023 05:12:26 -0400
X-MC-Unique: WS_v7WT0MX-p929cxNCcvw-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-25e837b564eso3511074a91.1
        for <linux-raid@vger.kernel.org>; Tue, 20 Jun 2023 02:12:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687252345; x=1689844345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j+DstClbbuIYoLgiuHR0ngP8+VmdOxHjqeCjdjYlEa0=;
        b=O98L/5AicLHO+N+XZnCBtNjOSNa4XYh0UU2/kCs4OKAlYqq6OaEY9jLus5GTogBzwX
         cUlx8QeSfvK31f2MVxtSEdE03SnjmH2hWlvNEKXi8amPvpVtuL8ChWetipwUrMNkjmc2
         ShnepYtqYhYk3ahcgJYHqqWetTcWX75Rr4bGpXorv5iBaJV6epR4u2QFYICBkezF4YV2
         Y0yzVsV05soK0ndx7yIMQI2qrGdJ3AzC9wU4peHy34wpsk11wS0N9n5zzByIqCSCFQAZ
         V6kQlNe8YJHvPqEAvGQpaVzQywYddHZYf6WoxPWJQKAtM1YYWfxY7h67W/RUfpeNK6Qq
         jAKQ==
X-Gm-Message-State: AC+VfDyTYRge34Qdr02Q67n5xT4HvFU/sdBLqFmPwm4a6oHVWoTNgsJB
        dSk1VMD1KpeasHwe+EWMIT4OkjWDsm9njwEGZ4MPC1RH1RS9a+qaq8ez+jqHvuWsaHkJnijd1mn
        FfbJX4mG2F6SLGGr33D2FOsJ5Cj8MJh6u45+sIagKkG61JnlC
X-Received: by 2002:a17:90a:38a1:b0:25e:886b:c6b with SMTP id x30-20020a17090a38a100b0025e886b0c6bmr10183568pjb.48.1687252345442;
        Tue, 20 Jun 2023 02:12:25 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5yf4FPi/w3rtXTM9KFhnWJaEmjdafqvs3GuqucUyaXBBPbxjvZ8esvPhO3pQcCESORqo2VmW2rh9OP3FsbCMQ=
X-Received: by 2002:a17:90a:38a1:b0:25e:886b:c6b with SMTP id
 x30-20020a17090a38a100b0025e886b0c6bmr10183561pjb.48.1687252345241; Tue, 20
 Jun 2023 02:12:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230619204826.755559-1-yukuai1@huaweicloud.com> <20230619204826.755559-8-yukuai1@huaweicloud.com>
In-Reply-To: <20230619204826.755559-8-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 20 Jun 2023 17:12:14 +0800
Message-ID: <CALTww2-_CTY3b9L1OYz0yJUBtNJPmANmw1-RWpDhEQgKCbhewQ@mail.gmail.com>
Subject: Re: [PATCH -next 7/8] md/md-linear: enable io accounting
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
>  drivers/md/md-linear.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index 4eb72b9dd933..71ac99646827 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -238,6 +238,7 @@ static bool linear_make_request(struct mddev *mddev, =
struct bio *bio)
>                 bio =3D split;
>         }
>
> +       md_account_bio(mddev, &bio);
>         bio_set_dev(bio, tmp_dev->rdev->bdev);
>         bio->bi_iter.bi_sector =3D bio->bi_iter.bi_sector -
>                 start_sector + data_offset;
> --
> 2.39.2
>

Reviewed-by: Xiao Ni <xni@redhat.com>

