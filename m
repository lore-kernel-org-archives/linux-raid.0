Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y6odWFlo"
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776A5101
	for <linux-raid@vger.kernel.org>; Sun,  3 Dec 2023 04:16:24 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-3333127685bso2004359f8f.0
        for <linux-raid@vger.kernel.org>; Sun, 03 Dec 2023 04:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701605783; x=1702210583; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pPrLmL0Scoj2/346Zzfl8Ur/MY5gFKnPdc5J6DwG1as=;
        b=Y6odWFlohaWbW2UzAecsbH4aJxzkU/kapRbX0FXzDOuuGu8euzEl9TbqH1fPHiWpbq
         ECZD5UYNeIJdBr6K8RDQcDRji52bPV4CdVv1kQxwUaNKoBDGGJfWvtHEoiqVBafOQ9PG
         ROG63dhVHbFib5s3IHkSpVjY0Q9jtk61RgiWNHb/g9Hx1Isdafidya3Czo944gSZmYC2
         bINbCXce2PqwkAILaTJ1S//YiWOEFUHxMbO/GoUrutHFTK/y84hgNEzWQXv0fIqb9mqO
         3tkDzC5nEG5Pt0BWbi09+Cu0PKfDpSg6Lzkhg/q6eLF+Ck/28M2Ojc4ttP2MtIajeiRo
         jEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701605783; x=1702210583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pPrLmL0Scoj2/346Zzfl8Ur/MY5gFKnPdc5J6DwG1as=;
        b=xA+9jzQN3NY8VHgMZc/xj6y2ey/0Ndrau2t1/nV12EqcocuzKFPXUvHJRtb5YZHwlf
         mA56E06UGXPmREd3CNGPRwijn2TLoq+mfitLSeJWDNEL5PdZvvNzA6sqyv4r+wgc7OnC
         AXFgODCY51bRrtT8WPnY+ZhDpCYFCxYnl3aWerdexJu6KmBz5uBoQHO3fv21tM4d/3Kp
         xQMeejCGS4m2AhoqvQIzch70dSyk5lztNU8iJbs1MlEdlot4WbQEDaAIzbwObJ5fYir2
         mBwOLgB5sSpnJdidKfaZ7LCj1qkkGvt0M/BAjpeigx6HNl0P7UiiWktEG56XdJ1HrKLp
         gAGw==
X-Gm-Message-State: AOJu0YyD2knsgrntWNMaX5/TMceJrUKj4NP9b5t5g5WDiYFgryNwEHAe
	DWJpc6hywj9R8WkHP9VIAATzI3LSjtSOwdDyKd6tmHbW
X-Google-Smtp-Source: AGHT+IH/BfT4fyEDAyjNJF35sN964pbWpyM+wiP5kthy0iJ+LC9x68s3w80R2QJmI5WJRni31x1ameRiFfhLHxo58mc=
X-Received: by 2002:a5d:690d:0:b0:333:3949:98ad with SMTP id
 t13-20020a5d690d000000b00333394998admr1256550wru.209.1701605782495; Sun, 03
 Dec 2023 04:16:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGRgLy5E3cb=MS8eSMH03fa27tgFnZp0hwrrobyQMuUU_Axiag@mail.gmail.com>
 <CAPhsuW4z7U-Aq=YemQjFKtcaB7k9x+T_=zM8oBkR3aK2fRzo=A@mail.gmail.com>
 <CAGRgLy6KH9WfqHzN2OkFg5tb49Y=wKnBqQCdWifoFV13aD17Dg@mail.gmail.com>
 <CAPhsuW6AT5_=d9ibfwBedsd-aVrdM1tfBnJpYD=hoiOeKMCpAw@mail.gmail.com>
 <CAGRgLy6H0q+VEGBeG5bqs-=826cZyGZYVq9_7ZG453n+XXJBcQ@mail.gmail.com> <CAPhsuW64xuwxJzbz+KHbot1_gJyM2bSMmT8R+HQwhhCpc0WC5g@mail.gmail.com>
In-Reply-To: <CAPhsuW64xuwxJzbz+KHbot1_gJyM2bSMmT8R+HQwhhCpc0WC5g@mail.gmail.com>
From: Alexander Lyakas <alex.bolshoy@gmail.com>
Date: Sun, 3 Dec 2023 14:16:17 +0200
Message-ID: <CAGRgLy7KGmX4zG_9CZ8NrFp4RKoN6CwFNTCKo8E+5iff790m8Q@mail.gmail.com>
Subject: Re: raid6 corruption after assembling with event counter difference
 of 1
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Song,

