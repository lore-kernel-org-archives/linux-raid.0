From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 fails to assemble after unclean shutdown
Date: Wed, 25 Apr 2012 21:01:45 +1000
Message-ID: <20120425210145.73b1e51b@notabene.brown>
References: <20120425103536.GA9978@nsrc.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/18m7m2Q/7.aaTFiHBO.PhAO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120425103536.GA9978@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <B.Candler@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/18m7m2Q/7.aaTFiHBO.PhAO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Apr 2012 11:35:36 +0100 Brian Candler <B.Candler@pobox.com> wrot=
e:

> I have a storage box (currently under test) which has two 12-drive RAID6
> arrays, /dev/md/data1 and /dev/md/data2.
>=20
> The box crashed for an unrelated reason, and when I brought it back up, o=
nly
> one of the arrays assembled:
>=20
>   root@storage1:~# cat /proc/mdstat
>   Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4] [raid10]=20
>   md126 : active raid6 sdj[8] sdk[9] sdd[2] sde[3] sdi[7] sdm[11] sdg[5] =
sdc[1] sdb[0] sdl[10] sdh[6] sdf[4]
>         29302650880 blocks super 1.2 level 6, 1024k chunk, algorithm 2 [1=
2/12] [UUUUUUUUUUUU]
>        =20
>   md127 : inactive sdq[3](S) sdx[10](S) sdu[6](S) sdt[5](S) sds[4](S) sdv=
[8](S) sdp[2](S) sdy[11](S) sdo[1](S) sdn[0](S) sdw[9](S) sdr[7](S)
>         35163186720 blocks super 1.2
>         =20
>   unused devices: <none>
>=20
> So it looks like 12 of the disks have all become spares (S)!

The '(S) is a bit misleading there.  When the array is 'inactive', everythi=
ng
claims to be spare.  Once the array is actually started it all would become
more sensible.


>=20
> An attempt to manually assemble the array failed:
>=20
>   root@storage1:~# mdadm --stop /dev/md127
>   mdadm: stopped /dev/md127
>   root@storage1:~# mdadm --assemble /dev/md/disk2 /dev/sd{n..y}
>   mdadm: /dev/md/disk2 assembled from 4 drives - not enough to start the =
array.

Adding "--verbose" here would help a lot.
Possibly adding "--force" would make it all work.

>=20
> Since this is currently under test system I just forcibly recreated the
> array, but I'm a bit worried about how I would handle this problem when I=
 go
> into production.
>=20
> Here is how I recreated the array:
>=20
>   root@storage1:~# mdadm --create /dev/md/disk2 -n 12 -c 1024 -l raid6 /d=
ev/sd{n..y}
>   mdadm: /dev/sdn appears to be part of a raid array:
>       level=3Draid6 devices=3D12 ctime=3DMon Mar 19 11:52:55 2012
>   mdadm: /dev/sdo appears to be part of a raid array:
>       level=3Draid6 devices=3D12 ctime=3DMon Mar 19 11:52:55 2012
>   mdadm: /dev/sdp appears to be part of a raid array:
>       level=3Draid6 devices=3D12 ctime=3DMon Mar 19 11:52:55 2012
>   mdadm: /dev/sdq appears to be part of a raid array:
>       level=3Draid6 devices=3D12 ctime=3DMon Mar 19 11:52:55 2012
>   mdadm: /dev/sdr appears to be part of a raid array:
>       level=3Draid6 devices=3D12 ctime=3DMon Mar 19 11:52:55 2012
>   mdadm: /dev/sds appears to be part of a raid array:
>       level=3Draid6 devices=3D12 ctime=3DMon Mar 19 11:52:55 2012
>   mdadm: /dev/sdt appears to be part of a raid array:
>       level=3Draid6 devices=3D12 ctime=3DMon Mar 19 11:52:55 2012
>   mdadm: /dev/sdu appears to be part of a raid array:
>       level=3Draid6 devices=3D12 ctime=3DMon Mar 19 11:52:55 2012
>   mdadm: /dev/sdv appears to be part of a raid array:
>       level=3Draid6 devices=3D12 ctime=3DMon Mar 19 11:52:55 2012
>   mdadm: /dev/sdw appears to be part of a raid array:
>       level=3Draid6 devices=3D12 ctime=3DMon Mar 19 11:52:55 2012
>   mdadm: /dev/sdx appears to be part of a raid array:
>       level=3Draid6 devices=3D12 ctime=3DMon Mar 19 11:52:55 2012
>   mdadm: /dev/sdy appears to be part of a raid array:
>   # /etc/fstab: static file system information.
>       level=3Draid6 devices=3D12 ctime=3DMon Mar 19 11:52:55 2012
>   Continue creating array? y
>   mdadm: Defaulting to version 1.2 metadata
>   mdadm: array /dev/md/disk2 started.
>=20
> So it seems like all the disks were known to be part of an array, but mda=
dm
> was still unable to assemble more than 4.

