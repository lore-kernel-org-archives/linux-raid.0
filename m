From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Mon, 21 Sep 2009 16:56:21 +0100
Message-ID: <20090921155621.GA29813@cthulhu.home.robinhill.me.uk>
References: <70ed7c3e0909171509k45d08dd6lbba9e15a710c3a43@mail.gmail.com>
 <200909211132543.SM05052@trainer>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200909211132543.SM05052@trainer>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Sep 21, 2009 at 11:32:17AM -0400, Sunpyo Hong wrote:

> Here's some more info:
>=20
> Before
> root@ubuntu:/home/ubuntu# cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]=20
> md2 : active raid5 sdb4[2] sdc4[1] sdd4[0]
>       5856150144 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>      =20
> md0 : active raid1 sdd1[0] sdb1[2] sdc1[1]
>       208768 blocks [4/3] [UUU_]
>=20
What exactly is this "before"?  Is this the state of the array when you
first connected (before trying anything else)?  If so, then this should
be the correct device order and chunk size.

Here md2 has the same device order as md0:
    0 =3D> sdd
    1 =3D> sdc
    2 =3D> sdb

> Now.
> root@ubuntu:/home/ubuntu# cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]=20
> md2 : active raid5 sdd4[2] sdb4[1] sdc4[0]
>       5856150144 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>      =20
> md0 : active raid1 sdd1[0] sdb1[2] sdc1[1]
>       208768 blocks [4/3] [UUU_]
>=20
And here it has a different order.  If the array mounted fine in the
"Before" state but doesn't now, then I'd say you need to recreate the
array in the correct order.

> [58638.991719] RAID5 conf printout:
> [58638.991720]  --- rd:4 wd:3
> [58638.991722]  disk 0, o:1, dev:sdc4
> [58638.991724]  disk 1, o:1, dev:sdb4
> [58638.991726]  disk 2, o:1, dev:sdd4
> [58638.993434]  md2: unknown partition table
> [58672.600433] VFS: Can't find ext3 filesystem on dev md2.
> [59137.799835] md: md2 stopped.
> [59137.799848] md: unbind<sdd4>
> [59137.800920] md: export_rdev(sdd4)
> [59137.800961] md: unbind<sdb4>
> [59137.804771] md: export_rdev(sdb4)
> [59137.804778] md: unbind<sdc4>
> [59137.804808] md: export_rdev(sdc4)
> [59166.007689] md: bind<sdd4>
> [59166.012173] md: bind<sdc4>
> [59166.014076] md: bind<sdb4>
> [59166.021627] raid5: device sdb4 operational as raid disk 2
> [59166.021630] raid5: device sdc4 operational as raid disk 1
> [59166.021633] raid5: device sdd4 operational as raid disk 0
> [59166.022090] raid5: allocated 4219kB for md2
> [59166.022092] raid5: raid level 5 set md2 active with 3 out of 4 devices,
> algorithm 2
> [59166.022095] RAID5 conf printout:
> [59166.022097]  --- rd:4 wd:3
> [59166.022099]  disk 0, o:1, dev:sdd4
> [59166.022100]  disk 1, o:1, dev:sdc4
> [59166.022102]  disk 2, o:1, dev:sdb4
> [59166.023663]  md2: unknown partition table
> [59219.038548] VFS: Can't find ext3 filesystem on dev md2.
> [59446.152543] kjournald starting.  Commit interval 5 seconds
> [59446.153319] EXT3 FS on sda1, internal journal
> [59446.153323] EXT3-fs: mounted filesystem with ordered data mode.
> [59527.884970] VFS: Can't find ext3 filesystem on dev md2.
> [60189.928644] VFS: Can't find ext3 filesystem on dev md2.
> [60649.834143] VFS: Can't find ext4 filesystem on dev md2.
>=20
And this output appears to show it assembling the array in two different
orders (both the "before" and "now" order), and failing to mount it in
either.  Is this from a single boot or is this as you're stopping &
recreating the array?

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq3oiQACgkQShxCyD40xBInvwCg2Dq9bu5rmlMUpJQZjSTeO1F0
upUAoKVaB5nZ9Lyky66O2ksY/FPjM0Kl
=a0qE
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
