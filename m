From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Promise SATA TX4 300 + 3TB disks?
Date: Fri, 5 Oct 2012 14:50:11 +0600
Message-ID: <20121005145011.673f4974@natsu>
References: <818058745.20121005012826@oudeis.org>
	<20121005123653.0a5398e0@natsu>
	<506E9E77.1080002@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XTKrB6d3UXKdaluAD4iSLC="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <506E9E77.1080002@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Rainer =?UTF-8?B?RsO8Z2Vuc3RlaW4=?= <rfu@oudeis.org>, Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/XTKrB6d3UXKdaluAD4iSLC=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 05 Oct 2012 03:46:47 -0500
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> > I would not recommend a PMP, with it your 5 disks will be limited to on=
e SATA
> > port's bandwidth, which will not give you good performance.
>=20
> Roman is simply wrong here.  The PMP will give far better performance in
> the OP's case than a 4 port PCI 32/33 HBA.

Compared to a 4-port PCI 32/33 card, sure. Sorry, I have overlooked the part
where author specifically asks for a PCI card.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/XTKrB6d3UXKdaluAD4iSLC=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBun0MACgkQTLKSvz+PZwhnxwCfbbCQmpeZHMVfxF+gqk6Egf4C
sg8An2xYwzVN+8DtoVZv90vlVWm1HiKT
=KEBa
-----END PGP SIGNATURE-----

--Sig_/XTKrB6d3UXKdaluAD4iSLC=--
