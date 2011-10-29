From: NeilBrown <neilb@suse.de>
Subject: Re: raid(1) and block caching
Date: Sat, 29 Oct 2011 17:26:41 +1100
Message-ID: <20111029172641.57f92fc3@notabene.brown>
References: <CAGqmV7p+GP-Ou-zUhq2rBb_9_tAEX6PRtQatvLCG9=FuOPNsow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FaE/e7O=QO/u2Pk36cF4QqS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7p+GP-Ou-zUhq2rBb_9_tAEX6PRtQatvLCG9=FuOPNsow@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/FaE/e7O=QO/u2Pk36cF4QqS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 29 Oct 2011 08:49:09 +0400 CoolCold <coolthecold@gmail.com> wrote:

> Hello!
>=20
> There is holywar once again on nginx maillist about standalone drives
> vs raid1 arrays for serving static files. By standalone drives it is
> assumed that file "Filename1" exist on /mnt/disk1, /mnt/disk2,
> /mnt/diskN where /mnt/diskX is mountpoint for drives /dev/sdY.

If you want fast reads, then use RAID0 if you don't care about losing your
data, and RAID10 in 'far' mode if you want RAID protection.

>=20
> As there are some pros and cons on both sides (at least theoretically)
>  I have dumb question - let's say our array md1 consists on 3 drives -
> /dev/sd{a,b,c} - and when data read from md1 occurs, which block is
> cached in VFS (or may be other cache in system, it would be nice to
> know which part of system is doing caching)  - the block from md1
> itself or from certain drive? If it is drive-based block cache, it's
> gonna be potentially memory wasting to keep 3 similar data copies, so
> I assume md does data reads with something like O_DIRECT flag, but as
> I 1) don't know C 2) don't know kernel, I'm asking this on the list to
> make this clean for myself.
>=20

The kernel caches pages of files, not pages of devices.
It doesn't matter where the page of data came from - it is the page of a fi=
le
that is cached.

NeilBrown

--Sig_/FaE/e7O=QO/u2Pk36cF4QqS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqucpjnsnt1WYoG5AQI/0w//f41tYMQcoFLRgrGVVJWDbMfK7ZIIP5NZ
PkerybffSIU2NqXvI8j4H3o/cfWlIPkDil55HorBzngYtlqXkWCG2cVXAbZNvJ5/
Fqi2sVQ4F848OxpuQEV1YobG51/PKAzrp9z7UHEoVW3ecyLlgOak9DSCqJk2Yglm
s4VAiBZuphm+Yx+Y3Db2/SDKubK4U3LJUvMYV9m1WxIvT6niorZ//3vbo0NTI2Bb
KwV6RjmzOujYD+gOzbiX9jXo8j8FIx06Rp/aYLycpnGcvFXW2AMm1f6L64a18W5H
l6J9IwHqUbUFxN7Vf0JyQ3t4jJY6LLIB5HRXU/AnujpufilKI70UGuRXGYLrKcQs
bsZ/xifh8I1ODbExTyVNpKkBhm/fh0kL6L/laf9R1iGsOA6IaAaHULG+/oA6tUdd
QvyK+6AC4QRWC3YnJz3sT35NJBgUVW9xMfociXuU03xSrdG7bPaGeW914qQ/ueIn
rfMNNipQFS98LFDQNH/pKL6MQQwDM+8GTuW/VVu8xNzOqEEFM/PnL5pck/S1kYem
bv2OFHpv8PvVU99t5kAM4Pqib9hWmtauV1xLHlrgnHPbPRRcZGOvISo44Do5373/
o1qScI9rAl0Lvdz8qDzLXf1PGiE+HvsiNZWu+mvyCZF0wHPU0czAfQdtOTfnQehw
TtSkolEAyB0=
=UZ0x
-----END PGP SIGNATURE-----

--Sig_/FaE/e7O=QO/u2Pk36cF4QqS--
