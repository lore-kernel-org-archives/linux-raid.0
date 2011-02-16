From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 02:44:02 +0500
Message-ID: <20110217024402.1dd44267@natsu>
References: <20110216212751.51a294aa@notabene.brown>
	<4D5BDB84.8050706@gmail.com>
	<20110217082412.51afa2a6@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/I4+.HiPBODTn_+pnge2qyro"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217082412.51afa2a6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Joe Landman <joe.landman@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/I4+.HiPBODTn_+pnge2qyro
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Feb 2011 08:24:12 +1100
NeilBrown <neilb@suse.de> wrote:

> "read/write/compare checksum" is not a lot of words so I may well not be
> understanding exactly what you mean, but I guess you are suggesting that =
we
> could store (say) a 64bit hash of each 4K block somewhere.
> e.g. Use 513 4K blocks to store 512 4K blocks of data with checksums.
> When reading a block, read the checksum too and report an error if they
> don't match.  When writing the block, calculate and write the checksum to=
o.
>=20
> This is already done by the disk drive - I'm not sure what you hope to ga=
in
> by doing it in the RAID layer as well.

Consider RAID1/RAID10/RAID5/RAID6, where one or more members are returning =
bad
data for some reason (e.g. are failing or have written garbage to disk duri=
ng
a sudden power loss). Having per-block checksums would allow to determine
which members have correct data and which do not, and would help the RAID
layer recover from that situation in the smartest way possible (with absolu=
tely
no loss or corruption of the user data).

--=20
With respect,
Roman

--Sig_/I4+.HiPBODTn_+pnge2qyro
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1cRSIACgkQTLKSvz+PZwg0VgCeI+4BjjPnFfpPIyGClgEZtjiv
zj8AnjuQtwvp9pG9TJuJ9DgaEhXkaXPS
=gCdX
-----END PGP SIGNATURE-----

--Sig_/I4+.HiPBODTn_+pnge2qyro--
