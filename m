From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5: failing an active component during spare rebuild -
 arrays hangs
Date: Wed, 7 Dec 2011 08:21:03 +1100
Message-ID: <20111207082103.0f86b3d6@notabene.brown>
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
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0hcQVmwaZ+_AkF+FdfODV_r"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6++0C5xJAP4B6rY1Gs-Ht-EdcbS04VEdANfq83eXKGsg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0hcQVmwaZ+_AkF+FdfODV_r
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Dec 2011 23:07:53 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Thanks, Neil!!!
> Looks like this patch solves the issue. I applied it manually though,
> for some reason git refused to apply it.
>=20
> Thanks again for great help,
>   Alex.

Great.  Thanks for the confirmation.

NeilBrown


>=20
>=20
> On Tue, Dec 6, 2011 at 5:16 AM, NeilBrown <neilb@suse.de> wrote:
> > On Sun, 27 Nov 2011 11:56:17 +0200 Alexander Lyakas <alex.bolshoy@gmail=
.com>
> > wrote:
> >
> >> Hello Neil,
> >> we have compiled the natty kernel with dynamic debugging enabled for
> >> raid456, and reproduced the problem.
> >> The kernel log is available at
> >> https://docs.google.com/open?id=3D0B9rmyUifdvMLMzk1YjYwZDUtYzhhYi00MDR=
lLTkzYjItMDM0Y2ZhZmU3ZDRk
> >>
> >> Some more information:
> >> - array was created at Nov 27 11:28:03
> >> - manual drive failure was issued at 11:28:09
> >>
> >> Please let me know if you need any additional information.
> >>
> >
> > Hi,
> > =A0sorry for the long delay, I've had a lot of distractions this past w=
eek.
> >
> > I looks like you are hitting the bug fixed by upstream commit
> > =A0 =A0355840e7a7e56bb2834fd3b0da64da5465f8aeaa
> >
> > The symptoms are slightly different to those described in that commit b=
ut I'm
> > sure the root problem is the same.
> >
> > That patch doesn't apply to 2.6.38 though.
> > Use this one.
> >
> > NeilBrown
> >
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 78536fd..8144126 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -3086,7 +3086,7 @@ static void handle_stripe5(struct stripe_head *sh)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Not in-sync */;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (test_bit(In_sync, &rdev->flags))
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_bit(R5_Insync, &dev-=
>flags);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (!test_bit(Faulty, &rdev->flags))=
 {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* could be in-sync depe=
nding on recovery/reshape status */
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (sh->sector + STRIPE_=
SECTORS <=3D rdev->recovery_offset)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_bit(=
R5_Insync, &dev->flags);
> > @@ -3377,7 +3377,7 @@ static void handle_stripe6(struct stripe_head *sh)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Not in-sync */;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (test_bit(In_sync, &rdev->flags))
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_bit(R5_Insync, &dev-=
>flags);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (!test_bit(Faulty, &rdev->flags))=
 {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* in sync if before rec=
overy_offset */
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (sh->sector + STRIPE_=
SECTORS <=3D rdev->recovery_offset)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_bit(=
R5_Insync, &dev->flags);


--Sig_/0hcQVmwaZ+_AkF+FdfODV_r
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt6HPznsnt1WYoG5AQJi2A//d2/am2K7Gr+oTm3hTHsNmWRGXQR7tpS5
aXVkrQBrdfYuhB7Ialy8GZASD28wLhF5wQwST1ydVHXFg15crRGDWP2jpVKFTCD3
vOwezFs49jFpun7VfSiFuXn+9Yjdz8JAO40oDymEA+/1YcOo7zqNInEzJefnldlW
5inoiL/rxNQD5e0O0SnDRli6qoJWvR/48NmFaEXbsmoXcpGd2+Vz3l1FzIP1gFiy
QkkRrg1OVf/QfZcHrGr3yiFRvODxy0YIYGMtbk2OYAG5Fn9L0jYxkotxx0rrFKTB
gj3IagzWSwh7L/crhPlkHAZoWIdpdUGrCvYmOvXqeAOcGHyJQG/5HKpTRlcYfOqL
EYRWU+u9u6vJ0YNJYupuvjQ0WSyiYt5+cX46yjAUvPasB7DXbLi6fd6qd4X7TGp+
G6oXnASpgiTuYb1FJPyjffCikS45V/xHfdcUC1/vhscrPXqhp2hpBZtE2AkGCkj/
l8RyjfL5bIwlpsbMqPKTkAUxxFxwmtrR8r5mp+iFJcyzluj+kZuKYBgfMHzbaoXP
Kr1AEcUVBes8mmX9GiJH+fCh/OdeUibXRSXZNlsLmeBbT7zs32tb8k6/3+oBLGJI
0P/n8iJQBTtm3rI+O/UUl1BKF2hYhEMwbvO2XfpJzusHtnxamCXkkvcTJblLSqLM
BchDONYYj5U=
=LGRG
-----END PGP SIGNATURE-----

--Sig_/0hcQVmwaZ+_AkF+FdfODV_r--
