Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077EAC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 17:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDD1E60F38
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 17:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhJLRW7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Oct 2021 13:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhJLRW7 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 12 Oct 2021 13:22:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A0F860F38;
        Tue, 12 Oct 2021 17:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634059257;
        bh=KLl+8VX4c+ZHvAiUyKBm4KSnrVYLhkWpkOqTx+1Xg4w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Z2xEFEL96TpHzRNOvLt4aUcaDUXFHGEVxQmLRSAtRnrWcV5PgkBj2KkskG1zO1e33
         GTm6+9WfWytxi6TzoSj5fKWvPd1KYdQ95Ms4l14xNemzw8xJGTNTSHh/CjXJxiOR/v
         IyAzPzTaiasexyCwM59Eig41PeAwggHBU6eqaxD2PFS/Gf0VEggyPZSK8TWUSiHmNT
         znaZMqhUj2bAhjLdRATqudk1UGxALj/QseGw/3HMeLM+ij/z4627mUUgVu+D1D148X
         j05+IIk26QQWk26Yncm59YLR6SGZ35Ohif7wLOmacAQwnw2Ta1CyrCcWcZfhWNE4P8
         4oAjTNIlzsWTg==
Received: by mail-lf1-f53.google.com with SMTP id j5so16504lfg.8;
        Tue, 12 Oct 2021 10:20:57 -0700 (PDT)
X-Gm-Message-State: AOAM531ikpbEwazs0jmf3fVvrfNxum+48E0Ul3U13ml1MdwVE1VpgYkf
        Txv+l8hEMBcyTCjNPFVx/sqoM8pkQt+IEPiaZM0=
X-Google-Smtp-Source: ABdhPJybb1dYd09nhHdN5yW0bkJ51EQt4i1dBYJspuCmUsXDo07fUhszhEc/95naLZORz1gl34KRE5gIykClV1ajGjI=
X-Received: by 2002:a2e:6e0b:: with SMTP id j11mr30821450ljc.527.1634059255633;
 Tue, 12 Oct 2021 10:20:55 -0700 (PDT)
MIME-Version: 1.0
References: <20211008032231.1143467-1-fengli@smartx.com> <CAPhsuW5+bdQwsyjBP=QDGRbtnF021291D_XrhNtV+v-geVouVg@mail.gmail.com>
 <CALTww28b0HGzSTTNGVzeZdRp0nGMDAyY8sQ+cBsSCuYJ4jMaqw@mail.gmail.com>
 <CAHckoCyuqxM8po4JA4=OacVWhYuo9SWescUVOKRFGwdc=aoN8A@mail.gmail.com>
 <CALTww28CsJdmVOLFeoHC8FgbHDK78h8Lncsf9fFA0RYXEj=R9A@mail.gmail.com>
 <CAHckoCzzVP7npmU4LWedzD-f1QmkH4K0iLk_=8ptSFXrFfRoDw@mail.gmail.com>
 <CAPhsuW4VFTpM94by-iMkTQ=b9Y7FqZ2oqHH+jV-f8BM=YKWyiA@mail.gmail.com>
 <CAHckoCxRj1qb=yfeQ2o_8n_BSSLD9JXqm8GopUp2qx9NEPxr7w@mail.gmail.com> <CALTww2_eScuqd4yUtDFhaRUGAK-f8J_L=yOZdTVA9uZ7Tq4bxg@mail.gmail.com>
In-Reply-To: <CALTww2_eScuqd4yUtDFhaRUGAK-f8J_L=yOZdTVA9uZ7Tq4bxg@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 12 Oct 2021 10:20:44 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6F6kF8CWAFk8Af+-WrELKVz8BYuYPFF1Fy_fAq8us84Q@mail.gmail.com>
Message-ID: <CAPhsuW6F6kF8CWAFk8Af+-WrELKVz8BYuYPFF1Fy_fAq8us84Q@mail.gmail.com>
Subject: Re: [PATCH RESEND] md: allow to set the fail_fast on RAID1/RAID10
To:     Xiao Ni <xni@redhat.com>
Cc:     Li Feng <fengli@smartx.com>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Oct 12, 2021 at 1:49 AM Xiao Ni <xni@redhat.com> wrote:
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

Please use bool for need_update_sb.

>      if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
>          md_error(rdev->mddev, rdev);
>          if (test_bit(Faulty, &rdev->flags))

[...]

> @@ -3120,6 +3122,11 @@ state_store(struct md_rdev *rdev, const char
> *buf, size_t len)
>      }
>      if (!err)
>          sysfs_notify_dirent_safe(rdev->sysfs_state);
> +    if (need_update_sb)
> +        if (mddev->pers) {
We can merge the two conditions in in one line

if (need_update_sb && mddev->pers) {
...
}

> +            set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> +            md_wakeup_thread(mddev->thread);
> +        }
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
