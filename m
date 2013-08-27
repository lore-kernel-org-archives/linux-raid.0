From: NeilBrown <neilb@suse.de>
Subject: Re: Disk with backup-file died during reshape
Date: Tue, 27 Aug 2013 10:48:27 +1000
Message-ID: <20130827104827.60262d5a@notabene.brown>
References: <521B3E43.5050707@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uw6N_aqC1s=Zr2kSZ5__SfI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <521B3E43.5050707@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Iruwen <iruwen@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/uw6N_aqC1s=Zr2kSZ5__SfI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Aug 2013 13:38:43 +0200 Iruwen <iruwen@gmx.net> wrote:

> Hi,
>=20
> the disk holding backup-file unfortunately died during an mdadm --grow=20
> /dev/md0 --level=3D6 --raid-devices=3D4 --backup-file=3D/mnt/backup/md0.b=
ak.
> The speed of the reshape dropped to 0K/sec, apart from that the RAID=20
> seems fine.
>=20
>=20
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sda1[4] sdc1[2] sdd1[3] sdb1[1]
>        2930271232 blocks super 1.2 level 6, 512k chunk, algorithm 18=20
> [4/3] [UUU_]
>        [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>..........]  reshape =3D 53.6% (78=
6497536/1465135616)=20
> finish=3D55405950.5min speed=3D0K/sec
>=20
> unused devices: <none>
>=20
>=20
> /dev/md0:
>          Version : 1.2
>    Creation Time : Fri Feb 11 21:10:18 2011
>       Raid Level : raid6
>       Array Size : 2930271232 (2794.52 GiB 3000.60 GB)
>    Used Dev Size : 1465135616 (1397.26 GiB 1500.30 GB)
>     Raid Devices : 4
>    Total Devices : 4
>      Persistence : Superblock is persistent
>=20
>      Update Time : Mon Aug 26 13:32:09 2013
>            State : clean, degraded, recovering
>   Active Devices : 3
> Working Devices : 4
>   Failed Devices : 0
>    Spare Devices : 1
>=20
>           Layout : left-symmetric-6
>       Chunk Size : 512K
>=20
>   Reshape Status : 53% complete
>       New Layout : left-symmetric
>=20
>             Name : backup:0  (local to host backup)
>             UUID : 832a100a:2996471b:51867bfa:aaf5c38f
>           Events : 1053146
>=20
>      Number   Major   Minor   RaidDevice State
>         3       8       49        0      active sync   /dev/sdd1
>         1       8       17        1      active sync   /dev/sdb1
>         2       8       33        2      active sync   /dev/sdc1
>         4       8        1        3      spare rebuilding   /dev/sda1
>=20
>=20
> What's the right thing to do now, is this recoverable? I have backups of=
=20
> course and since the RAID is still working I could just copy everything=20
> off and recreate it, but I'd rather fix this the "right way" than to set=
=20
> up a new system.

You should be able to simply stop the array and re-assemble with a different
backup file and the magic flag  "--invalid-backup" (required mdadm 3.2 or
later).

The backup-file is only really needed in case of a crash.  As you will stop
the array cleanly  there will be no need to recover anything when you
re-assemble, so --invalid-backup (Which say "there is nothing in the backup
file, but that is OK) is perfectly safe.

NeilBrown

--Sig_/uw6N_aqC1s=Zr2kSZ5__SfI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUhv3Wznsnt1WYoG5AQKNuhAAi8Ts8Jq+8F0iY4rRxHrC6d2gklDKLfwV
Nfq3eLNFq867il9EOI23ukFFZj0sh9KlmZ+lPQsgZW/RP6xbdKqjOKMRmkY0txcb
irMArnSB2DuToKs2K7D/2mIIT2c3wSQO6yNKa34Gp7e5H3JIP1y2tGXPxe4czq87
AV2NrNm7BP0COTeMOnKEtjPyLRDWpAL1KrTmyq1PoIkvcZ85ja4FTNcnEILkEdt6
A30kN+5dRKmzrLLnlSHxvQrFON2z2aFTjuvgj/393+GGBJb3qMh9yw+vk4+czOD+
B6OSVRIgqzB+W5eriR+crXz1574/4Hv/aD1/JaLfwl7aE5WdpBaxa6dM6abXsB6H
yETssbNAho6aClXlkV2Ps2sTkmTpyHvzk/0mZ3/6G4q0MHTpJ9DDHWA/s5WUBDkG
G68okcAhyzX9FCf09yQRt7nJpuW/Hji5v8FiwtOI/iVKEnnWpE/Xuztc+Zq2GyDp
6XcDsO3UIP2U6EEb/daruAtNuU3tuMWRqTDv88ubsQnGVeMJYYAFhy9vqY9UHexU
NjpwnNGR2W5opwdlXdxHk+8qF51ElOrHlstsi8QaYS7HdsPRNmp1DqRZ0dAL2oJB
zbVKjiqvkXQ/USLlOn1MJzi+e81evIB0PnScjGskgYTmHZfLkkE3NG3bXzvgWgZu
CJCvP8vWs3Y=
=l5Ci
-----END PGP SIGNATURE-----

--Sig_/uw6N_aqC1s=Zr2kSZ5__SfI--
