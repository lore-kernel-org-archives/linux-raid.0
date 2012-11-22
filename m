From: NeilBrown <neilb@suse.de>
Subject: Re: want-replacement got stuck?
Date: Thu, 22 Nov 2012 13:10:02 +1100
Message-ID: <20121122131002.4944ce0d@notabene.brown>
References: <20121120221145.9905.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Z_hfgZr0k4F4tzdwtQpm=oE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121120221145.9905.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Z_hfgZr0k4F4tzdwtQpm=oE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On 20 Nov 2012 17:11:45 -0500 "George Spelvin" <linux@horizon.com> wrote:

> I have a RAID10 array with 4 active + 1 spare.
> Kernel is 3.6.5, x86-64 but running 32-bit unserland.
>=20
> After a recent failure on sdd2, the spare sdc2 was
> activated and things looked something like (manual edit,
> may not be perfectly faithful):
>=20
> md5 : active raid10 sdd2[4](F) sdb2[1] sde2[2] sdc2[3] sda2[0]
>       725591552 blocks 256K chunks 2 near-copies [4/4] [UUUU]
>       bitmap: 50/173 pages [200KB], 2048KB chunk
>=20
> smartctl -A showed 1 pending sector, but badblocks didn't
> find it, so I decided to play with moving things back:
>=20
> # badblocks -s -v /dev/sdd2
> # mdadm /dev/md5 -r /dev/sdd2 -a /dev/sdd2
> # echo want_replacement >  /sys/block/md5/md/dev-sdc2/state
>=20
> This ran for a while, but now it has stopped, with the following
> configuration:
>=20
> md5 : active raid10 sdd2[3](R) sdb2[1] sde2[2] sdc2[4](F) sda2[0]
>       725591552 blocks 256K chunks 2 near-copies [4/4] [UUU_]
>       bitmap: 50/173 pages [200KB], 2048KB chunk
>=20
> # [530]# cat /sys/block/md5/md/dev-sd?2/state
> in_sync
> in_sync
> faulty,want_replacement
> in_sync,replacement
> in_sync
>=20
> I'm not quite sure how to interpret this state, and why it is showing
> "4/4" good drives but [UUU_].

"4/4" means the array is not degraded.
[UUU_] means that the drive in slot 3 is faulty.
The way this can happen without the array being degraded is that the
replacement is fully in-sync.

What has happened is the replacement finished perfectly and the want-replace
device was marked as faulty, but when md tried to remove that faulty device
it found that it was still active.  Some request that has previously been
sent hadn't completed yet.  So it couldn't remove it immediately.
Unfortunately it doesn't retry in any great hurry .. or possibly at all.=20
I'll have to look in to that and figure out the best fix.

...
> It appears to have completed:
> Nov 20 18:40:01 science kernel: md: md5: recovery done.
> Nov 20 18:40:01 science kernel: RAID10 conf printout:
> Nov 20 18:40:01 science kernel: --- wd:4 rd:4
> Nov 20 18:40:01 science kernel: disk 0, wo:0, o:1, dev:sda2
> Nov 20 18:40:01 science kernel: disk 1, wo:0, o:1, dev:sdb2
> Nov 20 18:40:01 science kernel: disk 2, wo:0, o:1, dev:sde2
> Nov 20 18:40:01 science kernel: disk 3, wo:1, o:0, dev:sdc2
>=20
> But as mentioned, the RAID state is a bit odd.  sdc2 is still in the
> array and sdd2 is not.

Yes, it completed.  The "conf printout" doesn't mention replacement devices
yet.  I guess it should..

NeilBrown

--Sig_/Z_hfgZr0k4F4tzdwtQpm=oE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK2Jejnsnt1WYoG5AQLEthAAoZReZA/Juz5VVd+0ULuuXv3JV2pU/XB8
T6qW2GThctdwtIwcmg53Oe9HaidAYcKG+0svbF3M/G9gkIDkkdF8S9fPs6jkQMDr
FYzWwjkxmMsz2sBupjgdVJAkd6UlrBC0w8s6RVgLHgd9GYLrCvZMGaxWQnBILp+n
EthYTbTfhRc/zKTX0b546AqhAtZI8s1c4ptoh47CZwLgo4AAo8ygOeqdA+aBZCz8
R59rb4/FI1n0EZGv4a8rsaRS3cIbcHzIA4JDXQXdYDlE9rTqYFSIFbdn5hqjx4dM
HXd5c8XUOiNDrMx5KODzCfsY6sD+iaq/69ud1Pti8J85dLrvhXwnVZvChuW+dney
73lzselh5r/GD59o8gDCigtBTg1jCxs8BS4CkmyUsz92lv+BoUcopdkyY8pw6kyj
KlfINHapa2/y3QGIMqP6CNcTLl8p1/HqP6z0BlWqnX8js7Lio6AXjUXGB411wEwr
uBLyt5FXjPb2JPSGmXgt/3vxRdQcdlG4GlfBdR9ZTmnk0pMW8oK3UJIDIC2OUHUi
/c++cvYlbk5vaJsSOxmVpD8+tRydKBp4ebsfLjOyEMrGvMe8xQG/XVurTU1e7qpX
nBkGej0YXpDrvGT3tLPC2zZSjal9dz/EBzMSxrEl2aTF5wk/+g3KrGp4CdhWTEco
stHZPHxVWE0=
=Kjl3
-----END PGP SIGNATURE-----

--Sig_/Z_hfgZr0k4F4tzdwtQpm=oE--
