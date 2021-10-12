Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD852C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 08:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2D7060E0B
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 08:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbhJLIJg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Oct 2021 04:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234368AbhJLIJf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Oct 2021 04:09:35 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D4FC06161C
        for <linux-raid@vger.kernel.org>; Tue, 12 Oct 2021 01:07:34 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id h132so9024231vke.8
        for <linux-raid@vger.kernel.org>; Tue, 12 Oct 2021 01:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b2FjW88iV7WH8M52qDc4ZYBbTRY828MiXLZ98UxnmbA=;
        b=xNjJ4i/g+iOuOz4grm6y/fgSVU+k588ykvt5Jak8x9dxQ+V2J8nSXIPAkIyI6EvXjz
         0HN1vyWq3MPhsN0EWXVXCvT754z6EqADHaNHIHzu9pnzkxRDwPEkkKiZnFi9JogTbRpG
         wkiV3QyEGmDyHKXcUPqLukTyS5YWJC0jQsGAPIQKLKvtxO9K2ddlhXX52cfrzHCE94q1
         YtfrLIRg7JJnOguBmwHl3x/nCVUursEeLWD50E9XKfKFqabvqef/XbD92jW9TGYabJSz
         Py6OmAWMYV1kqtI+JNayCTExKKOiUtkFLpXDry3x9ztQUYjV7OaE5x6244cGiEibZp8d
         rjNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b2FjW88iV7WH8M52qDc4ZYBbTRY828MiXLZ98UxnmbA=;
        b=uhsqwu1kf2ui76v5A6IEH1WW1NShmMC40LQ0az+m+tW7zv9F7MpCi6PXfgjK61nf0V
         Grm2fPOegn0y6j51Tl/r7n945Q9SGh2gc8CG8W1ctsXhi8qIJvkvvIAcz48GOnkvscM7
         lvYCMrumpxZbVQEhhSbLcSDObWiaRDtp96jezTzKETk6o3GxnvIhItcGFXaVafesBJG8
         HLOlIyHf/iaL3Xp4Y9JCmj9hJB6/OnsrdW5DqQ5tnzPg35CG+9tw0tSN8qPJWmbgp/MF
         ukLo4EmNdtVP4ghifwwx1bGRte4GsHkqkFhr8oHf9mUHbwiDOHKZ4qdCqQ3BJehFrRHv
         Mgvw==
X-Gm-Message-State: AOAM533qZHZGazBrbuIRv0yyFWLfmc8RXnLDg5KGG2Bwq+nqyVPP+mWC
        Dj0y7y1KDZjEughDyhMT42qF8o/sQDol3+1Je2nfSw==
X-Google-Smtp-Source: ABdhPJw+N8OD0BSrstSsRCN2Qv7yKT2BHtyoxMXlqpH3guFm53TQiNEblhFAdL9xzXLyFAYjrxqOjpJ5nqlvSz32LSg=
X-Received: by 2002:a05:6122:90d:: with SMTP id j13mr13052333vka.25.1634026053766;
 Tue, 12 Oct 2021 01:07:33 -0700 (PDT)
MIME-Version: 1.0
References: <20211008032231.1143467-1-fengli@smartx.com> <CAPhsuW5+bdQwsyjBP=QDGRbtnF021291D_XrhNtV+v-geVouVg@mail.gmail.com>
 <CALTww28b0HGzSTTNGVzeZdRp0nGMDAyY8sQ+cBsSCuYJ4jMaqw@mail.gmail.com>
 <CAHckoCyuqxM8po4JA4=OacVWhYuo9SWescUVOKRFGwdc=aoN8A@mail.gmail.com> <CALTww28CsJdmVOLFeoHC8FgbHDK78h8Lncsf9fFA0RYXEj=R9A@mail.gmail.com>
In-Reply-To: <CALTww28CsJdmVOLFeoHC8FgbHDK78h8Lncsf9fFA0RYXEj=R9A@mail.gmail.com>
From:   Li Feng <fengli@smartx.com>
Date:   Tue, 12 Oct 2021 16:07:22 +0800
Message-ID: <CAHckoCzzVP7npmU4LWedzD-f1QmkH4K0iLk_=8ptSFXrFfRoDw@mail.gmail.com>
Subject: Re: [PATCH RESEND] md: allow to set the fail_fast on RAID1/RAID10
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Xiao Ni <xni@redhat.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=8812=E6=97=A5=E5=91=
=A8=E4=BA=8C =E4=B8=8B=E5=8D=882:58=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Oct 11, 2021 at 5:42 PM Li Feng <fengli@smartx.com> wrote:
> >
> > Xiao Ni <xni@redhat.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=8811=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=883:49=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Hi all
> > >
> > > Now the per device sysfs interface file state can change failfast. Do
> > > we need a new file for failfast?
> > >
> > > I did a test. The steps are:
> > >
> > > mdadm -CR /dev/md0 -l1 -n2 /dev/sdb /dev/sdc --assume-clean
> > > cd /sys/block/md0/md/dev-sdb
> > > echo failfast > state
> > > cat state
> > > in_sync,failfast
> >
> > This works,  will it be persisted to disk?
> >
>
> mdadm --detail /dev/md0 can show the failfast information. So it
> should be written in superblock.
> But I don't find how md does this. I'm looking at this.
>
Yes, I have tested that it has been persisted, but don't understand who doe=
s it.

> Regards
> Xiao
>
