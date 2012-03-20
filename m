From: NeilBrown <neilb@suse.de>
Subject: Re: Array Size differences between mdadm --detail and --examine
Date: Tue, 20 Mar 2012 12:52:11 +1100
Message-ID: <20120320125211.27ad32b9@notabene.brown>
References: <CAM8ZctUH--UJmKi56UJNmDss67uzQycLyx1tP0qeyB9GCFBc0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CmLKRtajlFpioq6LuV+VbXZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAM8ZctUH--UJmKi56UJNmDss67uzQycLyx1tP0qeyB9GCFBc0g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Francy <zoredache@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CmLKRtajlFpioq6LuV+VbXZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Mar 2012 16:04:34 -0700 Chris Francy <zoredache@gmail.com> wrote:

> I am seeing a different array size with mdadm --detail and --examine,
> and I don't understand why.
>=20
> I have seen this on a production systems, but I created an array in a
> VM for testing purposes, and I am seeing the same results.
>=20
> I have a 5 device RAID10 with created like so.  It has 5 members 8GB
> each.  Which I believe should result in an array size of ~20GB.
>=20
>     mdadm -v --create  /dev/md0 --assume-clean \
>        --level=3Draid10 --layout=3Do2 --raid-devices=3D5 \
>        --chunk=3D64 \
>        /dev/sdb2 /dev/sdc2 /dev/sdd2 /dev/sde2 /dev/sdf2
>=20
> mdadm --detail reports an array size of ~20GiB
>=20
>   root@debian:~# mdadm --detail /dev/md0
>   /dev/md0:
>     Creation Time : Fri Mar 16 16:06:09 2012
>        Raid Level : raid10
>        Array Size : 20960960 (19.99 GiB 21.46 GB)
>     Used Dev Size : 8384384 (8.00 GiB 8.59 GB)
>=20
> mdadm --examine reports an array size of ~16GiB
>=20
>   root@debian:~# mdadm --examine /dev/sdb2  /dev/sdd2 /dev/sde2 /dev/sdf2
>   /dev/sdb2:
>    Avail Dev Size : 16769024 (8.00 GiB 8.59 GB)
>        Array Size : 33537536 (15.99 GiB 17.17 GB)
>     Used Dev Size : 16768768 (8.00 GiB 8.59 GB)

Thanks for the report.

There seems to be a rounding error in mdadm when calculating the size to
report for --examine.  The value for --detail is of course correct.

I'll try to get it fixed in the next release.

Thanks,
NeilBrown


>=20
> Most of my testing was done on a Debian squeeze system, but I manually
> compiled and installed mdadm 3.2.3 and I also saw the same confusing
> output from a Gentoo based livecd with a recent kernel.
>=20
> The full output of the mdadm output is pasted available here.
> http://paste.debian.net/160057/
>=20
> The array in the VM seems to work fine, I was able to create a
> filesystem and store data on it.  But the output from the --examine is
> confusing.
>=20
> The same is true with the use Dev size  `8384384 (8.00 GiB 8.59 GB)`
> versus `16768768 (8.00 GiB 8.59 GB)`.
>=20
> Chris Francy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/CmLKRtajlFpioq6LuV+VbXZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2fiyznsnt1WYoG5AQKWDQ//dQ5ASn7RMfXjATzvOdFyV3pIUb16JjIn
3UFs8HEl6hWRX6Ivycbq7bKEXVf5kJv3Gbi2+QTDDUW+FQpSmn8kTM+C/ocpI0z1
4hICETiFbK/BS8XCbY9IysIbfnBPcsZhSdxdAf9XMMN45BR2N+HlkAjgfdahwRrO
weXPtQEPq88yNMXg8HhAziVoQWcDDd+jwczJP27O1cs7WBILhgnkT71dUYlN8Sqi
77UrcSQ6KYCbdY1GD6PxwBj3Yk58CiT6VnPTjuuWy3ZVUInxOI05aCGLfrKft038
NEOSYQiVyawPxThYqKlj0NaaDxQ8cjK9iCJf94ldjNmawiOJOCvacKvmVp1IAQM5
t5WqbUk6HrW9QGzNytP4io1on4vQRUJhKmg7iQJMKfKSBpKJkkdnVaCDSK4ffTGY
WXAXba3IYmgqzdFcUn37pn8C1Qrbn2wRqoIXr5X7T1VECDC1QIMu1vbCHc1HhDpY
6Y4gaA8CaPYiHA1ApzKxOTPrAbSmEjES4tJwQ4JA660hdFDzGtKLvQ2OyL6vftdC
GgSfbhihhh3qgTKSaZICRYdX6cIyrLQI6BbUx3LuaaI66Qq70IkfiVFkqBf5qFO8
9D8oYSDnFV9m2Eli/sZp3qgYs9O/8dBirxglV5K16M+y8cP9F1VPXfXz+Qj/L3J6
Qy/XmN6tbVo=
=bxG5
-----END PGP SIGNATURE-----

--Sig_/CmLKRtajlFpioq6LuV+VbXZ--
