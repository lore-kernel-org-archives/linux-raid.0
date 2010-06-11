From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Fri, 11 Jun 2010 17:50:46 +0600
Message-ID: <20100611175046.54b41aad@natsu>
References: <4C1128C2.4020105@meetinghouse.net>
	<20100611005743.43664e5b@natsu>
	<4C11578B.8010202@meetinghouse.net>
	<20100611034108.6a2cdbc4@natsu>
	<4C1169CB.1030903@meetinghouse.net>
	<20100611085112.5f33b06f@natsu>
	<4C11BFB7.7050907@meetinghouse.net>
	<20100611150811.3c3f03bb@notabene.brown>
	<4C12199F.60108@xs4all.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WhKGcgYUdZn6RmeCRr0MB_d"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C12199F.60108@xs4all.nl>
Sender: linux-raid-owner@vger.kernel.org
To: John Hendrikx <hjohn@xs4all.nl>
Cc: Neil Brown <neilb@suse.de>, Miles Fidelman <mfidelman@meetinghouse.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WhKGcgYUdZn6RmeCRr0MB_d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Jun 2010 13:10:23 +0200
John Hendrikx <hjohn@xs4all.nl> wrote:

> > I would be really interested to find out if my assumption of small numb=
ers
> > of bits set is valid.   You can find out the number of bits set at any
> > instant with  "mdadm -X" run on some component of the array.
> >  =20
> I was interested as well, so I ran this command:
>=20
>  > mdadm -X /dev/md2
>=20
> and this is the result(??):
>=20
>         Filename : /dev/md2
>            Magic : d747992c
> mdadm: invalid bitmap magic 0xd747992c, the bitmap file appears to be=20
> corrupted
>          Version : 1132474982
> mdadm: unknown bitmap version 1132474982, either the bitmap file is=20
> corrupted or you need to upgrade your tools

I stumbled in the same way initially, but then re-read more closely and
noticed that Neil said to run it "on some component of the array",
e.g. /dev/sdxN, not the array itself -- and that way it worked fine. Howeve=
r as
my array sees almost no write load at the moment, I have no useful results =
to
report.

--=20
With respect,
Roman

--Sig_/WhKGcgYUdZn6RmeCRr0MB_d
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwSIxYACgkQTLKSvz+PZwjz1gCghjb68caR/TiN0cLW15SXBcF+
MSwAn1RhKqKV2bmzXhgK72VPqSKerOfX
=EJfg
-----END PGP SIGNATURE-----

--Sig_/WhKGcgYUdZn6RmeCRr0MB_d--
