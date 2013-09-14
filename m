From: NeilBrown <neilb@suse.de>
Subject: Re: Inoperative array shown as "active"
Date: Sat, 14 Sep 2013 15:59:12 +1000
Message-ID: <20130914155912.5ba135d9@notabene.brown>
References: <l10sq0$e24$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.LyhhHUZOIqX5acFljqk1Le"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <l10sq0$e24$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.LyhhHUZOIqX5acFljqk1Le
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 14 Sep 2013 00:39:20 -0500 Ian Pilcher <arequipeno@gmail.com> wrote:

> I'm in the process of writing a program to monitor various aspects of
> my NAS.  As part of this effort, I've been simulating RAID disk failures
> in a VM, and I noticed something that seems very odd.
>=20
> Namely, when a sufficient number of disks has been removed from a RAID-5
> or RAID-6 array to make it inoperable, the array is still shown as
> "active" in /proc/mdstat and "clean" in the sysfs array_state file.  For
> example:
>=20
> md0 : active raid5 sde[3](F) sdd[2] sdc[1](F) sdb[0]
>       6286848 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/2] [U_=
U_]
>=20
> (mdadm does show the state as "clean, FAILED".)
>=20
> Is this the expected behavior?

Yes.

>=20
> AFAICT, this means that there is no single item in either /proc/mdstat
> or sysfs that indicates that an array such as the example above has
> failed.  My program will have to parse the RAID level, calculated the
> number of failed members (if any), and determine whether that RAID level
> can survive that number of failures.  Is this correct?

Yes.

>=20
> Anything I'm missing?

mdadm already does this for you. "mdadm --detail /dev/md0".

NeilBrown

>=20
> Thanks!
>=20


--Sig_/.LyhhHUZOIqX5acFljqk1Le
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjP7MTnsnt1WYoG5AQIT5w/+Ph/SyMTq1GNc8bwdaS6D4eldqylqKuaY
WdqVI2KEk9hTNnsBhXWwRbglHV0IqwI61iZjc6wqJ5RBnKiTmuG/yGJnl6XZI+wF
BPiEE+TXiaC1NYZsfWKVs87PMTlJAjp6X5jbW6WelAZovUG5vrR/YN+8vxONfo7D
EZjp2Q4NCfL69oIpBh/whetEP29Qsnum0Ll4G3HNa0pYX9ScvFFQAEpqwxinE21g
Dy37znQ1rZ4q0t4vSJjO7dPbusqyC5KtS0vPCfwjdOF7FAeyih8vCZlziJjQOFch
4uXrPxWvW0IbVOqicxKtkXVqtY7bxYTJcvYntFPZYbvBNM+1gy29lzXfM8rBz6dh
a9XG5scttyiI/d1kECmLgM9U96R3EfoCHTOqkATx9q0itFwPvomvJpu7eu/ckjTW
tMYu5d3btiHs6hIxkvmxZZ53gIDJklm0DbXY4XGDvVHNolwaWbDV1ZkaQdDETO1H
2lMpDx2oxWHrY9474pu3bQIj2uSJ1h/up1W0k7rbZcUfY+J9OZGbFY8hAKYYOqaT
R9DT5wRit+PM6APPHXF+vLzrzrQY8Nvjyd5RxmXG/3xdnrrrY8EpBANNqb/tm6ox
VNyY1iAyIooXOhzSkpn/iTxxWlVDaAW8cAPWeFP7Q/IZ6GMU/WqX1J+nbGPX6c1a
UGratLl/iLk=
=F4uZ
-----END PGP SIGNATURE-----

--Sig_/.LyhhHUZOIqX5acFljqk1Le--
