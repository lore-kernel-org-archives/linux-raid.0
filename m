From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 grow failed
Date: Mon, 2 Apr 2012 10:26:00 +1000
Message-ID: <20120402102600.4046c483@notabene.brown>
References: <CAJ72viP2MLb2tL84P-aK6Rs9eAH4x9Wwd=kVNbmPA=2LAfNLjg@mail.gmail.com>
	<20120328151828.6988d3db@notabene.brown>
	<CAJ72viMxgfjhQiqJYVnjBQGfCq7jtegfvUY0nRdj46XDedeSjg@mail.gmail.com>
	<20120328192601.3db82133@notabene.brown>
	<CAJ72viPX1SDL2pPSkGQnujNcaoNmRposJXxaLhDkZDgFxv=-qA@mail.gmail.com>
	<CAJ72viPH9AykY-tafTChcS0ZbP0gGaiKRybafs4C4Yk-8D=g3A@mail.gmail.com>
	<20120401080036.355a8a23@notabene.brown>
	<CAJ72viOGCYrMqvX2=3BzWQZpfDUeNwHEVHbXyaKbrwvrBP6wPQ@mail.gmail.com>
	<CAJ72viPw=QrETGPU5OwBgL-GXfCUfqfbWCSAvp2_yzzxuJeT1w@mail.gmail.com>
	<20120402095425.168e5d94@notabene.brown>
	<CAJ72viOU2O-1rsaJWKbDbR6XS+VYfDuWa8DpN=+w-1BYp7fwNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P8m03Kc/21qnM1QS5ECwavV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ72viOU2O-1rsaJWKbDbR6XS+VYfDuWa8DpN=+w-1BYp7fwNA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Bush <bbushvt@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/P8m03Kc/21qnM1QS5ECwavV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Apr 2012 20:02:57 -0400 Bryan Bush <bbushvt@gmail.com> wrote:

> root@diamond:/# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md1 : inactive sdk1[13](S) sdj1[11](S) sdh1[9](S) sdo1[3](S)
> sdd1[6](S) sde1[7](S) sdn1[2](S) sdl1[0](S) sdb1[4](S) sdc1[8](S)
>       19535134315 blocks super 1.2
>=20
> md0 : active raid5 sdg1[3] sda1[0] sdf1[1] sdq1[2]
>       2929686528 blocks level 5, 256k chunk, algorithm 2 [4/4] [UUUU]
>=20
> unused devices: <none>
> root@diamond:/# mdadm -S /dev/md1
> mdadm: stopped /dev/md1
> root@diamond:/# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active raid5 sdg1[3] sda1[0] sdf1[1] sdq1[2]
>       2929686528 blocks level 5, 256k chunk, algorithm 2 [4/4] [UUUU]
>=20
> unused devices: <none>
> root@diamond:/# mdadm -A --verbose /dev/md1 /dev/sd[onjlkuhedcb]1
> mdadm: looking for devices for /dev/md1
> mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 4.
> mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 5.
> mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot 6.
> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 7.
> mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 12.
> mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 10.
> mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 8.
> mdadm: /dev/sdl1 is identified as a member of /dev/md1, slot 0.
> mdadm: /dev/sdn1 is identified as a member of /dev/md1, slot 2.
> mdadm: /dev/sdo1 is identified as a member of /dev/md1, slot 3.
> mdadm: device 8 in /dev/md1 has wrong state in superblock, but
> /dev/sdk1 seems ok
> mdadm: device 10 in /dev/md1 has wrong state in superblock, but
> /dev/sdj1 seems ok
> mdadm: device 12 in /dev/md1 has wrong state in superblock, but
> /dev/sdh1 seems ok
> mdadm: SET_ARRAY_INFO failed for /dev/md1: Device or resource busy
> root@diamond:/# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md1 : inactive sdk1[13](S) sdj1[11](S) sdd1[6](S) sdh1[9](S)
> sdo1[3](S) sde1[7](S) sdn1[2](S) sdl1[0](S) sdc1[8](S) sdb1[4](S)
>       19535134315 blocks super 1.2
>=20
> md0 : active raid5 sdg1[3] sda1[0] sdf1[1] sdq1[2]
>       2929686528 blocks level 5, 256k chunk, algorithm 2 [4/4] [UUUU]
>=20
> unused devices: <none>
>=20
>=20
> Output from /var/log/messages for the mdadm -A
> Apr  1 20:00:57 diamond kernel: [106978.432900] md: md1 stopped.
> Apr  1 20:00:57 diamond kernel: [106978.493151] md: bind<sdc1>
> Apr  1 20:00:57 diamond kernel: [106978.494551] md: bind<sdb1>
> Apr  1 20:00:57 diamond kernel: [106978.496256] md: bind<sdd1>
> Apr  1 20:00:57 diamond kernel: [106978.516939] md: array md1 already has=
 disks!

That is where SET_ARRAY_INFO is failing ... but why does md1 already have
disks I wonder...

either mdadm has some weird bug - what version are you running???

or something else is messing with md1.

Maybe udev is noticing those devices again for some reason and trying to add
them to the array independently.
You could run
   udevadm monitor

at the same time and see what happens.
Also look in /lib/udev/rules.d or /etc/udev/rules.d to find an entry that=20
run "mdadm -I" or "mdadm --incremental" and  try commenting that entry out.

NeilBrown


--Sig_/P8m03Kc/21qnM1QS5ECwavV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3jyGDnsnt1WYoG5AQINLxAAug4CdBpIUh7859DFO2MyhKWoPyO/YlTK
W1AhnUmzOkMwA2lXyAj1/t93KTQbuvG3FdUl2HyF+ddFMX1QI1jc4hdfw5YfFL5f
mppQ7oqozLbBeP+ww3rdTeNPlq1d3U/4DDrG2fI0k+mlWKZEj+3jlghI75d+NKPM
DJ+UJPeRbP5sWyqsDV7lknNbtzsA5jEwPF+azcOum076TsSZjq4vHS5ErnG1HkEI
XXL9n+xE0WSPI5XAU0bZgcv2WzHTgH7gaai9RJARK40Xajrl+/UZ/P8N9dihWAe0
9DH/uUcVyjgq3jy61/CO8ZyvcdFCdoLIxIcjEOxz/s8lnZqdubAPwzu69EZ2OuRT
QIkG8WlYKuyqQAvg5czf9PIkrwHX1V1/K1ohh9NJWfdTfhewMGwQCGs4c9DS7Isc
n6Scf54SsLcSZIRHOKCGKJ/GkruYs3TpBGC/mntDDfdaqIgLoINgYtGuFHEpBAAw
aeE/KilJtDtRpVDkg0MPIhF8aDYCeqWzy3EyqK2E0rGWe/uZFJDQ41LDjyEKISRO
BNGgHF5vleIFlRVbvogAnDpbf5khz8vQh0132Bds4DXqDJ2JoxXN050AHI3X0L17
INZmrM6WTw8DELJJ4kC7LRKPPF+92dPIjusZfYc8nBj2E5ggNfcIMctI/oR0nYU2
tma0/DSM13k=
=k0ao
-----END PGP SIGNATURE-----

--Sig_/P8m03Kc/21qnM1QS5ECwavV--
