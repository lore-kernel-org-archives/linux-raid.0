From: NeilBrown <neilb@suse.de>
Subject: Re: GPT Table broken on a Raid1
Date: Sun, 23 Sep 2012 07:58:43 +1000
Message-ID: <20120923075843.42ec8efb@notabene.brown>
References: <4961154.0TR9MeFlIq@techz>
	<2627519.Y2VdWh5VBI@techz>
	<1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com>
	<1361158.MkTZ6QR6cp@techz>
	<E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com>
	<3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com>
	<505DD9E2.7090908@anonymous.org.uk>
	<F7E53090-1143-4811-86B9-E71923B98AA2@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/V1a=uu2dR/YPowO5WgdOwxk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7E53090-1143-4811-86B9-E71923B98AA2@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/V1a=uu2dR/YPowO5WgdOwxk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 22 Sep 2012 12:45:39 -0600 Chris Murphy <lists@colorremedies.com>
wrote:

>=20
> On Sep 22, 2012, at 9:31 AM, John Robinson wrote:
>=20
> >=20
> > I don't think there's anything wrong here.
> >=20
> > The kernel sees the whole discs, sda and sdb, and complains that the GP=
T partition table looks wrong becase the second copy isn't at the end of th=
e discs. That's correct, at the end of the raw discs is the IMSM metadata.
>=20
> OK so sda and sdb shouldn't have been partitioned in the first place, is =
what that tells me.
>=20
>=20
> > Don't try to change the partition tables on /dev/sda and sdb or you wil=
l damage the IMSM metadata.
>=20
> Sounds like either imsm metadata is either not well designed for GPT, or =
it was intended to be placed on an unpartitioned disk in the first place.=20

IMSM metadata is definitely intended to be placed on an un-partitioned disk.

The only real point of IMSM is to provide interoperability with other
implementations, whether the one for Windows (allowing dual-boot) or the one
in the bios (allowing boot-from-RAID5 etc).
Those other implementations use IMSM on the whole device, so it would be
pointless using mdadm/IMSM on partitions.

Note that I haven't really been following this thread, so I might have miss=
ed
the point.  I'm really just responding to that last sentence.

NeilBrown

--Sig_/V1a=uu2dR/YPowO5WgdOwxk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUF40kznsnt1WYoG5AQLTpxAAwzZOUzG7ch11bM4iDofoh8THFRCjOf34
EAZUdshcBEMb25nq/vx8XZWf+hB4IJJU5DN1FIlW7EmfknuN7ep1YBsxMCkz7MKO
Dw+eO9DLettFo0bjZFTkpqQy6eWeHpf3RMKIa/SoxRQg0S5q3msbUcrx34ceDmGG
m5F9O58YPlSRkkmrvT/0Vrd29LfkB4MwPG0BI0nl+NT/2E2HTuDbgNsqgpBCZqBF
vvRJbijhL1OkhBvAuQY2Dm9VM0YSrfHe9LIjUbyKr+6WYpwkMugbgnPhrBvki1s6
tD2MFtPphbiiG+pMHtxHyyCQmLkDY1DGxlaZb+Xkq11psDiaJNs/XB7g+byeNABi
4t/lOhveqqZt4c6cefGqEY30jAmBO6xuXwIkIrzsTEFHxf30Yako4OFi8D+pr5q6
Y5wQb3cl/Q5HNaryZvZbbeAOFvzp7mhueXPnTP7hjc5EIpV7qk/8npTVi3JyLe8x
ieYRYR9lNcJLADQguc5zyMt7YYZRryr9drQXXnXBge2U2JaAYMmlw/lApbp/pz3n
W0o4lgO9BMNOMm5h2BNXQxg7Sm7cAVCahxDTZc9DUvrqw78lAOkDSig44MJYCvVP
m/vfzrRO7fnEOMi1rpiP0Lr29/pykXmoM+bwIfRtEsMyr4e8AvR7kAu7frguqu1r
XHYeo7TSnrs=
=7uC7
-----END PGP SIGNATURE-----

--Sig_/V1a=uu2dR/YPowO5WgdOwxk--