I would need to see the "--examine" output of each disk (Before you
recreated) to be able to explain.


>=20
> Platform: Ubuntu 11.10 server x86_64, stock kernel:
>=20
>   Linux storage1 3.0.0-16-server #29-Ubuntu SMP Tue Feb 14 13:08:12 UTC 2=
012 x86_64 x86_64 x86_64 GNU/Linux
>=20
> Unfortunately I saw the same problem once before on a different test syst=
em,
> and also had to forcibly rebuild the array.
>=20
> So my questions are:
>=20
> * Have I built the RAID array correctly in the first place? Are there some
> options I could have given to mdadm to make it more robust?

Yes, you have built the array correctly.


>=20
> * What should I have done when presented with an array which would not
> assemble, to attempt to recover without losing data?

 --verbose
and maybe
 --force

>=20
> * Any ideas why mdadm only thought 4 of the drives were usable?

Presumably something when wrong during shutdown.  However without more
details (--examine) I cannot guess.


NeilBrown

--Sig_/18m7m2Q/7.aaTFiHBO.PhAO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5fZmTnsnt1WYoG5AQImbA/+MhDOG38z34ISKMMige/OqmEfQcVH9eAC
4vrl1rf+BWNYZpe1HYt18v3EKz7PMopto3vCe0w9JDn1ezV9AvhmdXYaElC8kM9f
am8bdv6iVY3c3+yq9t8cuX0z77US8WAc/4QHYhUv1RUfXLEi5z9PDuMan99HXO2o
X0WMnaidwX2aumFvLm0/5oM4NyQnd1Hna5q59Xehwy/peq083lcgdkTR581z0W89
sOpbZDdQQy/THnZbs8lVQHpD0uypvb2RzHWQo/zJ/1diKrmahj7qHwRFnrlQRi9H
n+CCH20p4NK17wzIZ8VvkchBan/b4UsZykRBFVo5Bpq/TdBR5XDOztyqoOEy9IYO
TsNoz/jSxze5WqnwWAjFglnPDk+Of6NtEfbCpTafJcrtpx2LFSoo2lU9j2awTcV4
4uzvoGJPZGG7R6Leer/i7+/6NdwlZBKJdiq+sNYD0MP0StsklVp0SbzXjg7UZn1J
4VKQ1VGC03TrMTi2soXaEjb2K3KlvoVJuA5Dalm3gQBqDu0PJ76VukmuMVLM4NZH
T5lb4o5bd5JveoGkHySqBO43PFT3OckXCLBJ1/IOXH13hoKGa5pXCQ3ZftVL4myd
WkNUugJ7UqIY2it3AKMnZHMCaoisKWj67KskVWyM3LAv1MlKnY0AkwOJmONcG755
h9XZNqNIEMI=
=7IPK
-----END PGP SIGNATURE-----

--Sig_/18m7m2Q/7.aaTFiHBO.PhAO--
