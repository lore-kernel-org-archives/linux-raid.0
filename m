Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BED2C77B78
	for <linux-raid@archiver.kernel.org>; Wed, 26 Apr 2023 17:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbjDZR6g (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 Apr 2023 13:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233948AbjDZR6f (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 26 Apr 2023 13:58:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BF1618B
        for <linux-raid@vger.kernel.org>; Wed, 26 Apr 2023 10:58:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DC3561A73
        for <linux-raid@vger.kernel.org>; Wed, 26 Apr 2023 17:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF819C4339C
        for <linux-raid@vger.kernel.org>; Wed, 26 Apr 2023 17:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682531913;
        bh=SN7z3VzK04WlNUByemx8CQHAzIV7XwKryfMccUVeCg8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VG3dSOpIG0R3DeEt0PylMDmBEzNGAvww2mJUKQiNq/XtaXRwKUWXuM3Pva2lI5Uln
         VWzw+0sF7YxB9Gt14yInDVwNIvnifU6rIBQmY8PLQHEv99H9Nrg38yFNBe2n11Xu2X
         7TWCN0m9yEkcHp4p302kmY0HWznzyxNuhacoe4Ycdb8VnBZYxsygrNC+BBY0fcFBft
         pB4LgKHOJ1TcNqcygIjzKso7WrLYVsQKdLAmqh+vquNga0jpqqeajL8C68HUhtI46P
         mvycLBEK2iMia2Xrby5CL/Uj8kv/15fIcVoIAJJy7qxxkclRLzfj1HUMzkEu7ha1Ms
         kPow4pKywcj4g==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-4f004cc54f4so1275640e87.3
        for <linux-raid@vger.kernel.org>; Wed, 26 Apr 2023 10:58:33 -0700 (PDT)
X-Gm-Message-State: AAQBX9e0fb9T8QKBEIFupJ3Pz/h+VpFEzPq4xn9DBCSlw+WIoQnmvWiw
        0GiRtevfYjhDmO/lYDQiALVG69jQxNZvrRqAV0Q=
X-Google-Smtp-Source: AKy350asbKZfcosC4NU4bzU/4VnZz/afjk0yT4oaCkxvNaHF3ALKE2ov2DNuppo/f6Et19WFQjIqnfCRQ9JffLCMuTM=
X-Received: by 2002:ac2:5617:0:b0:4ed:c537:d0c2 with SMTP id
 v23-20020ac25617000000b004edc537d0c2mr5371287lfd.69.1682531911737; Wed, 26
 Apr 2023 10:58:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230425011438.71046-1-jonathan.derrick@linux.dev> <CAPhsuW6f+6nqqaap1pP_rETSk_WA68keq6wCxEJojkYcVw-Vhw@mail.gmail.com>
In-Reply-To: <CAPhsuW6f+6nqqaap1pP_rETSk_WA68keq6wCxEJojkYcVw-Vhw@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Apr 2023 10:58:19 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5LMzsus-nvNCj2Fy71cTW04rEN=bwcynqDHc7zrEYxCg@mail.gmail.com>
Message-ID: <CAPhsuW5LMzsus-nvNCj2Fy71cTW04rEN=bwcynqDHc7zrEYxCg@mail.gmail.com>
Subject: Re: [PATCH] md: Fix bitmap offset type in sb writer
To:     Jonathan Derrick <jonathan.derrick@linux.dev>
Cc:     linux-raid@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jonathan,

On Tue, Apr 25, 2023 at 8:44=E2=80=AFPM Song Liu <song@kernel.org> wrote:
>
> On Mon, Apr 24, 2023 at 6:16=E2=80=AFPM Jonathan Derrick
> <jonathan.derrick@linux.dev> wrote:
> >
> > Bitmap offset is allowed to be negative, indicating that bitmap precede=
s
> > metadata. Change the type back from sector_t to loff_t to satisfy
> > conditionals and calculations.

This actually breaks the following tests from mdadm:

05r1-add-internalbitmap-v1a
05r1-internalbitmap-v1a
05r1-remove-internalbitmap-v1a

Please look into these.

Thanks,
Song

> >
> > Signed-off-by: Jonathan Derrick <jonathan.derrick@linux.dev>
>
> I added the following to the patch and applied it to md-next.
>
> Thanks,
> Song
>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Fixes: 10172f200b67 ("md: Fix types in sb writer")
>
> > ---
> >  drivers/md/md-bitmap.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> > index 920bb68156d2..29ae7f7015e4 100644
> > --- a/drivers/md/md-bitmap.c
> > +++ b/drivers/md/md-bitmap.c
> > @@ -237,8 +237,8 @@ static int __write_sb_page(struct md_rdev *rdev, st=
ruct bitmap *bitmap,
> >         struct block_device *bdev;
> >         struct mddev *mddev =3D bitmap->mddev;
> >         struct bitmap_storage *store =3D &bitmap->storage;
> > -       sector_t offset =3D mddev->bitmap_info.offset;
> > -       sector_t ps, sboff, doff;
> > +       loff_t sboff, offset =3D mddev->bitmap_info.offset;
> > +       sector_t ps, doff;
> >         unsigned int size =3D PAGE_SIZE;
> >         unsigned int opt_size =3D PAGE_SIZE;
> >
> > --
> > 2.40.0
> >
