From: NeilBrown <neilb@suse.de>
Subject: Re: unexpected speed difference at RAID initialisation
Date: Wed, 13 May 2015 13:34:42 +1000
Message-ID: <20150513133442.1db42637@notabene.brown>
References: <1431125239.6206.11.camel@scientia.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/QqKEVo/o+8zz/KUBS_obIae"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1431125239.6206.11.camel@scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/QqKEVo/o+8zz/KUBS_obIae
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 09 May 2015 00:47:19 +0200 Christoph Anton Mitterer
<calestyo@scientia.net> wrote:

> Hey.
>=20
> I'm just deploying some new servers at the faculty, where I made the
> following strange observation, which I cannot explain.
>=20
> All nodes have exactly the same hardware (all recent stuff, some 15k=E2=
=82=AC
> Dell servers with 16 disks =C3=A1 6 TB, plenty of CPU), the same
> BIOS/firmware config, the same OS (Debian jessie, except the kernel
> 4.0.0 from experimental and btrfs-tools 4.0 from sid) with identical
> config.
>=20
> The discs are connected via some Dell PERC RAID controller but for
> testing they're exported as JBODs.
>=20
> Nothing except some standard daemons (haveged, irqbalance and that like)
> are running on these nodes.
>=20
>=20
> I created an MD RAID6 over all disks via:
> mdadm --create /dev/md/data-test-raid --verbose --metadata=3D1.2
> --size=3Dmax --chunk=3D512K --level=3Draid6 --bitmap=3Dinternal
> --name=3Ddata-test-raid --raid-devices=3D16
> --spare-devices=3D0 /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf=
 /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn /d=
ev/sdo /dev/sdp
> basically at the same time (few seconds difference) on both nodes.
>=20
>=20
> But looking at the initial rebuild on two nodes, one can see substantial
> speed differences:
> node A:=20
> # cat /proc/mdstat=20
> Personalities : [raid6] [raid5] [raid4]=20
> md127 : active raid6 sdp[15] sdo[14] sdn[13] sdm[12] sdl[11] sdk[10] sdj[=
9] sdi[8] sdh[7] sdg[6] sdf[5] sde[4] sdd[3] sdc[2] sdb[1] sda[0]
>       82045479936 blocks super 1.2 level 6, 512k chunk, algorithm 2 [16/1=
6] [UUUUUUUUUUUUUUUU]
>       [=3D=3D=3D=3D=3D>...............]  resync =3D 28.8% (1691996416/586=
0391424) finish=3D841.8min speed=3D82526K/sec
>       bitmap: 32/44 pages [128KB], 65536KB chunk
>=20
> unused devices: <none>
>=20
> node B:=20
> # cat /proc/mdstat=20
> Personalities : [raid6] [raid5] [raid4]=20
> md127 : active raid6 sdp[15] sdo[14] sdn[13] sdm[12] sdl[11] sdk[10] sdj[=
9] sdi[8] sdh[7] sdg[6] sdf[5] sde[4] sdd[3] sdc[2] sdb[1] sda[0]
>       82045479936 blocks super 1.2 level 6, 512k chunk, algorithm 2 [16/1=
6] [UUUUUUUUUUUUUUUU]
>       [=3D=3D=3D=3D>................]  resync =3D 20.1% (1180137984/58603=
91424) finish=3D1496.2min speed=3D52132K/sec
>       bitmap: 36/44 pages [144KB], 65536KB chunk
>=20
> unused devices: <none>
>=20
> (again taken with only few seconds in between).
>=20
> As you can see it already shows different speed (~80000K/s for node A
> and ~50000K/s for node B).

This could be quite normal.

When resyncing an array, md will read a full stripe and check if it is in
sync. If it is, it just continues.
If not, it schedules a write with the correct parity.

So if the array happens to be fully in-sync, this goes at maximum see
(sequential reads only).
If it is totally out of sync, it goes very slowly (read/write/read/write...=
).

What you are probably seeing is that all the drives in one array are (almos=
t)
completely zero, so it seems in-sync.  In the other array, one drive might
have old data on it so syncing is needed.

(snip)

>=20
> There's a bigger difference at:
> [ 8334.341904] raid6: using algorithm avx2x4 (24764 MB/s)
> vs.
> [ 8269.712632] raid6: using algorithm avx2x4 (25242 MB/s)
>=20
> How are these numbers determined?

Holding a finger up to the wind and seeing how cold it gets.

Well, it really runs a loop performing the calculation over and over and
times how long that takes.
It doesn't take cache effects into account properly so it isn't completely
reliable, but it is reasonably indicative.


>=20
>=20
> Further:
> node A:
> # ps ax  | grep md127
>   7550 ?        S    273:47 [md127_raid6]
>   7552 ?        D     79:43 [md127_resync]
>=20
>=20
> node B:
> # ps ax  | grep md127
>   7494 ?        R    251:30 [md127_raid6]
>   7495 ?        D     63:48 [md127_resync]
>=20
>=20
>=20
> Any ideas where this performance difference could come from?

Probably just different initial content of devices.

If it is still going, you could look at the IO stats.  One array might see a
lot more writes than the other.

NeilBrown

--Sig_/QqKEVo/o+8zz/KUBS_obIae
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVLGUjnsnt1WYoG5AQIYRRAApjeBqhJQZBNosPtQOPRaJx1CqPnVzqBR
SR81C1wLvBUV5X3ZrSYRd6aXZlocvwDGFHlmLO3R/1epe1tHO9j+qLIr+Rhc8OyG
xWs5C+Yl+ZZGXJGDQYjX2V0rj8l/r6Go4Ur9rdQJmhEWP/U4A5BZiYRESaD44stc
DpxS87xCPN0LqcGcQy+2T8ZF4Qfrg3s8ZKvcXCSpdPBpoJlM6E1hJEYmGHH8UE3T
opkeBxR7NXSxTvkieA2S0sFC57d7GqZiXRMQQFsQgZVbLMeQfaeZ/otSjrbH2mhz
2DQvoRKKjzjB5FjGnxBLv+XXsVxi6aZo/n8y2VHAD58ZDlF6gczQ3/dX6EGsOrUP
C4RHJdUDCyXN+V5SyEul86yTwumZ59LipuBhLC2SMyXFoFXeoXPBG0qpI0BW1Rx5
s+ERQJCcdWj73KKwDHRh2XPunDkoUTQVdNYfurfjJ6BlbbdWTWQ1Aqwex3NBgfRf
UDyW54B02itA12ozfxCzMtmkM/R59WOL0nYIN+jHAtu0lRpooyLo4fhu/vq5LfO2
y+RT8rQGI3yyxSznDlq3Ic9+n6w+KLRBOqrXrAa6iBz/BuslhHwGikG3UnrbWwJd
XzOTpi0SPmio0eY9EekNcpJo+m8EXOUH8MIgkSaRBi7s9F70cu96+iokmP2VQyN6
vZktQhAi6SY=
=nyTX
-----END PGP SIGNATURE-----

--Sig_/QqKEVo/o+8zz/KUBS_obIae--
