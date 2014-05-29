From: NeilBrown <neilb@suse.de>
Subject: Re: Understanding raid array status: Active vs Clean
Date: Thu, 29 May 2014 15:16:58 +1000
Message-ID: <20140529151658.3bfc97e5@notabene.brown>
References: <CAG__1a4MRV6gJL38XLAurtoSiD3rLBTmWpcS5HYvPpSfPR88UQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_N=5KXkNfUef72fVkkL0ESH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG__1a4MRV6gJL38XLAurtoSiD3rLBTmWpcS5HYvPpSfPR88UQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Duffield <forumscollective@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/_N=5KXkNfUef72fVkkL0ESH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 May 2014 22:08:40 +0200 George Duffield
<forumscollective@gmail.com> wrote:

> I recently created a raid 5 array under Arch Linux running on a HP
> Microserver using pretty much the same topography as I do under Ubuntu
> Server.  The creation process went fine and the array is accessible,
> however, from the outset it's only ever reported status as Active
> rather than Clean.
>=20
> After creating the array, watch -d cat /proc/mdstat returned:
>=20
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sda1[0] sdc1[2] sde1[5] sdb1[1] sdd1[3]
>       11720536064 blocks super 1.2 level 5, 512k chunk, algorithm 2
> [5/5] [UUUUU]
>       bitmap: 2/22 pages [8KB], 65536KB chunk
>=20
> unused devices: <none>
>=20
> which to me pretty much looks like the array sync completed successfully.
>=20
> I then updated the config file, assembled the array and formatted it usin=
g:
> mdadm --detail --scan >> /etc/mdadm.conf
> mdadm --assemble --scan
> mkfs.ext4 -v -L offsitestorage -b 4096 -E stride=3D128,stripe-width=3D512=
 /dev/md0
>=20
> mdadm --detail /dev/md0 returns:
>=20
> /dev/md0:
>         Version : 1.2
>   Creation Time : Thu Apr 17 01:13:52 2014
>      Raid Level : raid5
>      Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
>   Used Dev Size : 2930134016 (2794.39 GiB 3000.46 GB)
>    Raid Devices : 5
>   Total Devices : 5
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Thu Apr 17 18:55:01 2014
>           State : active
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>            Name : audioliboffsite:0  (local to host audioliboffsite)
>            UUID : aba348c6:8dc7b4a7:4e282ab5:40431aff
>          Events : 11306
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync   /dev/sda1
>        1       8       17        1      active sync   /dev/sdb1
>        2       8       33        2      active sync   /dev/sdc1
>        3       8       49        3      active sync   /dev/sdd1
>        5       8       65        4      active sync   /dev/sde1
>=20
> So, I'm now left wondering why the state of the array isn't "clean"?
> Is it normal for arrays to show a state of "active" instead of clean
> under Arch - is it simply a matter of Arch is packaged with a more
> recent version of mdadm than Ubuntu Server?

I doubt there is a difference between Ubuntu and Arch here.

The array should show "active" in "mdadm --detail" output for 200ms after t=
he
last write, and then switch to 'clean'.
So if you are writing every 100ms, it will always say "active".

NeilBrown

--Sig_/_N=5KXkNfUef72fVkkL0ESH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4bCyjnsnt1WYoG5AQL3exAAttfkoF0aU/P5eX0ZWWk29Dz6vqGnlWug
aZAjmokz7x2DTmMsgm/vZBZdM7R0x79+nrE2klouZ+SLKSFXXmW3ZONGgTr1crLF
kDbRcUwqoezx6dgyT1vSsC2FnSTAM5pDHOexirUZ+EpiZcW2grVuwwlKg9yDK7ug
g2fHqh+XVJeBSGejD3U2EOfXZiIITlz6b0xqBWWNFdGdRLhbDbWeTUx5zUZEaZVI
fzpYz7qIbCm2vsf9i3JJhfeAcW+rGRObZDDOgFKE6sxfdk9QmecXKHD8OXCpu74c
9w5VGtgxirbZfTuAbQLNZkWckhL4f2DANiGyC+cpJzloNPa85pe79jVARSGW5b6H
etRT/VtxQv2B6KSz2CoTfdhgOOKhcR77wsCjJn1Kt7w12a/A3gFkffqc1IU5a6Oa
uHdERHQFy7Wnc0FerZ9kVlB6k95USbpS7OcW9f0CyRH3wDJYzaLsC+wltzwiCsjd
RGHlBD51idKfBzWyVar/RdRnGcfx4d3lFaWbxuB1woRxA3pYeRl/vYK0ruGaS7iU
q8yOnP+sh85rW4go4SZidHBEJW4iypoancICypa6nc/uRHrVtNmSYGS9XktmOfbK
J+dTIVt7qeJKfLGyzqOSxpm6cm7s3Ojn+Mp93xW0dytJ+YrN4TMfWATE1gs1q6U6
XB+w2h6SJLQ=
=IMGb
-----END PGP SIGNATURE-----

--Sig_/_N=5KXkNfUef72fVkkL0ESH--
