Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara.com header.i=@zadara.com header.b="VuVhDJyc"
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1A0CF
	for <linux-raid@vger.kernel.org>; Wed, 13 Dec 2023 04:35:56 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2c9efa1ab7fso86253411fa.0
        for <linux-raid@vger.kernel.org>; Wed, 13 Dec 2023 04:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara.com; s=google; t=1702470955; x=1703075755; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qy7QdjCRS7MK44Zf7zBEPM+NUE8kMtItvlLi3557V1o=;
        b=VuVhDJycYmXTJrsxXSf7624e04oNeT00KCAG7PE5SPck70gZDFrNv1nr6L0pCCe8xr
         3QsCXtJeietXZoy/4lcL+YjcewHDKVXXjuuwi9JqPh9ncH1xCWxSkeUQNx+zmz0o6RRf
         CUVF/2LF3UX2HIxqJ47XWX0v0Zp/bXzkZYcZIUUdxHL752q6q6I73lVYWIvekeuiLyvx
         3uJVu2GPoDFD/ouNrU38xR3QnBa445ckI4K95X3hi6zEvH+uiGVAls9Fg7z2PsPF4UaZ
         eP8aUXbDhakOts5Izc2S2TyvgHoHxU/p0Xb8cr3R7F85XVZ29AqIIjP/hK+jXR3p1ItW
         m5hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702470955; x=1703075755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qy7QdjCRS7MK44Zf7zBEPM+NUE8kMtItvlLi3557V1o=;
        b=UMN98K7HQuWwG9hyne8boE1ibg84oqCRiqdHyXDxbcsipc1UilzewtGpNBZpRMzauq
         DJJdleMn7luTRC68Sii0TXhwcc+SeJxsKuB/KhzHIUaEqgVKFmRbYlRbKKSHey8sjLgx
         Ig/0Q148Zzj9Ou4qKL1R6icWYSUAFfjnMeohhHPi8ta2NMGtpDPVRKDRiF57PaQPhWoL
         Vg3YtbrN/RcJySz3/IJRirqdBIKCy3GiOUb6MQSaxpmdEORRRMIfUq3pyaqPg/Bb+3Pj
         VjEiCI0iefxev4ACTTiPZdYjWJSYgdERJVR7unMkllFwqce7lJrGsrLzYHGbtkrob6Xf
         xx1g==
X-Gm-Message-State: AOJu0YxHdVcKWp02QqQyWsNnGHZ9/VOMlwF4QeICQijiIshlIYwdwIP4
	LEcRCMOnVuPMEAptjlxBqlJiRxjFIEBzBtcOFSeenJvQsnua6jQu
X-Google-Smtp-Source: AGHT+IFbYH88qw7RNb9oPc/XGjaYPPN9nKGd317xjSMTy4Tv8f1+VfkjeFwHfyCuFcYXgc012EXowuWJ+UPHsS9Aw+E=
X-Received: by 2002:a2e:4942:0:b0:2ca:252d:ea62 with SMTP id
 b2-20020a2e4942000000b002ca252dea62mr1740449ljd.127.1702470955055; Wed, 13
 Dec 2023 04:35:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1701708855-17404-1-git-send-email-alex.lyakas@zadara.com> <CAPhsuW7YQek6EEp31mokqwUQ0KBjthgqVZFLz8C0N6rz_cGY+g@mail.gmail.com>
In-Reply-To: <CAPhsuW7YQek6EEp31mokqwUQ0KBjthgqVZFLz8C0N6rz_cGY+g@mail.gmail.com>
From: Alex Lyakas <alex.lyakas@zadara.com>
Date: Wed, 13 Dec 2023 14:35:43 +0200
Message-ID: <CAOcd+r14qsxsjq8z61ktyBxt_FUCFkXQwwuttsUGEwmqBjhZyw@mail.gmail.com>
Subject: Re: [PATCH] md: upon assembling the array, consult the superblock of
 the freshest device
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Song,


On Fri, Dec 8, 2023 at 7:28=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> Hi Alex,
>
> On Mon, Dec 4, 2023 at 9:00=E2=80=AFAM Alex Lyakas <alex.lyakas@zadara.co=
m> wrote:
> >
> > From: Alex Lyakas <alex@zadara.com>
> >
> > Upon assembling the array, both kernel and mdadm allow the devices to h=
ave event
> > counter difference of 1, and still consider them as up-to-date.
> > However, a device whose event count is behind by 1, may in fact not be =
up-to-date,
> > and array resync with such a device may cause data corruption.
> > To avoid this, consult the superblock of the freshest device about the =
status
> > of a device, whose event counter is behind by 1.
> >
> > Signed-off-by: Alex Lyakas <alex.lyakas@zadara.com>
>
> You are using two different emails for "From:" and "Signed-off-by", which=
 one
> would you prefer?
>
> Please run ./scripts/checkpatch.pl on the .patch file before sending them=
. It
> would help catch issues like code format and email mismatch
>
> >
> > Disclaimer: I was not able to test this change on one of the latest 6.7=
 kernels.
> > I tested it on kernel 4.14 LTS and then ported the changes.
> >
> > To test this change, I modified the code of remove_and_add_spares():
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index ad68b5e..f57854e 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
>
> This part confuses b4 (patch handling script used by many). It looks like=
 two
