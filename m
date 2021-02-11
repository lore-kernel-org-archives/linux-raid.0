Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A5AC433DB
	for <linux-raid@archiver.kernel.org>; Thu, 11 Feb 2021 08:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C4C564DDF
	for <linux-raid@archiver.kernel.org>; Thu, 11 Feb 2021 08:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBKI02 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 Feb 2021 03:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhBKI0M (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 11 Feb 2021 03:26:12 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E4CC061574
        for <linux-raid@vger.kernel.org>; Thu, 11 Feb 2021 00:25:31 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id l19so5210062oih.6
        for <linux-raid@vger.kernel.org>; Thu, 11 Feb 2021 00:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ym0jR5L0N+bS9wIXXqHqiV2OVAU2wxDNbKISqR4qPM0=;
        b=jifqTGabTgKIOgqD96/VwvtjeWDivkIJo68qMVwLTjlHS5+FOWtcYhWk+LVX25vxv2
         vPMCE4UaTRWzSaN+V1RTxJbgc3wMG4m+sOZcQzjmJPl8RiybXiloPuDnzhQIw6NryoEo
         z01OOTiWxcqtn4+m3NEowFBhPg+dAeUAMGsGc0fKhrFk0qM+j0nG3p0bzr40VWfILW0Q
         zB4isAj20azh+qea7AZoGJ+ToAX2DJROOmhKQBNBGR4+6w+ENlHT5ZGwOoF46CrFlwP8
         h4U/9C/c4QHUxxNvGdAJcPjyrTFaFNkbfgajM+zN+L47VyAP+5uolhWTChKlc7pgThll
         R4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ym0jR5L0N+bS9wIXXqHqiV2OVAU2wxDNbKISqR4qPM0=;
        b=Jeg8sFjmm4qvx8S9eKH/m1rn6Ntukb2VALnsY+8a6y4Uh+ltIQtG2h2eixq0gpU+Ft
         5UDuuYus33mRsHChQ5aRDSAA6RugCZqaQyeC9Gjn2JCQZxM36S1VUFZchVilbW02Vg6Q
         S3nXktg3NWj/sYg137Vvqm2NWtE2LLk8yiDh8RIUS6FPUVLdd9+tsQP4oFcr42ayjl3r
         OVTCpoZKbuhv4OWgU7pvhrPRjHir4mG8MHwN3PhQgRHAsK0SSIS7nmuvK1mBfIqupLP9
         4Rwemoj2rORt0bJc93fofJ/XsNJ5d2DIBVWORlj35M4uaICJCuWkGn/hr8OO4/dASUOy
         9i5g==
X-Gm-Message-State: AOAM5308Q/oAbLZ3DOZBh0aFzymL2BBoXxrjIxPPfs4kuqZZS8ZGeBE6
        lomghFa4NyMyTmg4K6U0OL8cEGb5h/tH8BTJVHl6aN/0Hm4=
X-Google-Smtp-Source: ABdhPJzWotoUOULksEQYw9+7R2LD9Xy+n0hT1syk+opwYHie9Z28QMncK+SW9PlIjrBlWlqJPDCik2kNXDxmKjKamn4=
X-Received: by 2002:aca:b655:: with SMTP id g82mr1982089oif.91.1613031931177;
 Thu, 11 Feb 2021 00:25:31 -0800 (PST)
MIME-Version: 1.0
References: <1612923676-18294-1-git-send-email-guoqing.jiang@cloud.ionos.com> <CAPhsuW5ZU2fpP1smSodKWFCqLu4J91sWqY6DC7ppQ=3VvJM+eQ@mail.gmail.com>
In-Reply-To: <CAPhsuW5ZU2fpP1smSodKWFCqLu4J91sWqY6DC7ppQ=3VvJM+eQ@mail.gmail.com>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Thu, 11 Feb 2021 09:25:20 +0100
Message-ID: <CA+res+Ro9F4nsS-=__xu6frsqsDn-AG8OgcEcVY5Fw708XWE5g@mail.gmail.com>
Subject: Re: [PATCH] md: don't unregister sync_thread with reconfig_mutex held
To:     Song Liu <song@kernel.org>
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Song Liu <song@kernel.org> =E4=BA=8E2021=E5=B9=B42=E6=9C=8811=E6=97=A5=E5=
=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=888:31=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Feb 9, 2021 at 6:22 PM Guoqing Jiang
> <guoqing.jiang@cloud.ionos.com> wrote:
> >
> > Unregister sync_thread doesn't need to hold reconfig_mutex since it
> > doesn't reconfigure array.
> >
> > And it could cause deadlock problem for raid5 as follows:
> >
> > 1. process A tried to reap sync thread with reconfig_mutex held after e=
cho
> >    idle to sync_action.
> > 2. raid5 sync thread was blocked if there were too many active stripes.
> > 3. SB_CHANGE_PENDING was set (because of write IO comes from upper laye=
r)
> >    which causes the number of active stripes can't be decreased.
> > 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not a=
ble
> >    to hold reconfig_mutex.
> >
> > More details in the link:
> > issu://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@=
molgen.mpg.de/T/#t
> >
> > Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
> > Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
>
> Thanks for debugging the issue. However, I am not sure whether this is
> the proper
> fix. For example, would this break dm-raid.c:raid_message()? IIUC,
> raid_message()
> calls md_reap_sync_thread() without holding reconfigure_mutex, no?
>
> Thanks,
> Song.
right.
A simple solution would be add a parameter to md_reap_sync_thread to
indicate if a reconfigure_mutex lock is held.

Regards!
Jack
>
> > ---
> >  drivers/md/md.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index ca40942..eec8c27 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -9365,13 +9365,18 @@ void md_check_recovery(struct mddev *mddev)
> >  EXPORT_SYMBOL(md_check_recovery);
> >
> >  void md_reap_sync_thread(struct mddev *mddev)
> > +       __releases(&mddev->reconfig_mutex)
> > +       __acquires(&mddev->reconfig_mutex)
> > +
> >  {
> >         struct md_rdev *rdev;
> >         sector_t old_dev_sectors =3D mddev->dev_sectors;
> >         bool is_reshaped =3D false;
> >
> >         /* resync has finished, collect result */
> > +       mddev_unlock(mddev);
> >         md_unregister_thread(&mddev->sync_thread);
> > +       mddev_lock_nointr(mddev);
> >         if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
> >             !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
> >             mddev->degraded !=3D mddev->raid_disks) {
> > --
> > 2.7.4
> >
