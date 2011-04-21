From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: mismatch_cnt and Raid6
Date: Thu, 21 Apr 2011 19:45:15 +0600
Message-ID: <20110421194515.719b3fa7@natsu>
References: <4DB02A77.8000902@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/U=v=UUsAn9Y+sU56X1Qi_Pn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DB02A77.8000902@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Falgout <andrew.falgout@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/U=v=UUsAn9Y+sU56X1Qi_Pn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 21 Apr 2011 08:00:39 -0500
Andrew Falgout <andrew.falgout@gmail.com> wrote:

> I got an error last week from a new raid6 array about a mismatch_cnt.  I=
=20
> did some reading online, performed a repair action on the array,=20
> performed a check action, and checked for the mismatch_cnt again.  The=20
> number was greatly reduced, but it was still there.  According to mdadm,=
=20
> everything appears to be working fine.  All the drives are passing short=
=20
> tests on smartctl.
>=20
> What is mismatch_cnt really?  Should I even be concerned about this? =20
> The array is giving me 25-30MB/sec performance on an sshfs mount over=20
> the network.  With a local copy I can see speeds of 50 to 60MB/sec.

Hello,

What kind of SATA cards/controllers do you use?

--=20
With respect,
Roman

--Sig_/U=v=UUsAn9Y+sU56X1Qi_Pn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2wNOsACgkQTLKSvz+PZwglUACeNbMbrXeY9UBAUbXygd3yaZK+
xwsAnjEGhiLEYzgFZvtsbue0GuPUA1O8
=TFWD
-----END PGP SIGNATURE-----

--Sig_/U=v=UUsAn9Y+sU56X1Qi_Pn--
