From: NeilBrown <neilb@suse.de>
Subject: Re: Reason for md raid 01 blksize limited to 4 KiB?
Date: Tue, 22 May 2012 09:28:17 +1000
Message-ID: <20120522092817.1b5946b8@notabene.brown>
References: <4FBA0047.5050208@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nCfbtJvLpqGZbyVd5UXaAyg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FBA0047.5050208@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/nCfbtJvLpqGZbyVd5UXaAyg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 May 2012 10:43:51 +0200 Sebastian Riemer
<sebastian.riemer@profitbricks.com> wrote:

> Hi list,
>=20
> I'm wondering why stacking raid1 above raid0 limits the block sizes in
> the blkio queue to 4 KiB both read and write.
>=20
> The max_sectors_kb is at 512. So it's not a matter of limits.
>=20
> Could someone explain, please? Or could someone pinpoint me to the
> related location in the source code?
>=20
> We've thought of using this for replication via InfiniBand/SRP. 4 KiB
> chunks are completely inefficient with SRP. We wanted to do this with
> DRBD first, but this is also extremely inefficient, because of chunk
> sizes in the blkio queue.
>=20
> I can reproduce the small 4 KiB chunks also in a file copy benchmark
> with raid 01 on ram disks.

This should be fixed in linux 3.4 with commit 6b740b8d79252f13bcb7e5d3c1d

NeilBrown

--Sig_/nCfbtJvLpqGZbyVd5UXaAyg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7rPkjnsnt1WYoG5AQLoCg//bNcVpRHg8yxGDgnswFTILFOMsjnqp2E1
6OlyaqDKlVYqifpk1kntRh7/ssoG/SBPCfWNc67QqXJjamSVDD+J25friZtMNu7J
2+nbjmg2M9JydsPcmEHYutFb2zOZYIs8V1a1c4zDBf8L9TSSALZq9ijKUmaF47Ii
87L0P7V79ji5a5gqLj3NY/ZlD6sPbFsR2XJNfrriAuRMwxP2p35xB2F3lY75/kjl
83dreVs57f8WS/FyHVfeLf/4qOiG7qAvCiv7rESZ8uasIjQ7VMTAbriKbwDcMYHf
GCFRRYViPkp7EBegu6tIsBOn53ti+8yK9oqK7cp9UDvXrEouTLDhzshwMmfbXCqO
VyD5tVci2cYchidPg+r14FY1ICPhb13AaD5EoF4MPvY3HbMdR9BULSPRYWd3hKoR
pwkH2hOs940HnQNRpZYL3l9sKjZzO4jrO9zrtpbjNjCSLW4ZZb164LG8B5t9UwZ1
79Y+MJbt4ry9GrDMzX5lNCVNHawdGX94pr53ZWRVRTdw76uGhxxnMPHEgsCzTAAI
CfG5xL1OSDTsWYnW9peobGMThhicwJ6cc/S8HPfYJr4Zy2y3kPHpwrE83Tygz1xg
zzAGqNz5W9X1A0IEAGZyL7m45+jGTcCTSIqxwQV6IMs+BYHnyWZaEf7KmjXvutC/
SPpLBv2VfwM=
=h2lW
-----END PGP SIGNATURE-----

--Sig_/nCfbtJvLpqGZbyVd5UXaAyg--