Thank you for your comments. I will address them. How do you want to
proceed? Do you want me to send a formal patch to the list (with
proper formatting this time)? As mentioned, I am not able to test this
fix on one of the latest kernels, but only on 4.14.99.

Thanks,
Alex.

On Thu, Nov 30, 2023 at 2:38=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> Hi Alexander,
>
> Thanks for working on this.
>
> The patch looks good overall. A few comments below.
>
> On Wed, Nov 29, 2023 at 4:15=E2=80=AFAM Alexander Lyakas <alex.bolshoy@gm=
ail.com> wrote:
> >
> [...]
> >
> > Please kindly note the following:
> > - md has many features, which we don't use, such as: "non-persistent
> > arrays", "clustered arrays", "autostart", "journal devices",
> > "write-behind", "multipath arrays" and others. I cannot say how this
> > fix will interoperate with these features.
> > - I tested the fix only on superblock version 1.2. I don't know how
> > 0.9 superblocks work (because I never used them), so I did not change
> > anything in super_90_validate().
>
> I think we can leave 0.9 as-is.
>
> > - I tested the fix on our production kernel 4.14 LTS. I ported the
> > changes to the mainline kernel 6.7-rc3, but I do not have the ability
> > at the moment to test it on this kernel.
> [...]
> >  drivers/md/md.c | 53 +++++++++++++++++++++++++++++++++++++++++++------=
----
> >  1 file changed, 43 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index c94373d..e490275 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -1195,6 +1195,7 @@ struct super_type  {
> >                                           struct md_rdev *refdev,
> >                                           int minor_version);
> >         int                 (*validate_super)(struct mddev *mddev,
> > +                                             struct md_rdev *freshest,
> >                                               struct md_rdev *rdev);
> >         void                (*sync_super)(struct mddev *mddev,
> >                                           struct md_rdev *rdev);
> > @@ -1333,7 +1334,7 @@ static int super_90_load(struct md_rdev *rdev,
> > struct md_rdev *refdev, int minor
> >  /*
> >   * validate_super for 0.90.0
> >   */
> > -static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev=
)
> > +static int super_90_validate(struct mddev *mddev, struct md_rdev
> > *freshest, struct md_rdev *rdev)
> >  {
> >         mdp_disk_t *desc;
> >         mdp_super_t *sb =3D page_address(rdev->sb_page);
> > @@ -1845,7 +1846,7 @@ static int super_1_load(struct md_rdev *rdev,
> > struct md_rdev *refdev, int minor_
> >         return ret;
> >  }
> >
> > -static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
> > +static int super_1_validate(struct mddev *mddev, struct md_rdev
> > *freshest, struct md_rdev *rdev)
> >  {
> >         struct mdp_superblock_1 *sb =3D page_address(rdev->sb_page);
> >         __u64 ev1 =3D le64_to_cpu(sb->events);
> > @@ -1941,13 +1942,15 @@ static int super_1_validate(struct mddev
> > *mddev, struct md_rdev *rdev)
> >                 }
> >         } else if (mddev->pers =3D=3D NULL) {
> >                 /* Insist of good event counter while assembling, excep=
t for
> > -                * spares (which don't need an event count) */
> > -               ++ev1;
> > +                * spares (which don't need an event count).
> > +                * Similar to mdadm, we allow event counter difference =
of 1
> > +                * from the freshest device.
> > +                */
> >                 if (rdev->desc_nr >=3D 0 &&
> >                     rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
> >                     (le16_to_cpu(sb->dev_roles[rdev->desc_nr]) <
> > MD_DISK_ROLE_MAX ||
> >                      le16_to_cpu(sb->dev_roles[rdev->desc_nr]) =3D=3D
> > MD_DISK_ROLE_JOURNAL))
> > -                       if (ev1 < mddev->events)
> > +                       if (ev1 + 1 < mddev->events)
> >                                 return -EINVAL;
> >         } else if (mddev->bitmap) {
> >                 /* If adding to array with a bitmap, then we can accept=
 an
> > @@ -1968,8 +1971,38 @@ static int super_1_validate(struct mddev
> > *mddev, struct md_rdev *rdev)
> >                     rdev->desc_nr >=3D le32_to_cpu(sb->max_dev)) {
> >                         role =3D MD_DISK_ROLE_SPARE;
> >                         rdev->desc_nr =3D -1;
> > -               } else
> > +               } else if (mddev->pers =3D=3D NULL && freshest !=3D NUL=
L &&
> > ev1 < mddev->events) {
> > +                       /*
> > +                        * If we are assembling, and our event counter
> > is smaller than the
> > +                        * highest event counter, we cannot trust our
> > superblock about the role.
> > +                        * It could happen that our rdev was marked as
> > Faulty, and all other
> > +                        * superblocks were updated with +1 event count=
er.
> > +                        * Then, before the next superblock update,
> > which typically happens when
> > +                        * remove_and_add_spares() removes the device
> > from the array, there was
> > +                        * a crash or reboot.
> > +                        * If we allow current rdev without consulting
> > the freshest superblock,
> > +                        * we could cause data corruption.
> > +                        * Note that in this case our event counter is
> > smaller by 1 than the
> > +                        * highest, otherwise, this rdev would not be
> > allowed into array;
> > +                        * both kernel and mdadm allow event counter
> > difference of 1.
> > +                        */
> > +                       struct mdp_superblock_1 *freshest_sb =3D
> > page_address(freshest->sb_page);
> > +                       u32 freshest_max_dev =3D
> > le32_to_cpu(freshest_sb->max_dev);
> > +
> > +                       if (rdev->desc_nr >=3D freshest_max_dev) {
> > +                               /* this is unexpected, better not proce=
ed */
> > +                               pr_warn("md: %s: rdev[%pg]:
> > desc_nr(%d) >=3D freshest(%pg)->sb->max_dev(%u)\n",
> > +                                               mdname(mddev),
> > rdev->bdev, rdev->desc_nr, freshest->bdev,
> > +                                               freshest_max_dev);
> > +                               return -EUCLEAN;
> > +                       }
> > +
> > +                       role =3D
> > le16_to_cpu(freshest_sb->dev_roles[rdev->desc_nr]);
> > +                       pr_warn("md: %s: rdev[%pg]: role=3D%d(0x%x)
> > according to freshest %pg\n",
> > +                                   mdname(mddev), rdev->bdev, role,
> > role, freshest->bdev);
>
> I think this should be a pr_debug(). Or maybe only warn when
> freshest and current rdev disagree.
>
> > +               } else {
> >                         role =3D le16_to_cpu(sb->dev_roles[rdev->desc_n=
r]);
> > +               }
> >                 switch(role) {
> >                 case MD_DISK_ROLE_SPARE: /* spare */
> >                         break;
> > @@ -2876,7 +2909,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
> >                  * and should be added immediately.
> >                  */
> >                 super_types[mddev->major_version].
> > -                       validate_super(mddev, rdev);
> > +                       validate_super(mddev, NULL/*freshest*/, rdev);
> >                 err =3D mddev->pers->hot_add_disk(mddev, rdev);
> >                 if (err) {
> >                         md_kick_rdev_from_array(rdev);
> > @@ -3813,7 +3846,7 @@ static int analyze_sbs(struct mddev *mddev)
> >         }
> >
> >         super_types[mddev->major_version].
> > -               validate_super(mddev, freshest);
> > +               validate_super(mddev, NULL/*freshest*/, freshest);
> >
> >         i =3D 0;
> >         rdev_for_each_safe(rdev, tmp, mddev) {
> > @@ -3828,7 +3861,7 @@ static int analyze_sbs(struct mddev *mddev)
> >                 }
> >                 if (rdev !=3D freshest) {
> >                         if (super_types[mddev->major_version].
> > -                           validate_super(mddev, rdev)) {
> > +                           validate_super(mddev, freshest, rdev)) {
> >                                 pr_warn("md: kicking non-fresh %pg
> > from array!\n",
> >                                         rdev->bdev);
> >                                 md_kick_rdev_from_array(rdev);
> > @@ -6836,7 +6869,7 @@ int md_add_new_disk(struct mddev *mddev, struct
> > mdu_disk_info_s *info)
> >                         rdev->saved_raid_disk =3D rdev->raid_disk;
> >                 } else
> >                         super_types[mddev->major_version].
> > -                               validate_super(mddev, rdev);
> > +                               validate_super(mddev, NULL/*freshest*/,=
 rdev);
> >                 if ((info->state & (1<<MD_DISK_SYNC)) &&
> >                      rdev->raid_disk !=3D info->raid_disk) {
> >                         /* This was a hot-add request, but events doesn=
't
> > --
> > 1.9.1
