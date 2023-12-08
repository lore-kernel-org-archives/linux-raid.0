Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93D763A3
	for <linux-raid@vger.kernel.org>; Fri,  8 Dec 2023 05:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="grECRR+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E09EC433C7
	for <linux-raid@vger.kernel.org>; Fri,  8 Dec 2023 05:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702013331;
	bh=+JsqRWHHKekzH+3r+c6xca7mpfHrpuAzB2AWMZLUtm4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=grECRR+lBLlQTeDvHvOf1Knkh5W3XtSSwRZFdndHAlGb9OgrqT4tLJ5WHWZFt4aU7
	 XW7lC3vyFmTRXFwbbpgp9DhKrlkjHcjl4W+sbFaNhO844r/zz1dP7EBXkF54G8PHwy
	 UpNPfLpLLZtp1km3ZrvcHS02cINdRqVT7H7ke6hBEuZuoaDkiijtp2K8BzOlq9mOXZ
	 x1Na5zxCf6FyMk4zz0U7/Cz0ijimMjQCdUvpvpIK4WbIgKy0NBDWuvX7cjmNAdKyAB
	 aTXCOT4x3qUkLI4FNotq2QePjc23sfuL+VbSe/tGC05m7aTFrUQUcOy0+pw40XBBsu
	 8a1Sl/miaBWRA==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2ca0c36f5beso21295351fa.1
        for <linux-raid@vger.kernel.org>; Thu, 07 Dec 2023 21:28:51 -0800 (PST)
X-Gm-Message-State: AOJu0YyTfKD0WG+NimBIJwHMuB58nrkJtQWEvSPl4wpnRf//qoqb+GXm
	UbUG7Uz9iR6o7rD3cM2LIM7BlOwLF7AEwGX29dI=
X-Google-Smtp-Source: AGHT+IFqZBZYOD2VC5DByGWhGoqqs8I8x5/B6fQcm8n2TakZZug4adCK+e80UGQH7fKLNh27wWLoHjw4jVTHXyRlUy0=
X-Received: by 2002:ac2:4156:0:b0:50b:ffb9:be80 with SMTP id
 c22-20020ac24156000000b0050bffb9be80mr1910660lfi.119.1702013329375; Thu, 07
 Dec 2023 21:28:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1701708855-17404-1-git-send-email-alex.lyakas@zadara.com>
In-Reply-To: <1701708855-17404-1-git-send-email-alex.lyakas@zadara.com>
From: Song Liu <song@kernel.org>
Date: Thu, 7 Dec 2023 21:28:38 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7YQek6EEp31mokqwUQ0KBjthgqVZFLz8C0N6rz_cGY+g@mail.gmail.com>
Message-ID: <CAPhsuW7YQek6EEp31mokqwUQ0KBjthgqVZFLz8C0N6rz_cGY+g@mail.gmail.com>
Subject: Re: [PATCH] md: upon assembling the array, consult the superblock of
 the freshest device
To: Alex Lyakas <alex.lyakas@zadara.com>
Cc: linux-raid@vger.kernel.org, Alex Lyakas <alex@zadara.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alex,

On Mon, Dec 4, 2023 at 9:00=E2=80=AFAM Alex Lyakas <alex.lyakas@zadara.com>=
 wrote:
>
> From: Alex Lyakas <alex@zadara.com>
>
> Upon assembling the array, both kernel and mdadm allow the devices to hav=
e event
> counter difference of 1, and still consider them as up-to-date.
> However, a device whose event count is behind by 1, may in fact not be up=
-to-date,
> and array resync with such a device may cause data corruption.
> To avoid this, consult the superblock of the freshest device about the st=
atus
> of a device, whose event counter is behind by 1.
>
> Signed-off-by: Alex Lyakas <alex.lyakas@zadara.com>

You are using two different emails for "From:" and "Signed-off-by", which o=
ne
would you prefer?

Please run ./scripts/checkpatch.pl on the .patch file before sending them. =
It
would help catch issues like code format and email mismatch

>
> Disclaimer: I was not able to test this change on one of the latest 6.7 k=
ernels.
> I tested it on kernel 4.14 LTS and then ported the changes.
>
> To test this change, I modified the code of remove_and_add_spares():
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ad68b5e..f57854e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c

This part confuses b4 (patch handling script used by many). It looks like t=
wo
patches bundled together.

