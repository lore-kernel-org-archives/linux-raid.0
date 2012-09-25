From: NeilBrown <neilb@suse.de>
Subject: Re: md: raid5 resync corrects read errors on data block - is this
 correct?
Date: Tue, 25 Sep 2012 16:57:02 +1000
Message-ID: <20120925165702.0d7afcd7@notabene.brown>
References: <CAGRgLy6Cqxyf2im+tG2JiaQFooLBBzT76hGpfTb47Cr_sFLr6g@mail.gmail.com>
	<20120912082909.33c8eec0@notabene.brown>
	<CAGRgLy6Syso2dfELFhpK9nCyEgvuD6k3F=MRJBnrVU=btKqKVw@mail.gmail.com>
	<20120913101924.13431e6e@notabene.brown>
	<CAGRgLy7VRTeegGXbxhzn4zrCt6agoQqLaOT5mM7=vSkq6XDN5A@mail.gmail.com>
	<CAGRgLy4bbfuK0zF8kkP2at+2kZz8CYrFy+EgTDFPMjPc+edUgg@mail.gmail.com>
	<CAGRgLy6wNUNWjOb8-5p2Wbag9R260AL++KU8xe-JTzgSoSqwpA@mail.gmail.com>
	<20120919155917.3d67f890@notabene.brown>
	<CAGRgLy6EsYj90f4UqPt9=p_qumWLq2vCCYwa-YL97P=k6R58HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m9voX7NYRP8aCPso_+M8eiz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6EsYj90f4UqPt9=p_qumWLq2vCCYwa-YL97P=k6R58HQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/m9voX7NYRP8aCPso_+M8eiz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Sep 2012 11:26:50 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> you are completely right. I got confused between mddev->recovery_cp
> and sb->resync_offset; the latter may become 0 due to in-flight WRITEs
> and not due to resync. Looking at the code again, I see that
> recovery_cp is totally one-way from sb->resync_offset to MaxSector
> (except for explicit loading via sysfs). Also recovery_cp is not
> relevant to "check" and "repair". So recovery_cp is pretty simple
> after all.
>=20
> Below is V2 patch. (I have also to credit it to somebody else, because
> he was the one that said - just do rcw while you are resyncing).
>=20
> Thanks,
> Alex.
>=20
>=20
> -----------------
> >From cc3e2bfcf2fd2c69180577949425d69de88706bb Mon Sep 17 00:00:00 2001
> From: Alex Lyakas <alex@zadarastorage.com>
> Date: Thu, 13 Sep 2012 18:55:00 +0300
> Subject: [PATCH] When RAID5 is dirty, force reconstruct-write instead of
>  read-modify-write.
>=20
> Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
> Signed-off-by: Yair Hershko <yair@zadarastorage.com>

Signed-off-by has a very specific meaning - it isn't just a way of giving
recredit.
If Yair wrote some of the code, this is fine.
If not, then something like "Suggest-by:" might be more appropriate.
Should I change it to that.

applied, thanks.

NeilBrown


