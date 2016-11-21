From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2] md: add block tracing for bio_remapping
Date: Mon, 21 Nov 2016 15:00:37 +1100
Message-ID: <87a8cteb2y.fsf@notabene.neil.brown.name>
References: <87shqpfrxv.fsf@notabene.neil.brown.name> <20161118172622.hzvmtt5rbtmdh7hh@kernel.org> <20161118175005.dodwcprytycwyuyq@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161118175005.dodwcprytycwyuyq@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 19 2016, Shaohua Li wrote:

> On Fri, Nov 18, 2016 at 09:26:22AM -0800, Shaohua Li wrote:
>> On Fri, Nov 18, 2016 at 01:22:04PM +1100, Neil Brown wrote:
>> >=20
>> > The block tracing infrastructure (accessed with blktrace/blkparse)
>> > supports the tracing of mapping bios from one device to another.
>> > This is currently used when a bio in a partition is mapped to the
>> > whole device, when bios are mapped by dm, and for mapping in md/raid5.
>> > Other md personalities do not include this tracing yet, so add it.
>> >=20
>> > When a read-error is detected we redirect the request to a different d=
evice.
>> > This could justifiably be seen as a new mapping for the originial bio,
>> > or a secondary mapping for the bio that errors.  This patch uses
>> > the second option.
>> >=20
>> > When md is used under dm-raid, the mappings are not traced as we do
>> > not have access to the block device number of the parent.
>>=20
>> thanks, applied patch 1, 3, 4.
>
> BTW, I added below patch
>

Yes, that looks good.  Thanks!

NeilBrown

>
> commit 504634f60f463e73e7d58c6810a04437da942dba
> Author: Shaohua Li <shli@fb.com>
> Date:   Fri Nov 18 09:44:08 2016 -0800
>
>     md: add blktrace event for writes to superblock
>=20=20=20=20=20
>     superblock write is an expensive operation. With raid5-cache, it can =
be called
>     regularly. Tracing to help performance debug.
>=20=20=20=20=20
>     Signed-off-by: Shaohua Li <shli@fb.com>
>     Cc: NeilBrown <neilb@suse.com>
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1f1c7f0..d3cef77 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -64,6 +64,7 @@
>  #include <linux/raid/md_p.h>
>  #include <linux/raid/md_u.h>
>  #include <linux/slab.h>
> +#include <trace/events/block.h>
>  #include "md.h"
>  #include "bitmap.h"
>  #include "md-cluster.h"
> @@ -2403,6 +2404,8 @@ void md_update_sb(struct mddev *mddev, int force_ch=
ange)
>  	pr_debug("md: updating %s RAID superblock on device (in sync %d)\n",
>  		 mdname(mddev), mddev->in_sync);
>=20=20
> +	if (mddev->queue)
> +		blk_add_trace_msg(mddev->queue, "md md_update_sb");
>  	bitmap_update_sb(mddev->bitmap);
>  	rdev_for_each(rdev, mddev) {
>  		char b[BDEVNAME_SIZE];

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYMnFlAAoJEDnsnt1WYoG5FMAP/jl+InHtBedwAcRWsbyFU6Lq
5M/n112GMMg2rydolI4a1xtr16M+Uids7i2UM7SlaSFYKZIxtzxPZ4bNZYhvvT22
5DOL/6WrZQIPhlySs1NDSu3ouxd0Z3xRETKx81lBtQN5Lnxzsn2RKrBo5uRn/Mct
CBNaRmZfbC3TsS+kPEfwlS+NLxmTWTvAuwRwj4dvgyzkinQnf3YBFTenVAqG8kB6
JgxOrLSkXpERLXg6LaljbbhTyRlKu6yfZwc/KpUZr1TyE+ru1YhE8fLuNiQvklOS
XWUW3tMgUk8EXNQ+kBLy67YUHc5cqjZw90UfGYoMxkJRndGHMW/lBu+9d636Xv6L
sIJP+D5nhmqkpPcIwW25ar8i+i8dJk5Tim58WONOKUt64V1vo8UBHw6LIskjVXh9
Gc4uB54qLyBZYhjiNYKpC/cjJR9jpswm18MLWZWMtt7y/liw8sgrvL1uV5eYhd1U
rH4PFMVUJND7YoHDBnakaV641ZE12ZfJwWALPnUqmvM9Hrg5A0LIFAE72Fe7xWSO
LbyC2mGTT3OcLnK8RT0QvYKroyfo4cUZqM/T1U9p7hcdjFxs5UE8DxBewSZOYV8m
0yKdjVSLhnKl1HLyODo2JqRU+ipsiGoIkVQ5xJrXZc3a3uW98g7WQWE1YLip0lHf
8dSMjrHKJDQhIRzQ4pej
=DXgg
-----END PGP SIGNATURE-----
--=-=-=--
