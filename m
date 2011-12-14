From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5: failing an active component during spare rebuild -
 arrays hangs
Date: Wed, 14 Dec 2011 22:32:40 +1100
Message-ID: <20111214223240.01045828@notabene.brown>
References: <BANLkTikkeoCsr3-UBSPEDrYwh4jGSn=MaA@mail.gmail.com>
	<BANLkTinwr9UE_B+MSXfbE2nAv0wLrTvhXg@mail.gmail.com>
	<20110622125409.14428883@notabene.brown>
	<BANLkTinijekK8Y6TTk6TYtYhv4Dn2YGQbA@mail.gmail.com>
	<20110628122921.42480f72@notabene.brown>
	<CAGRgLy5uK5As96j2Tprfrx+qNhYqvFiVUEnOJ+3AAwpPMHCDYg@mail.gmail.com>
	<CAGRgLy5huVzdA8q6V887Ay384kJ4ywgst6dEGgYuRg9+SxHB0A@mail.gmail.com>
	<20110831124646.21be9e25@notabene.brown>
	<CAGRgLy62uavK+9qosizaOey1Utz6STC+2fvOVqEbmi0HZbrQtw@mail.gmail.com>
	<20111206141608.0cca224a@notabene.brown>
	<CAGRgLy6++0C5xJAP4B6rY1Gs-Ht-EdcbS04VEdANfq83eXKGsg@mail.gmail.com>
	<20111207082103.0f86b3d6@notabene.brown>
	<CAGRgLy7fs5AUGk1a+Cp36VgqRvP23fYWx_GM9yViJM6YmmMdSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2aP_Hvjg+eq1uzfgJIAzH7q"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy7fs5AUGk1a+Cp36VgqRvP23fYWx_GM9yViJM6YmmMdSw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, tim.gardner@canonical.com, gregkh@suse.de
List-Id: linux-raid.ids

