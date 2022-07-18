Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1081EC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 06:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbiGRGIi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 02:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbiGRGIh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 02:08:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9759A11A26
        for <linux-raid@vger.kernel.org>; Sun, 17 Jul 2022 23:08:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38F5A611E8
        for <linux-raid@vger.kernel.org>; Mon, 18 Jul 2022 06:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEEBC341C0
        for <linux-raid@vger.kernel.org>; Mon, 18 Jul 2022 06:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658124515;
        bh=jvJAF6+9N8FWWEoaBPn4EuAMjH5fGIqWdGe5Pypy3HM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kFnInymuMp5KOaYJhBWABu7pY4sYzE1nxofSlatRVS6B+YqAu3iDWi/49v13qsEVy
         uR/G63UrZYkpjTLj1qU0gwkdlNw5L0r6VP/fEShU5NdZwQROYEFaJ4Kvieg6kzqkIk
         uvwma68iGquJSgwmif4PHy/6BSuOtgueoScL5tsel3C8UCv61HE7FmztVph2FzXlNx
         z9L1AcBUGS4Kw+BDVOaxGoTteSUNWITtKhsHUCv9wbWkJl29TNpvDXXVywxWT2Zzu/
         cnbJJyF3b4QG1uj0NlT/bQ0wnxsAT3Rg7URfuxn90T5kiKifark2hKj8vgpM8GPVgc
         eTXOm/kbikDSg==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-31c86fe1dddso96795917b3.1
        for <linux-raid@vger.kernel.org>; Sun, 17 Jul 2022 23:08:35 -0700 (PDT)
X-Gm-Message-State: AJIora+Ls+l+Ma1LqcZDlzuZCMKDIsKrvZ1iVB35oWGznxTnkjrN27qk
        4aPx1K7owlN6koFe1fV9bXeso8crNeWF+1CosGk=
X-Google-Smtp-Source: AGRyM1vCdg89v/GkGk66ndkSsVa3Q8OkU0Cx6oNA4W7XDM8hYw2IT2QMpaVR0smJWCJYKcH5O4wK0CBrr2wKka/w2Bk=
X-Received: by 2002:a0d:d757:0:b0:31c:87bb:d546 with SMTP id
 z84-20020a0dd757000000b0031c87bbd546mr27642034ywd.472.1658124514667; Sun, 17
 Jul 2022 23:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220716031136.1426264-1-liu.yun@linux.dev> <CAPhsuW7O2V1D4OT7xJKnjeQVVd8=oKLsxq7K4mXJGR31MN03Lw@mail.gmail.com>
 <8c062246-5cdf-9821-c047-e18f54f392e3@linux.dev>
In-Reply-To: <8c062246-5cdf-9821-c047-e18f54f392e3@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Sun, 17 Jul 2022 23:08:23 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5qeiAUPmOg33JPH-ha1Rus+1qA0ET+oQLLhex6w65MDg@mail.gmail.com>
Message-ID: <CAPhsuW5qeiAUPmOg33JPH-ha1Rus+1qA0ET+oQLLhex6w65MDg@mail.gmail.com>
Subject: Re: [PATCH RESEND] raid5: fix duplicate checks for rdev->saved_raid_disk
To:     Jackie Liu <liu.yun@linux.dev>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Jul 17, 2022 at 10:19 PM Jackie Liu <liu.yun@linux.dev> wrote:
>
> Hi, Song.
>
> =E5=9C=A8 2022/7/17 13:31, Song Liu =E5=86=99=E9=81=93:
> > On Fri, Jul 15, 2022 at 8:11 PM Jackie Liu <liu.yun@linux.dev> wrote:
> >>
> >> From: Jackie Liu <liuyun01@kylinos.cn>
> >>
> >> 'first' will always be greater than or equal to 0, it is unnecessary t=
o
> >> repeat the 0 check, clean it up.
> >>
> >> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> >
> > This looks identical to the original version. Which branch is this base=
d on?
> > Please rebase on top of md-next branch and resend the patch:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/log/?h=3Dmd=
-next
> >
>
> The md-next branch is lower than the upstream version, v5.19-rc5
> adds a patch.
>
> commit 617b365872a247480e9dcd50a32c8d1806b21861
> Author: Mikulas Patocka <mpatocka@redhat.com>
> Date:   Wed Jun 29 13:40:57 2022 -0400
>
>      dm raid: fix KASAN warning in raid5_add_disks
>
>      There's a KASAN warning in raid5_add_disk when running the LVM
> testsuite.
>      The warning happens in the test
>      lvconvert-raid-reshape-linear_to_raid6-single-type.sh. We fix the
> warning
>      by verifying that rdev->saved_raid_disk is within limits.
>
>      Cc: stable@vger.kernel.org
>      Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>      Signed-off-by: Mike Snitzer <snitzer@kernel.org>
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ba289411f26f..20e53b167f81 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8065,6 +8065,7 @@ static int raid5_add_disk(struct mddev *mddev,
> struct md_rdev *rdev)
>           */
>          if (rdev->saved_raid_disk >=3D 0 &&
>              rdev->saved_raid_disk >=3D first &&
> +           rdev->saved_raid_disk <=3D last &&
>              conf->disks[rdev->saved_raid_disk].rdev =3D=3D NULL)
>                  first =3D rdev->saved_raid_disk;
>
> ...
> can you rebase from upstream? Thanks.

ah, I see. Now it works. No need to resend.

Thanks,
Song
