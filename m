From: NeilBrown <neilb@suse.de>
Subject: Re: What are mdadm maintainers to do? (was: desktop disk's error
 recovery timeouts)
Date: Tue, 17 Feb 2015 10:49:06 +1100
Message-ID: <20150217104906.62d36c62@notabene.brown>
References: <loom.20150214T222329-324@post.gmane.org>
	<20150216142845.0d50207c@notabene.brown>
	<loom.20150216T124230-883@post.gmane.org>
	<54E1EDEA.1030503@turmel.org>
	<loom.20150216T165111-551@post.gmane.org>
	<54E226B5.1080500@turmel.org>
	<loom.20150216T183419-387@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/EHtQ3cCDNR_yW6rvtimKPKJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20150216T183419-387@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Chris <email.bug@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/EHtQ3cCDNR_yW6rvtimKPKJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Feb 2015 17:48:50 +0000 (UTC) Chris <email.bug@arcor.de> wrote:

>=20
> Thank you for the additional information, it calls for action.
>=20
>=20
> OK, calling for a solution to stop desktop drives from causing data loss =
and
> affecting the mdadm reputation:
>=20
>=20
> I gather that mdadm could ship with one additional udev rule that calls a
> script to check/set scterc, or falls back to increasing the system timout.
>=20
> Phil, you mentioned having posted such a script, could you prepare it for
> addition to the mdadm package?
>=20
>=20
> Would maintainers be ok with adding such a udev rule and script to the pa=
ckage?


"maintainers" ? Plural?  That would be nice.
Unfortunately there is just the one singular me....

There are certainly other contributors who=20
 - answer questions on the list=20
 - provide bug reports
 - provide bits of code

and I am very thankful to them.  But I haven't found a likely co-maintainer
yet :-(


I'm certainly happy to consider and concrete proposal.  The more concrete,
the better.

NeilBrown

--Sig_/EHtQ3cCDNR_yW6rvtimKPKJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOKB8jnsnt1WYoG5AQJvfg/9FwpmBnM330VOOKRckUDT40K4UepKP8eG
AtQ6EjWca2xKEjBS0mv/e89Rp2waD2YSaogUn5zPgQ2Vp6HbPtkp6VS4R54a7/sX
B29Q+tim2P3zRl6haKWFEekW87zykFBOxlbaS2bG/6+EDk++CX3hfrVTKuP4ZpF6
INNAlCJ3jVmkZCXwYzXYlEx3K2EdwUqwj8jVDARExARRiNlRdfzmAmZ0yw3u57q7
q00XXxsahsIbemzJK2znvfbnYDj4yHQzOVh7cOIHsqRNxCS91P1sQ8kf1yZewHLx
LkP8aURDRpyc9XFVaOlk7ea5l394FjPHvdE1+M/vcDJyD+l78TyX/j2w673htxsw
iF4zSCHp82nLac60jOoCozZ1zY/1WCtkpxD0oo9B3MRLns2a2blNnbjyactsDhqu
ANfIGhZlBkKhtXhM02pmAvv+bjbDUsazKFn9IbTE5ceR7M23Qki6HVWm8kahJVn0
R2OOcoV4uZKgnGZXl12z7b1qXb0vVwfTIy5JeYEjZL/z/p/aHi0y2EqmjFsudt8d
+RxSptFS0M+b+yf27xAgs3xjd/XDq+0eGg+azaNYzvAQ9ZQsLI0gpmvlUammbhpb
oUut550p3i0Zv4X43tehrfOOO6na1KHDPyINXKoKYnDVwRWohSEGXC7QVfvtOY4/
acPf4P6y0rA=
=M2cy
-----END PGP SIGNATURE-----

--Sig_/EHtQ3cCDNR_yW6rvtimKPKJ--