--Sig_/2aP_Hvjg+eq1uzfgJIAzH7q
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Dec 2011 12:27:43 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello Neil,
> we are looking at Ubuntu-oneiric kernel 3.0.0-14.23.
> We see that this fix was delivered to it by the following commit:
> ---------------------------------
> commit 5669de653e363cfaf2a2c7c48ea224a730f5a7a9
> Author: NeilBrown <neilb@suse.de>
> Date:   Wed Oct 26 10:31:04 2011 +1100
>=20
>     md/raid5: fix bug that could result in reads from a failed device.
>=20
>     BugLink: http://bugs.launchpad.net/bugs/890952
>=20
>     commit 355840e7a7e56bb2834fd3b0da64da5465f8aeaa upstream.
> ------------------------------------
> However, when looking at the diff, we see that only handle_stripe6()
> function was fixed and not handle_stripe5(). That also explains why we
> saw this issue on oneiric with raid5. Here is the diff:
> ----------------------------------------------------------
> alex@ubuntu-alyakas-srv:/mnt/share/src/ubuntu-oneiric$ git diff
> ccfe5df60a583cbad36969344679903585e2eac7
> 5669de653e363cfaf2a2c7c48ea224a730f5a7a9
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 2581ba1..e509147 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3369,7 +3369,7 @@ static void handle_stripe6(struct stripe_head *sh)
>                         /* Not in-sync */;
>                 else if (test_bit(In_sync, &rdev->flags))
>                         set_bit(R5_Insync, &dev->flags);
> -               else {
> +               else if (!test_bit(Faulty, &rdev->flags)) {
>                         /* in sync if before recovery_offset */
>                         if (sh->sector + STRIPE_SECTORS <=3D
> rdev->recovery_offset)
>                                 set_bit(R5_Insync, &dev->flags);
> -----------------------------------------------
>=20
> What is the reason the fix for raid5 was not applied there? Should we
> apply the same fix for raid5 as well manually?
> Copying also other two persons signed on the commit.

Yes, I stuffed up when I back-ported the patch for -stable and missed the
RAID5 bit I've been meaning to send and update to stable but haven't yet.
Will do it in the morning - thanks for the reminder.

NeilBrown


>=20
> Thanks,
>   Alex.
>=20
>=20
> On Tue, Dec 6, 2011 at 11:21 PM, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 6 Dec 2011 23:07:53 +0200 Alexander Lyakas <alex.bolshoy@gmail.=
com>
> > wrote:
> >
> >> Thanks, Neil!!!
> >> Looks like this patch solves the issue. I applied it manually though,
> >> for some reason git refused to apply it.
> >>
> >> Thanks again for great help,
> >> =C2=A0 Alex.
> >
> > Great. =C2=A0Thanks for the confirmation.
> >
> > NeilBrown
> >
> >
> >>
> >>
> >> On Tue, Dec 6, 2011 at 5:16 AM, NeilBrown <neilb@suse.de> wrote:
> >> > On Sun, 27 Nov 2011 11:56:17 +0200 Alexander Lyakas <alex.bolshoy@gm=
ail.com>
> >> > wrote:
> >> >
> >> >> Hello Neil,
> >> >> we have compiled the natty kernel with dynamic debugging enabled for
> >> >> raid456, and reproduced the problem.
> >> >> The kernel log is available at
> >> >> https://docs.google.com/open?id=3D0B9rmyUifdvMLMzk1YjYwZDUtYzhhYi00=
MDRlLTkzYjItMDM0Y2ZhZmU3ZDRk
> >> >>
> >> >> Some more information:
> >> >> - array was created at Nov 27 11:28:03
> >> >> - manual drive failure was issued at 11:28:09
> >> >>
> >> >> Please let me know if you need any additional information.
> >> >>
> >> >
> >> > Hi,
> >> > =C2=A0sorry for the long delay, I've had a lot of distractions this =
past week.
> >> >
> >> > I looks like you are hitting the bug fixed by upstream commit
> >> > =C2=A0 =C2=A0355840e7a7e56bb2834fd3b0da64da5465f8aeaa
> >> >
> >> > The symptoms are slightly different to those described in that commi=
t but I'm
> >> > sure the root problem is the same.
> >> >
> >> > That patch doesn't apply to 2.6.38 though.
> >> > Use this one.
> >> >
> >> > NeilBrown
> >> >
> >> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> > index 78536fd..8144126 100644
> >> > --- a/drivers/md/raid5.c
> >> > +++ b/drivers/md/raid5.c
> >> > @@ -3086,7 +3086,7 @@ static void handle_stripe5(struct stripe_head =
*sh)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0/* Not in-sync */;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else if (test=
_bit(In_sync, &rdev->flags))
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0set_bit(R5_Insync, &dev->flags);
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (!test_bi=
t(Faulty, &rdev->flags)) {
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0/* could be in-sync depending on recovery/reshape status */
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0if (sh->sector + STRIPE_SECTORS <=3D rdev->recovery_offset)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0set_bit(R5_Insync, &dev->flags=
);
> >> > @@ -3377,7 +3377,7 @@ static void handle_stripe6(struct stripe_head =
*sh)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0/* Not in-sync */;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else if (test=
_bit(In_sync, &rdev->flags))
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0set_bit(R5_Insync, &dev->flags);
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (!test_bi=
t(Faulty, &rdev->flags)) {
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0/* in sync if before recovery_offset */
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0if (sh->sector + STRIPE_SECTORS <=3D rdev->recovery_offset)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0set_bit(R5_Insync, &dev->flags=
);
> >


--Sig_/2aP_Hvjg+eq1uzfgJIAzH7q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuiJWTnsnt1WYoG5AQL8IQ//S1oxbmJpuRc9+ae/rNqZgqmoS7vMeVbD
vBRYEx3sg5fQPg9zcoYBDcbkQvp1f6XDJPaL/RYKdZMTFbBDkQnMPZoEvQvCqdbA
7P47sNB215d3boTrl9r0IPp1/wb89zaq/hSOgfrzP/NwVcrmRR3QKxS05qwxJj0X
l4S+RMBaoVw7A/aEHDTC8X7Kuwd+jZI3udkirUJ4wpHsfvITyMxpY2Q6oRLHEzxj
kcy8Sgx+k5BOpKaXnxdllJClw4bIuZ3hdgTJGHSm8MKVj7NKqbZRP0U/xBJBSz6d
hkEn1Nc7rYjpFv+t7mhq4GB4/muGXAq+rHtKO8/iuYKMkkawG99wxpwYO81xaT/r
gjIAnPflPnj1WUfbBMtYSo3SdKK1Wk3a0Kp9FIh/ZS9ibMEz0iY6l/nt/REAmCT9
JVadZIyP9wrcvUJabe/bhofwWh++/foGpoyIQHa1BwmJ0QhpqeeLMBm/nVLW8msX
zhyQIg+5RU6k7/jzv43/QpvzRPhl5N9cMx2Z9pqs3EWr+hF0+MgFY2qKRSC65Oz8
uVD5SrVuglTsjcwp8TmeExri7EN68z/+3sLq1WiPg35ygfnD01sWIOPaT7MDh7Bj
BVGQEe33JPEUO43co2Ou+gtnZpTum5z+ozPOV0YauhAA+7EUYoFhqq/sJaAVoqzx
BUBMnbGuVZQ=
=h4Ga
-----END PGP SIGNATURE-----

--Sig_/2aP_Hvjg+eq1uzfgJIAzH7q--
