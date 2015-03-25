From: NeilBrown <neilb@suse.de>
Subject: Re: MD request counter broken on 4.0-rc5 RAID1
Date: Wed, 25 Mar 2015 11:46:18 +1100
Message-ID: <20150325114618.6bf007ed@notabene.brown>
References: <20150325000403.GA27368@hostway.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6BLDb4mzYSCLLOy.2jVcztP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150325000403.GA27368@hostway.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Kirby <sim@hostway.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6BLDb4mzYSCLLOy.2jVcztP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Mar 2015 17:04:03 -0700 Simon Kirby <sim@hostway.ca> wrote:

> Hello :)
>=20
> I'm seeing "iostat -x -k 1" print this after a RAID1 rebuild on 4.0-rc5.
> It's not abnormal other than it's 3-disk, with one being SSD (sdc) and
> the other two being write-mostly:
>=20
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-s=
z avgqu-sz   await r_await w_await  svctm  %util
> sda               0.00     0.00    0.00    0.00     0.00     0.00     0.0=
0     0.00    0.00    0.00    0.00   0.00   0.00
> sdb               0.00     0.00    0.00    0.00     0.00     0.00     0.0=
0     0.00    0.00    0.00    0.00   0.00   0.00
> sdc               0.00     0.00    0.00    0.00     0.00     0.00     0.0=
0     0.00    0.00    0.00    0.00   0.00   0.00
> md0               0.00     0.00    0.00    0.00     0.00     0.00     0.0=
0   345.00    0.00    0.00    0.00   0.00 100.00
> md2               0.00     0.00    0.00    0.00     0.00     0.00     0.0=
0 58779.00    0.00    0.00    0.00   0.00 100.00
> md1               0.00     0.00    0.00    0.00     0.00     0.00     0.0=
0    12.00    0.00    0.00    0.00   0.00 100.00
>=20
> This was working on 3.18. Shall I bisect, or is it obvious?

Almost certainly 18c0b223cf9901727ef3b02da6711ac930b4e5d4 in 3.19.

It adds 'part_inc_in_flight' and never decrements it.

Complain to the author.

Thanks,
NeilBrown

>=20
> It seems to just be leaking as the counters were going up gradually while
> it was rebuilding.
>=20
> Personalities : [linear] [raid0] [raid1] [raid10]
> md1 : active raid1 sdb2[1](W) sda2[0](W) sdc2[2]
>       530048 blocks [3/3] [UUU]
>=20
> md2 : active raid1 sdb3[0](W) sdc3[2] sda3[1](W)
>       153613440 blocks [3/3] [UUU]
>=20
> md0 : active raid1 sdb1[0](W) sdc1[2] sda1[1](W)
>       2104384 blocks [3/3] [UUU]
>=20
> unused devices: <none>
>=20
> Simo-
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/6BLDb4mzYSCLLOy.2jVcztP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVRIFWjnsnt1WYoG5AQKeIw//fCqX962Rlp3h/Wg/4jFgTnqxxt7oZbC7
6xZIXIf558knyYOX/U5CGEppfS43LL7LtQVEP/cuyrjZ2uqg0YMtV0HzzS9Ljf6I
te/jSejXvulBoAigf/PYSlq1N9GRILr9vhRYKSYLYC3y9ywNqALEG7YQsjIgns2Z
XulT+3IqXuNarmo7Voy8Xf9/lvRfysFk/q/s0WOwfD2eQ+p+PB64qLsORZkvmP77
JwzTxrAmrZIBDRWOZVs1BLRRAzdWoAZ4wyFiq8YqInuQDne5otKRe4qIx2g4p9gy
mJqkC0Ml25/EJbDOUoBzOAe+q7e/u8VQ4KtIq5TL7pByGivQxdnWIHmvcQKG0L22
JXJYBuGestf5yygsOAnTwqd97b31iElCfdkqqZiyNe/zYlQUN0VNpcwEJ3lqoArR
MyOBHsER2i/lOcNTaPc4QRaiiGbjWYTpRxdFeODT7/QYYYYybU5/IRUoiKo9lKIZ
EEqdSt19Bo1uMeyEvYmhctWLv61VHqsXc/vMoNAlHbMJZ2NB3hy29AsELA76igX2
PJr9flW1y80NFz5e53j8+mQEpYNOwW9DapSSwrsCKTnvQ305VABiTFXoTtpBwWSO
bf91aVXujo/cC/pDZoFi03jlPnVjWkjaUKMtQHdmqGaq9+hNek88X3ycjSjHPygN
z1Cl1WrHFjM=
=MCBO
-----END PGP SIGNATURE-----

--Sig_/6BLDb4mzYSCLLOy.2jVcztP--
