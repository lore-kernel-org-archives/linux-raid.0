From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Bitmap in RAM?
Date: Sat, 8 Oct 2016 21:02:16 +0500
Message-ID: <20161008210216.1a3fead2@natsu>
References: <57F8EC82.9010804@yandex.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/bo.XfG..C9vJtj6XVMGu=Ey"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57F8EC82.9010804@yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Dark Penguin <darkpenguin@yandex.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/bo.XfG..C9vJtj6XVMGu=Ey
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 8 Oct 2016 15:54:26 +0300
Dark Penguin <darkpenguin@yandex.ru> wrote:

> So if I were to place it on a tmpfs, I could eliminate this problem only=
=20
> at the expense of being unable to re-add drives after a reboot, right?..=
=20

If you don't need that ability, you can just remove bitmap entirely, it's n=
ot
mandatory. Run:

  mdadm --grow --bitmap=3Dnone /dev/mdX

However I'd say being able to re-add drives is very useful, so first consid=
er
switching to a higher bitmap granularity,=20

  mdadm --grow --bitmap=3Dnone /dev/mdX
  mdadm --grow --bitmap=3Dinternal --bitmap-chunk=3D131072 /dev/mdX

(or even 262144, 524288) as that will reduce the performance impact of the
bitmap.

--=20
With respect,
Roman

--Sig_/bo.XfG..C9vJtj6XVMGu=Ey
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlf5GIsACgkQTLKSvz+PZwgjNwCeJd8bmRxnozCBlnphYvUwij4B
lLgAn0d4SjjRSq6hxvq94qc+5cIGJKmK
=u7yZ
-----END PGP SIGNATURE-----

--Sig_/bo.XfG..C9vJtj6XVMGu=Ey--
