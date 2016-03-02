From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Checkarray doesn't seem to do anything
Date: Wed, 2 Mar 2016 22:47:45 +0500
Message-ID: <20160302224745.32db9c07@natsu>
References: <20160301175009.0a91db92e0d9ae1e5e3fde0508678719.a1548d3694.wbe@email03.secureserver.net>
	<20160302174454.GA2567@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/=ygA_ESRvIkd_4t86fqfbQC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160302174454.GA2567@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: rodman@shellport.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=ygA_ESRvIkd_4t86fqfbQC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Mar 2016 18:44:54 +0100
Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:

> Just tested:
>=20
> dd if=3D/sys/block/md0/md/sync_action bs=3D1 count=3D1
>=20
> On kernel 3.x I get "i", on kernel 4.x I get "idle"... :-)

I am getting 'i' on 4.4.1.

# dd if=3D/sys/block/md0/md/sync_action bs=3D1 count=3D1
i1+0 records in
1+0 records out
1 byte (1 B) copied, 0.000218199 s, 4.6 kB/s

--=20
With respect,
Roman

--Sig_/=ygA_ESRvIkd_4t86fqfbQC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlbXJ0oACgkQTLKSvz+PZwjprACdHvXJSiom1rOKYbxp5hBQ3MhD
sJgAoITgvf8S/VqbFDEMqJlNOQCT8dPN
=i3ba
-----END PGP SIGNATURE-----

--Sig_/=ygA_ESRvIkd_4t86fqfbQC--
