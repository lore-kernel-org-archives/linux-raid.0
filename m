Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C71B6C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 17:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97F7B6101D
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 17:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhJMR3O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Oct 2021 13:29:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhJMR3O (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 13 Oct 2021 13:29:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2CB4610E5
        for <linux-raid@vger.kernel.org>; Wed, 13 Oct 2021 17:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634146030;
        bh=NCn7viDFzU1cWLTxMNpNtuqpdBLGeFZkYm+eMms3xqU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=auvMYV1bA7Ih7WmBXeL4NfGA7OFJSnoA8vUS3RIgCMTF71hi25U9U2yD6PXUnoGA0
         KyZsShEylrkTFPW/RC2a+Gcbs0a03Chw0OpRYIIpdWLpyI9KTn1Ajj0jC0oVSv9sU+
         a2zuO4FAZPsiclpIc4E5hx61uP8tE29dmyzIwEwN29kjQ93XPnHAIzBcidgiruriM2
         kJTdiF868vy6/lOFQE4Ri1QjwytJZJN8EC+N3xIXloc05XwyzTQE9p04Er16OJQ6ak
         SyKL81JQIy9JbsAvakX8O5cssrGufYri2huHw1SaPbwQCPKmNB2XtA95UOqSHapBoS
         +6mPKGj25WETg==
Received: by mail-lf1-f47.google.com with SMTP id c16so14935164lfb.3
        for <linux-raid@vger.kernel.org>; Wed, 13 Oct 2021 10:27:10 -0700 (PDT)
X-Gm-Message-State: AOAM530L2wYxvfc6wq9jUH7GmQsaAENcYjSKbVKbpLQFZ3gXw4GhH2pr
        knSwCAdSkKMZuAciyH5ZXueN7xsI/4mZgwVF2hg=
X-Google-Smtp-Source: ABdhPJw0IhN1sXQJAj0s3McovoH0Y1xB/pVSizwZs5xVU3WE7MHl92IJFBFogWlAi3LdMFRucpwLD+Wcm7hW/RN36hU=
X-Received: by 2002:a05:6512:1042:: with SMTP id c2mr267304lfb.223.1634146028909;
 Wed, 13 Oct 2021 10:27:08 -0700 (PDT)
MIME-Version: 1.0
References: <1634137173-5342-1-git-send-email-xni@redhat.com> <CAHckoCymOtJoDZF7khAUJr2VQ-p0Xyzh+WQm7FtUCDqHvP2iBg@mail.gmail.com>
In-Reply-To: <CAHckoCymOtJoDZF7khAUJr2VQ-p0Xyzh+WQm7FtUCDqHvP2iBg@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 13 Oct 2021 10:26:57 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6K0YbnoCf=zWxxR_bnde74tJAPfpwJZKtryao7GamDpg@mail.gmail.com>
Message-ID: <CAPhsuW6K0YbnoCf=zWxxR_bnde74tJAPfpwJZKtryao7GamDpg@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] md: Need to update superblock after changing rdev sb_flags
To:     Li Feng <fengli@smartx.com>
Cc:     Xiao Ni <xni@redhat.com>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Oct 13, 2021 at 8:19 AM Li Feng <fengli@smartx.com> wrote:
>
> Looks good. Feel free to add:
>
> Reviewed-by: Li Feng <fengli@smartx.com>
>
>
> Xiao Ni <xni@redhat.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=8813=E6=97=A5=E5=
=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8810:59=E5=86=99=E9=81=93=EF=BC=9A
>
>
> >
> > It doesn't update rdev superblock flags to disk after changing these fl=
ags.
> > This patch does this job.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>

I updated the commit log and applied it to md-next.

Thanks,
Song

> > ---
> > V2: calls md_update_sb directly
> > ---
> >  drivers/md/md.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 6c0c3d0..e89eb46 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -2976,7 +2976,11 @@ state_store(struct md_rdev *rdev, const char *bu=
f, size_t len)
> >          *  -write_error - clears WriteErrorSeen
> >          *  {,-}failfast - set/clear FailFast
> >          */
> > +
> > +       struct mddev *mddev =3D rdev->mddev;
> >         int err =3D -EINVAL;
> > +       bool need_update_sb =3D false;
> > +
> >         if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
> >                 md_error(rdev->mddev, rdev);
> >                 if (test_bit(Faulty, &rdev->flags))
> > @@ -2991,7 +2995,6 @@ state_store(struct md_rdev *rdev, const char *buf=
, size_t len)
> >                 if (rdev->raid_disk >=3D 0)
> >                         err =3D -EBUSY;
> >                 else {
> > -                       struct mddev *mddev =3D rdev->mddev;
> >                         err =3D 0;
> >                         if (mddev_is_clustered(mddev))
> >                                 err =3D md_cluster_ops->remove_disk(mdd=
ev, rdev);
> > @@ -3008,10 +3011,12 @@ state_store(struct md_rdev *rdev, const char *b=
uf, size_t len)
> >         } else if (cmd_match(buf, "writemostly")) {
> >                 set_bit(WriteMostly, &rdev->flags);
> >                 mddev_create_serial_pool(rdev->mddev, rdev, false);
> > +               need_update_sb =3D true;
> >                 err =3D 0;
> >         } else if (cmd_match(buf, "-writemostly")) {
> >                 mddev_destroy_serial_pool(rdev->mddev, rdev, false);
> >                 clear_bit(WriteMostly, &rdev->flags);
> > +               need_update_sb =3D true;
> >                 err =3D 0;
> >         } else if (cmd_match(buf, "blocked")) {
> >                 set_bit(Blocked, &rdev->flags);
> > @@ -3037,9 +3042,11 @@ state_store(struct md_rdev *rdev, const char *bu=
f, size_t len)
> >                 err =3D 0;
> >         } else if (cmd_match(buf, "failfast")) {
> >                 set_bit(FailFast, &rdev->flags);
> > +               need_update_sb =3D true;
> >                 err =3D 0;
> >         } else if (cmd_match(buf, "-failfast")) {
> >                 clear_bit(FailFast, &rdev->flags);
> > +               need_update_sb =3D true;
> >                 err =3D 0;
> >         } else if (cmd_match(buf, "-insync") && rdev->raid_disk >=3D 0 =
&&
> >                    !test_bit(Journal, &rdev->flags)) {
> > @@ -3118,6 +3125,8 @@ state_store(struct md_rdev *rdev, const char *buf=
, size_t len)
> >                 clear_bit(ExternalBbl, &rdev->flags);
> >                 err =3D 0;
> >         }
> > +       if (need_update_sb)
> > +               md_update_sb(mddev, 1);
> >         if (!err)
> >                 sysfs_notify_dirent_safe(rdev->sysfs_state);
> >         return err ? err : len;
> > --
> > 2.7.5
> >
