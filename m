From: NeilBrown <neilb@suse.de>
Subject: Re: Odd IO traffic during raid5 reshape
Date: Mon, 22 Apr 2013 08:26:33 +1000
Message-ID: <20130422082633.6430312c@notabene.brown>
References: <20130418184822.GB16749@frosties>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kwWA6ssQpxRc/cBYS8gLhXy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130418184822.GB16749@frosties>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kwWA6ssQpxRc/cBYS8gLhXy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Apr 2013 20:48:22 +0200 Goswin von Brederlow <goswin-v-b@web.de>
wrote:

> Hi,
>=20
> I'm currently upgrading a NAS system with new disks. Since I'm
> changing the filesystem type and due to a lack of enough SATA ports I
> have to do add one new disk at a time, copy data, shrink the old
> filesystem, remove an old disks and repeat. I've started with a 2 disk
> raid5, copied data, freed a 3rd SATA slot and added the 3rd new disk.
>=20
> Now I'm reshaping the new raid5 from 2 disks to 3 disks:
>=20
> md0 : active raid5 sdd1[3] sdc1[2] sda1[0]
>       3907015168 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] =
[UUU]
>       [=3D=3D>..................]  reshape =3D 14.0% (547848840/390701516=
8) finish=3D1355.4min speed=3D41302K/sec
>=20
> so far everything works fine. But the speed is rather low and the IO
> traffic is higher than I think it should be:
>=20
> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
> sda             604.33     81706.00     40904.73    4902360    2454284
> md0               0.00         0.00         0.00          0          0
> sdc             440.78     81839.40     40542.07    4910364    2432524
> sdd             509.72         0.00     40817.67          0    2449060
>=20
> To reshape the kernel needs to read 1 data block from sda, 1 data
> block from sdc, compute the XOR of both blocks and write 2 data blocks
> + parity block back to the 3 disks. The kernel read 160MB/s, add
> 80MB/s parity and it should write 240MB/s (or 80MB/s per disk).
> Instead it only writes 120MB/s (40MB/s per disk), only half of what I
> expect.
>=20
> So what is going on there? Is the kernel reading both data and parity
> blocks and verifying them?

The kernel is reading data and parity.  Maybe it doesn't need to, but unless
your chunks are very big (10s of megatabyes?) reading takes about as long as
seeking over, so it is unlikely to affect total time.

Reshape simple is not a fast operation, nowhere near as fast as resync.
It needs to
  - read a few stripes
  - seek backward to where that data now belong
  - write the data as slightly fewer stripes
  - update the metadata to record where the data now is.
  - repeat

So there is lots of seeking.  md/raid5 tries to avoid unnecessary seeking,
but quite a bit of it is necessary.

It looks to me like it is performing quite well.

NeilBrown

--Sig_/kwWA6ssQpxRc/cBYS8gLhXy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXRnmTnsnt1WYoG5AQIOmxAAtisz6lFSK48mYuU1vaC0XPdYUsg5jB8a
SEa0SMVaSZnt9580JGWkloGonoRcJcbxeQ9v5L4lVdUxd/Y1GYZh4Qqk3zNGKMEM
edn3qHp6+WpF2cGdccRCE4HeQi5sU3tddcE3PI8Nhr9PDZ8vpLjhVZ0c6QNXgM4N
Pe/4KS45SL3gUg4HkAmliwj1zPF0ktPoyM1yWReQ5pca4PZrw8WDwxhgyTGleJx8
z2fABS36e7IaGB+KqaP63nQ90BWTSfYMkbMJWkCiRAyqh2xzLJYzhUibu3DyY6W6
CJEyEjPML/DiYdqkzb4hWuUtT66/QAT/BgRBjqsQzz8YtKMhr7Oh2/5lf1c1KGJE
1rDkSAw9irXo8WSVXBR5P3jjjw6fD4eSVvnEZFbDzvCkBb1MYGmTl/cqFtVgRTVH
lKBUFHeEiFZr62/gFEE/JikmV0n/kvP6shzgDkp6vsDPwId+xF1Y+oYawVYPjIPZ
fO6P1IGIe9foQSxNygTD6u5Opjv+bb81+9Ja6yN2KnNJ9fr3EFfU1R4u810rBcKW
TFa1X72J6AKx2/qzq/7sde6aNL0D7yJdVWgjO+p82YIJm4rWe9r/Wyhoppp2iZn4
iVFNNoJfCBgp13AjB05wjwmTYk+SW7Wi88HrIIaNXVj1zVqCW5M1SRAQZafTI5Zl
vgVuAtK5/0k=
=TXCo
-----END PGP SIGNATURE-----

--Sig_/kwWA6ssQpxRc/cBYS8gLhXy--
