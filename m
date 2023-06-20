Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D91EB64DB
	for <linux-raid@archiver.kernel.org>; Tue, 20 Jun 2023 09:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbjFTJMZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Jun 2023 05:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbjFTJMR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Jun 2023 05:12:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3CC1987
        for <linux-raid@vger.kernel.org>; Tue, 20 Jun 2023 02:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687252282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n+0GtW6bkdqCBjUlS06id9SCgWtcNWaYm4T3cD/2Dtk=;
        b=TRQRW9XZg/v0ig+W00lRYKfWeJZ35XMZlngrgRCwTvf4n0MiYumhMFmRf6c7ftC7jhmXuF
        ujuEssRAU/5cjfsVvul2Y11huvAPSdprc4sb4sEIrOi/VREaNzF529jeO+CrmUK3VfKqQH
        w8Y4i9XNQrvQqaL4MsX7mU5KH+Ks1oI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-KqHEF2iaNP-E0_U9Rgybew-1; Tue, 20 Jun 2023 05:11:21 -0400
X-MC-Unique: KqHEF2iaNP-E0_U9Rgybew-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-25ea9bc1705so3589839a91.0
        for <linux-raid@vger.kernel.org>; Tue, 20 Jun 2023 02:11:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687252280; x=1689844280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n+0GtW6bkdqCBjUlS06id9SCgWtcNWaYm4T3cD/2Dtk=;
        b=DcotjRsEj36MuR+Irq2iOQ1+UnO2R09GJQ9yi5bzqbq3sp196zP90AzH2XlLes6o8U
         aAc4Z7WKPT/QmuTq0ViPgQYJoMU46fXbK+LNL/GaOAAVDhFkJdvYWVbfY6AUAaQJMuYM
         IjISsi6o4MKD1EIBqxrF1xrB07FWHXY5yKT8yio06f4U7bxSJvznpDAl/yZKrds0Q5sb
         /GtYX95MtJLhXb2gIiL4ZAx42zuvoMBUXSiWt6RF7TSEinBZ+4cFRWdDi3HpgkJdiEoP
         hpe5NMfZX4sJIQisiYIKfvwMQYFkSUdlXWE/Y2utCJf/IdQuhYyTXtk2Bo+H+ZTgXXvC
         z+ew==
X-Gm-Message-State: AC+VfDylzMlAJtYWGT08FW+YwOt/tcwkWMAJILf7MCi9irtysIyBB99Y
        9FMBYdJv5OSpqaH2IYZpUz3G1mPXCxIxcSNna/uQEyH2fsQ/xYBDzY/PUIM8X57u/lSNVs+CLdR
        3AmGPZCrSE/MXFZQOzSlgj/r0vY/yDxrfUaRemVdN3S4BQUOS
X-Received: by 2002:a17:90b:3881:b0:25e:f133:41cb with SMTP id mu1-20020a17090b388100b0025ef13341cbmr7009738pjb.21.1687252280304;
        Tue, 20 Jun 2023 02:11:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6sTmxyYbOXmiA8R0BgDeuOvK102mmYMt5VKcJc9LRl61g7stUC75HbUqF8IzElkXAczAB7dW/d3gEY+4rctN0=
X-Received: by 2002:a17:90b:3881:b0:25e:f133:41cb with SMTP id
 mu1-20020a17090b388100b0025ef13341cbmr7009734pjb.21.1687252280079; Tue, 20
 Jun 2023 02:11:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230619204826.755559-1-yukuai1@huaweicloud.com> <20230619204826.755559-7-yukuai1@huaweicloud.com>
In-Reply-To: <20230619204826.755559-7-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 20 Jun 2023 17:11:09 +0800
Message-ID: <CALTww28Ezy4NRvyYP7FOfcin7msGn8sr00HQFpfOEFsPyh8Asg@mail.gmail.com>
Subject: Re: [PATCH -next 6/8] md/md-multipath: enable io accounting
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
>  drivers/md/md-multipath.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
> index 92c45be203d7..d22276870283 100644
> --- a/drivers/md/md-multipath.c
> +++ b/drivers/md/md-multipath.c
> @@ -107,6 +107,7 @@ static bool multipath_make_request(struct mddev *mdde=
v, struct bio * bio)
>             && md_flush_request(mddev, bio))
>                 return true;
>
> +       md_account_bio(mddev, &bio);
>         mp_bh =3D mempool_alloc(&conf->pool, GFP_NOIO);
>
>         mp_bh->master_bio =3D bio;
> --
> 2.39.2
>

Reviewed-by: Xiao Ni <xni@redhat.com>

