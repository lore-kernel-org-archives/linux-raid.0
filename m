From: NeilBrown <neilb@suse.de>
Subject: Re: raid10 make_request failure during iozone benchmark upon btrfs
Date: Mon, 2 Jul 2012 12:52:27 +1000
Message-ID: <20120702125227.179c4343@notabene.brown>
References: <4FF108A8.6090606@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MKz75Al6rT7fn9hl1cdrWQv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FF108A8.6090606@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kerin Millar <kerframil@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/MKz75Al6rT7fn9hl1cdrWQv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Jul 2012 03:34:16 +0100 Kerin Millar <kerframil@gmail.com> wrote:

> Hello,
>=20
> I'm running a 4-way RAID-10 array with the f2 layout scheme on a 3.5-rc5

I thought I fixed this in 3.5-rc2.
Maybe there is another bug....

Could you please double check that you are running a kernel with

commit aba336bd1d46d6b0404b06f6915ed76150739057
Author: NeilBrown <neilb@suse.de>
Date:   Thu May 31 15:39:11 2012 +1000

    md: raid1/raid10: fix problem with merge_bvec_fn

in it?

Thanks,
NeilBrown


> kernel:
>=20
> Personalities : [raid10] [raid6] [raid5] [raid4]
> md0 : active raid10 sdb2[4] sdd2[3] sdc2[2] sda2[1]
>        5860462592 blocks super 1.1 256K chunks 2 far-copies [4/4] [UUUU]
>=20
> I am also using LVM, with md0 serving as the sole PV in a volume group
> named vg0. The drives are brand new Hitachi Desktar 5K3000 drives and
> they are known to be in good health. XFS is my filesystem of choice but
> I recently created a volume so that I could benchmark btrfs with iozone
> (just out of curiosity). The volume arrangement is as follows:
>=20
> # lvs -o lv_name,lv_attr,lv_size,seg_pe_ranges
>    LV     Attr   LSize   PE Ranges
>    public -wi-ao   3.00t /dev/md0:25600-812031
>    rootfs -wi-ao 100.00g /dev/md0:0-25599
>    test   -wi-ao   2.00g /dev/md0:812032-812543
>=20
> The btrfs filesystem was created as follows:
>=20
> # mkfs.btrfs /dev/vg0/test
> ...
> fs created label (null) on /dev/vg0/test
>          nodesize 4096 leafsize 4096 sectorsize 4096 size 2.00GB
> Btrfs Btrfs v0.19
>=20
> I'm not sure whether this is a bug in the raid10 code but I am
> encountering a reproducible error while running iozone -a. It triggers
> during the tests that read and write 2MiB with a 4KiB record length.
> Here's the tail end of iozone's output:
>=20
> 2048  4  530020  473540  1660915  1655474  1427182  388846  1405465  5588=
11  1394966  462500  520324
>=20
> Error in file: Found ?101010101010101? Expecting ?6d6d6d6d6d6d6d6d? addr =
7ff7c8700000
> Error in file: Position 131072
> Record # 32 Record size 4 kb
> where 7ff7c8700000 loop 0
>=20
> Note that the last two column's worth of figures are missing, implying
> that the failure occurs when iozone is running the fread/freread tests.
>=20
> Here are the error messages from the kernel ring buffer:
>=20
> [  919.893454] md/raid10:md0: make_request bug: can't convert block acros=
s chunks or bigger than 256k 6653500160 256
> [  919.893465] btrfs: bdev /dev/mapper/vg0-test errs: wr 1, rd 0, flush 0=
, corrupt 0, gen 0
> [  919.894060] md/raid10:md0: make_request bug: can't convert block acros=
s chunks or bigger than 256k 6653500672 256
> [  919.894070] btrfs: bdev /dev/mapper/vg0-test errs: wr 2, rd 0, flush 0=
, corrupt 0, gen 0
> [  919.894634] md/raid10:md0: make_request bug: can't convert block acros=
s chunks or bigger than 256k 6653501184 256
> [  919.894643] btrfs: bdev /dev/mapper/vg0-test errs: wr 3, rd 0, flush 0=
, corrupt 0, gen 0
> [  919.895225] md/raid10:md0: make_request bug: can't convert block acros=
s chunks or bigger than 256k 6653501696 256
> [  919.895234] btrfs: bdev /dev/mapper/vg0-test errs: wr 4, rd 0, flush 0=
, corrupt 0, gen 0
> [  919.895801] md/raid10:md0: make_request bug: can't convert block acros=
s chunks or bigger than 256k 6653502208 256
> [  919.895811] btrfs: bdev /dev/mapper/vg0-test errs: wr 5, rd 0, flush 0=
, corrupt 0, gen 0
> [  919.896390] md/raid10:md0: make_request bug: can't convert block acros=
s chunks or bigger than 256k 6653502720 256
> [  919.896399] btrfs: bdev /dev/mapper/vg0-test errs: wr 6, rd 0, flush 0=
, corrupt 0, gen 0
> [  919.896981] md/raid10:md0: make_request bug: can't convert block acros=
s chunks or bigger than 256k 6653503232 256
> [  919.896990] btrfs: bdev /dev/mapper/vg0-test errs: wr 7, rd 0, flush 0=
, corrupt 0, gen 0
> [  920.029589] md/raid10:md0: make_request bug: can't convert block acros=
s chunks or bigger than 256k 6653504256 256
> [  920.029603] btrfs: bdev /dev/mapper/vg0-test errs: wr 8, rd 0, flush 0=
, corrupt 0, gen 0
> [  920.030208] md/raid10:md0: make_request bug: can't convert block acros=
s chunks or bigger than 256k 6653504768 256
> [  920.030222] btrfs: bdev /dev/mapper/vg0-test errs: wr 9, rd 0, flush 0=
, corrupt 0, gen 0
> [  920.030788] md/raid10:md0: make_request bug: can't convert block acros=
s chunks or bigger than 256k 6653505280 256
> [  920.030802] btrfs: bdev /dev/mapper/vg0-test errs: wr 10, rd 0, flush =
0, corrupt 0, gen 0
> [  920.031385] md/raid10:md0: make_request bug: can't convert block acros=
s chunks or bigger than 256k 6653505792 256
> [  920.031957] md/raid10:md0: make_request bug: can't convert block acros=
s chunks or bigger than 256k 6653506304 256
> [  920.032551] md/raid10:md0: make_request bug: can't convert block acros=
s chunks or bigger than 256k 6653506816 256
> [  920.033135] md/raid10:md0: make_request bug: can't convert block acros=
s chunks or bigger than 256k 6653507328 256
> [  920.161304] btrfs no csum found for inode 328 start 131072
> [  920.180249] btrfs csum failed ino 328 off 131072 csum 2259312665 priva=
te 0
>=20
> I have no intention of using btrfs for anything other than
> experimentation. Sill, my fear is that something could be amiss in
> the guts of the raid10 code. I'd welcome any insights as to what is
> happening here.
>=20
> Cheers,
>=20
> --Kerin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/MKz75Al6rT7fn9hl1cdrWQv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/EM6znsnt1WYoG5AQIGNw/9HnauceHn23lFSrk9Q/yyoCGiuJ0v7NmM
p1cJIz+I52JQ2t9sl/I9hr2+sk0hFa2GyynCtMYaMEnpXvrENehIJMmYM3POA6pv
S/J7g0v1gRpW1nk+o+NmbIjW9PWoltSX1bMReYKnlaLl6g8U+v+UR+HWGPI6+y/X
9WBvZbdGhcaBxIFStzUxM+KQxIuY0vHUr6omwsqpRXeLOPEtub9TOb6qHxHPcE/m
xO3HedONDmAKpbssNsvSkK5cOPsBhuUbAUNr93JwMRC9IMEknFpey8vk4MNiO89f
Ga+Tza7YKmSwJoBxPeexqIIISZFUEgIFgJLPFgKVStCuaAo8Agy56x9Uujjv+1dT
Y88k7y8431PKvz2AG0rKWkIw0uWzq8iUbMSqn39fh5A4HjQ4WuPO1ZpC7QzQfwfr
vsPAsCezEpeXYhlNsNWvkD8zbuu3owZe+kPCsfbha0z8186A2TuGfbRA9f3kB8rc
6iWfDo8FeQz/zj6aEDUC0/p8NnBNLnqaAoLTXfwStrSM5LePiYodW4oFZT1z80pB
pB76dvdeXgG8xxvi3WgNGG+ksmoMNTIu66Dam935w+9auqRihb+MyczJicXwWnoC
d9wHee+JKpYN+oILzhG6wcmcsQ89sG3yiLGd58xNJzNhj8NWVrUNuS8yyGFhmR3j
WA1sRnogpVg=
=/NGm
-----END PGP SIGNATURE-----

--Sig_/MKz75Al6rT7fn9hl1cdrWQv--
