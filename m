Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D94C77B75
	for <linux-raid@archiver.kernel.org>; Fri, 19 May 2023 23:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjESXeQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 19 May 2023 19:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjESXeP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 19 May 2023 19:34:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6320C1B3;
        Fri, 19 May 2023 16:34:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF82D6581C;
        Fri, 19 May 2023 23:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC63C433D2;
        Fri, 19 May 2023 23:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684539253;
        bh=if2/G0ZrC+fJhWOYOagV8AnkQSj3tA63Bhq9TGZHGYk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lUPfGQ3H0PPhWZSljEEQlNvat82efDFSTpEPU/YpfYBXUa/BSz6xjXh0V47noN20x
         H7NXYE08ojKXlACq1lN/+HI8Lu+pwXFJAFxKLB6SNvhnhX4r14+CTcUM6Vd2/1zwYS
         Ft/Asn7ZpLpVoPfjySkbH1RRU/WJkRlQypVDYxVdBtXwv0CgSr6g/iCeCOMNjfHIU0
         jFMx3qsv5K1gDCYrAO964tmbhrmLOBAHBnc+8JoS1CkfU3DoEYjBWrQE3R4xviUxpT
         MUsNb02ykl6XEroBcTfacBBv0gXaY3dWhbqC5yWVN3tycD9drElS1NahM6E5pJp0Mz
         hr5/zXep1FDEg==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-4f3a9ad31dbso2264025e87.0;
        Fri, 19 May 2023 16:34:13 -0700 (PDT)
X-Gm-Message-State: AC+VfDxEy2LbY3dR6/keZUOGus9gBxaf6JlOxJLzBagPUK3ttwo+U+Ws
        xCTYpUyhaCxIxXVQLqKZ3WBgaLOEPrcNB98wzso=
X-Google-Smtp-Source: ACHHUZ6LfY6K9jjxmGKO/W1QrpyD/5wePW5/lQCKmNiE6NXZT/3Kr4Xvz33U7xtKeGUp3skcJW7qaTpzkNvN0wRJMqE=
X-Received: by 2002:ac2:5106:0:b0:4f1:4526:1d80 with SMTP id
 q6-20020ac25106000000b004f145261d80mr1047534lfb.50.1684539251410; Fri, 19 May
 2023 16:34:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230512015610.821290-1-yukuai1@huaweicloud.com> <20230512015610.821290-2-yukuai1@huaweicloud.com>
In-Reply-To: <20230512015610.821290-2-yukuai1@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 19 May 2023 16:33:59 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5YFnqkOFz2tU+GQT=TnVXc-RySECaj=FOHw2rEh5tz0g@mail.gmail.com>
Message-ID: <CAPhsuW5YFnqkOFz2tU+GQT=TnVXc-RySECaj=FOHw2rEh5tz0g@mail.gmail.com>
Subject: Re: [PATCH -next 1/5] md/raid5: don't allow replacement while reshape
 is not done
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     logang@deltatee.com, reddunur@online.de, jovetoo@gmail.com,
        dgilmour76@gmail.com, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, yukuai3@huawei.com,
        yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, May 11, 2023 at 6:59=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Set rdev replacement has but not only two conditions:
>
> 1) MD_RECOVERY_RUNNING is not set;
> 2) rdev nr_pending is 0;

The above is confusing. I updated it and applied the set to md-next.
Please let me know if it looks good.

Thanks,
Song

>
> If reshape is interrupted(for example, echo frozen to sync_action), then
> rdev replacement can be set. It's safe because reshape is always prior to
> resync in md_check_recovery(). However, if system reboots, then kernel wi=
ll
> complain cannot handle concurrent replacement and reshape and this array
> is not able to assemble anymore.
>
> Fix this problem by don't allow replacement until reshape is done.
>
> Reported-by: Peter Neuwirth <reddunur@online.de>
> Link: https://lore.kernel.org/linux-raid/e2f96772-bfbc-f43b-6da1-f520e516=
4536@online.de/
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/raid5.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a58507a4345d..bd3b535c0739 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8378,6 +8378,7 @@ static int raid5_add_disk(struct mddev *mddev, stru=
ct md_rdev *rdev)
>                 p =3D conf->disks + disk;
>                 tmp =3D rdev_mdlock_deref(mddev, p->rdev);
>                 if (test_bit(WantReplacement, &tmp->flags) &&
> +                   mddev->reshape_position =3D=3D MaxSector &&
>                     p->replacement =3D=3D NULL) {
>                         clear_bit(In_sync, &rdev->flags);
>                         set_bit(Replacement, &rdev->flags);
> --
> 2.39.2
>