> patches bundled together.
>
> > @@ -9341,6 +9341,7 @@ static int remove_and_add_spares(struct mddev *md=
dev,
> >                 }
> >         }
> >  no_add:
> > +       removed =3D 0;
> >         if (removed)
> >                 set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> >         return spares;
> >
> > With this change, when a device fails, the superblock of all other devi=
ces
> > is only updated once. During test, I sumulated a failure of one of the =
devices,
> > and then rebooted the machine. After reboot, I re-assembled the array
> > with all devices, including the device that I failed.
> > Event counter difference between the failed device and the other device=
s
> > was 1, and then with my change the role of the problematic device was t=
aken
> > from the superblock of one of the higher devices, which indicated
> > the role to be MD_DISK_ROLE_FAULTY. After array assembly completed,
> > remove_and_add_spares() ejected the problematic disk from the array,
> > as expected.
> > ---
> >  drivers/md/md.c | 53 +++++++++++++++++++++++++++++++++++++++++++------=
----
> >  1 file changed, 43 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index c94373d..ad68b5e 100644
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
> > @@ -1333,7 +1334,7 @@ static int super_90_load(struct md_rdev *rdev, st=
ruct md_rdev *refdev, int minor
> >  /*
> >   * validate_super for 0.90.0
> >   */
> > -static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev=
)
> > +static int super_90_validate(struct mddev *mddev, struct md_rdev *fres=
hest, struct md_rdev *rdev)
>
> Please add a comment saying we are not using "freshest for 0.9 superblock=
.
>
> >  {
> >         mdp_disk_t *desc;
> >         mdp_super_t *sb =3D page_address(rdev->sb_page);
> > @@ -1845,7 +1846,7 @@ static int super_1_load(struct md_rdev *rdev, str=
uct md_rdev *refdev, int minor_
> >         return ret;
> >  }
> >
> > -static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
> > +static int super_1_validate(struct mddev *mddev, struct md_rdev *fresh=
est, struct md_rdev *rdev)
> >  {
> >         struct mdp_superblock_1 *sb =3D page_address(rdev->sb_page);
> >         __u64 ev1 =3D le64_to_cpu(sb->events);
> > @@ -1941,13 +1942,15 @@ static int super_1_validate(struct mddev *mddev=
, struct md_rdev *rdev)
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
> >                     (le16_to_cpu(sb->dev_roles[rdev->desc_nr]) < MD_DIS=
K_ROLE_MAX ||
> >                      le16_to_cpu(sb->dev_roles[rdev->desc_nr]) =3D=3D M=
D_DISK_ROLE_JOURNAL))
> > -                       if (ev1 < mddev->events)
> > +                       if (ev1 + 1 < mddev->events)
> >                                 return -EINVAL;
> >         } else if (mddev->bitmap) {
> >                 /* If adding to array with a bitmap, then we can accept=
 an
> > @@ -1968,8 +1971,38 @@ static int super_1_validate(struct mddev *mddev,=
 struct md_rdev *rdev)
> >                     rdev->desc_nr >=3D le32_to_cpu(sb->max_dev)) {
> >                         role =3D MD_DISK_ROLE_SPARE;
> >                         rdev->desc_nr =3D -1;
> > -               } else
> > +               } else if (mddev->pers =3D=3D NULL && freshest !=3D NUL=
L && ev1 < mddev->events) {
> > +                       /*
> > +                        * If we are assembling, and our event counter =
is smaller than the
> > +                        * highest event counter, we cannot trust our s=
uperblock about the role.
> > +                        * It could happen that our rdev was marked as =
Faulty, and all other
> > +                        * superblocks were updated with +1 event count=
er.
> > +                        * Then, before the next superblock update, whi=
ch typically happens when
> > +                        * remove_and_add_spares() removes the device f=
rom the array, there was
> > +                        * a crash or reboot.
> > +                        * If we allow current rdev without consulting =
the freshest superblock,
> > +                        * we could cause data corruption.
> > +                        * Note that in this case our event counter is =
smaller by 1 than the
> > +                        * highest, otherwise, this rdev would not be a=
llowed into array;
> > +                        * both kernel and mdadm allow event counter di=
fference of 1.
> > +                        */
> > +                       struct mdp_superblock_1 *freshest_sb =3D page_a=
ddress(freshest->sb_page);
> > +                       u32 freshest_max_dev =3D le32_to_cpu(freshest_s=
b->max_dev);
> > +
> > +                       if (rdev->desc_nr >=3D freshest_max_dev) {
> > +                               /* this is unexpected, better not proce=
ed */
> > +                               pr_warn("md: %s: rdev[%pg]: desc_nr(%d)=
 >=3D freshest(%pg)->sb->max_dev(%u)\n",
> > +                                               mdname(mddev), rdev->bd=
ev, rdev->desc_nr, freshest->bdev,
>
> There is probably some format issue here. checkpatch.pl should also
> warn about it.
>
> Please address the feedback and send v2 of the patch.

Thank you for the comments. I addressed them and sent out a v2.

Thanks,
Alex.

>
> Thanks,
> Song
>
>
> > +                                               freshest_max_dev);
> > +                               return -EUCLEAN;
> > +                       }
> > +
> > +                       role =3D le16_to_cpu(freshest_sb->dev_roles[rde=
v->desc_nr]);
> > +                       pr_debug("md: %s: rdev[%pg]: role=3D%d(0x%x) ac=
cording to freshest %pg\n",
> > +                                    mdname(mddev), rdev->bdev, role, r=
ole, freshest->bdev);
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
> >                                 pr_warn("md: kicking non-fresh %pg from=
 array!\n",
> >                                         rdev->bdev);
> >                                 md_kick_rdev_from_array(rdev);
> > @@ -6836,7 +6869,7 @@ int md_add_new_disk(struct mddev *mddev, struct m=
du_disk_info_s *info)
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
> >
