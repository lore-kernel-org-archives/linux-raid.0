Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5019C6FD19
	for <linux-raid@archiver.kernel.org>; Mon, 13 Mar 2023 21:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjCMVvU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Mar 2023 17:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjCMVvS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Mar 2023 17:51:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711978C51F
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 14:51:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05D3E6150D
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 21:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B71C433EF
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 21:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678744269;
        bh=x+H2FT1undjTsiDMgWK1bNaWcdBo9zMwiYDkNjngaLo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LDMbxt6zFUZ7rnO9NLkwKxNr+VE5RoCjoAJYsMZHRMmTQSg+3QVm3RkCvj9YRB10a
         RBOLUo7o7whLI8H0hJ+wRe5mdUp2mmIeIqrL/epqAOgUOBMkrjBiCP60zIr4Gnr9uf
         OHQjStAAEgR37/PHbjPKyjyq06M+B9MkYCqsmUMMEECdXm2US1E9TsTtVxg1KKkgR+
         uR0LBaAA+x7p907kAZgM7Hza2DIqoZRyLgMW4sYvJLKlePAnDqUQbBUgi2sPMFEz9x
         vP9XytBLPbb72w1odD/fSMDng6vgRLOz+EA7dQiNXipxkZT51E4ZmWSnVOkFl13fwi
         qcxAZYZ3pdhDA==
Received: by mail-lf1-f52.google.com with SMTP id r27so17512929lfe.10
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 14:51:09 -0700 (PDT)
X-Gm-Message-State: AO0yUKUgfJi7Qu0C3XuWWr9d0EIt7a0Njn3d1G+UgjBUerfZLuT5uys4
        vy/Rry+AbDB51G9Pw/NghWo09Pasc6kVCfx24po=
X-Google-Smtp-Source: AK7set+4ncZW/BtGhu2TKnBYUPqQ1NMjRZBW+d1XhCyQ2BCt5NkuxspxnIoG9UPZKIG5elw0ipkSqzRmglY8eGkuBjA=
X-Received: by 2002:a19:7613:0:b0:4d5:ca32:6ed5 with SMTP id
 c19-20020a197613000000b004d5ca326ed5mr11534lff.3.1678744267381; Mon, 13 Mar
 2023 14:51:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230306130317.3418-1-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20230306130317.3418-1-mariusz.tkaczyk@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 13 Mar 2023 14:50:54 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7AUASschZ=xoE=QhuWAb4UsE3RFOiZZsbKQfOKbTVkgg@mail.gmail.com>
Message-ID: <CAPhsuW7AUASschZ=xoE=QhuWAb4UsE3RFOiZZsbKQfOKbTVkgg@mail.gmail.com>
Subject: Re: [PATCH] raid0, linear, md: add error_handlers
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, guoqing.jiang@linux.dev, xni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Mar 6, 2023 at 5:03=E2=80=AFAM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> After the commit 9631abdbf406c("md: Set MD_BROKEN for RAID1 and RAID10")
> MD_BROKEN must be set if array is failed because state_store() checks it.
> If it is set then -EBUSY is returned to userspace.
>
> For raid0 and linear MD_BROKEN is not set by error_handler(). As a result
> mdadm is unable to trigger clean-up actions. It is a regression.
>
> This patch adds appropriate error_handler for raid0 and linear. The
> error handler sets MD_BROKEN for this device.
>
> Reviewed-by: Xiao Ni <xni@redhat.com>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Applied to md-next.

Thanks,
Song

