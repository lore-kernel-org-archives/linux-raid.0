From: NeilBrown <neilb@suse.de>
Subject: Re: md raid6 deadlock on write
Date: Mon, 9 Jul 2012 13:46:53 +1000
Message-ID: <20120709134653.332102fd@notabene.brown>
References: <20120629194600.GA23859@calhariz.com>
	<20120702221508.GA24801@calhariz.com>
	<20120704113811.180be107@notabene.brown>
	<20120704102411.GG15287@calhariz.com>
	<20120706135524.GI15287@calhariz.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hr8yd7Be0/Y9bZz_R3x01N3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120706135524.GI15287@calhariz.com>
Sender: linux-raid-owner@vger.kernel.org
To: jose.spam@netvisao.pt
Cc: jose.calhariz@netvisao.pt, linux-raid@vger.kernel.org, ns-list@dsi.ist.utl.pt
List-Id: linux-raid.ids

--Sig_/hr8yd7Be0/Y9bZz_R3x01N3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Jul 2012 14:55:24 +0100 Jose Manuel dos Santos Calhariz
<jose.calhariz@netvisao.pt> wrote:

> On Wed, Jul 04, 2012 at 11:24:11AM +0100, Jose Manuel dos Santos Calhariz=
 wrote:
> > On Wed, Jul 04, 2012 at 11:38:11AM +1000, NeilBrown wrote:
> > > On Mon, 2 Jul 2012 23:15:08 +0100 Jose Manuel dos Santos Calhariz
> > > <jose.calhariz@netvisao.pt> wrote:
> > >=20
> > > >=20
> > > > We have a group of servers with a LVM over a RAID6 of 16 drives.
> > > > During normal work loads, sometimes, the md raid enter on deadlock =
for
> > > > writes and only a power off/power on allows to recover the machine.
> > >=20
> > > This might be fixed by the following commit which was recently includ=
ed in
> > > 3.5-rc. If could test with that I'd appreciate it.
> >=20
> > We will do it, at first opportunity.
>=20
> We have two machines that are running fio for 24 hours without
> problems.  So the bug seams to be fixed, thank you.

Thanks for testing and reported.


>=20
> Any possibility of the fix being ported to kernel 3.2?

It seems that I didn't tag that patch for -stable so it won't automatically
get included.  I'll send it the old way - maybe it'll get into 3.2.23.

Thanks,
NeilBrown


--Sig_/hr8yd7Be0/Y9bZz_R3x01N3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/pULTnsnt1WYoG5AQKdwQ/+Pu1dpxovCtU3HMXyx7qyFilLFjUFTDGY
NLLppOJ2I7jI/RBEIuD8wI+NfDlWItZKgXKUio4ZEPdeymaqLYlvfgmnmN1+g6qr
+ii96M3ntX+p7VVhe1A/CaAqiJ2Qw1Y2WUQup0DZn5UTFa8ASiqdSBIQYTlplzzk
eVOibzjJoweIq5VpwyOzVFIZBidjNXHkIH9AK+mw3FW1dHctD5d5caklFmFe6sTn
Q4KCAD6n1v0BUpE88d+BIQqU7bqRgfncXL986MHwkyj2YXxECK3yzUD+ax/zi+9x
XFir4hKTE+RFCQYFLtt+BWPgh5N72llnKxyN37nQijhSDE0AHVaGcT6v4fxzdcOB
oFk5+Nb2KEbHEfw/qFv+yZtwzFPJsJChh+qRdfApsmO6oUDeQkyS88xyciwbiCC/
wypxwZcp1tBsNDFwGtEgLQVsB85K5PAOr4xlrMdpLpu3/b0v+1tikxPJA14IXsA1
abW196PDoqrCTNmO9QCpCKVE3KxNsySb54nyDuEJgTYrnhH+z+edOZPr2orr9qj2
bOgElrHiw0IT7o/z7TGOuipSWA79BtEeC+EXLQh66JBE0hYX1w1ZiXuvQnXJkAjv
m9uWNpp1Gbh1MxuMIZxAQ5SFCX4MsaagneWGysJRGeIo5oer+ZCGpcCrcjMXZplQ
DdBD9zsviF0=
=KiZU
-----END PGP SIGNATURE-----

--Sig_/hr8yd7Be0/Y9bZz_R3x01N3--
