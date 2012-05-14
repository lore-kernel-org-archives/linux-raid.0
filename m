From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: Failed, but "md: cannot remove active disk..."
Date: Mon, 14 May 2012 13:44:25 +0200
Message-ID: <1336995865.6722.22.camel@localhost>
References: <1336933308.2831.4.camel@localhost>
	 <20120514202220.5a164eb0@notabene.brown>
	 <1336992780.6722.18.camel@localhost>
	 <20120514213623.3bc1bfa5@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-RD2R6AbeGiqaLIv0BH0o"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120514213623.3bc1bfa5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-RD2R6AbeGiqaLIv0BH0o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2012-05-14, pon o godzinie 21:36 +1000, NeilBrown pisze:
> Is the array still functioning?
> Are there any interesting messages appearing in the kernel logs?

Yes and no, the array is fine, working, nothing interesting in any logs
I can see.

> What does
>   grep . /sys/block/md126/md/dev*/*
> show?

# grep . /sys/block/md126/md/dev*/*
/sys/block/md126/md/dev-sda1/errors:0
/sys/block/md126/md/dev-sda1/offset:2048
/sys/block/md126/md/dev-sda1/recovery_start:none
/sys/block/md126/md/dev-sda1/size:1953512448
/sys/block/md126/md/dev-sda1/slot:3
/sys/block/md126/md/dev-sda1/state:in_sync
/sys/block/md126/md/dev-sdb/errors:0
/sys/block/md126/md/dev-sdb/offset:2048
/sys/block/md126/md/dev-sdb/recovery_start:none
/sys/block/md126/md/dev-sdb/size:1953513560
/sys/block/md126/md/dev-sdb/slot:5
/sys/block/md126/md/dev-sdb/state:in_sync
/sys/block/md126/md/dev-sdc/errors:0
/sys/block/md126/md/dev-sdc/offset:2048
/sys/block/md126/md/dev-sdc/recovery_start:none
/sys/block/md126/md/dev-sdc/size:1953513560
/sys/block/md126/md/dev-sdc/slot:2
/sys/block/md126/md/dev-sdc/state:in_sync
/sys/block/md126/md/dev-sdf1/errors:0
/sys/block/md126/md/dev-sdf1/offset:2048
/sys/block/md126/md/dev-sdf1/recovery_start:none
/sys/block/md126/md/dev-sdf1/size:1953512448
/sys/block/md126/md/dev-sdf1/slot:4
/sys/block/md126/md/dev-sdf1/state:in_sync
/sys/block/md126/md/dev-sdg1/errors:2776
/sys/block/md126/md/dev-sdg1/offset:2048
/sys/block/md126/md/dev-sdg1/recovery_start:none
/sys/block/md126/md/dev-sdg1/size:1953512448
/sys/block/md126/md/dev-sdg1/slot:0
/sys/block/md126/md/dev-sdg1/state:faulty
/sys/block/md126/md/dev-sdh1/errors:0
/sys/block/md126/md/dev-sdh1/offset:2048
/sys/block/md126/md/dev-sdh1/recovery_start:none
/sys/block/md126/md/dev-sdh1/size:1953512448
/sys/block/md126/md/dev-sdh1/slot:6
/sys/block/md126/md/dev-sdh1/state:in_sync
/sys/block/md126/md/dev-sdi1/errors:0
/sys/block/md126/md/dev-sdi1/offset:2048
/sys/block/md126/md/dev-sdi1/recovery_start:none
/sys/block/md126/md/dev-sdi1/size:1953512448
/sys/block/md126/md/dev-sdi1/slot:1
/sys/block/md126/md/dev-sdi1/state:in_sync

Thanks,
--=20
Micha=C5=82 Sawicz <michal@sawicz.net>

--=-RD2R6AbeGiqaLIv0BH0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPsPAZAAoJEGnv7NPGHSZF7D0QAKWESxxo3N+1kuFBBbHH2Oj4
eNBNMIRzsW/4jo9Gs6IfmaTPPuV8K0JtS6+BH0ZTPoT2h6ntOQMbTJ5I1yXROKVQ
3G6znn0DzNFQfXvbcM7TdzIuZ8gI7gt3pb9duWSnrzhWn3Q6cgEHApCr7fThrIVq
mgmXQM8LuXCmz+eXEwZmYTdJg8LtPVNbovGPNNtvCaOMZwhn0Ha8cKBNb+KeWdZb
LPkCEPtpeNhfloIwYOcqI9zIpetHesALUOMPZPMQtidKlaDhnYSAPxNC+TOLxXXO
ntzAB3Ea819oO0vHmiBTnPjvN2aEC+FPIPuxioJvns8Q3D6XbeXZENxC7EW8cBfd
L8d5AjQo6HSLAfLTasT2BfuBd65DMOhMRO2hc9KwfEa2IJhul2H40iPuL/V3a62V
F0jJLRxJ+F82hPwDeZm5QhPZ+sENwHeZzFTWHfDv2pNzDMyB8gAlgtPYl8jwiY0B
6IKxqk+ZofHtEA+aBOa6Aav/d+TufkwMXRi45gFZsz19rfibx54gW8KCoRlIUW62
ZuMlW/33JWxNB6iEsqVrpRT5ULlv1YmXhZMGXzy6+KFAMalpS3GBCImhvhtofhV2
XIAjtB2F5AlHfAgGhFA0MLdQEgRw34sHk6l74X7uqc35AM/OX3E59sh+jOpEibP2
5XafKi70UpvuHIgGf/Ek
=cUT+
-----END PGP SIGNATURE-----

--=-RD2R6AbeGiqaLIv0BH0o--

