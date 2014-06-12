From: NeilBrown <neilb@suse.de>
Subject: Re: raid5.c::grow_stripes() kmem_cache_create() race
Date: Thu, 12 Jun 2014 17:37:44 +1000
Message-ID: <20140612173744.03dd7a70@notabene.brown>
References: <CAGRgLy5Nz7aVRsqhco1eUB0hTvnYgupaUuGv=wA7ttWg+mdBmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3TCMf.TzKwLrWBfO96+vGNz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5Nz7aVRsqhco1eUB0hTvnYgupaUuGv=wA7ttWg+mdBmQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Yair Hershko <yair@zadarastorage.com>, Vladimir Popovski <vladimir@zadarastorage.com>, Shyam Kaushik <shyam@zadarastorage.com>
List-Id: linux-raid.ids

--Sig_/3TCMf.TzKwLrWBfO96+vGNz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Jun 2014 19:00:42 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> in your master branch, you have a code like:
>=20
> static int grow_stripes(struct r5conf *conf, int num)
> {
>     struct kmem_cache *sc;
>     int devs =3D max(conf->raid_disks, conf->previous_raid_disks);
>     int hash;
>=20
>     if (conf->mddev->gendisk)
>         sprintf(conf->cache_name[0],
>             "raid%d-%s", conf->level, mdname(conf->mddev));
>     else
>         sprintf(conf->cache_name[0],
>             "raid%d-%p", conf->level, conf->mddev);
>     sprintf(conf->cache_name[1], "%s-alt", conf->cache_name[0]);
>=20
>     conf->active_name =3D 0;
>     sc =3D kmem_cache_create(conf->cache_name[conf->active_name],
>                    sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5de=
v),
>                    0, 0, NULL);
>=20
> In our case what happened was:
> - we were assembling two MDs in parallel: md4 and md5
> - each one tried to create its own kmem_cache: raid5-md4 and raid5-md5
> (each one had valid conf->mmdev->gendisk)
>=20
> In our kernel SLUB is configured. So the code went to
> slub.c::__kmem_cache_create(). It called sysfs_slab_add(), which
> eventually tried to do:
>=20
> if (unmergeable) {
>     // not here
> } else {
>     // we went here
>     name =3D create_unique_id(s);
> }
>=20
> For both threads calling this, it created the same unique id:
> "t-0001832". And then sysfs freaked out and complained[1]. So md5 was
> unlucky and failed to initialize, and md4 got lucky and came up.
> Later, we retried md5 assembly and it worked alright.
>=20
> In this case, both MDs have the same number of disks. That's why
> kernel tried to have a single cache. Problem is that
> __kmem_cache_create unlocks slab_mutex, so that's why the race becomes
> possible.
>=20
> I realize that this is not MD-specific, but rather slab-specific
> issue, but do you have any idea how to fix that?:(

no, sorry.

As the slub developers.

NeilBrown

--Sig_/3TCMf.TzKwLrWBfO96+vGNz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU5lYyDnsnt1WYoG5AQIC3g//SP5X3MlyKsQocCoV+efS019f6zmjijvP
7YDIz7eHfZ2MXOJMuGOemPdKh+ZFJkvSrV9/GdwJ48K5YDU8ucJ1GoLK7JQot1bP
rT9bNmUjst205kex6tEjCn67rEIdzRiNKYrxrd7t19j6wQqrPQtBeFoY7PCORYZ1
qbgYZ45DxUTXuV1ba598jqPUw1MKBTFk84WzHIwEd2Zhd15yxGLAv1vzecbDAEWB
fthA2wJQxKNVEyPhILbSzd0TX8Vxp2nH2iaUD0tWqFLW3p1M2Y7PgcpHvnodqUCm
R7Yt+DLRSlIrkCDMSPhP9tQjp3ibH7yN+0oSQL5XPJH/w2dIVJtwyBgiXcDiqy6J
iOLW6UPlmU71J08KWyLr4Ka2DjIBhjikKA6B5BMSv7V+JpjpOLkIgSYBOxycIjwA
8yZRbumjLonCc4ZqDeqmrWJny5MDlZboRyd/uSbTdxNZx1CKXWwMR8cS6YERLqNg
BJhHn3/fO2pkIMoMUW3/0Z1H+ffHfPBx4oGou+jAymtogWksjIeIxXcDs5+FIUS8
d+xchX1ZMJVjuWibzyG0Y0zjq/FckntWVUckp1cgv1YrTvDQK2h/jFpOBYani39B
9yOIKRk1mxBiltyfmy6f/ptEHTOH0Zd9Jsl7fBRFtyO1YZ9vFQSmFp/NzGblXV7t
VUGISvz48nw=
=8B3f
-----END PGP SIGNATURE-----

--Sig_/3TCMf.TzKwLrWBfO96+vGNz--
