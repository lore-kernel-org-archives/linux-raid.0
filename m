Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85562C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 03:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6364A6105A
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 03:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbhJHDZe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Oct 2021 23:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhJHDZd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Oct 2021 23:25:33 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD61C061714
        for <linux-raid@vger.kernel.org>; Thu,  7 Oct 2021 20:23:39 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id w68so3629498vkd.7
        for <linux-raid@vger.kernel.org>; Thu, 07 Oct 2021 20:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YH7hWGnKeMLgME7ZCIPQSyX99DlhWg8uLLxzZysdl6c=;
        b=xgmstvbjJLGF1lTZbyBTuNi5sVdmLkUuqSqjwmctdcKkGPx4U8PqmN1hnHImv1lKzr
         OOONo1S/PEcXIZNyaIaWd3pZPLnGslMUukZihzinq2Q/ksQvdQPQV4bZPnnz7lmlYyDw
         FOnXrT4hkEivmurDrwJ3k56fYsN60DRZwmUdRhobKaJvd4wYqlfMraH60uRCptnYx8Gw
         FOj7OZl3WkiuXB+I+HDvXpILdP4LpPyA7tGlE7PEbBTHjKXEkpSpqBjmhmubEVNOMcV5
         l1kdNxw3IUr1ErTV6H1/6R5P1e1zSdQpUU5sZtvd6Q3z7e9Tuim7g2WGG7vkARtqRoyA
         Q05g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YH7hWGnKeMLgME7ZCIPQSyX99DlhWg8uLLxzZysdl6c=;
        b=pIJp5gMArdGxOJklHV8+3/4C0QreZ/JGC1VJUdVVWEo1FWEr54odJmKx82CnOKVV6e
         OsN5xYdSa7fY6jcpGw+hIx2nDlB+B7xyrHJjq2zZNJYgxGUdrWbLMJ5y+vvclKm1N4NV
         /JOUKFOs+JEe9iA2kTWqOmJhXoQ1zFU2M27vWS8v9GBaUdIz3NbjuouroUZgxjWLsVqw
         ++iDkhWmI6BioVnNbaJ/sfYpt5tpSNYxOQ5r/p6r14riR02hEVuJxnc1Q2xdvSq6N3rB
         HdbPNLmZObfxeIhBIxjuTBdQXA4IdfTeOjA1x+qbygRAXZoL3Kcr9EyRwEODUvDw2B7U
         VNvA==
X-Gm-Message-State: AOAM530JJDJ0cQ3RPQIZczjG2ke60e8IL9VztdQZ+kRaAX/uK8nroY1W
        JpDtJzmhTgVaxPFFHY0AoXjSaHMxRmP5KFqZ6QfTPQ==
X-Google-Smtp-Source: ABdhPJwqfz2mGqpRet+PozKsM933EUcZeBoNJ9o/urpvJvtSLhpa/iufwSAh2JhaCWf3z7kg+I4Y/RGaJtwQTQP1pv4=
X-Received: by 2002:a1f:2603:: with SMTP id m3mr7759371vkm.2.1633663418390;
 Thu, 07 Oct 2021 20:23:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210913032003.2836583-1-fengli@smartx.com> <CAHckoCyDULok_QLLh5Nmbx4qLCxKL43TgtFgCSAwuaPpRy1BFw@mail.gmail.com>
 <CAHckoCwOgpH8E9UgkRkyZitPb6X5Jp-PVKoN6QFHJMt_4h+V6g@mail.gmail.com>
 <CAHckoCwk1i7_vV=oweLTNYkCjMi4ReyXed2NOvZ10z2J32xGBg@mail.gmail.com> <CAPhsuW5Txh_FSKCRNA8PPAwm2LesYAX5+k_bde87OsDvYpTi=Q@mail.gmail.com>
In-Reply-To: <CAPhsuW5Txh_FSKCRNA8PPAwm2LesYAX5+k_bde87OsDvYpTi=Q@mail.gmail.com>
From:   Li Feng <fengli@smartx.com>
Date:   Fri, 8 Oct 2021 11:23:27 +0800
Message-ID: <CAHckoCyMvAw8ux2mNdM6Keo+LeHY=1DNVOoEVNKkOi+cFds+CA@mail.gmail.com>
Subject: Re: [PATCH] md: allow to set the fail_fast on RAID1/RAID10
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Done, thanks for responding.

