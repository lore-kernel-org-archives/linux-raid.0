From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: potentially lost largeish raid5 array..
Date: Fri, 23 Sep 2011 10:58:34 +0600
Message-ID: <20110923105834.71fc7c78@natsu>
References: <201109221950.36910.tfjellstrom@shaw.ca>
	<20110923143210.583e11ec@notabene.brown>
	<201109222249.12892.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tI4KVlbzW9AuHbYR=sLKXH9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201109222249.12892.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/tI4KVlbzW9AuHbYR=sLKXH9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Sep 2011 22:49:12 -0600
Thomas Fjellstrom <tfjellstrom@shaw.ca> wrote:

> Now I guess the question is, how to get that last drive back in? would:=20
>=20
> mdadm --re-add /dev/md1 /dev/sdi=20
>=20
> work?

It should, or at least it will not harm anything, but keep in mind that sim=
ply trying to continue using the array (raid5 with a largeish member count)=
 on a flaky controller card is akin to playing with fire.

--=20
With respect,
Roman

--Sig_/tI4KVlbzW9AuHbYR=sLKXH9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk58EfoACgkQTLKSvz+PZwjuMQCgjLvyHMCSHh9N3itpt3eA+ZPb
uhoAnj8YmR/vA5rYinKATNx/TnNstLJw
=bB4R
-----END PGP SIGNATURE-----

--Sig_/tI4KVlbzW9AuHbYR=sLKXH9--
