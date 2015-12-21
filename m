From: NeilBrown <neilb@suse.de>
Subject: Re: clustered MD - beyond RAID1
Date: Tue, 22 Dec 2015 07:47:12 +1100
Message-ID: <87bn9j4jhr.fsf@notabene.neil.brown.name>
References: <56742652.5040304@nasa.gov> <87si2w66tm.fsf@notabene.neil.brown.name> <567850C4.30108@bnl.gov>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <567850C4.30108@bnl.gov>
Sender: linux-raid-owner@vger.kernel.org
To: Tejas Rao <raot@bnl.gov>, Scott Sinno <scott.sinno@nasa.gov>, linux-raid@vger.kernel.org
Cc: "Knister, Aaron S. (GSFC-606.2)[COMPUTER SCIENCE CORP]" <aaron.s.knister@nasa.gov>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 22 2015, Tejas Rao wrote:

> What if the application is doing the locking and making sure that only 1=
=20
> node writes to a md device at a time? Will this work? How are rebuilds=20
> handled? This would be helpful with distributed filesystems like=20
> GPFS/lustre etc.
>

You would also need to make sure that the filesystem only wrote from a
single node at a time (or access the block device directly).  I doubt
GPFS/lustre make any promise like that, but I'm happy to be educated.

rebuilds are handled by using a cluster-wide lock to block all writes to
a range of addresses while those stripes are repaired.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWeGVQAAoJEDnsnt1WYoG5uMAP/3JHF3UyXgF3d/bAcLgY8/IF
gQLZtZNi2GqP3gPG9YyNZduuR8z5zXTO9qWK4VaUcIFeboaAku/V6A/cvoylugK/
RJjk5is/K8jpM6EaSGs24zaqoGULcBM/+pyFAYhjvQzIoeF1RBOK7zEZV9QmmjkN
ddZVKCbDVmUwEEhEqn6b+aG07zMsPzK5WD0onT+vDHd0RFrQxcpxE+JOghPMab9B
ctIqZhgIdLfEgp8wzHejccquVNbhTGQNpv87yjrg8JPKgiTVegUqfGBJWtIwoFMQ
v4OQv9EwsuS165urGgeDDfhpLsNKDqBAUCLrY7IdDMFV5hbg3CPVofd03yovIOA7
jFz0nQJNYwV/IdTyjYhUcMIsNjajZtP8jqCbBttgYI/VEvrwJi6+RuXf+5Wn5B5m
fpkxLvMjncW8rTgCuhhR+SCZ6whlDqc9kRP5Ci3uD98OEAzEnXRoEzrI4kh0KPF4
/WBm2MSs1Z2YLnIP0ZxgnQi9O3bw3oRqIhETyACnGTzB5r4UGLDloWZ4ITRTm5JD
d0fqyOrbjKKlzBWxEm0LDCX6shNIc6zFrHN+3tpo4tptoNcnfbSc9Zyiw467ElpF
ZDlstsRGHLDzv3nSAburU1VA/4T+8X7eBVCJ6+SkxGDLmQydI49FV5fLb0eNb52C
nh0Ygwysi47ZufNBcFzy
=hnt8
-----END PGP SIGNATURE-----
--=-=-=--
