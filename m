From: NeilBrown <neilb@suse.de>
Subject: Re: making a hot spare ... hot
Date: Wed, 21 Sep 2011 14:05:51 +1000
Message-ID: <20110921140551.31828ea9@notabene.brown>
References: <4E795A49.1060000@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/b_1Bh_Wgp3P6z0fC124/7L="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E795A49.1060000@swiftspirit.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/b_1Bh_Wgp3P6z0fC124/7L=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Sep 2011 05:30:17 +0200 Brendan Hide <brendan@swiftspirit.co.za>
wrote:

> Hi all
>=20
> To the point: When a disk is designated as a hot spare, would it be of=20
> benefit to spread copies of data chunks from the other disks onto the=20
> hot spare even before a failure? Has this been tried before?
>=20
> If its not already being done, it'd have a small positive consequence=20
> for performance as well as data integrity, with relatively little to no=20
> negative consequences. Benefits would diminish the larger the array,=20
> much like the performance difference between raid3 and raid5. Read=20
> speeds would theoretically increase and write speeds should not decrease=
=20
> except in the case of poor hardware.
>=20
> Given a 6-disk raid5 (5 "data" disks + 1 spare) array, a re-sync will=20
> start at 25% progress from the moment a disk gets dropped out of the=20
> array. The theoretical max read speed will also increase by 16% by=20
> reading from 6 disks instead of 5. The cons will be that, when writing,=20
> an extra write will need to occur to the "spare" disk. Though this=20
> shouldn't have any performance penalties on modern hardware I can still=20
> see it as being a concern.
>=20
> I suspect something like this might have been suggested before - but I=20
> haven't been able to find any reference to something along these lines=20
> online. I'll welcome any discussion or links to relevant information.
>=20
> Thanks.
>=20
> Key:
> 0-F: Data Chunks
> P: Parity
>=20
> Layout of standard RAID5 + 1 standard spare
>=20
> Disk0: 048C
> Disk1: 159P
> Disk2: 26PD
> Disk3: 3PAE
> Disk4: P7BF
> Disk5: Spare (empty)
>=20
> Chunks read per read "cycle": 5
> Time to read all 16 data chunks: 4 cycles
>=20
> Layout of standard RAID5 + 1 "hot" spare:
> Disk0: 048C
> Disk1: 159P
> Disk2: 26PD
> Disk3: 3PAE
> Disk4: P7BF
> Disk5: 05AF
>=20
> Chunks read per "cycle": 6
> Time to read all 16 data chunks: 3 cycles
>=20

I see what you are getting at, but I doubt the value justifies the extra
complexity.
If you want more redundancy and have a spare device - use RAID6.

NeilBrown


--Sig_/b_1Bh_Wgp3P6z0fC124/7L=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeWKfG5fc6gV+Wb0RAvgrAJwPo7ruZhYI5tTwIqYr0G/QrERCWACeM6bY
/3aUF12afup2ALUXgmwQvXE=
=vfTh
-----END PGP SIGNATURE-----

--Sig_/b_1Bh_Wgp3P6z0fC124/7L=--
