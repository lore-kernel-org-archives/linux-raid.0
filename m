From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: alignment of metadata 1.2 and mkfs.ext4
Date: Wed, 6 Jul 2011 15:20:16 +0600
Message-ID: <20110706152016.1982c6fd@natsu>
References: <1309936276.11661.8.camel@baal>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/L3S=jQ/G4tRG.qUA=wYD0bJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1309936276.11661.8.camel@baal>
Sender: linux-raid-owner@vger.kernel.org
To: "Tyler J. Wagner" <tyler@tolaris.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/L3S=jQ/G4tRG.qUA=wYD0bJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 06 Jul 2011 08:11:16 +0100
"Tyler J. Wagner" <tyler@tolaris.com> wrote:

> Metadata 1.2 puts the data 4K from the start of the device/partition.

This is not correct. See mdadm -E /dev/sdX.

$ sudo mdadm -E /dev/sdc3
/dev/sdc3:
...
        Version : 1.2
...
    Data Offset : 2048 sectors
...


--=20
With respect,
Roman

--Sig_/L3S=jQ/G4tRG.qUA=wYD0bJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4UKNAACgkQTLKSvz+PZwh31gCeIAb4lZkLVKiIybcHKx3cO5fR
psMAn2UawaIj+6gWR5jJXSjGbCSanfKZ
=JMiW
-----END PGP SIGNATURE-----

--Sig_/L3S=jQ/G4tRG.qUA=wYD0bJ--
