From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 (re)-add recovery data corruption
Date: Mon, 23 Jun 2014 11:36:41 +1000
Message-ID: <20140623113641.79965998@notabene.brown>
References: <53A518BB.60709@sbcglobal.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vf6ve2g+k9CwAsA8w1Wgx2d"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53A518BB.60709@sbcglobal.net>
Sender: linux-raid-owner@vger.kernel.org
To: Bill <billstuff2001@sbcglobal.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/vf6ve2g+k9CwAsA8w1Wgx2d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jun 2014 00:31:39 -0500 Bill <billstuff2001@sbcglobal.net> wrote:

> Hi Neil,
>=20
> I'm running a test on 3.14.8 and seeing data corruption after a recovery.
> I have this array:
>=20
>      md5 : active raid5 sdc1[2] sdb1[1] sda1[0] sde1[4] sdd1[3]
>            16777216 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
>            bitmap: 0/1 pages [0KB], 2048KB chunk
>=20
> with an xfs filesystem on it:
>      /dev/md5 on /hdtv/data5 type xfs=20
> (rw,noatime,barrier,swalloc,allocsize=3D256m,logbsize=3D256k,largeio)
>=20
> and I do this in a loop:
>=20
> 1. start writing 1/4 GB files to the filesystem
> 2. fail a disk. wait a bit
> 3. remove it. wait a bit
> 4. add the disk back into the array
> 5. wait for the array to sync and the file writes to finish
> 6. checksum the files.
> 7. wait a bit and do it all again
>=20
> The checksum QC will eventually fail, usually after a few hours.
>=20
> My last test failed after 4 hours:
>=20
>      18:51:48 - mdadm /dev/md5 -f /dev/sdc1
>      18:51:58 - mdadm /dev/md5 -r /dev/sdc1
>      18:52:06 - start writing 3 files
>      18:52:08 - mdadm /dev/md5 -a /dev/sdc1
>      18:52:18 - array recovery done
>      18:52:23 - writes finished. QC failed for one of three files.
>=20
> dmesg shows no errors and the disks are operating normally.
>=20
> If I "check" /dev/md5 it shows mismatch_cnt =3D 896
> If I dump the raw data on sd[abcde]1 underneath the bad file, it shows
> sd[abde]1 are correct, and sdc1 has some chunks of old data from a=20
> previous file.
>=20
> If I fail sdc1, --zero-superblock it, and add it, it then syncs and the=20
> QC is correct.
>=20
> So somehow is seems like md is loosing track of some changes which need=20
> to be
> written to sdc1 in the recovery. But rarely - in this case it failed=20
> after 175 cycles.
>=20
> Do you have any idea what could be happening here?

No.  As you say, it looks like md is not setting a bit in the bitmap
correctly, or ignoring one that is set, or maybe clearing one that shouldn't
be cleared.
The last is most likely I would guess.

Are you able to run you your test one a slightly older kernel to see how lo=
ng
the bug has been around.
A full 'git bisect' would be wonderful, but also a lot of work and I don't
really expect it.  Any extra data point would help though.

Maybe I'll see if I can reproduce it myself....

NeilBrown

--Sig_/vf6ve2g+k9CwAsA8w1Wgx2d
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU6eEqTnsnt1WYoG5AQILxRAAkQ15+dHHtlPOyMXejkliZWtDikxROMsQ
fpUbTGhgfmo8rJJeE5ONvgHmGc9SU3FAwFUU92SkgRTde9msHVvojm1LZGiQ4Bxa
KX9o1/jY6La59TmIyyGI88ktLItELKyMF81eXBRwPqjphn6zHOaq8vCkzQnvM0VT
JIzTJK3oTc5UIs8dXG4JL73OXGB0uA6nkb3hGKeoKTGWQc1yNKg297Ie8F+JRP/y
fbcUppIYcVMq21WuqGzHxGr8GcCk2aH9h1ggQ/ZqRrTMTPALEb49MqC40pWzMQOk
roHLFzfyPI2K7KFsiXO2jJLrlg3FD/X7Z8MmufPrLB7F7hz+s+3nwpgSOBeVUvFc
3Ia6tiCh/oqMCjuV9YqU2PSWTZHEY863wksLH4Zty9uK03OQ7g0L6DqhwZfd7wDt
lbf8O2CB0iKXvt4aGgFFxowCj1hJ45YfufmYTPOY0B5tYqk2GF/qBiRZTTPNPhuW
ToQcA4zyLa2Qd/2l+HIKFQN+JuFceJO5HYbKGp5Lbc3QxRDFovefmXrFop4H5CAe
I9pIpsOdGGCsNW4/p1KdHd9KI8OFYsrdUtOcz3Nklz5mPnCIKtkfYcV9u+eZCWTo
DEOegddwXqFNGqiwMIFg3v4YXz1vPVX5QR22NHvFYQgfGNp84NrX+3sFJ1TQKOhx
awGpr7041SI=
=mTPl
-----END PGP SIGNATURE-----

--Sig_/vf6ve2g+k9CwAsA8w1Wgx2d--
