Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708EEC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 18:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbiGSSqF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 14:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiGSSqF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 14:46:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA22550BE
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 11:46:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 198C1B81CCD
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 18:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CADC341C6
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 18:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658256359;
        bh=pUaQ9TtdJJkbUE18NPuIHOyu3arSUBWBeXjtbXn27a8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=J/MkY0GfDoZ4BR0jIbED99Rsa7hBEKOv0wtdxf7zjnsGuefDLYvY0/A8VX/qkUe6u
         A6ZT3n7kKpYYSzYeBGR3ybRvnFRtgoKOkfU9e+58CFcT/y5s4czlaSD3Mhumgl4YZ7
         jrk4viEVRIIQbEC5aed2vFAPOT4Tzf6lbO9hAl63NnJREDhrObhYgz8CPJsp7z9Sub
         Pnv7/H2YpD1WbhijI7ektcKZY5iDAoa6LqrZ0T8uD6XhWu0NPw68zZhqWrICQX7pWZ
         MfH1yzepoqpJkRxg9uisRJvK4GE6Mv3AZwaarGTcesyC1rX0aGseqA7HiUGq67FcjP
         L6eE1NkL1E8pQ==
Received: by mail-yb1-f175.google.com with SMTP id i206so28149075ybc.5
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 11:45:59 -0700 (PDT)
X-Gm-Message-State: AJIora92OuYCjYeuoCApi42n7KKj7lpb3B/F9+KmW6utD5DKNOuU0kqQ
        7eLEMqiVv7DLZedX9Y3hA8tGS2BQGdjtD8obZU4=
X-Google-Smtp-Source: AGRyM1vBd+Tvkh8Loo+TVFJ/GWI26b4UyZhw0lGI1qh8e0QJUO23Ez6CEhjTtW94V9vVSRsswVNjjEn12xLdAHJP844=
X-Received: by 2002:a25:2595:0:b0:670:3a85:78a2 with SMTP id
 l143-20020a252595000000b006703a8578a2mr11580048ybl.389.1658256358854; Tue, 19
 Jul 2022 11:45:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220716031136.1426264-1-liu.yun@linux.dev> <CAPhsuW7O2V1D4OT7xJKnjeQVVd8=oKLsxq7K4mXJGR31MN03Lw@mail.gmail.com>
 <8c062246-5cdf-9821-c047-e18f54f392e3@linux.dev> <CAPhsuW5qeiAUPmOg33JPH-ha1Rus+1qA0ET+oQLLhex6w65MDg@mail.gmail.com>
In-Reply-To: <CAPhsuW5qeiAUPmOg33JPH-ha1Rus+1qA0ET+oQLLhex6w65MDg@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 19 Jul 2022 11:45:48 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4d9kS9m211wrQUFeXQdeim7POpoWno-1_fFocNS=ik6g@mail.gmail.com>
Message-ID: <CAPhsuW4d9kS9m211wrQUFeXQdeim7POpoWno-1_fFocNS=ik6g@mail.gmail.com>
Subject: Re: [PATCH RESEND] raid5: fix duplicate checks for rdev->saved_raid_disk
To:     Jackie Liu <liu.yun@linux.dev>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jackie,

As suggested by Jens, I will postpone this fix until after the merge window=
.

Thanks,
Song

On Sun, Jul 17, 2022 at 11:08 PM Song Liu <song@kernel.org> wrote:
>
> On Sun, Jul 17, 2022 at 10:19 PM Jackie Liu <liu.yun@linux.dev> wrote:
> >
> > Hi, Song.
> >
> > =E5=9C=A8 2022/7/17 13:31, Song Liu =E5=86=99=E9=81=93:
> > > On Fri, Jul 15, 2022 at 8:11 PM Jackie Liu <liu.yun@linux.dev> wrote:
> > >>
> > >> From: Jackie Liu <liuyun01@kylinos.cn>
> > >>
> > >> 'first' will always be greater than or equal to 0, it is unnecessary=
 to
> > >> repeat the 0 check, clean it up.
> > >>
> > >> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> > >
> > > This looks identical to the original version. Which branch is this ba=
sed on?
> > > Please rebase on top of md-next branch and resend the patch:
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/log/?h=3D=
md-next
> > >
> >
> > The md-next branch is lower than the upstream version, v5.19-rc5
> > adds a patch.
> >
> > commit 617b365872a247480e9dcd50a32c8d1806b21861
> > Author: Mikulas Patocka <mpatocka@redhat.com>
> > Date:   Wed Jun 29 13:40:57 2022 -0400
> >
> >      dm raid: fix KASAN warning in raid5_add_disks
> >
> >      There's a KASAN warning in raid5_add_disk when running the LVM
> > testsuite.
> >      The warning happens in the test
> >      lvconvert-raid-reshape-linear_to_raid6-single-type.sh. We fix the
> > warning
> >      by verifying that rdev->saved_raid_disk is within limits.
> >
> >      Cc: stable@vger.kernel.org
> >      Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >      Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> >
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index ba289411f26f..20e53b167f81 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -8065,6 +8065,7 @@ static int raid5_add_disk(struct mddev *mddev,
> > struct md_rdev *rdev)
> >           */
> >          if (rdev->saved_raid_disk >=3D 0 &&
> >              rdev->saved_raid_disk >=3D first &&
> > +           rdev->saved_raid_disk <=3D last &&
> >              conf->disks[rdev->saved_raid_disk].rdev =3D=3D NULL)
> >                  first =3D rdev->saved_raid_disk;
> >
> > ...
> > can you rebase from upstream? Thanks.
>
> ah, I see. Now it works. No need to resend.
>
> Thanks,
> Song
