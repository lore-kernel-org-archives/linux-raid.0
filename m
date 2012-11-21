From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: want-replacement got stuck?
Date: Wed, 21 Nov 2012 22:41:20 +0600
Message-ID: <20121121224120.65129930@natsu>
References: <20121120221145.9905.qmail@science.horizon.com>
	<20121121163300.30697.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/w53ZKQqRePN_wZihX5nFc6H"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121121163300.30697.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/w53ZKQqRePN_wZihX5nFc6H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On 21 Nov 2012 11:33:00 -0500
"George Spelvin" <linux@horizon.com> wrote:

> Nov 21 16:21:00 science kernel: UDP: bad checksum. From 187.194.52.187:65=
535 to 71.41.210.146:6881 ulen 70

This is a message that your system even got a checksum error when verifying=
 an
UDP packet received from the network -- something completely unrelated to
Ext4, MD or disks in general.

I'd say you just have bad RAM/motherboard/CPU or some related general hardw=
are
failure.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/w53ZKQqRePN_wZihX5nFc6H
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCtBDAACgkQTLKSvz+PZwi4mACfRiqqNJV8GJaStNeNFVZU81Jm
bK4AoJHiQjk/hur4uNopa2zhgKrKJ4y9
=7AsL
-----END PGP SIGNATURE-----

--Sig_/w53ZKQqRePN_wZihX5nFc6H--
