From: NeilBrown <neilb@suse.de>
Subject: Re: Panic doing BLKDISCARD on a raid 5 array on linux 3.17.3
Date: Thu, 18 Dec 2014 16:28:58 +1100
Message-ID: <20141218162858.47310158@notabene.brown>
References: <5491704D.1080709@overnetdata.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/b2hYAfbtJ80x5509Z=.If83"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5491704D.1080709@overnetdata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Wright <anthony@overnetdata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/b2hYAfbtJ80x5509Z=.If83
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Dec 2014 12:00:13 +0000 Anthony Wright <anthony@overnetdata.com>
wrote:

> I've hit a panic bug on stock linux 3.17.3 (which includes the recent
> commit on BLKDISCARD in md/raid5.c) running in Dom0 under Xen 4.1.0 that
> I've isolated to a BLKDISCARD system call within mkfs.ext3 and only
> happens on a raid 5 array (it doesn't happen on a raid 1 array).
>=20
> The system it happens on is remote and I don't have physical access to
> it, but the system administrator there is fairly helpful. We're in the
> process of commissioning the system which needs to be done tomorrow
> (thursday), so I've only got 24 hours in which I can run any tests you
> may want. If necessary I can arrange remote access, but it's a little
> complex.
>=20
> We have 3 512GB SSDs on the system, all with a GPT partition table and
> the same partition layout. All the partitions have optimal alignment
> according to parted. One of the partitions on each SSD is assembled into
> a raid 1 array, another partition is assembled into a raid 5 array. Each
> array is the used as the only physical volume in a LVM volume group. I
> then create a logical volume on each array and format the logical volume
> with mkfs.ext3. I ran mkfs.ext3 in verbose mode and also ran strace on
> it in a separate session (though it was over a network) so it's possible
> I lost the last few packets of data.
>=20
> /dev/Test/Test - 400MB LV on raid 1
> /dev/Master/Test - 400MB LV on raid 5
>=20
> A) mkfs.ext3 -E nodiscard -v /dev/Test/Test - succeeds
> B) mkfs.ext3 -v /dev/Test/Test - succeeds
> C) mkfs.ext3 -E nodiscard -v /dev/Master/Test - succeeds
> D) mkfs.ext3 -v /dev/Master/Test - panics
>=20
> mkfs.ext3 output from (B)
> -------------------------
> mke2fs 1.42.9 (28-Dec-2013)
> fs_types for mke2fs.conf resolution: 'ext3', 'small'
> Discarding device blocks: done                           Discard
> succeeded and will return 0s - skipping inode table wipe
> Filesystem label=3D
> OS type: Linux
> Block size=3D1024 (log=3D0)
> Fragment size=3D1024 (log=3D0)
> Stride=3D4 blocks, Stripe width=3D4 blocks
> 51200 inodes, 204800 blocks
> 10240 blocks (5.00%) reserved for the super user
> First data block=3D1
> Maximum filesystem blocks=3D67371008
> 25 block groups
> 8192 blocks per group, 8192 fragments per group
> 2048 inodes per group
> Superblock backups stored on blocks:
>     8193, 24577, 40961, 57345, 73729
>=20
> Allocating group tables: done                           Writing inode
> tables: done                           Creating journal (4096 blocks): do=
ne
> Writing superblocks and filesystem accounting information: done
>=20
> strace output from (B) around the BLKDISCARD
> --------------------------------------------
> gettimeofday({1418806647, 890754}, NULL) =3D 0
> gettimeofday({1418806647, 890814}, NULL) =3D 0
> ioctl(3, BLKDISCARD, {0, 3000000010})   =3D 0
> write(1, "Discarding device blocks: ", 26) =3D 26
> write(1, "  1024/204800", 13)           =3D 13
> write(1, "\10\10\10\10\10\10\10\10\10\10\10\10\10", 13) =3D 13
> ioctl(3, BLKDISCARD, {100000, 3000000010}) =3D 0
> write(1, "             ", 13)           =3D 13
> write(1, "\10\10\10\10\10\10\10\10\10\10\10\10\10", 13) =3D 13
> write(1, "done                            "..., 33) =3D 33
> write(1, "Discard succeeded and will retur"..., 65) =3D 65
>=20
> mkfs.ext3 output from (D)
> -------------------------
> mke2fs 1.42.9 (28-Dec-2013)
> fs_types for mke2fs.conf resolution: 'ext3', 'small'
> <Panic>
>=20
> strace output from (D) around the BLKDISCARD
> --------------------------------------------
> gettimeofday({1418809706, 244197}, NULL) =3D 0
> gettimeofday({1418809706, 244259}, NULL) =3D 0
> ioctl(3, BLKDISCARD, {0, 3000000010}
> <Panic>
>=20
> I have a photograph of the panic output from a previous session which
> includes raid5d and blk_finish_plug in the stack trace, unfortunately I
> don't have the top part of the panic and vger won't accept the
> attachment. I also have a photograph of the console output from the
> crash at (D), but in this case it outputs to the console every 180 second=
s:
>=20
> INFO: rcu_sched self-detected stall on CPU { 1}
> sending NMI to all CPUs:
> xen: vector 0x2 is not implemented
>=20
> thanks,
>=20
> Anthony Wright

Presumably you have deliberately enabled DISCARD support by setting the
  raid456.devices_handle_discard_safely

modules parameters?  Otherwise the DISCARD should be a no-op.

It is very hard to deduce anything without the full Oops.  Do you have acce=
ss
to another machine on the same subnet?  If so you could enable netconsole a=
nd
capture the full oops from the other machines (all console messages are sent
via UDP at a very low level).


I suspect md/raid5 is sending down a discard request in some way that the
scsi/sata layer or driver doesn't like, but without the full oops, I really
cannot guess what it might be.

NeilBrown

--Sig_/b2hYAfbtJ80x5509Z=.If83
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVJJmGjnsnt1WYoG5AQKAXg/8DWTJlUcGTr2IcyqsfGAQ/fYV1kjnagoV
/gT6dXr4RWFglcc15t+lX5qlrR3e5Ne5MzVtE2Df7BoBMMuLouCHkJEANiZTTtu5
LfQOI6l88wVshQbFMIyrEfvw55PpBQLSR/JHJ0+j9Q90IsUYFvqILCN39oQk92As
m+k38CIFW5VrvJpVRwnMdXOWRx0HxQFTiueDQCO9TqAiFL0z6NghShibGCgmPXma
ENmWJUlD+WAuwPPgX8/UHm3MKoc59rLYyFKR/8HlSBYDMgPWZXcwhLnzB21lQh6z
FlxquJtOr8Pt04F28me86jnx1sYeQfV2845nmxCtqYoE3IIyBU7liUy+mCsgyaW6
rig8+JcTSGEQ6CpJT6eYWSxmSa1JvKep8HzGHSZWfqTCYBbCZJ2l8SUZ3SvAnSDx
OQ2CQsYvD1Jp888KnkNevi9Hno8RRqrtTTKt1yctUHC69k9oMmJIExqtixV1JvK7
7Eb7ocPcHYFXM4tTF6n0BfIg0jyNZKiMMJfXKwPdmj6FLNLGfdgr+/XFX3xzv0AO
bGY2x/2nL1/0frlB5o2I4GVa4eYMMl1sdi1neZ4N8P/H5u87ZoRpofxYsrr7ICmP
lPXnarGw84axYavaOG4gxH3XZHleueKLaPeyfN0rdc8hVrDH6dXFWKJOI2YWdkli
pAwnA9rg8+I=
=mdl4
-----END PGP SIGNATURE-----

--Sig_/b2hYAfbtJ80x5509Z=.If83--
