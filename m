From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID50 boot problems
Date: Fri, 19 Apr 2013 17:45:09 +0600
Message-ID: <20130419174509.5892c4bd@natsu>
References: <CAGqvA+t8Nr7D6h35ZKVi5Wa0tF46TQHK_Af_mXO2=ByRjWRQag@mail.gmail.com>
	<CAGqvA+sui=5R7+agbrJgHTQpm+1e9PVZ_MskjO3RTWq+LcAdnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HwwNw=bJF3GhXSOq=t2_.rp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqvA+sui=5R7+agbrJgHTQpm+1e9PVZ_MskjO3RTWq+LcAdnQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Zvyagin <zvyagin.alexander@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/HwwNw=bJF3GhXSOq=t2_.rp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Apr 2013 20:45:40 +0200
Alexander Zvyagin <zvyagin.alexander@gmail.com> wrote:

> I have almost working RAID50 (two RAID5 forms RAID0) in my
> Linux-mint13. When booting the system always ends up in initramfs
> shell, saying it cannot find the "root".

Post a full dmesg of a failed boot-up;

also try "rootdelay=3D10" kernel command line parameter.

--=20
With respect,
Roman

--Sig_/HwwNw=bJF3GhXSOq=t2_.rp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFxLkUACgkQTLKSvz+PZwgMbQCeNR0bznuf7waMbQx3DCrlyb7A
ewIAoIqhM8Ys4FNbiuOraotLRsIB6p2H
=YH+U
-----END PGP SIGNATURE-----

--Sig_/HwwNw=bJF3GhXSOq=t2_.rp--
