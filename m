From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdmon: honour --offroot, again
Date: Fri, 13 Sep 2013 08:42:40 +1000
Message-ID: <20130913084240.16ca92ee@notabene.brown>
References: <1378930519-7679-1-git-send-email-mwilck@arcor.de>
	<20130912154250.09c986c2@notabene.brown>
	<5232072A.5050308@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3CAZ/a_3r5JV=vIdcq2DZxy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5232072A.5050308@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3CAZ/a_3r5JV=vIdcq2DZxy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Sep 2013 20:25:46 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> On 09/12/2013 07:42 AM, NeilBrown wrote:
> > On Wed, 11 Sep 2013 22:15:19 +0200 mwilck@arcor.de wrote:
> >=20
> >> Reintroducing --offroot as an undocumented option, as its use is going=
 to
> >> go away soon anyway.
> >>
> >=20
> > Aggh...  This is all pretty horrible isn't it?
> >=20
> > I've applied your patch because I don't think it can break anything and=
 it
> > could possible help as you say.
>=20
> I just verified that OpenSUSE Factory still needs this patch as well.
> Fedora is probably the only distribution that "properly" (according to
> the systemd developers) starts and stops mdmon from "offroot" (i.e. initr=
d).
>=20

Thanks ... I'd better include it in my update for openSUSE 13.1-rc1 then ;-)

NeilBrown

--Sig_/3CAZ/a_3r5JV=vIdcq2DZxy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjJDYDnsnt1WYoG5AQK6SBAAqAPtszneZIg2IFXSacCK0rjzssWyHbwm
F32vH2Vbef4SBOHgZHGCGeqX7K1XF/i70b4lmjFAEztsBjLQ7f8EoZqkw0vfgcNu
G7cQvTWdsAwuIdAEtjYcTIz0HC4ssfDAgYWoXD40VogjULSoxS/K4w97aafFtTbc
5rO5s/r3PM7JPXGze/A+BI+UwEs7aNJShpNSXRaUCw0IRNx1H+P/+CtW4p5VH8m/
nd+e1vddAc+ccnUsyzrOsG6Alfv5oITsKfM4yWoLdTf6UYubEsrB3kGSHedx+RNA
OW4Ds3Fc7Tg8+7D+EAzH8LUp6YE60Rx6PhheWlzyqq5hb5SJAAiUPEoMDDSzt3lq
SKLGEr983FgXIJ2Oa4MbZrOG9h9eDvnU9Rspt43naFnZGYKNk3itS1vBoGsGYliF
ckqgCo6zGhJ8zcno/QBMsSgzSX4qbXQ+93bweYR0q+ChziWBIzxx44Qs4dBgkFvS
QzwSZLw16NF8amGt2GmsmvLpRCb7QsSH0j2yyx6Ohxwa2YcDEWg1XmVLrEAoDxDI
hdYa1QCHMi/wfpoiHxXbpccpyH57B1qhGsUrKL6Jg+ZApIzhhjHnanZE1FlcAR+k
seQ2jARdYORZB2Qxrw0NcTeLTIz3NbixUxBflDe0HA4u9RIkC/HAecVXOPFSK+7m
bUrBT8oNYqA=
=etxT
-----END PGP SIGNATURE-----

--Sig_/3CAZ/a_3r5JV=vIdcq2DZxy--
