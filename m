From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: data corruption after rebuild
Date: Tue, 19 Jul 2011 21:12:40 +0600
Message-ID: <20110719211240.2578bba6@natsu>
References: <2073005.NH8LALaxuD@bloomfield>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/020Ahsc9DU4WJor_qKExBc6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2073005.NH8LALaxuD@bloomfield>
Sender: linux-raid-owner@vger.kernel.org
To: Pavel Herrmann <morpheus.ibis@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/020Ahsc9DU4WJor_qKExBc6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, 19 Jul 2011 15:55:35 +0200
Pavel Herrmann <morpheus.ibis@gmail.com> wrote:

> the problem is that the rebuilt array is corrupted. most of the data is f=
ine,=20
> but every several MB there is an error (which doesn't look like being cau=
sed=20
> by a crash), effectively invalidating all data on the drive (about 7TB, m=
ainly=20
> HD video)

Which model of SATA controller/HBA do you use?

Kernel version, mdadm version?

Anything unusual in SMART reports of any of the drives (e.g. a nonzero UDMA=
 CRC Error count)?

>=20
> I do monthly scans, so the redundancy syndromes should have been up-to-da=
te,=20
> the array is made of 8 disks, the setup is ext4 on lvm on mdraid

Did you notice any nonzero mismatch_cnt during those scans?

--=20
With respect,
Roman

--Sig_/020Ahsc9DU4WJor_qKExBc6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4lnugACgkQTLKSvz+PZwhp0QCeNKJ/6XQCLsSt15x+7PokBUca
TvkAn3oe+ANvFrY+izCPlp11SqkMGoBn
=DYQm
-----END PGP SIGNATURE-----

--Sig_/020Ahsc9DU4WJor_qKExBc6--
