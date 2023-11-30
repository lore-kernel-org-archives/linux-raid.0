Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFC7386
	for <linux-raid@vger.kernel.org>; Thu, 30 Nov 2023 00:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcdJahCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB2EC433C8
	for <linux-raid@vger.kernel.org>; Thu, 30 Nov 2023 00:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701304736;
	bh=lKJ3VhljPOeukQQawN1FUNKq1ZQV0eyEnHLxoS/mzh0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dcdJahCyZMu2wx4FNQMTuQCY15u1KLrWorD2VSdd2gKduBk/2OMWJfLd8uqxctcCw
	 EpPhtI5feZkWFUT+VuU4qfRXurDDSfeWt2uPtuKbA0PDUUCiNMM8Q2KUFIVsDkk/4M
	 kx22ExeWslGzJ4VbvUyao6ujoCctyAFXX02In9bifYD9W/KFbcW+pqxlXr35msg9Kf
	 PqX5sM4INK+gtg6w/UyYAZmrRdrkg34+KVvw2GZqz5J/amxQ4DA2ziyIv24ty52Db9
	 U9OsAFkXYvUeEdQqinOVfFKEKQyHZGtNjv37gajaA7v0JLuNdWvxC2/NTYAxD2exYG
	 r6E+MuV8UwsHA==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-50bc8e37b5fso630639e87.0
        for <linux-raid@vger.kernel.org>; Wed, 29 Nov 2023 16:38:56 -0800 (PST)
X-Gm-Message-State: AOJu0YxXpWjDUCwoa8vOlKzbLDG73jGMFjVf9En8+M4mA+Q/ATXlV5yx
	7YinhfsiFmThAR47AVnOB/ThAY/Z5V9b2Z9jTUM=
X-Google-Smtp-Source: AGHT+IEHFa0m8KIAt/TELRhUHwUDDMWBN8k81tJEJDh2IeSmndBbmkQYbaIXxyofVRnYtKTH5Buzxgz1QnHxW42+ktw=
X-Received: by 2002:a05:6512:2017:b0:50b:c8a9:a65f with SMTP id
 a23-20020a056512201700b0050bc8a9a65fmr1421284lfb.6.1701304734458; Wed, 29 Nov
 2023 16:38:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGRgLy5E3cb=MS8eSMH03fa27tgFnZp0hwrrobyQMuUU_Axiag@mail.gmail.com>
 <CAPhsuW4z7U-Aq=YemQjFKtcaB7k9x+T_=zM8oBkR3aK2fRzo=A@mail.gmail.com>
 <CAGRgLy6KH9WfqHzN2OkFg5tb49Y=wKnBqQCdWifoFV13aD17Dg@mail.gmail.com>
 <CAPhsuW6AT5_=d9ibfwBedsd-aVrdM1tfBnJpYD=hoiOeKMCpAw@mail.gmail.com> <CAGRgLy6H0q+VEGBeG5bqs-=826cZyGZYVq9_7ZG453n+XXJBcQ@mail.gmail.com>
In-Reply-To: <CAGRgLy6H0q+VEGBeG5bqs-=826cZyGZYVq9_7ZG453n+XXJBcQ@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Wed, 29 Nov 2023 16:38:42 -0800
X-Gmail-Original-Message-ID: <CAPhsuW64xuwxJzbz+KHbot1_gJyM2bSMmT8R+HQwhhCpc0WC5g@mail.gmail.com>
Message-ID: <CAPhsuW64xuwxJzbz+KHbot1_gJyM2bSMmT8R+HQwhhCpc0WC5g@mail.gmail.com>
Subject: Re: raid6 corruption after assembling with event counter difference
 of 1
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

Thanks for working on this.

The patch looks good overall. A few comments below.