> ---
>
> We decided to drop this patch. Xiao determined that there is a regression
> so bringing it back. I can implement it differently to avoid
> error_handlers() if you still see them as overhead.
>
> https://lore.kernel.org/linux-raid/CAPhsuW4ZkqRQpW7UA45m_EB_sGcxL84RAg2JS=
5ZcZ8seGwMj+g@mail.gmail.com/
>
>  drivers/md/md-linear.c | 14 +++++++++++++-
>  drivers/md/md.c        |  3 +++
>  drivers/md/md.h        | 10 ++--------
>  drivers/md/raid0.c     | 14 +++++++++++++-
>  4 files changed, 31 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index 6e7797b4e738..4eb72b9dd933 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -223,7 +223,8 @@ static bool linear_make_request(struct mddev *mddev, =
struct bio *bio)
>                      bio_sector < start_sector))
>                 goto out_of_bounds;
>
> -       if (unlikely(is_mddev_broken(tmp_dev->rdev, "linear"))) {
> +       if (unlikely(is_rdev_broken(tmp_dev->rdev))) {
> +               md_error(mddev, tmp_dev->rdev);
>                 bio_io_error(bio);
>                 return true;
>         }
> @@ -270,6 +271,16 @@ static void linear_status (struct seq_file *seq, str=
uct mddev *mddev)
>         seq_printf(seq, " %dk rounding", mddev->chunk_sectors / 2);
>  }
>
> +static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
> +{
> +       if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
> +               char *md_name =3D mdname(mddev);
> +
> +               pr_crit("md/linear%s: Disk failure on %pg detected, faili=
ng array.\n",
> +                       md_name, rdev->bdev);
> +       }
> +}
> +
>  static void linear_quiesce(struct mddev *mddev, int state)
>  {
>  }
> @@ -286,6 +297,7 @@ static struct md_personality linear_personality =3D
>         .hot_add_disk   =3D linear_add,
>         .size           =3D linear_size,
>         .quiesce        =3D linear_quiesce,
> +       .error_handler  =3D linear_error,
>  };
>
>  static int __init linear_init (void)
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 927a43db5dfb..d95cf47ff924 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7974,6 +7974,9 @@ void md_error(struct mddev *mddev, struct md_rdev *=
rdev)
>                 return;
>         mddev->pers->error_handler(mddev, rdev);
>
> +       if (mddev->pers->level =3D=3D 0 || mddev->pers->level =3D=3D LEVE=
L_LINEAR)
> +               return;
> +
>         if (mddev->degraded && !test_bit(MD_BROKEN, &mddev->flags))
>                 set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>         sysfs_notify_dirent_safe(rdev->sysfs_state);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index e148e3c83b0d..fd8f260ed5f8 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -790,15 +790,9 @@ extern void mddev_destroy_serial_pool(struct mddev *=
mddev, struct md_rdev *rdev,
>  struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
>  struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev);
>
> -static inline bool is_mddev_broken(struct md_rdev *rdev, const char *md_=
type)
> +static inline bool is_rdev_broken(struct md_rdev *rdev)
>  {
> -       if (!disk_live(rdev->bdev->bd_disk)) {
> -               if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags))
> -                       pr_warn("md: %s: %s array has a missing/failed me=
mber\n",
> -                               mdname(rdev->mddev), md_type);
> -               return true;
> -       }
> -       return false;
> +       return !disk_live(rdev->bdev->bd_disk);
>  }
>
>  static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *=
mddev)
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index b536befd8898..f8ee9a95e25d 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -569,8 +569,9 @@ static bool raid0_make_request(struct mddev *mddev, s=
truct bio *bio)
>                 return true;
>         }
>
> -       if (unlikely(is_mddev_broken(tmp_dev, "raid0"))) {
> +       if (unlikely(is_rdev_broken(tmp_dev))) {
>                 bio_io_error(bio);
> +               md_error(mddev, tmp_dev);
>                 return true;
>         }
>
> @@ -592,6 +593,16 @@ static void raid0_status(struct seq_file *seq, struc=
t mddev *mddev)
>         return;
>  }
>
> +static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
> +{
> +       if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
> +               char *md_name =3D mdname(mddev);
> +
> +               pr_crit("md/raid0%s: Disk failure on %pg detected, failin=
g array.\n",
> +                       md_name, rdev->bdev);
> +       }
> +}
> +
>  static void *raid0_takeover_raid45(struct mddev *mddev)
>  {
>         struct md_rdev *rdev;
> @@ -767,6 +778,7 @@ static struct md_personality raid0_personality=3D
>         .size           =3D raid0_size,
>         .takeover       =3D raid0_takeover,
>         .quiesce        =3D raid0_quiesce,
> +       .error_handler  =3D raid0_error,
>  };
>
>  static int __init raid0_init (void)
> --
> 2.26.2
>
