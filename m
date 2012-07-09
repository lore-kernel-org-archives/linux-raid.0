From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 faild while in degraded mode, need help
Date: Tue, 10 Jul 2012 09:02:14 +1000
Message-ID: <20120710090214.286059f2@notabene.brown>
References: <CACMY3vC=iAbKCssHH8CQ=msqNtmE1zF1muoZTusfRd989HvD_w@mail.gmail.com>
	<20120709101208.49528808@notabene.brown>
	<CACMY3vDNoZN4tt4TRoE=49q9hkrFZ+7NRKgHHQXKe1_=wi8byw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lCwaUGmO4Qd7tF5n+NzvQ9c"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACMY3vDNoZN4tt4TRoE=49q9hkrFZ+7NRKgHHQXKe1_=wi8byw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dietrich Heise <dh@dhde.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lCwaUGmO4Qd7tF5n+NzvQ9c
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Jul 2012 13:02:04 +0200 Dietrich Heise <dh@dhde.de> wrote:

> Hello,
>=20
> thanks for the hint.
>=20
> I do a backup with dd before that, I hope I can get back the data of the =
raid.
>=20
> The following is in the syslog:
>=20
> Jul  8 19:21:15 p3 kernel: Buffer I/O error on device dm-1, logical
> block 365625856
> Jul  8 19:21:15 p3 kernel: Buffer I/O error on device dm-1, logical
> block 365625856
> Jul  8 19:21:15 p3 kernel: lost page write due to I/O error on dm-1
> Jul  8 19:21:15 p3 kernel: lost page write due to I/O error on dm-1
> Jul  8 19:21:15 p3 kernel: JBD: I/O error detected when updating
> journal superblock for dm-1.
> Jul  8 19:21:15 p3 kernel: JBD: I/O error detected when updating
> journal superblock for dm-1.
> Jul  8 19:21:15 p3 kernel: RAID conf printout:
> Jul  8 19:21:15 p3 kernel: RAID conf printout:
> Jul  8 19:21:15 p3 kernel: --- level:5 rd:4 wd:2
> Jul  8 19:21:15 p3 kernel: --- level:5 rd:4 wd:2
> Jul  8 19:21:15 p3 kernel: disk 0, o:1, dev:sdf1
> Jul  8 19:21:15 p3 kernel: disk 0, o:1, dev:sdf1
> Jul  8 19:21:15 p3 kernel: disk 1, o:1, dev:sde1
> Jul  8 19:21:15 p3 kernel: disk 1, o:1, dev:sde1
> Jul  8 19:21:15 p3 kernel: disk 2, o:1, dev:sdc1
> Jul  8 19:21:15 p3 kernel: disk 2, o:1, dev:sdc1
> Jul  8 19:21:15 p3 kernel: disk 3, o:0, dev:sdd1
> Jul  8 19:21:15 p3 kernel: disk 3, o:0, dev:sdd1
> Jul  8 19:21:15 p3 kernel: RAID conf printout:
> Jul  8 19:21:15 p3 kernel: RAID conf printout:
> Jul  8 19:21:15 p3 kernel: --- level:5 rd:4 wd:2
> Jul  8 19:21:15 p3 kernel: --- level:5 rd:4 wd:2
> Jul  8 19:21:15 p3 kernel: disk 0, o:1, dev:sdf1
> Jul  8 19:21:15 p3 kernel: disk 0, o:1, dev:sdf1
> Jul  8 19:21:15 p3 kernel: disk 1, o:1, dev:sde1
> Jul  8 19:21:15 p3 kernel: disk 1, o:1, dev:sde1
> Jul  8 19:21:15 p3 kernel: disk 2, o:1, dev:sdc1
> Jul  8 19:21:15 p3 kernel: disk 2, o:1, dev:sdc1
> Jul  8 19:21:15 p3 kernel: md: recovery of RAID array md0
> Jul  8 19:21:15 p3 kernel: md: recovery of RAID array md0
> Jul  8 19:21:15 p3 kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/d=
isk.
> Jul  8 19:21:15 p3 kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/d=
isk.
> Jul  8 19:21:15 p3 kernel: md: using maximum available idle IO
> bandwidth (but not more than 200000 KB/sec) for recovery.
> Jul  8 19:21:15 p3 kernel: md: using maximum available idle IO
> bandwidth (but not more than 200000 KB/sec) for recovery.
> Jul  8 19:21:15 p3 kernel: md: using 128k window, over a total of 1465126=
400k.
> Jul  8 19:21:15 p3 kernel: md: using 128k window, over a total of 1465126=
400k.
> Jul  8 19:21:15 p3 kernel: md: resuming recovery of md0 from checkpoint.
> Jul  8 19:21:15 p3 kernel: md: resuming recovery of md0 from checkpoint.
>=20
> I think the right order is sdf1 sde1 sdc1 sdd1, I am right?

Yes, that looks right.

>=20
> So I have to do:
>=20
> mdadm -C /dev/md1 -l5 -n4 -e 1.2 -c 512 /dev/sdf1 /dev/sde1 missing /dev/=
sdd1
>=20
> The question is: sould I also add --assume-clean

--assume-clean makes no difference to a degraded raid5 so it doesn't really
matter.
However I always suggest using --assume-clean when re-creating an array so
on principle I would say "yes - you should add --assume-clean".

NeilBrown


>=20
> Thanks!
> Dietrich
>

--Sig_/lCwaUGmO4Qd7tF5n+NzvQ9c
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/ti9jnsnt1WYoG5AQLSOg/+P461+inNfVnqDyig8PY9EUTKpjb95oKM
0ZU+SGLr6YHVwtbG6seAtL3jzdle7Q5ue0NwBItX7V4G/Q11vXCd8ALJtYBl/1Z4
p8XCcIVnLZpXXA1sHqfS4fmin9CLd7UxNbGEniVh6vyAi3IjBLoA6N7ogF1ooVpY
JiqFjGzQacue9pajkIi9VLv4UWn7XTDonxfHOXzm7lZZQdp9OTgDzdESu+GqbPWu
rLjGmtmNRi7BIIBQ/sj0EOWwv9VrEdyJnPWz1XJMQsqkI7psA/YZpSlFfNl/AOhT
UlvP9QJmuaExvFjX2PzXRhI0xijGkB6D9MNVaAhhY635b74dC9iHeSTNPQ/k3bdv
n1IK4PjoMCoRiOSyKDhYuTBj4C6D6Tg3RSLfxHl+fPgH7qJzQ5rrTD5NaO6YCfvX
H4sTLn/icet60DXJOmeVa0afaazSHW97hU5WD87I0m+CvNIPjAQ1s3PHd5GOfHM4
M3YIHzk3kMBadPDbGQ2qmkwHbCo45GOvaho6dGG/S7HYRsEYDrQ77L0uOPdOga+G
ENXzBPb+6sh9h6spwuqR1rdqyOhkPQRMvjaQ77xaLmiiVLxMSYrT3SApPi8C6gmu
qAcLTKfzfXY3PP0tZAKc2mx7ryAy2SMPI6uIKRaZNgju/8APYIjFFa27sfsyp2ON
vawQnTBN1rs=
=2Jy8
-----END PGP SIGNATURE-----

--Sig_/lCwaUGmO4Qd7tF5n+NzvQ9c--