On Wed, Nov 29, 2023 at 4:15=E2=80=AFAM Alexander Lyakas <alex.bolshoy@gmai=
l.com> wrote:
>
[...]
>
> Please kindly note the following:
> - md has many features, which we don't use, such as: "non-persistent
> arrays", "clustered arrays", "autostart", "journal devices",
> "write-behind", "multipath arrays" and others. I cannot say how this
> fix will interoperate with these features.
> - I tested the fix only on superblock version 1.2. I don't know how
> 0.9 superblocks work (because I never used them), so I did not change
> anything in super_90_validate().

I think we can leave 0.9 as-is.

> - I tested the fix on our production kernel 4.14 LTS. I ported the
> changes to the mainline kernel 6.7-rc3, but I do not have the ability
> at the moment to test it on this kernel.
[...]
>  drivers/md/md.c | 53 +++++++++++++++++++++++++++++++++++++++++++--------=
--
>  1 file changed, 43 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c94373d..e490275 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1195,6 +1195,7 @@ struct super_type  {
>                                           struct md_rdev *refdev,
>                                           int minor_version);
>         int                 (*validate_super)(struct mddev *mddev,
> +                                             struct md_rdev *freshest,
>                                               struct md_rdev *rdev);
>         void                (*sync_super)(struct mddev *mddev,
>                                           struct md_rdev *rdev);
> @@ -1333,7 +1334,7 @@ static int super_90_load(struct md_rdev *rdev,
> struct md_rdev *refdev, int minor
>  /*
>   * validate_super for 0.90.0
>   */
> -static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
> +static int super_90_validate(struct mddev *mddev, struct md_rdev
> *freshest, struct md_rdev *rdev)
>  {
>         mdp_disk_t *desc;
>         mdp_super_t *sb =3D page_address(rdev->sb_page);
> @@ -1845,7 +1846,7 @@ static int super_1_load(struct md_rdev *rdev,
> struct md_rdev *refdev, int minor_
>         return ret;
>  }
>
> -static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
> +static int super_1_validate(struct mddev *mddev, struct md_rdev
> *freshest, struct md_rdev *rdev)
>  {
>         struct mdp_superblock_1 *sb =3D page_address(rdev->sb_page);
>         __u64 ev1 =3D le64_to_cpu(sb->events);
> @@ -1941,13 +1942,15 @@ static int super_1_validate(struct mddev
> *mddev, struct md_rdev *rdev)
>                 }
>         } else if (mddev->pers =3D=3D NULL) {
>                 /* Insist of good event counter while assembling, except =
for
> -                * spares (which don't need an event count) */
> -               ++ev1;
> +                * spares (which don't need an event count).
> +                * Similar to mdadm, we allow event counter difference of=
 1
> +                * from the freshest device.
> +                */
>                 if (rdev->desc_nr >=3D 0 &&
>                     rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
>                     (le16_to_cpu(sb->dev_roles[rdev->desc_nr]) <
> MD_DISK_ROLE_MAX ||
>                      le16_to_cpu(sb->dev_roles[rdev->desc_nr]) =3D=3D
> MD_DISK_ROLE_JOURNAL))
> -                       if (ev1 < mddev->events)
> +                       if (ev1 + 1 < mddev->events)
>                                 return -EINVAL;
>         } else if (mddev->bitmap) {
>                 /* If adding to array with a bitmap, then we can accept a=
n
> @@ -1968,8 +1971,38 @@ static int super_1_validate(struct mddev
> *mddev, struct md_rdev *rdev)
>                     rdev->desc_nr >=3D le32_to_cpu(sb->max_dev)) {
>                         role =3D MD_DISK_ROLE_SPARE;
>                         rdev->desc_nr =3D -1;
> -               } else
> +               } else if (mddev->pers =3D=3D NULL && freshest !=3D NULL =
&&
> ev1 < mddev->events) {
> +                       /*
> +                        * If we are assembling, and our event counter
> is smaller than the
> +                        * highest event counter, we cannot trust our
> superblock about the role.
> +                        * It could happen that our rdev was marked as
> Faulty, and all other
> +                        * superblocks were updated with +1 event counter=
.
> +                        * Then, before the next superblock update,
> which typically happens when
> +                        * remove_and_add_spares() removes the device
> from the array, there was
> +                        * a crash or reboot.
> +                        * If we allow current rdev without consulting
> the freshest superblock,
> +                        * we could cause data corruption.
> +                        * Note that in this case our event counter is
> smaller by 1 than the
> +                        * highest, otherwise, this rdev would not be
> allowed into array;
> +                        * both kernel and mdadm allow event counter
> difference of 1.
> +                        */
> +                       struct mdp_superblock_1 *freshest_sb =3D
> page_address(freshest->sb_page);
> +                       u32 freshest_max_dev =3D
> le32_to_cpu(freshest_sb->max_dev);
> +
> +                       if (rdev->desc_nr >=3D freshest_max_dev) {
> +                               /* this is unexpected, better not proceed=
 */
> +                               pr_warn("md: %s: rdev[%pg]:
> desc_nr(%d) >=3D freshest(%pg)->sb->max_dev(%u)\n",
> +                                               mdname(mddev),
> rdev->bdev, rdev->desc_nr, freshest->bdev,
> +                                               freshest_max_dev);
> +                               return -EUCLEAN;
> +                       }
> +
> +                       role =3D
> le16_to_cpu(freshest_sb->dev_roles[rdev->desc_nr]);
> +                       pr_warn("md: %s: rdev[%pg]: role=3D%d(0x%x)
> according to freshest %pg\n",
> +                                   mdname(mddev), rdev->bdev, role,
> role, freshest->bdev);

I think this should be a pr_debug(). Or maybe only warn when
freshest and current rdev disagree.

> +               } else {
>                         role =3D le16_to_cpu(sb->dev_roles[rdev->desc_nr]=
);
> +               }
>                 switch(role) {
>                 case MD_DISK_ROLE_SPARE: /* spare */
>                         break;
> @@ -2876,7 +2909,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
>                  * and should be added immediately.
>                  */
>                 super_types[mddev->major_version].
> -                       validate_super(mddev, rdev);
> +                       validate_super(mddev, NULL/*freshest*/, rdev);
>                 err =3D mddev->pers->hot_add_disk(mddev, rdev);
>                 if (err) {
>                         md_kick_rdev_from_array(rdev);
> @@ -3813,7 +3846,7 @@ static int analyze_sbs(struct mddev *mddev)
>         }
>
>         super_types[mddev->major_version].
> -               validate_super(mddev, freshest);
> +               validate_super(mddev, NULL/*freshest*/, freshest);
>
>         i =3D 0;
>         rdev_for_each_safe(rdev, tmp, mddev) {
> @@ -3828,7 +3861,7 @@ static int analyze_sbs(struct mddev *mddev)
>                 }
>                 if (rdev !=3D freshest) {
>                         if (super_types[mddev->major_version].
> -                           validate_super(mddev, rdev)) {
> +                           validate_super(mddev, freshest, rdev)) {
>                                 pr_warn("md: kicking non-fresh %pg
> from array!\n",
>                                         rdev->bdev);
>                                 md_kick_rdev_from_array(rdev);
> @@ -6836,7 +6869,7 @@ int md_add_new_disk(struct mddev *mddev, struct
> mdu_disk_info_s *info)
>                         rdev->saved_raid_disk =3D rdev->raid_disk;
>                 } else
>                         super_types[mddev->major_version].
> -                               validate_super(mddev, rdev);
> +                               validate_super(mddev, NULL/*freshest*/, r=
dev);
>                 if ((info->state & (1<<MD_DISK_SYNC)) &&
>                      rdev->raid_disk !=3D info->raid_disk) {
>                         /* This was a hot-add request, but events doesn't
> --
> 1.9.1
