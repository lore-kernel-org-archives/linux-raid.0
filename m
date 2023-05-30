Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80AA7C77B7A
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 22:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbjE3WUh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 May 2023 18:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbjE3WUg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 30 May 2023 18:20:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398A3EC;
        Tue, 30 May 2023 15:20:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C980F62B56;
        Tue, 30 May 2023 22:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBDEC433D2;
        Tue, 30 May 2023 22:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685485234;
        bh=2trLB9mJazIsJ+HTMKPp7ovHRwQNo7xd+PEwZQ+UIYg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CRuzqcxd0C89vvW00KNplKdfkD6pE4TpFVIDARI7u3U1T6vag5MxGJ9KOuFd5RZmf
         2bzg9AQlYv95xo1Ninx1yhUOJJJWHu7WD4sQgU8cmWgUIniYDSv9JsyO3H0WGAd4Nu
         DK1WDpVTahPCPrPMM3F6MvLM5E7vi6brvXKrL7+Y5NBQSAXSVFtjwNgi+aqU+wUfMm
         I2TouBaq4SfBv0yEuwZN/WD/000Yh+iKH4LMgQAd3PJ3b+cSl1c2s09JE86BfAvuVB
         BQXCUjnG9G1Mwub7DMYRdgFmVprbyV9wvljjaUzNZpQVzHvBnWBD91f6xkjacw2UiG
         U/1DuW9qH/SWA==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2af98eb6ef0so55724711fa.3;
        Tue, 30 May 2023 15:20:34 -0700 (PDT)
X-Gm-Message-State: AC+VfDx4fPvz715TcgXTZkiw/a5Uf+aDXbVCqHI9JtyieZd49ePFYou/
        8jDBFIyuhGmImQheu4MMBAYwR2vgxBCjcRYhQUg=
X-Google-Smtp-Source: ACHHUZ6QGvDHbOS41ufK5Rc4GB6v/aWIq+j79Hrjd3nx0m0U9ux7Ke4MEuKP6C0OEMhJP8D7OcDtJhCnfLgqsXA82zI=
X-Received: by 2002:a2e:350c:0:b0:2ab:6e23:ef71 with SMTP id
 z12-20020a2e350c000000b002ab6e23ef71mr1572061ljz.37.1685485232261; Tue, 30
 May 2023 15:20:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230527101851.3266500-1-linan666@huaweicloud.com>
 <20230527101851.3266500-2-linan666@huaweicloud.com> <216ed892-11a9-2d8b-c6d5-a0c7dabe2c9d@huaweicloud.com>
In-Reply-To: <216ed892-11a9-2d8b-c6d5-a0c7dabe2c9d@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 30 May 2023 15:20:20 -0700
X-Gmail-Original-Message-ID: <CAPhsuW56xuywG80HsS_AQLh9pUUTAztM9wkN=c6Q2ukSqTtNbw@mail.gmail.com>
Message-ID: <CAPhsuW56xuywG80HsS_AQLh9pUUTAztM9wkN=c6Q2ukSqTtNbw@mail.gmail.com>
Subject: Re: [PATCH] md/raid10: clean up md_add_new_disk()
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linan666@huaweicloud.com, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, linan122@huawei.com,
        yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, May 28, 2023 at 12:49=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> =E5=9C=A8 2023/05/27 18:18, linan666@huaweicloud.com =E5=86=99=E9=81=93:
> > From: Li Nan <linan122@huawei.com>
> >
> > Commit 1a855a060665 ("md: fix bug with re-adding of partially recovered
> > device.") only add device which is set to In_sync. But it let devices
> > without metadata cannot be added when they should be.
> >
> > Commit bf572541ab44 ("md: fix regression with re-adding devices to arra=
ys
> > with no metadata") fix the above issue, it set device without metadata =
to
> > In_sync when add new disk.
> >
> > However, after commit f466722ca614 ("md: Change handling of save_raid_d=
isk
> > and metadata update during recovery.") deletes changes of the first pat=
ch,
> > setting In_sync for devcie without metadata is meanless because the fla=
g
> > will be cleared soon and will not be used during this period. Clean it =
up.
>
> LGME, feel free to add:
>
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> >
> > Signed-off-by: Li Nan <linan122@huawei.com>

Applied to md-next.

Thanks,
Song
