Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50785C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  7 Oct 2021 14:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2971E60FA0
	for <linux-raid@archiver.kernel.org>; Thu,  7 Oct 2021 14:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242231AbhJGPBD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Oct 2021 11:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233392AbhJGPBB (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 7 Oct 2021 11:01:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76AFF61130;
        Thu,  7 Oct 2021 14:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633618747;
        bh=agUEa5tnymA5cLSQOimR3s7Rpv88HWpHN23UjSzV7aA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Jg/Hk1q6vizyHYdxD/J9WP3bsG8DOzxJZ76ABMmXUuxD+VzkvIwqX7aWmLDJ2Kyf3
         esvsQUQ6KxlfDHCv4H0pgqsJcIFt2S80ugDdz6WIskyhj9P+NUdDWxcxeIhN3ynQoc
         DiylFI/xJPBRoteYwVoIXlmXa0oM1RFzR9WozWkxYfYgnV6arqmQxvx0fQGins3fZY
         Hx0rxC1KDb97PPZuEhlDMWts1qQ8D5gmIcTf3Ih/LX0XE7ks9NkgcM04A56FHeRvGH
         RoKUxFZ4yG8Ln4AyMsQtL6Mj8yHGWoNw6/6WEdOjuUngEkBFPFqL7KuqWfdouPECTR
         wgGOLLSdqM5Xw==
Received: by mail-lf1-f53.google.com with SMTP id x27so26225877lfu.5;
        Thu, 07 Oct 2021 07:59:07 -0700 (PDT)
X-Gm-Message-State: AOAM530zeLuo9m8Ukf8cUVAK9eTJabVCLW2Ad2u/vKDRBY54+EG4SVWe
        UPDjysqCV+xMevnQapSwJdpEQ+VeOmSqYXBkBDU=
X-Google-Smtp-Source: ABdhPJxFOt0eMhJPHZ/918XuAr4MaGOYv0n7KCfJR/pXgG2VQy3spCJKj5w8b9sHNjcHJkdoYq5vHXGQ9D19vU5g3rU=
X-Received: by 2002:a05:6512:1052:: with SMTP id c18mr4661456lfb.223.1633618745817;
 Thu, 07 Oct 2021 07:59:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210913032003.2836583-1-fengli@smartx.com> <CAHckoCyDULok_QLLh5Nmbx4qLCxKL43TgtFgCSAwuaPpRy1BFw@mail.gmail.com>
 <CAHckoCwOgpH8E9UgkRkyZitPb6X5Jp-PVKoN6QFHJMt_4h+V6g@mail.gmail.com> <CAHckoCwk1i7_vV=oweLTNYkCjMi4ReyXed2NOvZ10z2J32xGBg@mail.gmail.com>
In-Reply-To: <CAHckoCwk1i7_vV=oweLTNYkCjMi4ReyXed2NOvZ10z2J32xGBg@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 7 Oct 2021 07:58:54 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5Txh_FSKCRNA8PPAwm2LesYAX5+k_bde87OsDvYpTi=Q@mail.gmail.com>
Message-ID: <CAPhsuW5Txh_FSKCRNA8PPAwm2LesYAX5+k_bde87OsDvYpTi=Q@mail.gmail.com>
Subject: Re: [PATCH] md: allow to set the fail_fast on RAID1/RAID10
To:     Li Feng <fengli@smartx.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Oct 7, 2021 at 12:00 AM Li Feng <fengli@smartx.com> wrote:
>
> Continue ping...
>
> Thanks,
> Feng Li

Hmm.. this is weird. I didn't see previous emails in this thread.
Could you please
send it again?

Thanks,
Song

>
> Li Feng <fengli@smartx.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=8827=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=889:24=E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi Song,
> >
> > What about this feature?
> >
> > Thanks,
> > Feng Li
> >
> > Li Feng <fengli@smartx.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=8815=E6=97=A5=
=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8811:08=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > ping ...
> > >
> > > Thanks,
> > > Feng Li
> > >
> > > Li Feng <fengli@smartx.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=8813=E6=97=
=A5=E5=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8811:22=E5=86=99=E9=81=93=EF=BC=9A
> > > >
> > > > When the running RAID1/RAID10 need to be set with the fail_fast fla=
g,
> > > > we have to remove each device from RAID and re-add it again with th=
e
> > > > --fail_fast flag.
> > > >
> > > > Export the fail_fast flag to the userspace to support the read and
> > > > write.
> > > >
> > > > Signed-off-by: Li Feng <fengli@smartx.com>
> > > > ---
> > > >  drivers/md/md.c | 30 ++++++++++++++++++++++++++++++
> > > >  1 file changed, 30 insertions(+)
> > > >
> > > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > > index ae8fe54ea358..ce63972a4555 100644
> > > > --- a/drivers/md/md.c
> > > > +++ b/drivers/md/md.c
> > > > @@ -3583,6 +3583,35 @@ ppl_size_store(struct md_rdev *rdev, const c=
har *buf, size_t len)
> > > >  static struct rdev_sysfs_entry rdev_ppl_size =3D
> > > >  __ATTR(ppl_size, S_IRUGO|S_IWUSR, ppl_size_show, ppl_size_store);
> > > >
> > > > +static ssize_t
> > > > +fail_fast_show(struct md_rdev *rdev, char *page)
> > > > +{
> > > > +       return sprintf(page, "%d\n", test_bit(FailFast, &rdev->flag=
s));
> > > > +}
> > > > +
> > > > +static ssize_t
> > > > +fail_fast_store(struct md_rdev *rdev, const char *buf, size_t len)
> > > > +{
> > > > +       int ret;
> > > > +       bool bit;
> > > > +
> > > > +       ret =3D kstrtobool(buf, &bit);
> > > > +       if (ret)
> > > > +               return ret;
> > > > +
> > > > +       if (test_bit(FailFast, &rdev->flags) && !bit) {
> > > > +               clear_bit(FailFast, &rdev->flags);
> > > > +               md_update_sb(rdev->mddev, 1);
> > > > +       } else if (!test_bit(FailFast, &rdev->flags) && bit) {
> > > > +               set_bit(FailFast, &rdev->flags);
> > > > +               md_update_sb(rdev->mddev, 1);
> > > > +       }
> > > > +       return len;
> > > > +}
> > > > +
> > > > +static struct rdev_sysfs_entry rdev_fail_fast =3D
> > > > +__ATTR(fail_fast, 0644, fail_fast_show, fail_fast_store);
> > > > +
> > > >  static struct attribute *rdev_default_attrs[] =3D {
> > > >         &rdev_state.attr,
> > > >         &rdev_errors.attr,
> > > > @@ -3595,6 +3624,7 @@ static struct attribute *rdev_default_attrs[]=
 =3D {
> > > >         &rdev_unack_bad_blocks.attr,
> > > >         &rdev_ppl_sector.attr,
> > > >         &rdev_ppl_size.attr,
> > > > +       &rdev_fail_fast.attr,
> > > >         NULL,
> > > >  };
> > > >  static ssize_t
> > > > --
> > > > 2.31.1
> > > >
