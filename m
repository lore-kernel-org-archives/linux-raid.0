From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 assemble fails after reboot while reshaping
Date: Mon, 18 May 2015 10:03:42 +1000
Message-ID: <20150518100342.4fe761a7@notabene.brown>
References: <5558C551.80203@die-fuckners.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/UT4EEDIxCZd1FqQB+fyM7ro"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5558C551.80203@die-fuckners.de>
Sender: linux-raid-owner@vger.kernel.org
To: Marco Fuckner <marco@die-fuckners.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/UT4EEDIxCZd1FqQB+fyM7ro
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 17 May 2015 18:44:01 +0200 Marco Fuckner <marco@die-fuckners.de>
wrote:

> Hi everybody,
>=20
> first of all, I'm using mdadm 3.3.2 on linux 4.0.1, all of my disks are
> partitioned with the same geometry.
>=20
> I wanted to grow my 4 disk RAID5 array to 7 disks. After adding the
> disks and initiating the grow, the reshape didn't seem to start:
>=20
>     md0 : active raid5 sdf1[7] sde1[6] sdd1[5] sdg1[3] sdb1[4] sdh1[1]
> sdc1[0]
>         11720044800 blocks super 1.2 level 5, 256k chunk, algorithm 2
> [7/7] [UUUUUUU]
>         [>....................]  reshape =3D  0.0% (0/3906681600)
> finish=3D166847860.0min speed=3D0K/sec
>         bitmap: 0/30 pages [0KB], 65536KB chunk
>=20
> I waited about three hours and checked again:
>=20
>     md0 : active raid5 sdf1[7] sde1[6] sdd1[5] sdg1[3] sdb1[4] sdh1[1]
> sdc1[0]
>         11720044800 blocks super 1.2 level 5, 256k chunk, algorithm 2
> [7/7] [UUUUUUU]
>         [>....................]  reshape =3D  0.0% (0/3906681600)
> finish=3D9599856140.0min speed=3D0K/sec
>         bitmap: 0/30 pages [0KB], 65536KB chunk


This looks very much like  the reshape has not done anything at all.
i.e. your data is still exactly where you left it, it is just a case of
getting hold of it.

It's not impossible that running the --assemble with --update=3Drevert-resh=
ape
would work, but I'm far from certain.  If you backed up the first gigabyte =
of
each device (sd?1) first then it would probably be safe enough to try.

Another option is to add --invalid-backup to the --assemble command.
This has a reasonable chance of allowing the reshape to continue, but also
has a reasonable chance of corrupting the first few megabytes of your array
(the part that it things should be backed up).
If you "make test_stripe" in the mdadm source code, you can use that to ext=
ra
the first few megabytes of array data so you could restore it if it gets
corrupted.
Something like
   test_stripe save /root/thing 4 262144 5 2 0 \
   $BIGNUM /dev/sdc1:262144 /dev/sdh1:262144 ......

Check the source to make sure you get the args right.
Make sure the order of the devices and their data_offsets are correct.  che=
ck
the "Device Role:" for each and order them by that number.

Another option is to recreate the array as 4-drive RAID5.  Again you need to
make sure the device order and data offsets are correct, along with all the
other data.

I might be able to dig into the code and find out what happened and maybe
offer an "easier" solution, but that won't be for a day or two at least.


NeilBrown



