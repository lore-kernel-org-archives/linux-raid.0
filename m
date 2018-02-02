From: NeilBrown <neilb@suse.com>
Subject: Re: Troubleshooting "Buffer I/O error" on reading md device
Date: Fri, 02 Feb 2018 12:55:53 +1100
Message-ID: <87inbg2lzq.fsf@notabene.neil.brown.name>
References: <1z_MZ4Xqld_IRMUbGJE66v2VUhXkBhlHnWJEfLASWNcv5s3Wo3A1YeuQBJBuksxJtFPpmsPbg1_F8PC3Sj4HrzL6Go3aIanVihzcC-4ZHEQ=@protonmail.com> <87373og9z9.fsf@notabene.neil.brown.name> <XUhdgUHMsoit8A9Qw13P1q6NQUxsgqNZCsgx6us_8kHu50GPOvQoOBwP-ryQz54CBi6Js7J2xwC8jgKQ5geXi5AdVLT27YlucQ4tWH-8xlM=@protonmail.com> <87r2r8dk80.fsf@notabene.neil.brown.name> <f92IIdV_PSMtdilVnQDOaLSxzvpTkAa6D0nxpuplzzdnaP9km9JveoXfzOlygcXD5Y_HpN49Fh0x4nOZFhXPfv5VyPrT6CgFO-nsULq6wn0=@protonmail.com> <871sj5dsiv.fsf@notabene.neil.brown.name> <M1riU2VdgyXq3ozdVUjaSDLksJfD8z3lZEy7D8JWIMb9mJk8A6CFz7Q1_tA_wFkVGC1lyTI7yTMb8DXv7T6JDGvKzUFGHbY7mZ9vLNqlowo=@protonmail.com> <F_VxJAwrrEFTHG3fvMDQYPLKrS0w9yabmLk-nyrGRf3UQV-QxsnRSzojv6XQtCiKN7YMZ3sSOlbLduUL_apbYN25g7ouW-Th2S_fbMDgAEM=@protonmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F_VxJAwrrEFTHG3fvMDQYPLKrS0w9yabmLk-nyrGRf3UQV-QxsnRSzojv6XQtCiKN7YMZ3sSOlbLduUL_apbYN25g7ouW-Th2S_fbMDgAEM=@protonmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: RQM <rqm@protonmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 13 2018, RQM wrote:

> Hello,
>
> I have been made aware that the link I had supplied previously does not w=
ork anymore.
> Here's another attempt at uploading the `mdadm --dump /dev/sd[bcdef]3` ou=
tput:
>
> https://filebin.net/i0olmgzg52obnp0f/dump.tgz
> =E2=80=8B
> Any help is greatly appreciated. Please do let me know whether you plan o=
n working on this issue in the near future, because otherwise I will have t=
o re-create a new array on these disks in order to put them into production=
 again.
>
> Thank you so much!

Sorry that is has taken me so long to get to this - January was a bit
crazy.

Short answer is that if you use
  --assemble --force-no-bbl
it will really truly get rid of the bad block log.  I really should add
that to the man page.

Longer answer:
If you assemble the array (without force-no-bbl) and

  grep . /sys/block/md0/md/rd*/bad_blocks

you'll get

 /sys/block/md0/md/rd2/bad_blocks:3196060416 8
 /sys/block/md0/md/rd3/bad_blocks:3196060416 8

So that is a 4K block that is bad at the same location on 2 devices.
There is no data offset, and the chunk size is 64K, so using bc:

% bc
3196060416/(64*2)
24969222
3196060416%(64*2)
0

the blocks are at the start of stripe 24969222.
Each stripe is 4 date chunks, and a chunk is 64K or 16 4K blocks.
So the block offset is close to

% bc
24969222*4*16
1598030208

which is exactly the "logical block" which was reported.

There are 5 devices, so the parity block rotates through the pattern

D0 D1 D2 D3 P
D1 D2 D3 P  D0
D2 D3 P  D0 D1
D3 P  D0 D1 D2
P  D0 D1 D2 D3

% bc
24969222%5
2

So this should be row 2 (counting from 0)
D2 D3 P  D0 D1

rd2 and rd2 are bad, so that is 'P' and 'D0'.

So this confirms that it is just the first 4K block of that stripe which
is bad.
Writing should fix it... but it doesn't.  The write gets an IO error.

Looking at the code I can see why.  The fix isn't completely
trivial. I'll have think about it carefully.

But for now --update=3Dforce-no-bbl should get you going.

NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlpzxSoACgkQOeye3VZi
gblYWhAAn32lYiQxNFIgDPXGvNpcy6nlf/YKb/ev4gctqG1oTwoz/OtjmsP9h6p1
hU0oE27n//QDgjQubKVp9N7DX0VjtPUQpVB48XEgb7kKNHlM9u1zF7mna5AD+DxJ
xtOEcvJdMxc3R+B2Q0tSonTJtoDF8L3CvCHSesVva5urhse+X2EUtfB507Ka3ng7
944cXw8GYVT12cp+UvpTqT7YlxnP5mbJmtPFYfGa042tiRVK4oyq17tBbEVh4LaT
w09Vxpqq+aOZBeLDTTNOIA8bFVRCGIZaVPBkbaKBKzS0lK0/lqMx1E2zJjP028A+
qIbmKBfDwNvR9695acWQq9bHMOzOzcfr6S4RjAV46FYPmE+ML7NzRWKGUGBXqHYl
tMpn4n+wlTDX/ow3m0R7juSL3LED1tyDjh/I5bvjH5gI6/PXxffNL1/h3Ma26nYk
MazNDAOiC1m9VXvdjtP5yRI/BogVWyVKJGS0c8FqSr5v5C4r/5vzGlVLMt1VuceX
HkqgaLcSl7NRrxKsd4GSp37JymCaR3ZUInVKYSpIT2S5R0IimF8DZpKjnkANuo69
G5+v2GGMhGmExAZtPBKC1+aSJoDwblyPxJGvlDSYzx+/RYpwSxkNXRbNAhvrXAAz
hMLbcAUPAWwMaq2OW/BHlnhfGPP5dXsoQPcGP2WqCmVdqEpvD9A=
=XM2G
-----END PGP SIGNATURE-----
--=-=-=--
