From: NeilBrown <neilb@suse.de>
Subject: Re: degraded raid 6 (1 bad drive) showing up inactive, only spares
Date: Fri, 15 Jun 2012 22:37:40 +1000
Message-ID: <20120615223740.22a76a9c@notabene.brown>
References: <B5902F16-9C82-4072-BD67-FC6D6488ADB7@googlemail.com>
	<20120607222933.14ec3cd5@notabene.brown>
	<alpine.DEB.2.00.1206080743310.25054@uplift.swm.pp.se>
	<20120615173719.6076714f@notabene.brown>
	<4FDB1DF3.3080401@schinagl.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KfdNuq39VXhy3K_AIbvh/4="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FDB1DF3.3080401@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/KfdNuq39VXhy3K_AIbvh/4=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 15 Jun 2012 13:35:15 +0200 Oliver Schinagl <oliver+list@schinagl.nl>
wrote:

> Neil,
>=20
> Good read! I don't know if it's important to have a list of all affected=
=20
> kernels, but as a Gentoo user, know that it affects at least the=20
> unstable branch, but I would not be surprised if it even affects the=20
> stable hardened kernel. I run those on my servers and may have noticed=20
> that behavior on my arrays as well.

Thanks.

It would be useful adding other kernels, but only where a vendor has
backported the offending patch to an earlier release, and then I'd want
actual release numbers from the vendor.

So if you could show me how to decode the gentoo kernel package information
so I could see exactly what patches were in which release I could work out
the release numbers from that ....

Thanks,
NeilBrown


>=20
> Oliver
>=20
> On 15-06-12 09:37, NeilBrown wrote:
> > At the suggestion of Mikael Abrahamsson I have written
> >
> >    http://neil.brown.name/blog/20120615073245
> >
> > discussing this bug in detail.
> >
> > I'll probably post the whole thing to Linux RAID tomorrow, which a bett=
er
> > subject line.
> >
> > NeilBrown


--Sig_/KfdNuq39VXhy3K_AIbvh/4=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9sslDnsnt1WYoG5AQL0FQ//dpiplNF8M02RwtOEBS9BOVStYlb4/MaM
EnPRTy8nxA0vOJc786psd58NLPjg2PoXy6k6JdNn4rlT5f6o60nBhzMHBLT1Z9X4
oPYlZQ5b18H5+CC8h1rGI2YHhnexjczyLLsTnRPWaKe/PwMM4iewwc++BA8G+m4h
mePzQnu6AassxpWczs3pnj6NRp7cPxf5r5oeEtPTP4YQKTlXNy0iJpOcpFAQNucr
pWvG7RbIybw4lZp7x9G3BPPyRbQe7hcQ/ldWWeLw1XQ/IBt13HO9uxc+EyijY065
R1e3vBkRQzxhjDni84Nz2gboMtX+No4o32C9xROKS+6eP5+AhaDSdFLCkvyAjjQo
RMmAfGeVqrK6gcSvjFcjS+3YfNdhuKjI9kema0GG+69FA62AgtG93crTXHILPnlM
VB+C2SDdGtQ40jgPxFKCpIcSSoLeKe5iPLfgLnF4Kh1cONmPsK2MlBFJEx4xxut4
bbGiyf83JbrvBvgu7hTId3oE2uuFbn0XcA1hr7NqLX/Vu2JC3k3ou9np+6yRpOWe
3CE1iqANl11h2Gzdd9aOlrnyczKGeGPZ9mocuhUujcUQ1CUNN4Hkb/LsSKW+AM62
Huxq1Jzd/gjUcm3DdJNgZ0sqxyqm+nFQs4PC+CRxBbWaaeMkbm4uHvOqMNqHOFg6
8OpA7Ycq++g=
=UuXN
-----END PGP SIGNATURE-----

--Sig_/KfdNuq39VXhy3K_AIbvh/4=--