> @@ -9341,6 +9341,7 @@ static int remove_and_add_spares(struct mddev *mdde=
v,
>                 }
>         }
>  no_add:
> +       removed =3D 0;
>         if (removed)
>                 set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>         return spares;
>
> With this change, when a device fails, the superblock of all other device=
s
> is only updated once. During test, I sumulated a failure of one of the de=
vices,
> and then rebooted the machine. After reboot, I re-assembled the array
> with all devices, including the device that I failed.
> Event counter difference between the failed device and the other devices
> was 1, and then with my change the role of the problematic device was tak=
en
> from the superblock of one of the higher devices, which indicated
> the role to be MD_DISK_ROLE_FAULTY. After array assembly completed,
> remove_and_add_spares() ejected the problematic disk from the array,
> as expected.
> ---
>  drivers/md/md.c | 53 +++++++++++++++++++++++++++++++++++++++++++--------=
--
>  1 file changed, 43 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c94373d..ad68b5e 100644
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
> @@ -1333,7 +1334,7 @@ static int super_90_load(struct md_rdev *rdev, stru=
ct md_rdev *refdev, int minor
>  /*
>   * validate_super for 0.90.0
>   */
> -static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
> +static int super_90_validate(struct mddev *mddev, struct md_rdev *freshe=
st, struct md_rdev *rdev)

Please add a comment saying we are not using "freshest for 0.9 superblock.

>  {
>         mdp_disk_t *desc;
>         mdp_super_t *sb =3D page_address(rdev->sb_page);
> @@ -1845,7 +1846,7 @@ static int super_1_load(struct md_rdev *rdev, struc=
t md_rdev *refdev, int minor_
>         return ret;
>  }
>
> -static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
> +static int super_1_validate(struct mddev *mddev, struct md_rdev *freshes=
t, struct md_rdev *rdev)
>  {
>         struct mdp_superblock_1 *sb =3D page_address(rdev->sb_page);
>         __u64 ev1 =3D le64_to_cpu(sb->events);
> @@ -1941,13 +1942,15 @@ static int super_1_validate(struct mddev *mddev, =
struct md_rdev *rdev)
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
>                     (le16_to_cpu(sb->dev_roles[rdev->desc_nr]) < MD_DISK_=
ROLE_MAX ||
>                      le16_to_cpu(sb->dev_roles[rdev->desc_nr]) =3D=3D MD_=
DISK_ROLE_JOURNAL))
> -                       if (ev1 < mddev->events)
> +                       if (ev1 + 1 < mddev->events)
>                                 return -EINVAL;
>         } else if (mddev->bitmap) {
>                 /* If adding to array with a bitmap, then we can accept a=
n
> @@ -1968,8 +1971,38 @@ static int super_1_validate(struct mddev *mddev, s=
truct md_rdev *rdev)
>                     rdev->desc_nr >=3D le32_to_cpu(sb->max_dev)) {
>                         role =3D MD_DISK_ROLE_SPARE;
>                         rdev->desc_nr =3D -1;
> -               } else
> +               } else if (mddev->pers =3D=3D NULL && freshest !=3D NULL =
&& ev1 < mddev->events) {
> +                       /*
> +                        * If we are assembling, and our event counter is=
 smaller than the
> +                        * highest event counter, we cannot trust our sup=
erblock about the role.
> +                        * It could happen that our rdev was marked as Fa=
ulty, and all other
> +                        * superblocks were updated with +1 event counter=
.
> +                        * Then, before the next superblock update, which=
 typically happens when
> +                        * remove_and_add_spares() removes the device fro=
m the array, there was
> +                        * a crash or reboot.
> +                        * If we allow current rdev without consulting th=
e freshest superblock,
> +                        * we could cause data corruption.
> +                        * Note that in this case our event counter is sm=
aller by 1 than the
> +                        * highest, otherwise, this rdev would not be all=
owed into array;
> +                        * both kernel and mdadm allow event counter diff=
erence of 1.
> +                        */
> +                       struct mdp_superblock_1 *freshest_sb =3D page_add=
ress(freshest->sb_page);
> +                       u32 freshest_max_dev =3D le32_to_cpu(freshest_sb-=
>max_dev);
> +
> +                       if (rdev->desc_nr >=3D freshest_max_dev) {
> +                               /* this is unexpected, better not proceed=
 */
> +                               pr_warn("md: %s: rdev[%pg]: desc_nr(%d) >=
=3D freshest(%pg)->sb->max_dev(%u)\n",
> +                                               mdname(mddev), rdev->bdev=
, rdev->desc_nr, freshest->bdev,

There is probably some format issue here. checkpatch.pl should also
warn about it.

Please address the feedback and send v2 of the patch.

Thanks,
Song


> +                                               freshest_max_dev);
> +                               return -EUCLEAN;
> +                       }
> +
> +                       role =3D le16_to_cpu(freshest_sb->dev_roles[rdev-=
>desc_nr]);
> +                       pr_debug("md: %s: rdev[%pg]: role=3D%d(0x%x) acco=
rding to freshest %pg\n",
> +                                    mdname(mddev), rdev->bdev, role, rol=
e, freshest->bdev);
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
>                                 pr_warn("md: kicking non-fresh %pg from a=
rray!\n",
>                                         rdev->bdev);
>                                 md_kick_rdev_from_array(rdev);
> @@ -6836,7 +6869,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu=
_disk_info_s *info)
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
>
