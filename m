Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37029C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  7 Oct 2021 07:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20332610A5
	for <linux-raid@archiver.kernel.org>; Thu,  7 Oct 2021 07:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240232AbhJGHCU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Oct 2021 03:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240203AbhJGHCS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Oct 2021 03:02:18 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9CBC061755
        for <linux-raid@vger.kernel.org>; Thu,  7 Oct 2021 00:00:24 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id w13so5712210vsa.2
        for <linux-raid@vger.kernel.org>; Thu, 07 Oct 2021 00:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=KPvY9m8xF7OhMRrQhNbNUN45tpWYIkMldtqvzSBBP4Q=;
        b=REIqf8NfQ1eKMpt6Uf2AM4qcDo68FgmR/POVotERZS0U2XCypUiwT89kbwcYYaTCEj
         emvfkcnX+sY2WvZr+Ivm4po4OoFW2wid/mIBR7Rr2QunsXOHEe71Mi/nuaoJEWm+AG19
         1tdijotabn3rz7HSb0wHuRNO343Y+4tUxpp9iA+vR44XiUNA5ShrcoRkMtBWbg1s6elE
         YWwU0dvN+k+bjrY9oBAfp/M4/cWWbbMl4Bp0Vd/Dxosle3S5gi+Kyt/AepIkcL2bXA8Y
         sOpPJPEb90+yI1IJKcT8z/c47tud19Bwvt/zw+75sREDHFlkLDnaP4bNHtUrR5XC6X+T
         PNfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=KPvY9m8xF7OhMRrQhNbNUN45tpWYIkMldtqvzSBBP4Q=;
        b=38H+Zk4oux/14P6fwGbkLtPhYc/k3gRWHa1ZfSItYVN4MXj/x8hieWib7YaVtHYaCw
         uWRReEI5/4qQMeowoQsBA3wZ2b91rcgya9g4bcYnFPMDBMzsQOLkvHG4hps4wXuXADiV
         YjGq2joTLrmpmCGrXCZ3APf3Fns3cP0pTnqPi/iqWYOCGEtWKK0MoYv/pC3gelER4ivH
         DiluAscFQgWtw5lELIGOWDDZrPZEq/GeRkrJvjVK9To7mOhsWlwdHlh1S2kSP+2tVUGh
         TAV1eN/WOKM377GZIimcvAlRIcs/JLjweTyTSNhg7d7Rks7PlOmIZDHjJr6siODVvyy4
         luOg==
X-Gm-Message-State: AOAM531C3wQ7pP4PvHh7nGmg6sCcWg4lxgiwmrifx7ySdjx3VHzU0Yli
        GI76LkpQmOyR9TkZwKrHasSsuy3bOy/bCACOa3myNA==
X-Google-Smtp-Source: ABdhPJxhTIeTM2YsBQjs/Hxb8tjpMKMRA+oM7JCom2mWp29uuhG00YcV/ZEg5rWysJ0bwM2edQ4GNk9QbT2krnMKZFI=
X-Received: by 2002:a67:d28f:: with SMTP id z15mr2434728vsi.44.1633590024062;
 Thu, 07 Oct 2021 00:00:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210913032003.2836583-1-fengli@smartx.com> <CAHckoCyDULok_QLLh5Nmbx4qLCxKL43TgtFgCSAwuaPpRy1BFw@mail.gmail.com>
 <CAHckoCwOgpH8E9UgkRkyZitPb6X5Jp-PVKoN6QFHJMt_4h+V6g@mail.gmail.com>
In-Reply-To: <CAHckoCwOgpH8E9UgkRkyZitPb6X5Jp-PVKoN6QFHJMt_4h+V6g@mail.gmail.com>
From:   Li Feng <fengli@smartx.com>
Date:   Thu, 7 Oct 2021 15:00:11 +0800
Message-ID: <CAHckoCwk1i7_vV=oweLTNYkCjMi4ReyXed2NOvZ10z2J32xGBg@mail.gmail.com>
Subject: Re: [PATCH] md: allow to set the fail_fast on RAID1/RAID10
To:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Continue ping...

Thanks,
Feng Li

Li Feng <fengli@smartx.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=8827=E6=97=A5=E5=
=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=889:24=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Song,
>
> What about this feature?
>
> Thanks,
> Feng Li
>
> Li Feng <fengli@smartx.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=8815=E6=97=A5=
=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8811:08=E5=86=99=E9=81=93=EF=BC=9A
> >
> > ping ...
> >
> > Thanks,
> > Feng Li
> >
> > Li Feng <fengli@smartx.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=8813=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8811:22=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > When the running RAID1/RAID10 need to be set with the fail_fast flag,
> > > we have to remove each device from RAID and re-add it again with the
> > > --fail_fast flag.
> > >
> > > Export the fail_fast flag to the userspace to support the read and
> > > write.
> > >
> > > Signed-off-by: Li Feng <fengli@smartx.com>
> > > ---
> > >  drivers/md/md.c | 30 ++++++++++++++++++++++++++++++
> > >  1 file changed, 30 insertions(+)
> > >
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index ae8fe54ea358..ce63972a4555 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -3583,6 +3583,35 @@ ppl_size_store(struct md_rdev *rdev, const cha=
r *buf, size_t len)
> > >  static struct rdev_sysfs_entry rdev_ppl_size =3D
> > >  __ATTR(ppl_size, S_IRUGO|S_IWUSR, ppl_size_show, ppl_size_store);
> > >
> > > +static ssize_t
> > > +fail_fast_show(struct md_rdev *rdev, char *page)
> > > +{
> > > +       return sprintf(page, "%d\n", test_bit(FailFast, &rdev->flags)=
);
> > > +}
> > > +
> > > +static ssize_t
> > > +fail_fast_store(struct md_rdev *rdev, const char *buf, size_t len)
> > > +{
> > > +       int ret;
> > > +       bool bit;
> > > +
> > > +       ret =3D kstrtobool(buf, &bit);
> > > +       if (ret)
> > > +               return ret;
> > > +
> > > +       if (test_bit(FailFast, &rdev->flags) && !bit) {
> > > +               clear_bit(FailFast, &rdev->flags);
> > > +               md_update_sb(rdev->mddev, 1);
> > > +       } else if (!test_bit(FailFast, &rdev->flags) && bit) {
> > > +               set_bit(FailFast, &rdev->flags);
> > > +               md_update_sb(rdev->mddev, 1);
> > > +       }
> > > +       return len;
> > > +}
> > > +
> > > +static struct rdev_sysfs_entry rdev_fail_fast =3D
> > > +__ATTR(fail_fast, 0644, fail_fast_show, fail_fast_store);
> > > +
> > >  static struct attribute *rdev_default_attrs[] =3D {
> > >         &rdev_state.attr,
> > >         &rdev_errors.attr,
> > > @@ -3595,6 +3624,7 @@ static struct attribute *rdev_default_attrs[] =
=3D {
> > >         &rdev_unack_bad_blocks.attr,
> > >         &rdev_ppl_sector.attr,
> > >         &rdev_ppl_size.attr,
> > > +       &rdev_fail_fast.attr,
> > >         NULL,
> > >  };
> > >  static ssize_t
> > > --
> > > 2.31.1
> > >
