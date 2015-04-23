From: NeilBrown <neilb@suse.de>
Subject: Re: Bisected, with rfc/patch - was Re: BUG: unable to handle kernel
 NULL pointer dereference at sysfs_do_create_link_sd (after mdadm)
Date: Thu, 23 Apr 2015 18:03:14 +1000
Message-ID: <20150423180314.367c0876@notabene.brown>
References: <20150414171537.GH25394@azat>
	<20150423160551.45345f96@notabene.brown>
	<20150423073724.GA8139@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/BzTUIMqFfgZ9ORi1yrmuqov"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150423073724.GA8139@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Azat Khuzhin <a3at.mail@gmail.com>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>
List-Id: linux-raid.ids

--Sig_/BzTUIMqFfgZ9ORi1yrmuqov
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Apr 2015 09:37:24 +0200 Christoph Hellwig <hch@lst.de> wrote:

> Plase fix your device name lifetimes.

Any chance you could be more explicit?

The commit you identified doesn't seem to help much - md and dm are quite
different in this area.

It seems that it is no longer safe to call 'add_disk' between calling
'del_gendisk' and bdi_destroy being called.  How can I find out if I am in
that window, or wait for bdi_destroy to be called?

Thanks,
NeilBrown


>=20
> See the DM commit
>=20
>     63a4f0 ("dm: fix add_disk() NULL pointer due to race with free_dev()")
>=20
> for a template.
>=20
> Unregistering the device too early means we'll have half constructed
> bdis hanging around, which caused all kinds of problems for filesystems
> and the writeback code.


--Sig_/BzTUIMqFfgZ9ORi1yrmuqov
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVTinQjnsnt1WYoG5AQJk0w/9EkFoE+6At2piFMGHEeleoVwd59NVDL6T
69vkZkYjcGt1jKg6pCV/CFRp130AUhZkXVqR6Wo6GJpfKWq/FCSuaLWDmPantF9w
Fjk3K/XKMusy7vD8NR3HkSPjKlki4n8T73AbEemjKfd4zIOc2TxvvFK2X0DXzz+0
DM6r35MkbmFgoWlBxW5DOfIyJSGME3pUIbDRP1ZWuyo8JXJGTS4jq4Syzt6B/Vmq
PS5NHn2cJo+8wr+cInIrS7QkqY32Kdwsu/Cm5Gn7qei1/X2f/cAtOsilB9gPwNoe
dWgelUES2fvpgPvCu9AVmNhWnjycSYuFe6fFrfAUiITWl20roYKbrTZfbMz6969C
yNZmDMgJg3F8ZcDYQ83QA3Cjd1bDTdeBjpwjGwNXXG9WLO+8QSwG1JV9YIXYH+xO
d8vvYB/fp7gBCsHG+cJ3uuxuZ5NvLzJAetLqWEbqhdFJEfKgv0Q/0k2OdTOw6grQ
psNXFbtgus593uaNqNrorXjsDeVQJuouXkpB0Bbr7kJoyZ6M4erc1yVryy1Fy49g
ZzfOsWwkDmzKm/Bs23fX+mVnEuX5qDU0HhTTm3TWE09kBnH/12wcRyauEyzzKlom
ukB6oSzOnFySJQEZwmav6vd2Lvx+7DHgHShbdNTxViqOVIvHqrP1uOV1N17VWG+i
fX+awXZV+3w=
=70kr
-----END PGP SIGNATURE-----

--Sig_/BzTUIMqFfgZ9ORi1yrmuqov--
