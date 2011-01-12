From: NeilBrown <neilb@suse.de>
Subject: Re: Reshape RAID5 to a RAID6 with more (smaller) devices
Date: Wed, 12 Jan 2011 18:54:35 +1100
Message-ID: <20110112185435.79c19036@notabene.brown>
References: <20110112122930.6a17440f@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4+gmqsdPfRioOKbHctxfcOV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112122930.6a17440f@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4+gmqsdPfRioOKbHctxfcOV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Jan 2011 12:29:30 +0500 Roman Mamedov <rm@romanrm.ru> wrote:

> Hello!
>=20
> I am considering to move my configuration in which I currently use two RA=
ID5
> arrays (3*2TB and 3*1TB) to one described in [1]. Specifically, make a 6*=
1TB
> RAID6 plus 3*1TB RAID5 consisting of 2TB drives' "tails".
>=20
> My question is: does mdadm support a simultaneous reshape, changing at on=
ce:
> 1) RAID5 to RAID6
> 2) number of devices from 3 to 6
> 3) individual device size from 2TB to 1TB
>=20
> Note that the user-accessible space after this reshape does not change, a=
nd
> remains at 4 TB. So is that supported? Will that require a backup file? W=
ill
> that proceed particularly inefficiently/slowly?
>=20
> [1] http://www.linuxconfig.org/prouhd-raid-for-the-end-user
>=20

Sorry,  but no.
It could be implemented, probably without a lot of difficulty, but it hasn't
been.

NeilBrown

--Sig_/4+gmqsdPfRioOKbHctxfcOV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iD8DBQFNLV5CG5fc6gV+Wb0RAr7kAJ44ksFpxDmyKlOy8Wt2e8lS/lzhmgCfUsPP
FV3WZW/abgoxu2Dz3ILl2hk=
=rNS4
-----END PGP SIGNATURE-----

--Sig_/4+gmqsdPfRioOKbHctxfcOV--
