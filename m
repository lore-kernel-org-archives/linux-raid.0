From: NeilBrown <neilb@suse.de>
Subject: Re: RAID10-shrink does not work
Date: Mon, 11 Aug 2014 13:22:26 +1000
Message-ID: <20140811132226.02f89e62@notabene.brown>
References: <201408101646.s7AGkvDm009836@portal.naev.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/SP/EgJudkW30lg4zG/l91Q7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201408101646.s7AGkvDm009836@portal.naev.de>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Koch <mdraid.pkoch@dfgh.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/SP/EgJudkW30lg4zG/l91Q7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Aug 2014 18:46:57 +0200 mdraid.pkoch@dfgh.net (Peter Koch) wrote:

> Dear readers,
>=20
> As you might have read in my former postings, I grew
> a 13 disk raid10-array with near-2 layout into a 16 disk
> array. The data is mirrored between all disks with even
> numbers and all disks with odd numbers.
>=20
> Now I learned that my disks have both a number and an id.
> When you add a disk it will get the next number and it
> does not matter wether you add one or more disks.
>=20
> But when you grow an array by more then one disk, then
> linux md will use the disks in an unpredictable way.
>=20
> In my case I added three disks, they got id 13, 14 and 15
> and when I grew my array from 13 to 16 disks these disk where
> used in sequence: 14, 13, 15=20
>=20
> Since I have not grown the filsystem on my raid10-array I
> can shrink the array back to 13 disks and then add each disk
> one by one. Of course this will last three times longer than
> adding all 3 disks in one operation. But I see no other
> possibility to get a ono-to-one corresponding between ids
> and numbers.

You could just decide that it doesn't matter.
As soon as a device fails and you need to rebuild a spare, the numbers will
be out of sync again.

>=20
> Unfortunately shrinking the raid10-array back to 13 devices
> does not work:
>=20
> # mdadm --grow /dev/md5 --array-size 12696988928
> # mdadm --grow /dev/md5 --raid-devices=3D13
> mdadm: Cannot set array shape for /dev/md5

Where did you get that array-size from?  It isn't a multiple
of 512K.  Hence the chunksize setting reports an error.

NeilBrown


>=20
> I'm using mdadm 3.3 with linux 3.14.16
>=20
> The mdadm-3.3 source code has only one line that prints
> "Cannot set array shape". It's in Grow.c, function raid10_reshape()
> and I added the following printf-statements:
>=20
> printf("err=3D%d\n", err);
> if (!err && sysfs_set_num(sra, NULL, "chunk_size", info->new_chunk) < 0)
>         err =3D errno;
> if(err) printf("chunk_size %d failed, err=3D%d, %s\n", info->new_chunk, e=
rr, strerror(errno));
>=20
> mdadm will then output:
>=20
> # ./mdadm --grow /dev/md5 --raid-devices=3D13
> err=3D0
> chunk_size 524288 failed, err=3D22, Invalid argument
> mdadm: Cannot set array shape for /dev/md5
>=20
> So the problem is caused by writing 512K to some sysfs-location
> for a raid10-array that has already a chunk size of 512K !!
>=20
> Strange - And why does this problem only occur on shrinking?



>=20
> I cannot reproduce this problem with test-data. Adding 3 loop-devices
> to a raid10-array consisting of 13 loop devices and then shrinking
> it back to 13 devices worked with no problems.
>=20
> Kind regards
>=20
> Peter Koch
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/SP/EgJudkW30lg4zG/l91Q7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+g28jnsnt1WYoG5AQLqEBAAuJ3Ns4KkZwhH7khW93p1PMJ57xHYeQFY
QZ4oims9xhWNgIeh1MKuORXCkdOgRKh9P9f6nbS9pSxIR7PTZ9n/xetC3jAKjUNP
ays5X/cZuUOHn9xvcCllkh0Kv2j8KnhYsa0gjkReatOXjxDDDRQN91ClpopvSQCW
hDyx0ISEiepPeHSwK6ezbbeohA9X477zFdiEUftEYslIwxZqzOAyH1qNkKX/2NwY
nedPAvIqdQdpcQCGkLCyzueS2uUtP1Dp00H1b1CBfbsBMvVoIgdc9dw8pVed1YFR
4SFD6jvu4OUC6U/0BEz5LgVLA77MWHvFLyKnSRVHlKSLy3CDe3fkzvymLyL6ThAr
8d5v+bUH2eBbVurhiY4LFEV6VvtttZtASevM4L2F11L+4PoJd++Q6JK7hfhh1BGh
rPL+sETzIzzISATzVQF+jtdd3WaSCffa4LDMR294FWxeZKw1qqRwoFxDbfs0ZRVr
vEMGM9lKvSyVPhS1P9CidiomAg5DwqZRcQgLU5CqkSYXhSXH6knHgCug+EfRC7Wz
bdlnR2PsZ3itvorRX5efGdFDvMaEXjG7njXdXX4AgIO4Cwmy+cFZmLhK5GE84+eq
Y+wXpaiNaeKUN6wad12RbvWs6WpMjK0/TpzoSAisy7NT/j1M6yfeq8u3gd2WjNOJ
j1A8jwoa1vc=
=PmTI
-----END PGP SIGNATURE-----

--Sig_/SP/EgJudkW30lg4zG/l91Q7--
