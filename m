Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16AF7C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 27 Sep 2021 13:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E961461052
	for <linux-raid@archiver.kernel.org>; Mon, 27 Sep 2021 13:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbhI0N0I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 27 Sep 2021 09:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbhI0N0I (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 27 Sep 2021 09:26:08 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C32C061604
        for <linux-raid@vger.kernel.org>; Mon, 27 Sep 2021 06:24:30 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id l19so18076213vst.7
        for <linux-raid@vger.kernel.org>; Mon, 27 Sep 2021 06:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=DAo7I/BZC1qYd6MF3qSicniWvTR8rtUDikb4S5qnXhg=;
        b=KwTuroM8SG4lRxbD4EIdWgTuAQeS+ADX1D2WvbgzV0GjrOZJF7nadBpzci5PZ0o5gP
         qacO1s82qS5PcAKflWitGfnB8HkFf8xTi6gnV5gLKqoDO/DZ9gfQ2AJpeEFqEifyBWR7
         QUYlTDIYdmdTpIf/Abq0WZSaH0HQmbfYOZENTtUGx9378wM7K3lsAxRbm0xdQdZgZPZB
         UK1R/5m9qARU1rwBaI13APQymFD10p9u6GdkL65GOwTOMchN3AAD5hHg7/cvXYeXifBL
         p43l98Em5bwPMCPbf2EOb8B7QBGUt0ob6McbDfkBjiCQaT3yde8cejoxo1sf7wxab7hx
         dQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=DAo7I/BZC1qYd6MF3qSicniWvTR8rtUDikb4S5qnXhg=;
        b=YFZ/W8NJA6LLzIDQ136IPmsi8KJk4gYY03kPn4jah4/7s91W0wYTaSBsHKHVTMDl5K
         HOT7FPr9Km0huTTFjGUdxBs5bf2y+KbHzxiEzxlwcJwoPkr+k+uqThOjTzZQCbIMViCL
         nopgm476haDreOAeDP2OEceDAh585f0RAyLata9aBMHHdi55nypOHGdOfUHbiZf97JT+
         PqS9OllotrC6bDMThJM59sVc8fbp+tqJGWFUZ5B6xA6q2eTCpPtzbNEkqFAMoJcYWB7f
         1ezE3o17SURYsvbT32U9ICQRYGZeEGODBFSf59X8bz0yGMEN/aIe9YuD9ZXLOGjVxLas
         9UmA==
X-Gm-Message-State: AOAM531BfjYy9OcEqCiPq/Df1WfFrS3sfW2xkQOSwYCAKOR4zxR3MhKs
        B2gSbzPry6K/E1tSzQ/omgBBvR8Wcn1FmynYQf7odg==
X-Google-Smtp-Source: ABdhPJy87lQ9kGwsi669ZXp5VRXHe55QPzrnJ+B227yNYkw8/SaEKJAjjvNs4HEyzuIISpGuTPTpq0tMLf6gcM0SmhQ=
X-Received: by 2002:a05:6102:222b:: with SMTP id d11mr3073514vsb.20.1632749069329;
 Mon, 27 Sep 2021 06:24:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210913032003.2836583-1-fengli@smartx.com> <CAHckoCyDULok_QLLh5Nmbx4qLCxKL43TgtFgCSAwuaPpRy1BFw@mail.gmail.com>
In-Reply-To: <CAHckoCyDULok_QLLh5Nmbx4qLCxKL43TgtFgCSAwuaPpRy1BFw@mail.gmail.com>
From:   Li Feng <fengli@smartx.com>
Date:   Mon, 27 Sep 2021 21:24:18 +0800
Message-ID: <CAHckoCwOgpH8E9UgkRkyZitPb6X5Jp-PVKoN6QFHJMt_4h+V6g@mail.gmail.com>
Subject: Re: [PATCH] md: allow to set the fail_fast on RAID1/RAID10
To:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

What about this feature?

Thanks,
Feng Li

Li Feng <fengli@smartx.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=8815=E6=97=A5=E5=
=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8811:08=E5=86=99=E9=81=93=EF=BC=9A
>
> ping ...
>
> Thanks,
> Feng Li
>
> Li Feng <fengli@smartx.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=8813=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8811:22=E5=86=99=E9=81=93=EF=BC=9A
> >
> > When the running RAID1/RAID10 need to be set with the fail_fast flag,
> > we have to remove each device from RAID and re-add it again with the
> > --fail_fast flag.
> >
> > Export the fail_fast flag to the userspace to support the read and
> > write.
> >
> > Signed-off-by: Li Feng <fengli@smartx.com>
> > ---
> >  drivers/md/md.c | 30 ++++++++++++++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index ae8fe54ea358..ce63972a4555 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -3583,6 +3583,35 @@ ppl_size_store(struct md_rdev *rdev, const char =
*buf, size_t len)
> >  static struct rdev_sysfs_entry rdev_ppl_size =3D
> >  __ATTR(ppl_size, S_IRUGO|S_IWUSR, ppl_size_show, ppl_size_store);
> >
> > +static ssize_t
> > +fail_fast_show(struct md_rdev *rdev, char *page)
> > +{
> > +       return sprintf(page, "%d\n", test_bit(FailFast, &rdev->flags));
> > +}
> > +
> > +static ssize_t
> > +fail_fast_store(struct md_rdev *rdev, const char *buf, size_t len)
> > +{
> > +       int ret;
> > +       bool bit;
> > +
> > +       ret =3D kstrtobool(buf, &bit);
> > +       if (ret)
> > +               return ret;
> > +
> > +       if (test_bit(FailFast, &rdev->flags) && !bit) {
> > +               clear_bit(FailFast, &rdev->flags);
> > +               md_update_sb(rdev->mddev, 1);
> > +       } else if (!test_bit(FailFast, &rdev->flags) && bit) {
> > +               set_bit(FailFast, &rdev->flags);
> > +               md_update_sb(rdev->mddev, 1);
> > +       }
> > +       return len;
> > +}
> > +
> > +static struct rdev_sysfs_entry rdev_fail_fast =3D
> > +__ATTR(fail_fast, 0644, fail_fast_show, fail_fast_store);
> > +
> >  static struct attribute *rdev_default_attrs[] =3D {
> >         &rdev_state.attr,
> >         &rdev_errors.attr,
> > @@ -3595,6 +3624,7 @@ static struct attribute *rdev_default_attrs[] =3D=
 {
> >         &rdev_unack_bad_blocks.attr,
> >         &rdev_ppl_sector.attr,
> >         &rdev_ppl_size.attr,
> > +       &rdev_fail_fast.attr,
> >         NULL,
> >  };
> >  static ssize_t
> > --
> > 2.31.1
> >
