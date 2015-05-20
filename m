From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v2 0/6] a caching layer for raid5/6
Date: Wed, 20 May 2015 15:23:53 +1000
Message-ID: <20150520152353.175365f4@notabene.brown>
References: <cover.1432003804.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//pL0=sHf_XTDKBMS9NDpAKS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1432003804.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_//pL0=sHf_XTDKBMS9NDpAKS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


hi,
 I cannot possible give any consideration to this caching layer until I'm
 happy with the code I got from you for stripe batching, and I'm not.

I asked:

Subject: Re: [PATCH 7/7] md/raid5: fix handling of degraded stripes in batc=
hes.
Date: Wed, 13 May 2015 10:56:04 +1000

> What exactly do you expect to happen after the stripes in a batch after t=
hey
> have been split up?

and haven't received a reply yet.
Did you not get that email?

Thanks,
NeilBrown



On Mon, 18 May 2015 19:57:28 -0700 Shaohua Li <shli@fb.com> wrote:

> Hi,
>=20
> This is the second version of the raid5/6 caching layer patches. The patc=
hes add a
> caching layer for raid5/6. The caching layer uses a SSD as a cache for a =
raid
> 5/6. It works like the similar way of a hardware raid controller. The pur=
pose
> is to improve raid performance (reduce read-modify-write) and fix write h=
ole
> issue. The main patch is patch 3 and the description has all details abou=
t the
> implementation.
>=20
> Main changes of V2 are to improve performance. Meta data write doesn't us=
e FUA
> any more. Discard request is only dispatched when discard range is big en=
ough.
> Also have some bug fixing and code cleanup. Please review!
>=20
> Thanks,
> Shaohua
>=20
>=20
> Shaohua Li (5):
>   raid5: directly use mddev->queue
>   raid5: A caching layer for RAID5/6
>   raid5: add some sysfs entries
>   md: don't allow resize/reshape with cache support
>   raid5: skip resync if caching is enabled
>=20
> Song Liu (1):
>   MD: add a new disk role to present cache device
>=20
>  drivers/md/Makefile            |    2 +-
>  drivers/md/md.c                |   14 +-
>  drivers/md/md.h                |    4 +
>  drivers/md/raid5-cache.c       | 3519 ++++++++++++++++++++++++++++++++++=
++++++
>  drivers/md/raid5.c             |   97 +-
>  drivers/md/raid5.h             |   16 +-
>  include/uapi/linux/raid/md_p.h |   73 +
>  7 files changed, 3705 insertions(+), 20 deletions(-)
>  create mode 100644 drivers/md/raid5-cache.c
>=20


--Sig_//pL0=sHf_XTDKBMS9NDpAKS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVwaaTnsnt1WYoG5AQL/bQ/6A6UWoCArqTBLyvQptgYvUdh/xg9y+RcE
9+8F+HWwpXYRkwG+9ccadJEm924Em6BgtNnKZ6Ot+FzHCkcS6VXewUuCAgBgiSQh
0Y5W37Cq7uA5bhBorweYCyoENU8UDvoxK+BUwNlGKrGOsZjQzGGlDYNExrfhZpQz
rdCXkkpSRzSY+OR6tMPtM2HvssCAJNMI79QaFnOwHp0Vjr8X4Fifjb1WfuvCAER2
hN06LUq8rM7jBcAXnNk7YKCjeCw3rTHqIkPc1mDVzsi/nS46jVn9U+hpqDSW76rX
dztBnl0BTNhVkE06tgnSiXrxBVqgQRky7C6TzepdoOUpAqcVYW90RkoFQZM8rf5P
mKcRCMKPsVgrAeaACmLtxS4MDZ5u8KCX7RoHZwjEVyJxCrGtk7WQEEgQXHOPufM3
mU11xzSPrfbpknX5sw/QQaIoTb4SnW2dP5tXms3VFH4A27ODtErV2aud7Tw6GEX3
0+87ryOdSefW6FViR8Hzsu7Uc0oJ/BS3iYHIDMnNUZ1sfNptN5p4t7dtStNZi9zE
hJu2H5/uy+fFGs8wBDoGWJFLsh1QQXcTYCzT4wWWYi+3flXKh8bvlrrFCRWzjRVZ
aVeZTsZVE4sfVhspZKzOBpDHGDjit8JaZMrBz8lxd6bXrXj7tMJ9CbCCNuxccSfZ
2bmXZQuUu2k=
=i4gO
-----END PGP SIGNATURE-----

--Sig_//pL0=sHf_XTDKBMS9NDpAKS--
