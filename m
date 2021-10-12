Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D7EC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 09:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AB9661056
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 09:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbhJLJQG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Oct 2021 05:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbhJLJQF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Oct 2021 05:16:05 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060E1C061570
        for <linux-raid@vger.kernel.org>; Tue, 12 Oct 2021 02:14:04 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id u5so17303537uao.13
        for <linux-raid@vger.kernel.org>; Tue, 12 Oct 2021 02:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cdx68haq+GI9hYbv4kInfLBYws9f1YTUpzJDYZRtxTQ=;
        b=0wKyXGV0Sg2HzurNg19D86iRRMxMHIHP6ii4dL16JWNKqKQYSc5SUyd7KX7qRZyWOl
         DAhJ41KHAOMKyphg5k6jvKyLVx2+u8E3bfB75fMZnWHGNlD325rFCJosgkhW7gqYaona
         qv/P81BHmuvTERxGFTIrd94wXylE1Y/5txUgNnxfopn+XYVlDYnLlZoVn0EeanjvoFFQ
         Yog+CTTCvhiILRXszHSN6sevNmhwxeI2TtRT4OURFfOQen8MYtsbmDt4GGcSTzRbH6Eu
         SM43VV7E1Odf93RpGuR5dgox7IxOnKMt0k6l6pD6AsYnM7DdDjZnoj88ZkXgHzTqGqwA
         Hj5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cdx68haq+GI9hYbv4kInfLBYws9f1YTUpzJDYZRtxTQ=;
        b=4bm9vRGQUfq2HRWQoPug/k1SEoAglnD4IF/BiixyVEQiZ6P+JHWEUkRNd8Q9FgXJds
         pw/hCQ084NwXb9f/r18NiKANEZemJDcoKUHPvVxugO4I29taJVkj0qM8ickFJxd/ASyy
         IAJaCgRAiF/i5Qh6jDfWlUCuFPYiJdsVijAqA7PsXkW5KO0Q/Ft/iLMhecdvdJNFpA9f
         g2Libw2pEWZJfbSQKRVnYvicRgXVn9v3p5ONLpREakCDrOzRp+l/9EZS/4QIxlKXvMnG
         Ig4OksY7tUenSTROwoDn61wEv8iSvwW+WxPQDy1C7AFI6uteWX1AGrL5byuQSm0O8WZW
         zTOg==
X-Gm-Message-State: AOAM530+xb3mK+C7BP3PN6afGQ7tpcgMSLRmsSLXVxvyfqgaHTgDkNn1
        a9jYrTbkMPX5LxSUyWCnNoi0Ou/65LnckI692e6WrDCotk0Y5b4p
X-Google-Smtp-Source: ABdhPJzr8KcM6zJqeVR++RcjnWt01xCANrk81+BaS6dd8rKggMvZSv67FzuFQrLwYcVLcwrt5iWlrCz+XUDCCgFnUyE=
X-Received: by 2002:ab0:36dc:: with SMTP id v28mr12460789uau.31.1634030043137;
 Tue, 12 Oct 2021 02:14:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211008032231.1143467-1-fengli@smartx.com> <CAPhsuW5+bdQwsyjBP=QDGRbtnF021291D_XrhNtV+v-geVouVg@mail.gmail.com>
 <CALTww28b0HGzSTTNGVzeZdRp0nGMDAyY8sQ+cBsSCuYJ4jMaqw@mail.gmail.com>
 <CAHckoCyuqxM8po4JA4=OacVWhYuo9SWescUVOKRFGwdc=aoN8A@mail.gmail.com>
 <CALTww28CsJdmVOLFeoHC8FgbHDK78h8Lncsf9fFA0RYXEj=R9A@mail.gmail.com>
 <CAHckoCzzVP7npmU4LWedzD-f1QmkH4K0iLk_=8ptSFXrFfRoDw@mail.gmail.com>
 <CAPhsuW4VFTpM94by-iMkTQ=b9Y7FqZ2oqHH+jV-f8BM=YKWyiA@mail.gmail.com>
 <CAHckoCxRj1qb=yfeQ2o_8n_BSSLD9JXqm8GopUp2qx9NEPxr7w@mail.gmail.com> <CALTww2_eScuqd4yUtDFhaRUGAK-f8J_L=yOZdTVA9uZ7Tq4bxg@mail.gmail.com>
In-Reply-To: <CALTww2_eScuqd4yUtDFhaRUGAK-f8J_L=yOZdTVA9uZ7Tq4bxg@mail.gmail.com>
From:   Li Feng <fengli@smartx.com>
Date:   Tue, 12 Oct 2021 17:13:51 +0800
Message-ID: <CAHckoCys6_SG56jzuK0OfFwKb6BtBsUhpp6A70hOKFSeVTWU-Q@mail.gmail.com>
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

Thanks,
Feng Li

