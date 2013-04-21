From: NeilBrown <neilb@suse.de>
Subject: Re: Odd CPU usage in the last stage of a raid5 reshape
Date: Mon, 22 Apr 2013 08:28:33 +1000
Message-ID: <20130422082833.34724ab9@notabene.brown>
References: <20130419075404.GA1938@frosties>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/k+kJ8zv+K6Jt6or=4ufdOE="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130419075404.GA1938@frosties>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/k+kJ8zv+K6Jt6or=4ufdOE=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Apr 2013 09:54:04 +0200 Goswin von Brederlow <goswin-v-b@web.de>
wrote:

> Hi,
>=20
> I'm still reshaping a 2 disk raid5 to 3 disks. It has now progressed
> past the 50% mark so all data has been reshaped. So now the kernel
> simply writes zeroes (I assume) to all 3 disks. There are no more
> reads, only writes.
>=20
> Now what is odd is the cpu usage:
>=20
> /proc/mdsata:
> md0 : active raid5 sdd1[3] sdc1[2] sda1[0]
>       3907015168 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] =
[UUU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>........]  reshape =3D 62.0% =
(2425537964/3907015168) finish=3D22
> 0.0min speed=3D112230K/sec
>=20
> iostat -k 10:
> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
> sda             834.40         0.00    103372.60          0    1033726
> md0               0.00         0.00         0.00          0          0
> sdc             813.90         0.00    104601.80          0    1046018
> sdd             718.50         0.00    104499.40          0    1044994
>=20
> top:
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND     =
     =20
>  2058 root      20   0     0    0    0 R   96  0.0   1106:40 md0_raid5
> 18379 root      20   0     0    0    0 R   50  0.0 324:11.19 md0_reshape
>=20
> Is the kernel zero filling the raid device and computing the XOR of
> zeroes for the parity blocks? Wouldn't it be less cpu consuming to
> insert zero filled stripes directly into the stripe cache?
>=20

Yes, the kernel is computing an XOR of the zeros to determine the parity
block.  This certainly could be optimised, but it is hardly a priority.

NeilBrown

--Sig_/k+kJ8zv+K6Jt6or=4ufdOE=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXRoETnsnt1WYoG5AQK8gA/+NsA1/EdwnhkSGkCmfLZo07XF0OYqWNew
40q2Fj8UqOo7J1+GMP8tZbbh1HJ+43gq1a8XlVljRxjY56TYiLc52QRNZJd9+Cso
JGUavdu6i3ul+D9Y3qNdoLRqRdg5KmFS/V3qk8Drbbw2D4lwldUqce8V+53GBnft
s63yUJBbCBQuBBxlY4AHg33rQl7XR7PG/H/nk7b2fapzKyEOloEnEJweng3Dne5c
78lqFQVe1EkSfrbXtfFzukQ9u8/qWJjNFm+qOrSPb6Ce2Rcy1LCUgCe/JzN94T4Y
UO1m9gIpTYawed/Hs48KNQNnUDk0GFO7JpvAZpVGAimhwnOChqkiBI09wAgBJ7Ey
VCYWuAJXbJghJ76YqDL/+Yd0ShhI0wyNWxZXArK8fQH35B88TcAwIf0ZBpBnDZ8+
DePi3ebYowV7dnA2bHegFKDa9X17qrhEhIvyVCSy+L43Uyie228HkZ691oNi+HZw
93SNbJMZytKjHTtlVo5t1HUKO5QS3Q9YrVks5EETfV1x7fmGYoqDZWmaDZNhQ8oq
RscsQBUrlJjMbIaZCLmmk/2HkqnZO4AB1KoA1H/uQm++D+tbCbZEcxzP9OjpcR1E
CToxY+zNbgUcS4LUoc71ZqzXN7ZKVTJQlIq9CrCIUFLNRWSJCwvT0IXHp6iJ5OJ3
ASSL9LnGy6Y=
=YG4+
-----END PGP SIGNATURE-----

--Sig_/k+kJ8zv+K6Jt6or=4ufdOE=--
