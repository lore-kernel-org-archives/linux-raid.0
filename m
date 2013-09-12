From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm 3.3: issue with mdmon --takeover
Date: Thu, 12 Sep 2013 15:00:41 +1000
Message-ID: <20130912150041.55267bc8@notabene.brown>
References: <CAC9WiBjg4Tbv_UM4o66-8jtFEYGvh3kuP6xSdnz7uL+fq3fZTQ@mail.gmail.com>
	<20130904160832.3627bcb8@notabene.brown>
	<CAC9WiBiHkOjqY4nDwMh4S8td9NMz2mrdqK0R7cZp7nKSMyhBvg@mail.gmail.com>
	<20130905121123.27968f9f@notabene.brown>
	<CAC9WiBiHcS126iFv91250d83sMrBYmRbvoqYAEhjJWjb2p5J3A@mail.gmail.com>
	<CAC9WiBgRiu_YL1TpzD4dtLXv=LiA-RERn+C6Q+i=P_WTNdw3+w@mail.gmail.com>
	<20130911093518.794bbb21@notabene.brown>
	<CAC9WiBiRWN4sZ=nd2R3+XqxMD2X=d9F6JtDGpXaNX1jtOFMB4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hW3.gXS7LOoHEoI9KXsAKmo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBiRWN4sZ=nd2R3+XqxMD2X=d9F6JtDGpXaNX1jtOFMB4w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hW3.gXS7LOoHEoI9KXsAKmo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Sep 2013 09:40:56 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Yes it fixes the problem.
>=20
> I had to adjust the patch to make it compile by using be64_to_cpu()
> where needed.

Thanks.  I've applied with those fixes.

NeilBrown

--Sig_/hW3.gXS7LOoHEoI9KXsAKmo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjFKeTnsnt1WYoG5AQIXEhAAtyMwczIGpiPX+3iVfvLNpgBIxJTgmXlk
262n2qtRYSFK3oRWRo+0TxH9aZST2hOFsgzMoys4z5Olu8FXPoNPXQO7N1/m07dz
8B04Mam9aj7BtfwD4rqm9bZ71V78vcqdT45Zh6/x5QYY7nljG5rYSp6KVHCKGBCw
pJh2xLEYRNU02tdrNdeP6zOvgtRAzmdYvAJBQSJVp8TUzOO9FbRb2CjbWmfmjfCI
XlEooBl20wkDoodlmkMgZTDIA7lBy7/ryqk3kvPkRW/xNJmqg6949ixZw7O7lj5d
JigXbIpxNydkHwMnwdRG+lAsge4sdOpL2hugm3iuomqOPcFMbM8zpy9Hq/r3BE3P
2+Cs5R5Lxtw5SUcmcpmlAQLfCpDMoHmVRHe5q67a6ZpMZwpa1JPsuJdixpghZWkb
eR+jL5dyDxXj5GG5q+AAJN0rH9nAe3VEjhMTIJ3muGQSJuXP2FkIraqgghpa3eXT
Ql5RM/eRcECPcP7OVaRF1dcE5W/e5+Tk3z9Fovxc5O7vL9lFmPIJArlUyfQNnT5U
dR9maZYTcoukp3l4M1dxBrBWz6C3guSkphTyTyESr5AEIx8s5F/cE9q7YPMUCtwl
CScU/3XmRdCQJxbzI5LI/3XeWyHofRVK+zl7MNgPdLZBrXTFcAuzVAUQ5MVZtc24
sRgX3sWNiTk=
=LaeD
-----END PGP SIGNATURE-----

--Sig_/hW3.gXS7LOoHEoI9KXsAKmo--
