From: NeilBrown <neilb@suse.de>
Subject: Re: Is it safe to shutdown while mdadm --grow is in progress.
Date: Mon, 13 Oct 2014 09:15:28 +1100
Message-ID: <20141013091528.219789fb@notabene.brown>
References: <543A15A6.5010508@gmail.com>
	<20141012193555.69907c13@notabene.brown>
	<543AA5B6.6010200@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Ji/_9q3ODG.LaAxs0XvupmX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <543AA5B6.6010200@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Ji/_9q3ODG.LaAxs0XvupmX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Oct 2014 11:00:54 -0500 Ram Ramesh <rramesh2400@gmail.com> wrote:

> Thanks. I appreciate you taking the time to respond. I would like to=20
> forward this to those that maintain faq/wiki so that some one searches=20
> gets the info and does not have to bother you. Is that OK?

Sure - anything on a public mailing list is public.

>=20
> I normally would go for backup before rebuild, but 15TB disk space is=20
> too much to come up with, without serious $$ and need. Besides, these=20
> are movies/recordings for htpc and the data is available on=20
> dvds/internet. So there is inherent lack of importance. In other words,=20
> I recommend backup as most do, but it looks like every one has some=20
> justification not to do, and want some one else to assure them that it=20
> is ok :-)

Quite understandable...

NeilBrown

>=20
> Thanks and Regards
> Ramesh
>=20
> On 10/12/2014 03:35 AM, NeilBrown wrote:
> > On Sun, 12 Oct 2014 00:46:14 -0500 Ram Ramesh <rramesh2400@gmail.com> w=
rote:
> >
> >> I googled this topic and got differing answers. Some old ones report
> >> horror stories and others suggest rebuild continues after reboot
> >> normally. My array is rebuilding and it will take about 6 days to
> >> complete. I am expecting bad weather in a couple of days and would like
> >> to proactively shutdown the machine and reboot. Is this safe?
> >>
> >> If the information is already available in a clear manner, please let =
me
> >> know.
> >>
> >> uname: Linux xxx 3.13.0-37-generic #64-Ubuntu SMP Mon Sep 22 21:28:38
> >> UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
> >> mdadm - v3.2.5 - 18th May 2012
> >>
> >> Thanks for your help
> >>
> > It is certainly designed to be safe and my experience is that it is.
> > However it is difficult to test all corner cases so it is not impossibl=
e that
> > someone what quite work right.
> > If something does go wrong:
> >   1/ don't panic
> >   2/ don't try to --create the array to fix it
> >   3/ report all details to this list and I'm 99.9% sure I can get your =
array
> >      running again with all your data safe.
> > But I suspect it won't come to that.
> >
> > NeilBrown


--Sig_/Ji/_9q3ODG.LaAxs0XvupmX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDr9gDnsnt1WYoG5AQJs1Q//R661kBybdkWjhWNBNn9g4WeAXt74qOW6
HO1VdxHzv5DpaZ1WlHctFqlLQ9DVvWo6/yPsXUrVac8cQMByV4IQCnFGYa5ksC3w
gl8i0Um/FJ0BORYO25qXgXiDI+j1hUT4FfTuZ/hv1//1qxY7cLHoIB9Tus1Z5u2M
mBslq2dAPfZbWu/SKxR6oQi/kjE97QCk3Y2N4qWsJynks8aFpz165ObPPWzWdz7Z
sUOt4bzjEgLVMm1kd44a7U80N8v8dDKTq9VoyOItZWTQOCoafeDzEMXDHYq5erXX
JkPhFDtnncmi66S0FD3q1cPEWiWGV045A5w/3ksh0ACQ1UZDX3dF9i6KsoY/3Xvt
ZB7lSQxGJW82GENlN/QgAsrkbzhT+W/eLcV8c+mSk3tAP+Y3sn1Qw4wy08Z01UDB
TFY1KB2HJ45y1I3qTQXCI5HyA+fhqEKBw5n8LIDSGrTBS683gzLeMw6JXVI02ETC
nuu0+XeQ3nGU/gzR6BMgLWyP/tWebn5Wa+8pPfET396bSfwnCWa4l8o7um+4WGy6
mTZRWNeKKsLXZsK2cVW+YtRcvspbw9GM3gCuqMkKtoizpPXSBsYP9DjE1GqnoENP
PVqiOqvBgM2/KVfbNIUhK9L9aG6gVa4NZPnSx/7LAj3o04y6eUMZBbvX4wj75FKF
7NiVrGMPXQU=
=HTBX
-----END PGP SIGNATURE-----

--Sig_/Ji/_9q3ODG.LaAxs0XvupmX--
