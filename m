Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A60C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 15:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 723AC61139
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 15:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhJMPVT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Oct 2021 11:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhJMPVS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Oct 2021 11:21:18 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17EAC061570
        for <linux-raid@vger.kernel.org>; Wed, 13 Oct 2021 08:19:14 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id q13so5235707uaq.2
        for <linux-raid@vger.kernel.org>; Wed, 13 Oct 2021 08:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HMzblwUq6gQb5cYVxgMSWBDOSxCHihLWNPJkPNrKnxw=;
        b=cU1ozvHP7oAW7gHU/MYuPHCMBdSJERpym66OgD4VeFufwmcCGnjOIVjqWO2q6oXhZG
         x+u3/INnyo5NiZseoI6t2I+qvkxgcDwc5t7peEBfCseOtqNU/+ctATqKZ+IuYNZSzCE7
         hpxeadsQVHJcEdRlTKGW7WiW86aNs9HLrNeaftfbs+F7RWVPj7TJneBy98dpS3uuLkOT
         rYMgs+UF9OFnVZlAPGG4XXb23kSsxnUjrJ91hjH6cNcjc+QHAHmdou2QMm3P9su7Ej1Z
         Kxhn8vGu5AZMYB6bPAePE5j5fvEAjaN6ZuJESW2sCZE/zuZroIPMrfa4g2Yd4avnD6I3
         gKFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HMzblwUq6gQb5cYVxgMSWBDOSxCHihLWNPJkPNrKnxw=;
        b=hQg3AdY41kX7oLoWkqCa6Me4To07DhzzmYkOwBcv7md8xnnO92WTsEzhOx38ecD+hn
         JZmL348bLmg7opYQ69ZSzZBVFCjwbyfzZMp72ls8TsKMDgjC6iCag4qV/sT/jedXVf1i
         x123gRqnBKI5tyadak/kDlKz7xxvJiuGQeFbuqlOtW0g+LWvEs7MeP7u1tsyMaMqj0/1
         dFiJhAQIrOObytdzLxN3ndt0Zsiu65CRtio88Dru35dR03AFg2a5BE/NGgmnboawgkZ9
         tnjHTdQIoa34SCK+YNmyFPZzBEQ0iAOAtUW82p1qD2ZiZPcgORRF4ED5Dq2QHDSvSzfW
         ZiUw==
X-Gm-Message-State: AOAM530c3x15ctU3y2X8s5pAgcH1XhwmjDdYuG+OZnJpfg8HCGMLa7Na
        DeSaNZD6MbOlcYRS+RUtvz+o0Gu1oAFRtYr2misZ/g==
X-Google-Smtp-Source: ABdhPJzwiIXlusiB8jkgUuXmRoQh4Br6mZQS1NAGrD2FgtYaqLf/3tAu6+NGLiOL+ccP8tSZsn4kmctBbM51hWG7h8E=
X-Received: by 2002:a05:6102:c:: with SMTP id j12mr11931530vsp.49.1634138353976;
 Wed, 13 Oct 2021 08:19:13 -0700 (PDT)
MIME-Version: 1.0
References: <1634137173-5342-1-git-send-email-xni@redhat.com>
In-Reply-To: <1634137173-5342-1-git-send-email-xni@redhat.com>
From:   Li Feng <fengli@smartx.com>
Date:   Wed, 13 Oct 2021 23:19:03 +0800
Message-ID: <CAHckoCymOtJoDZF7khAUJr2VQ-p0Xyzh+WQm7FtUCDqHvP2iBg@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] md: Need to update superblock after changing rdev sb_flags
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good. Feel free to add:

Reviewed-by: Li Feng <fengli@smartx.com>


Xiao Ni <xni@redhat.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=8813=E6=97=A5=E5=91=
=A8=E4=B8=89 =E4=B8=8B=E5=8D=8810:59=E5=86=99=E9=81=93=EF=BC=9A


>
> It doesn't update rdev superblock flags to disk after changing these flag=
s.
> This patch does this job.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
> V2: calls md_update_sb directly
> ---
>  drivers/md/md.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6c0c3d0..e89eb46 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2976,7 +2976,11 @@ state_store(struct md_rdev *rdev, const char *buf,=
 size_t len)
>          *  -write_error - clears WriteErrorSeen
>          *  {,-}failfast - set/clear FailFast
>          */
> +
> +       struct mddev *mddev =3D rdev->mddev;
>         int err =3D -EINVAL;
> +       bool need_update_sb =3D false;
> +
>         if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
>                 md_error(rdev->mddev, rdev);
>                 if (test_bit(Faulty, &rdev->flags))
> @@ -2991,7 +2995,6 @@ state_store(struct md_rdev *rdev, const char *buf, =
size_t len)
>                 if (rdev->raid_disk >=3D 0)
>                         err =3D -EBUSY;
>                 else {
> -                       struct mddev *mddev =3D rdev->mddev;
>                         err =3D 0;
>                         if (mddev_is_clustered(mddev))
>                                 err =3D md_cluster_ops->remove_disk(mddev=
, rdev);
> @@ -3008,10 +3011,12 @@ state_store(struct md_rdev *rdev, const char *buf=
, size_t len)
>         } else if (cmd_match(buf, "writemostly")) {
>                 set_bit(WriteMostly, &rdev->flags);
>                 mddev_create_serial_pool(rdev->mddev, rdev, false);
> +               need_update_sb =3D true;
>                 err =3D 0;
>         } else if (cmd_match(buf, "-writemostly")) {
>                 mddev_destroy_serial_pool(rdev->mddev, rdev, false);
>                 clear_bit(WriteMostly, &rdev->flags);
> +               need_update_sb =3D true;
>                 err =3D 0;
>         } else if (cmd_match(buf, "blocked")) {
>                 set_bit(Blocked, &rdev->flags);
> @@ -3037,9 +3042,11 @@ state_store(struct md_rdev *rdev, const char *buf,=
 size_t len)
>                 err =3D 0;
>         } else if (cmd_match(buf, "failfast")) {
>                 set_bit(FailFast, &rdev->flags);
> +               need_update_sb =3D true;
>                 err =3D 0;
>         } else if (cmd_match(buf, "-failfast")) {
>                 clear_bit(FailFast, &rdev->flags);
> +               need_update_sb =3D true;
>                 err =3D 0;
>         } else if (cmd_match(buf, "-insync") && rdev->raid_disk >=3D 0 &&
>                    !test_bit(Journal, &rdev->flags)) {
> @@ -3118,6 +3125,8 @@ state_store(struct md_rdev *rdev, const char *buf, =
size_t len)
>                 clear_bit(ExternalBbl, &rdev->flags);
>                 err =3D 0;
>         }
> +       if (need_update_sb)
> +               md_update_sb(mddev, 1);
>         if (!err)
>                 sysfs_notify_dirent_safe(rdev->sysfs_state);
>         return err ? err : len;
> --
> 2.7.5
>
