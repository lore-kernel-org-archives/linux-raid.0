From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Filesystem writes on RAID5 too slow
Date: Tue, 19 Nov 2013 01:25:36 +0600
Message-ID: <20131119012536.473bf37b@natsu>
References: <CACtJ3HZxp6xEjY_wOucCcqX4scNzEGuiAsovQYObJS9whtYJsQ@mail.gmail.com>
	<20131119004140.3fea96df@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zJADM7HgRyYwXL4UQY8zh=N"; protocol="application/pgp-signature"
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20131119004140.3fea96df@natsu>
Sender: linux-ext4-owner@vger.kernel.org
To: Martin Boutin <martboutin@gmail.com>
Cc: "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, "Kernel.org-Linux-XFS" <linux-xfs@vger.kernel.org>, "Kernel.org-Linux-EXT4" <linux-ext4@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/zJADM7HgRyYwXL4UQY8zh=N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Nov 2013 00:41:40 +0600
Roman Mamedov <rm@romanrm.net> wrote:

> > The command line for measuring filesystem read and write speeds was:
> >=20
> > $ dd if=3D/tmp/diskmnt/filerd.zero of=3D/dev/null bs=3D1M count=3D1000 =
iflag=3Ddirect
> > $ dd if=3D/dev/zero of=3D/tmp/diskmnt/filewr.zero bs=3D1M count=3D1000 =
oflag=3Ddirect
>=20
> Try testing with "fdatasync" instead of "direct" here.

Sorry, "conv=3Dfdatasync" instead of "oflag=3Ddirect".

--=20
With respect,
Roman

--Sig_/zJADM7HgRyYwXL4UQY8zh=N
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlKKabAACgkQTLKSvz+PZwgoPgCfRGrUCd59bvnmF2xxIL6/wWfJ
/DoAn0+AZJ6y6v3sZvsSH0222y+5yhkp
=OFIi
-----END PGP SIGNATURE-----

--Sig_/zJADM7HgRyYwXL4UQY8zh=N--
