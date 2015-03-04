From: NeilBrown <neilb@suse.de>
Subject: Re: RAID0 & diskstats.
Date: Thu, 5 Mar 2015 08:31:11 +1100
Message-ID: <20150305083111.5932159e@notabene.brown>
References: <20150304210904.GA26981@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ImIAj6fD422Wlop5TjrGOKv"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150304210904.GA26981@codemonkey.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Jones <davej@codemonkey.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ImIAj6fD422Wlop5TjrGOKv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Mar 2015 16:09:04 -0500 Dave Jones <davej@codemonkey.org.uk> wrot=
e:

> Hi Neil,
>    According to Documentation/iostats.txt, the 9th column of
> /proc/diskstats (and its modern replacement in sysfs) should go to 0
> as IO completes.
>=20
> I assembled a RAID0 stripe using two SSD's, and saw this..
>=20
> # mdadm --assemble /dev/md0
> mdadm: /dev/md0 has been started with 2 drives.
> # cat /sys/block/md0/stat
>      167        0     5656        0        5        0     4096        0  =
   172     3408   582825
> # cat /sys/block/md0/stat
>      167        0     5656        0        5        0     4096        0  =
   172   231469 39809317
>=20
> The 10th & 11th fields constantly increase, as field 9 remains non-zero.
> If I mount and umount a filesystem on that volume, it works as expected,
> but the 9th 'IOs inflight' field continues to rise and never decreases ev=
en
> though the IO has obviously completed.
>=20
> # umount /mnt/ssd
> # cat /sys/block/md0/stat
>      167        0     5656        0        9        0     4225        0  =
   176   571384 98278615
>=20
> The underlying disks have their respective stats entries behaving as
> expected, it only seems to affect the upper md layer.
>=20
> Some missing accounting somewhere in md ?
>=20
> (Only tested on 4.0rc2 so far, and only on RAID0)
>=20
> 	Dave

blockdev stats often aren't really a good match for md/raid...

"in_flight" assumes a queue, and raid0 doesn't have one.  It just redirects
each request to the relevant device and lets the device handle it.

The only useful thing we could do here is make that value always zero.=20


I guess I need to add a "generic_end_io_acct()" call to md.c somewhere.
For raid1/5 there is probably somewhere sensible to put it.
For raid0/linear, it probably goes immediately after generic_start_io_acct(=
).

Patches welcome :-)

NeilBrown

--Sig_/ImIAj6fD422Wlop5TjrGOKv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVPd5nznsnt1WYoG5AQLe2Q//cT/3VWONiZscxLAFW2NHDPstRvGZUy7E
0pXHp2SuEFG9kJeFq2qTgRqZexK6xyEYe1r11wT/+B8ZMZg2K5dtf5DHABdpZwwg
yY4z2tH8oFbNb5JRT0y5QGR4Uyfeln3mCbTmazYB0w6XW6IXZ4rxq3eE24xLnKNV
D1oCiVx1i6XlIDqeXsoBRb7qKfCXTU5EnqTMZMNtNGc5qccq+J71xRgtAeZm40dJ
1eXeiIHiK54LG+LpBtplsDdrSNwM2ATt3qEQ7A8Smm16aTo0Lj6Oxlq3dTuv8Sc7
NEVdn+AcQjgSXT7HzuK7PuLPlRkEkxqkK7hOMSkkfMmAzma08Esv2TBTOISoHTfm
GOd7D6kZ2h9qSaklVSAVDSEjiQvRHEJY5wqS5lyg/LxA00UuI5ZeBbIyrvFo7RC2
95JDdZ4gAytgz+Gdd9ToBbD0qb+jB0LdJVkLFwJ7HpNjG8cNWKdhIZ0xriHHv2UI
e24stH1rapZPFFKeeX2dkDy8CuVRtqrWuqFpvjyNQvx/Cqbt75LpeHPdKDAhFZed
UXG8okmRAmJp1VHIQf7szgCFysKCcwGa2cY7Bpewem343MEZadhBPq74pLgl0snm
HrlWQWXS1Y3EDWJs3swl14wHmy5jUL/p24HRoGb1osvSuTGaMJeihWtxI9vzZEs6
7e1aXaSQPFo=
=2s7O
-----END PGP SIGNATURE-----

--Sig_/ImIAj6fD422Wlop5TjrGOKv--