>=20
> Unfortunately, I forgot to save the output of the grow command, but it
> exited with 0.
> /mdadm --misc --detail /dev/md0/ didn't show anything suspicious to me:
>=20
> /dev/md0:
>     Version : 1.2
>     Creation Time : Sun Nov  9 02:38:25 2014
>     Raid Level : raid5
>     Array Size : 11720044800 (11177.11 GiB 12001.33 GB)
>     Used Dev Size : 3906681600 (3725.70 GiB 4000.44 GB)
>     Raid Devices : 7
>     Total Devices : 7
>     Persistence : Superblock is persistent
>=20
>     Intent Bitmap : Internal
>=20
>     Update Time : Mon May 11 11:55:07 2015
>     State : clean, reshaping
>     Active Devices : 7
>     Working Devices : 7
>     Failed Devices : 0
>     Spare Devices : 0
>=20
>     Layout : left-symmetric
>     Chunk Size : 256K
>=20
>     Reshape Status : 0% complete
>     Delta Devices : 3, (4->7)
>=20
>     Name : anaNAS:0  (local to host anaNAS)
>     UUID : 33f0604f:46e80f5e:11b1a694:608fd9b3
>     Events : 51839
>=20
>     Number   Major   Minor   RaidDevice   State
>         0           8           33        0              active sync =20
> /dev/sdc1
>         1           8           113      1              active sync =20
> /dev/sdh1
>         3           8           97        2              active sync =20
> /dev/sdg1
>         4           8           17        3              active sync =20
> /dev/sdb1
>         7           8           81        4              active sync =20
> /dev/sdf1
>         6           8           65        5              active sync =20
> /dev/sde1
>         5           8           49        6              active sync =20
> /dev/sdd1
>=20
> As it looked like it wouldn't be ready until long after my death and I
> also wrote a backup file, somehow restarting and continuing afterwards
> seemed reasonable to me.
> The source I was reading suggested running /mdadm /dev/md0 --continue
> --backup-file=3D$FILE/. Apparently this command was wrong, and I couldn't
> reassamble the array:
>=20
> # mdadm --assemble /dev/md0 --verbose /dev/sd[b-h]1
> --backup-file=3D/root/grow7backup.bak
>=20
>     mdadm: looking for devices for /dev/md0
>     mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 4.
>     mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 5.
>     mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 6.
>     mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 2.
>     mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 3.
>     mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 1.
>     mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 0.
>     mdadm: :/dev/md0 has an active reshape - checking if critical
> section needs to be restored
>     mdadm: No backup metadata on /root/grow7backup.bak
>     mdadm: No backup metadata on device-4
>     mdadm: No backup metadata on device-5
>     mdadm: No backup metadata on device-6
>     mdadm: Failed to find backup of critical section
>     mdadm: Failed to restore critical section for reshape, sorry.
>=20
> I started searching for answers but didn't find anything helpful except
> the hint on the raid.wiki.kernel.org page to send an email here. The
> last sentence from mdadm sounds a bit pessimistic, but I hope someone in
> here can help me. The output of /mdadm --examine /dev/sd[bh]1 /is in the
> attachment.
>=20
> Thanks in advance,
>=20
> Marco


--Sig_/UT4EEDIxCZd1FqQB+fyM7ro
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVksXznsnt1WYoG5AQLoWxAAurc73U9QfQaSHmzZ96UAa8fdOHAWZm27
toRty+M/gxrypqFxHp6NGFONbpfXcPSZUCwak0wcZeTsINlURdJXlsaHFSbp3Ddt
9zw1qv45L3GS4bJ/hQz/NBuLxP2ZGyyrXfA7PMbJY0imQg+dUqbPIL2FvCaF+H0W
l7SBwbx/4jFmRPtEMWXBBvqfUwR47gPJYAy6Fx0UL/hzQ/vA7hXveBzKfoc7J/A/
osCyfR0qCvkXsSaqWaQwsC5ur556Jd4hw5s2ivm1JKnzyFPQrd9kcBPDSaHVggAW
dpc7kDPTeTv6UmBSl9MKmQmNnMiNtSTGLytrSb9G7HIwKovz3cod74ehXhP+SK6v
zNLnUUbjhCUZMytzdZUMrvmd1ZKjsjlP8lkEnryTjw2hXl6VXTh3GrMmqRusLmgF
AN1m0/TyhWZ1Z9zP/YJ72vEU/ajSxq/m/ASuzP524dQyHX0BmpPNQvtZKpxIJAhk
r7r0Xi0wdJiNTwO9Rdx2yluHMVPu65oRw4OrTmBe8cCh1DvHrH5QFyTpjnsAxPxA
TaFfGGQk0V5DRqxsU3zAvcm4sKV0kBEYlzfBoMyMLPwzKMMmXiY24hnJj5V7DZdD
afO6jYWvrsVeISDJMkgQv6/jwWLO+2K++hWsCneI1zGxYTbcmrDVVfU1MDi7zgpA
1taZm1V9B/E=
=i5nr
-----END PGP SIGNATURE-----

--Sig_/UT4EEDIxCZd1FqQB+fyM7ro--
