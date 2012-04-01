From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 grow failed
Date: Mon, 2 Apr 2012 09:54:25 +1000
Message-ID: <20120402095425.168e5d94@notabene.brown>
References: <CAJ72viP2MLb2tL84P-aK6Rs9eAH4x9Wwd=kVNbmPA=2LAfNLjg@mail.gmail.com>
	<20120328151828.6988d3db@notabene.brown>
	<CAJ72viMxgfjhQiqJYVnjBQGfCq7jtegfvUY0nRdj46XDedeSjg@mail.gmail.com>
	<20120328192601.3db82133@notabene.brown>
	<CAJ72viPX1SDL2pPSkGQnujNcaoNmRposJXxaLhDkZDgFxv=-qA@mail.gmail.com>
	<CAJ72viPH9AykY-tafTChcS0ZbP0gGaiKRybafs4C4Yk-8D=g3A@mail.gmail.com>
	<20120401080036.355a8a23@notabene.brown>
	<CAJ72viOGCYrMqvX2=3BzWQZpfDUeNwHEVHbXyaKbrwvrBP6wPQ@mail.gmail.com>
	<CAJ72viPw=QrETGPU5OwBgL-GXfCUfqfbWCSAvp2_yzzxuJeT1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8JdBfr6+9woQ0TPfGtJ_OIV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ72viPw=QrETGPU5OwBgL-GXfCUfqfbWCSAvp2_yzzxuJeT1w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Bush <bbushvt@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/8JdBfr6+9woQ0TPfGtJ_OIV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Apr 2012 03:05:29 -0400 Bryan Bush <bbushvt@gmail.com> wrote:

> Additional info that might be useful.  When I specify which disks to
> use in the array, I get this
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
> root@diamond:/#

1/ Are you absolutely certain you did
     mdadm -S /dev/md1
 first?  Because it really looks like you didn't.

2/ Any kernel log messages?
    dmesg | tail -n 50
  immediately after the failed "mdadm -A" command.

NeilBrown


--Sig_/8JdBfr6+9woQ0TPfGtJ_OIV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3jqsjnsnt1WYoG5AQIAMQ//fevRgIo8GLhVb+j945+HA+JJu+MG6joC
H4Fdxvw3BHtf5lM0vt1pgb94G+R1UAzU1L9uTSyUzsFHZ4pX8vOwaq8pjWCTBeO1
FKsS+PibXmjgbAMR2f7MjaAE+zfjWWvy6zEzm039zd50Qq2N/JlSVq13XLdmDHPZ
u7Mf1onVuMbR7ghKeopiMiug515QOfz6mLTyadQLze19/iMMYkPQDUFpCKnJzrmo
JFUb7LmCycs/q6+ZpF+wGxALLa1HVVY947OSMhAAjILwFSwazNqV+p1LRITI4dk2
IW/sST0aowKkihyCSG8dPBuwEfE3pq7JDlkfqSMJL63fJh9LTimBIx3bz1a8yrCP
0nLhDNCVcGWYEEk65TO+KRQ//cNoYtQADpEZuqvuufiARGia6FW0xGwjWSlSWHuY
I8L2JeMNXZ6ncfAgfs5uccOTv2FvkY7nLKKRmppznBJB6aQ5D6kbVN+SMeFx4dVA
bDWvrtA8sYtMTKsifxCcmTe7twBr09Y/qPVGzOgSkItZyQ9U5DOG1tow6vNB1oDx
vEPTsjh8G7sARpxEsMv9s8OQg/BvbmDRmWbbZA3gXVElyKQsipN6nRBrBiASsIoM
+cgVhekp38rHh9iHnbGmlCZsslERzsjrOdVXQHpIwMz+4MyldwG23TWHvXgaNdiZ
nHCsDKmtn74=
=072h
-----END PGP SIGNATURE-----

--Sig_/8JdBfr6+9woQ0TPfGtJ_OIV--
