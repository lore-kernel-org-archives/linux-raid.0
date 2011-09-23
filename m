From: NeilBrown <neilb@suse.de>
Subject: Re: potentially lost largeish raid5 array..
Date: Fri, 23 Sep 2011 14:32:10 +1000
Message-ID: <20110923143210.583e11ec@notabene.brown>
References: <201109221950.36910.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4EdauhzQo0Jz9qhHaFHpuBf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201109221950.36910.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4EdauhzQo0Jz9qhHaFHpuBf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Sep 2011 19:50:36 -0600 Thomas Fjellstrom <tfjellstrom@shaw.ca>
wrote:

> Hi,
>=20
> I've been struggling with a SAS card recently that has had poor driver su=
pport=20
> for a long time, and tonight its decided to kick every drive in the array=
 one=20
> after the other. Now mdstat shows:
>=20
> md1 : active raid5 sdf[0](F) sdh[7](F) sdi[6](F) sdj[5](F) sde[3](F) sdd[=
2](F)=20
> sdg[1](F)
>       5860574208 blocks super 1.1 level 5, 512k chunk, algorithm 2 [7/0]=
=20
> [_______]
>       bitmap: 3/8 pages [12KB], 65536KB chunk
>=20
> Does the fact that I'm using a bitmap save my rear here? Or am I hosed? I=
f I'm=20
> not hosed, is there a way I can recover the array without rebooting? mayb=
e=20
> just a --stop and a --assemble ? If that won't work, will a reboot be ok?
>=20
> I'd really prefer not to have lost all of my data. Please tell me (please=
)=20
> that it is possible to recover the array. All but sdi are still visible i=
n=20
> /dev (I may be able to get it back via hotplug maybe, but it'd get sdk or=
=20
> something).
>=20

mdadm --stop /dev/md1

mdadm --examine /dev/sd[fhijedg]
mdadm --assemble --verbose /dev/md1 /dev/sd[fhijedg]

Report all output.

NeilBrown


--Sig_/4EdauhzQo0Jz9qhHaFHpuBf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOfAvKG5fc6gV+Wb0RAod5AKDD/kNYpiNlvYQ0BgBXfazzk0JjbACeJvr9
nZ41KzZGQ4rQMf76l5X2N1E=
=Ykya
-----END PGP SIGNATURE-----

--Sig_/4EdauhzQo0Jz9qhHaFHpuBf--