Thanks,
Feng Li

Song Liu <song@kernel.org> =E4=BA=8E2021=E5=B9=B410=E6=9C=887=E6=97=A5=E5=
=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=8810:59=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Oct 7, 2021 at 12:00 AM Li Feng <fengli@smartx.com> wrote:
> >
> > Continue ping...
> >
> > Thanks,
> > Feng Li
>
> Hmm.. this is weird. I didn't see previous emails in this thread.
> Could you please
> send it again?
>
> Thanks,
> Song
>
> >
> > Li Feng <fengli@smartx.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=8827=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=889:24=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Hi Song,
> > >
> > > What about this feature?
> > >
> > > Thanks,
> > > Feng Li
> > >
> > > Li Feng <fengli@smartx.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=8815=E6=97=
=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8811:08=E5=86=99=E9=81=93=EF=BC=9A
> > > >
> > > > ping ...
> > > >
> > > > Thanks,
> > > > Feng Li
> > > >
> > > > Li Feng <fengli@smartx.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=8813=E6=
=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8811:22=E5=86=99=E9=81=93=EF=BC=9A
> > > > >
> > > > > When the running RAID1/RAID10 need to be set with the fail_fast f=
lag,
> > > > > we have to remove each device from RAID and re-add it again with =
the
> > > > > --fail_fast flag.
> > > > >
> > > > > Export the fail_fast flag to the userspace to support the read an=
d
> > > > > write.
> > > > >
> > > > > Signed-off-by: Li Feng <fengli@smartx.com>
> > > > > ---
> > > > >  drivers/md/md.c | 30 ++++++++++++++++++++++++++++++
> > > > >  1 file changed, 30 insertions(+)
> > > > >
> > > > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > > > index ae8fe54ea358..ce63972a4555 100644
> > > > > --- a/drivers/md/md.c
> > > > > +++ b/drivers/md/md.c
> > > > > @@ -3583,6 +3583,35 @@ ppl_size_store(struct md_rdev *rdev, const=
 char *buf, size_t len)
> > > > >  static struct rdev_sysfs_entry rdev_ppl_size =3D
> > > > >  __ATTR(ppl_size, S_IRUGO|S_IWUSR, ppl_size_show, ppl_size_store)=
;
> > > > >
> > > > > +static ssize_t
> > > > > +fail_fast_show(struct md_rdev *rdev, char *page)
> > > > > +{
> > > > > +       return sprintf(page, "%d\n", test_bit(FailFast, &rdev->fl=
ags));
> > > > > +}
> > > > > +
> > > > > +static ssize_t
> > > > > +fail_fast_store(struct md_rdev *rdev, const char *buf, size_t le=
n)
> > > > > +{
> > > > > +       int ret;
> > > > > +       bool bit;
> > > > > +
> > > > > +       ret =3D kstrtobool(buf, &bit);
> > > > > +       if (ret)
> > > > > +               return ret;
> > > > > +
> > > > > +       if (test_bit(FailFast, &rdev->flags) && !bit) {
> > > > > +               clear_bit(FailFast, &rdev->flags);
> > > > > +               md_update_sb(rdev->mddev, 1);
> > > > > +       } else if (!test_bit(FailFast, &rdev->flags) && bit) {
> > > > > +               set_bit(FailFast, &rdev->flags);
> > > > > +               md_update_sb(rdev->mddev, 1);
> > > > > +       }
> > > > > +       return len;
> > > > > +}
> > > > > +
> > > > > +static struct rdev_sysfs_entry rdev_fail_fast =3D
> > > > > +__ATTR(fail_fast, 0644, fail_fast_show, fail_fast_store);
> > > > > +
> > > > >  static struct attribute *rdev_default_attrs[] =3D {
> > > > >         &rdev_state.attr,
> > > > >         &rdev_errors.attr,
> > > > > @@ -3595,6 +3624,7 @@ static struct attribute *rdev_default_attrs=
[] =3D {
> > > > >         &rdev_unack_bad_blocks.attr,
> > > > >         &rdev_ppl_sector.attr,
> > > > >         &rdev_ppl_size.attr,
> > > > > +       &rdev_fail_fast.attr,
> > > > >         NULL,
> > > > >  };
> > > > >  static ssize_t
> > > > > --
> > > > > 2.31.1
> > > > >