>=20
> diff --git a/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
> b/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
> index 5332202..9fdd5e3 100644
> --- a/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
> +++ b/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
> @@ -2555,12 +2555,24 @@ static void handle_stripe_dirtying(struct r5conf =
*conf,
>                                    int disks)
>  {
>         int rmw =3D 0, rcw =3D 0, i;
> -       if (conf->max_degraded =3D=3D 2) {
> -               /* RAID6 requires 'rcw' in current implementation
> -                * Calculate the real rcw later - for now fake it
> +       sector_t recovery_cp =3D conf->mddev->recovery_cp;
> +
> +       /* RAID6 requires 'rcw' in current implementation.
> +        * Otherwise, check whether resync is now happening or should sta=
rt.
> +        * If yes, then the array is dirty (after unclean shutdown or
> +        * initial creation), so parity in some stripes might be inconsis=
tent.
> +        * In this case, we need to always do reconstruct-write, to ensure
> +        * that in case of drive failure or read-error correction, we
> +        * generate correct data from the parity.
> +        */
> +       if (conf->max_degraded =3D=3D 2 ||
> +           (recovery_cp < MaxSector && sh->sector >=3D recovery_cp)) {
> +               /* Calculate the real rcw later - for now make it
>                  * look like rcw is cheaper
>                  */
>                 rcw =3D 1; rmw =3D 2;
> +               pr_debug("force RCW max_degraded=3D%u, recovery_cp=3D%lu
> sh->sector=3D%lu\n",
> +                        conf->max_degraded, recovery_cp, sh->sector);
>         } else for (i =3D disks; i--; ) {
>                 /* would I have to read this buffer for read_modify_write=
 */
>                 struct r5dev *dev =3D &sh->dev[i];
>=20
>=20
>=20
>=20
>=20
>=20
> On Wed, Sep 19, 2012 at 8:59 AM, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 17 Sep 2012 14:15:16 +0300 Alexander Lyakas <alex.bolshoy@gmail=
.com>
> > wrote:
> >
> >> Hi Neil,
> >> below is a bit less-ugly version of the patch.
> >> Thanks,
> >> Alex.
> >>
> >> >From 05cf800d623bf558c99d542cf8bf083c85b7e5d5 Mon Sep 17 00:00:00 2001
> >> From: Alex Lyakas <alex@zadarastorage.com>
> >> Date: Thu, 13 Sep 2012 18:55:00 +0300
> >> Subject: [PATCH] When RAID5 is dirty, force reconstruct-write instead =
of
> >>  read-modify-write.
> >>
> >> Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
> >> Signed-off-by: Yair Hershko <yair@zadarastorage.com>
> >>
> >> diff --git a/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
> >> b/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
> >> index 5332202..0702785 100644
> >> --- a/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
> >> +++ b/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
> >> @@ -2555,12 +2555,36 @@ static void handle_stripe_dirtying(struct r5co=
nf *conf,
> >>                                    int disks)
> >>  {
> >>         int rmw =3D 0, rcw =3D 0, i;
> >> -       if (conf->max_degraded =3D=3D 2) {
> >> -               /* RAID6 requires 'rcw' in current implementation
> >> -                * Calculate the real rcw later - for now fake it
> >> +       sector_t recovery_cp =3D conf->mddev->recovery_cp;
> >> +       unsigned long recovery =3D conf->mddev->recovery;
> >> +       int needed =3D test_bit(MD_RECOVERY_NEEDED, &recovery);
> >> +       int resyncing =3D test_bit(MD_RECOVERY_SYNC, &recovery) &&
> >> +                       !test_bit(MD_RECOVERY_REQUESTED, &recovery) &&
> >> +                       !test_bit(MD_RECOVERY_CHECK, &recovery);
> >> +       int transitional =3D test_bit(MD_RECOVERY_RUNNING, &recovery) =
&&
> >> +                          !test_bit(MD_RECOVERY_SYNC, &recovery) &&
> >> +                          !test_bit(MD_RECOVERY_RECOVER, &recovery) &&
> >> +                          !test_bit(MD_RECOVERY_DONE, &recovery) &&
> >> +                          !test_bit(MD_RECOVERY_RESHAPE, &recovery);
> >
> > Thanks Alex,
> >  however I don't understand why you want to test all of these bits.
> > Isn't it enough just to check ->recovery_cp ??
> >
> >> +
> >> +       /* RAID6 requires 'rcw' in current implementation.
> >> +        * Otherwise, attempt to check whether resync is now happening
> >> +        * or should start.
> >> +         * If yes, then the array is dirty (after unclean shutdown or
> >> +         * initial creation), so parity in some stripes might be inco=
nsistent.
> >> +         * In this case, we need to always do reconstruct-write, to e=
nsure
> >> +         * that in case of drive failure or read-error correction, we
> >> +         * generate correct data from the parity.
> >> +         */
> >> +       if (conf->max_degraded =3D=3D 2 ||
> >> +           (recovery_cp < MaxSector && sh->sector >=3D recovery_cp &&
> >> +            (needed || resyncing || transitional))) {
> >> +               /* Calculate the real rcw later - for now fake it
> >>                  * look like rcw is cheaper
> >
> > Also, we should probably fix this comment.  s/fake/make/
> >
> > Thanks,
> > NeilBrown
> >
> >
> >
> >>                  */
> >>                 rcw =3D 1; rmw =3D 2;
> >> +               pr_debug("force RCW max_degraded=3D%u, recovery_cp=3D%=
lu
> >> sh->sector=3D%lu recovery=3D0x%lx\n",
> >> +                        conf->max_degraded, recovery_cp, sh->sector, =
recovery);
> >>         } else for (i =3D disks; i--; ) {
> >>                 /* would I have to read this buffer for read_modify_wr=
ite */
> >>                 struct r5dev *dev =3D &sh->dev[i];
> >


--Sig_/m9voX7NYRP8aCPso_+M8eiz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGFVvjnsnt1WYoG5AQKgGQ/+KbCplLOaUHzerZthl2FuIxbRIxXZTN0H
ylSpZrPa3Cpte4AionVIQBrpdKNyRewRVSPvI0ELBaNHqa9RvX8EDMg7ceSp5Y1f
NCdKR3M7A1Wf1Esp3w/gVln6rIveO4vR/LoNOkCOcRJMELgNhg7Bu/ziBn2EnI+o
Sh6IJe6GEKjU5MrAey5m7rwOl41K096hkDgxQDpC0LQMesL0YjBzTp5QtpS1SSds
Ii75a6ZfZP/OWII0A8H58sHIYQkpybIURNS7EQC5PeKOJw6zLg1trlGoFhVVOE+j
6uQXjDZt1B3rIkSMrxKrlfl7QEJ9eX7lcdFs8mqhNt6lczxjgRENql07CQ6k0ZRE
V5HkJqwxvfeM9IutXR80SKAEGUiS9lIriGAVCi1dNh0xk2xqcqQ0GZMU3WDv/qPk
1ufU1xBdvC6QLvJ95uOW1Mjm9y2M2QBpng5gCXkgN8N8A4w5PDezJ0qDnSt6N2JN
L27R1fzhne6R7YA2gkJET2byi42uau6996cOwCTavhE/uN61vzFHSYVk45in0hwK
gPlsTbCWbazP7ljVeD1GUeXAdFNVwYdL2LKqvxDpUo9mVsZJn/xKiU9R42E3mD8k
Y1JlH63G0D/5ryYKupYD018MZ0hj8arFG2PYgx8SNMWWA0AyL+jJXt4zEBgaSAg7
uwMwjfyuS30=
=86SA
-----END PGP SIGNATURE-----

--Sig_/m9voX7NYRP8aCPso_+M8eiz--