Xiao Ni <xni@redhat.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=8812=E6=97=A5=E5=91=
=A8=E4=BA=8C =E4=B8=8B=E5=8D=884:49=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi all
>
> How about this patch? Now writemostly flag doesn't be stored in
> superblock too. So this patch fix this problem too.
> If this patch is ok, I'll send the patch.
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6c0c3d0d905a..9e8a8c5c7758 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2977,6 +2977,7 @@ state_store(struct md_rdev *rdev, const char
> *buf, size_t len)
>       *  {,-}failfast - set/clear FailFast
>       */
>      int err =3D -EINVAL;
> +    int need_update_sb =3D 0;
>      if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
>          md_error(rdev->mddev, rdev);
>          if (test_bit(Faulty, &rdev->flags))
> @@ -2998,20 +2999,19 @@ state_store(struct md_rdev *rdev, const char
> *buf, size_t len)
>
>              if (err =3D=3D 0) {
>                  md_kick_rdev_from_array(rdev);
> -                if (mddev->pers) {
> -                    set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> -                    md_wakeup_thread(mddev->thread);
> -                }
> +                need_update_sb =3D 1;
>                  md_new_event(mddev);
>              }
>          }
>      } else if (cmd_match(buf, "writemostly")) {
>          set_bit(WriteMostly, &rdev->flags);
>          mddev_create_serial_pool(rdev->mddev, rdev, false);
> +        need_update_sb =3D 1;
>          err =3D 0;
>      } else if (cmd_match(buf, "-writemostly")) {
>          mddev_destroy_serial_pool(rdev->mddev, rdev, false);
>          clear_bit(WriteMostly, &rdev->flags);
> +        need_update_sb =3D 1;
>          err =3D 0;
>      } else if (cmd_match(buf, "blocked")) {
>          set_bit(Blocked, &rdev->flags);
> @@ -3037,9 +3037,11 @@ state_store(struct md_rdev *rdev, const char
> *buf, size_t len)
>          err =3D 0;
>      } else if (cmd_match(buf, "failfast")) {
>          set_bit(FailFast, &rdev->flags);
> +        need_update_sb =3D 1;
>          err =3D 0;
>      } else if (cmd_match(buf, "-failfast")) {
>          clear_bit(FailFast, &rdev->flags);
> +        need_update_sb =3D 1;
>          err =3D 0;
>      } else if (cmd_match(buf, "-insync") && rdev->raid_disk >=3D 0 &&
>             !test_bit(Journal, &rdev->flags)) {
> @@ -3120,6 +3122,11 @@ state_store(struct md_rdev *rdev, const char
> *buf, size_t len)
>      }
>      if (!err)
>          sysfs_notify_dirent_safe(rdev->sysfs_state);
> +    if (need_update_sb)
> +        if (mddev->pers) {
> +            set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> +            md_wakeup_thread(mddev->thread);
> +        }
When will mddev->pers is NULL?
If it is NULL, this change will not on disk.

>      return err ? err : len;
>  }
>  static struct rdev_sysfs_entry rdev_state =3D
>
> On Tue, Oct 12, 2021 at 4:44 PM Li Feng <fengli@smartx.com> wrote:
> >
> > Song Liu <song@kernel.org> =E4=BA=8E2021=E5=B9=B410=E6=9C=8812=E6=97=A5=
=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=884:17=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Tue, Oct 12, 2021 at 1:07 AM Li Feng <fengli@smartx.com> wrote:
> > > >
> > > > Xiao Ni <xni@redhat.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=8812=E6=97=
=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=882:58=E5=86=99=E9=81=93=EF=BC=9A
> > > > >
> > > > > On Mon, Oct 11, 2021 at 5:42 PM Li Feng <fengli@smartx.com> wrote=
:
> > > > > >
> > > > > > Xiao Ni <xni@redhat.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=8811=E6=
=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=883:49=E5=86=99=E9=81=93=EF=BC=9A
> > > > > > >
> > > > > > > Hi all
> > > > > > >
> > > > > > > Now the per device sysfs interface file state can change fail=
fast. Do
> > > > > > > we need a new file for failfast?
> > > > > > >
> > > > > > > I did a test. The steps are:
> > > > > > >
> > > > > > > mdadm -CR /dev/md0 -l1 -n2 /dev/sdb /dev/sdc --assume-clean
> > > > > > > cd /sys/block/md0/md/dev-sdb
> > > > > > > echo failfast > state
> > > > > > > cat state
> > > > > > > in_sync,failfast
> > > > > >
> > > > > > This works,  will it be persisted to disk?
> > > > > >
> > > > >
> > > > > mdadm --detail /dev/md0 can show the failfast information. So it
> > > > > should be written in superblock.
> > > > > But I don't find how md does this. I'm looking at this.
> > > > >
> > > > Yes, I have tested that it has been persisted, but don't understand=
 who does it.
> > >
> > > I think this is not guaranteed to be persistent:
> > >
> > > [root@eth50-1 ~]# cat /sys/block/md127/md/rd1/state
> > > in_sync,failfast
> > > [root@eth50-1 ~]# echo -failfast >  /sys/block/md127/md/rd1/state
> > > [root@eth50-1 ~]# cat /sys/block/md127/md/rd1/state
> > > in_sync
> > > [root@eth50-1 ~]# mdadm --stop /dev/md*
> > > mdadm: /dev/md does not appear to be an md device
> > > mdadm: stopped /dev/md127
> > > [root@eth50-1 ~]# mdadm -As
> > > mdadm: /dev/md/0_0 has been started with 4 drives.
> > > [root@eth50-1 ~]# cat /sys/block/md127/md/rd1/state
> > > in_sync,failfast
> > >
> > > How about we fix state_store to make sure it is always persistent?
> > >
> > I agree with you.
> >
> > > Thanks,
> > > Song
> >
>
