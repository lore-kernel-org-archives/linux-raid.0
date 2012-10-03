From: NeilBrown <neilb@suse.de>
Subject: Re: MD RAID Bug 7/15/12
Date: Wed, 3 Oct 2012 11:54:17 +1000
Message-ID: <20121003115417.52cfd598@notabene.brown>
References: <022FFCA9-5D0E-41DB-9617-202C6FAADD06@rightthisminute.com>
	<20121001130242.745b7ca3@notabene.brown>
	<42BA87F6-C5A3-4321-A4C7-0DCF0A9DF79D@rightthisminute.com>
	<20121002114920.1029bed7@notabene.brown>
	<0B674309-5CBC-4C36-983F-AB75D9C2BDDB@rightthisminute.com>
	<20121002150740.717a9448@notabene.brown>
	<2599ECDD-7B9E-4272-BAFC-E4A04880D12E@rightthisminute.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yBpgteF=fBMExyi8+nKxyAv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2599ECDD-7B9E-4272-BAFC-E4A04880D12E@rightthisminute.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Munoz <mark.munoz@rightthisminute.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/yBpgteF=fBMExyi8+nKxyAv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Oct 2012 15:53:34 -0700 Mark Munoz <mark.munoz@rightthisminute.co=
m>
wrote:

> Neil,
>=20
> I just wanted to send you a HUGE thank you.  We got back all of our data =
and are very pleased!  Do you guys have some sort of donation fund or somet=
hing that we can send something to your team to show our appreciation?

Thanks for the offer, but no: there is nothing like that.

NeilBrown



>=20
> Mark
>=20
> On Oct 1, 2012, at 10:07 PM, NeilBrown <neilb@suse.de> wrote:
>=20
> > On Mon, 1 Oct 2012 19:33:50 -0700 Mark Munoz <mark.munoz@rightthisminut=
e.com>
> > wrote:
> >=20
> >=20
> >> So I am now thinking that during my shutdown this weekend the device /=
dev/md0 as part of the array /dev/md2 was affected by the bug as well as 18=
 of the 19 devices contained inside of /devm/md1
> >=20
> > Yes, I agree, so:
> >=20
> >>>>=20
> >>>> sudo mdadm --create --assume-clean /dev/md2 --level=3D0 --chunk=3D64=
 --metadata=3D1.2 --raid-devices=3D2 /dev/md0 /dev/md1
> >=20
> > This is the correct thing to do.
> >=20
> > NeilBrown
> >=20
> >=20


--Sig_/yBpgteF=fBMExyi8+nKxyAv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGuayjnsnt1WYoG5AQKtSQ/9HW8L6tbGUejDYC2qc8snaSvvPlOWXSAn
co/U/enS25lyLPwE0ZfZKjDyHboYRO8MDsXHff1CYryJLRWo5SA84K0/exnFL8Mi
GIVuDIa2rYErjCYz2KX+Itnzazl9OtQDRG35urSE1VKs+8Yjx/kHzA7dkBDg6fFs
Pk9x/JqF2d7PM297pbXurMqQgAcSUZQWIsDdz38pjZWOWK3W3UemM9V9UsT68Uuz
M9JMF6SziTEzWImnJOmOx97DVL+joPaSPmm9kX05NNJHnHXxGoDmpzTLueA3GgHZ
URRarr7bw6revgLfS9ooAJj+KSkhOebOh407JGA5rRv6YaDFY0ZEbsq5s+78IN6+
8xFMaLanw4kiWg0sowYVafQ1cjoEibIvWW0NrOk/S6hGB7qCLAUXmft5ZukmMAWf
h5vRPwaBcfpVfkGwE7v0YODvPIn3fY1DiTCryVpmQ5Y8HDWyDdSkDdRfkElLq/kE
SyssFEheLbxNk0gf28YA8Y+KXb66oBL1DauNrzJL45hnYgBU88W9ar31pfVflPZs
ZOHcJuSoL2R8i9fQ/x6Su6aggLBOZgllFCFZ53k9y3SnA6VPWoPq5/B9zIUzsbQZ
rnw3WlRBX44nkrYjCqS50NlQj/IkgQPuvptxNW3U9kTmxgUyyz1vFk8BhJoKYF5q
sLRCBge6gro=
=jXrR
-----END PGP SIGNATURE-----

--Sig_/yBpgteF=fBMExyi8+nKxyAv--
