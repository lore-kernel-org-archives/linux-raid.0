From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 6/8] raid5: make_request use batch stripe release
Date: Thu, 7 Jun 2012 17:33:10 +1000
Message-ID: <20120607173310.2a3f147b@notabene.brown>
References: <20120604080152.098975870@kernel.org>
	<20120604080335.029329200@kernel.org>
	<20120607112345.1429436b@notabene.brown>
	<20120607063358.GB779@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nJPEA/dcLqL3.W+B6xbyAT4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120607063358.GB779@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/nJPEA/dcLqL3.W+B6xbyAT4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Jun 2012 14:33:58 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Thu, Jun 07, 2012 at 11:23:45AM +1000, NeilBrown wrote:
> > On Mon, 04 Jun 2012 16:01:58 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > make_request() does stripe release for every stripe and the stripe us=
ually has
> > > count 1, which makes previous release_stripe() optimization not work.=
 In my
> > > test, this release_stripe() becomes the heaviest pleace to take
> > > conf->device_lock after previous patches applied.
> > >=20
> > > Below patch makes stripe release batch. When maxium strips of a batch=
 reach,
> > > the batch will be flushed out. Another way to do the flush is when un=
plug is
> > > called.
> > >=20
> > > Signed-off-by: Shaohua Li <shli@fusionio.com>
> >=20
> > I like the idea of a batched release.
> > I don't like the per-cpu variables... and I don't think it is safe to o=
nly
> > allocate them for_each_present_cpu without support cpu-hot-plug.
> >=20
> > I would much rather keep a list of stripes (linked on ->lru) in struct
> > md_plug_cb (or maybe in some structure which contains that) and release=
 them
> > all on unplug - and only on unplug.
> >=20
> > Maybe pass a size to mddev_check_unplugged, and it allocates that much =
more
> > space.  Get mddev_check_unplugged to return the md_plug_cb structure.
> > If the new space is NULL, then list_head_init it, and change the cb.cal=
lback
> > to a raid5 specific function.
> > Then add any stripe to the md_plug_cb, and in the unplug function, rele=
ase
> > them all.
> >=20
> > Does that make sense?
> >=20
> > Also I would rather the batched stripe release code were defined in the=
 same
> > patch that used it.  It isn't big enough to justify a separate patch.
>=20
> The stripe->lru need protection of device_lock, so I can't use a list. An=
 array
> is preferred. I really didn't like the idea to allocate memory especially=
 when
> allocating an array. I'll fix the code for cpuhotplug.

You don't need device_lock to use ->lru.
Currently the lru is not used when sh->count is not-zero unless
STRIPE_EXPANDING is set - and we never attach IO requests if STRIPE_EXPANDI=
NG
is set.
So when make_request wants to release a stripe_head, ->lru is currently
unused.
So we can use it to put the stripe on a per-thread list without locking.

We need another stripe_head flag to say "is on a per-thread unplug list" to
avoid racing between processes, but we don't need a spinlock for that.
ie.
  if (!test_and_set(STRIPE_ON_UNPLUG_LIST, &sh->state))
           list_add(&plug->list, &sh->lru);

or similar.

Please do waste time on cpuhotplug - it isn't the right solution.

NeilBrown

--Sig_/nJPEA/dcLqL3.W+B6xbyAT4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9BZNjnsnt1WYoG5AQJ6AhAAwLNXDCKKt+WM2RdwIlibUmbee3o12mfo
iDrSXnx9tOtkBUr0DtGKCfXjSMtsrFK3jp00hh+ZRfLeGoTfwURORQn7RHe82392
Givp0UZ475iDMAwzUVW9F08Kkkk/ROsu0EnlaO5Y7rxcE+4XxOgY8PHzw7EOy3zl
18X6E/k6QXHJ2BUlA9YNYGF4dX+mPo/KCPynV7+VKZMdJCSYsciJGgVnalIY7Wu3
3dXGwHKS3sL8eG/oXnwPd9gkUoLiWoWPAC/BxJs7/UzSr5JC0I4r8GzviP1dy3wd
KQTmmoVC0g8+WilkpFwqmps8SZyqIQppep2fIY8aYWSkUC6lIZBiexZWJF4pekes
lKmlwZl7qb77qs/IwASgzQm4kS6Olb2yf3pA2kliPQkjj/EgE9C57SXkR6F4wGVT
6T1Au6ERBvON8vzfuzz7q2mObRomaaut+W7Z4crCYOsJwe1aq9KOIpTb/VUBLkbM
HrGm+ILltIQ7IrxdOUWc0ZAHbskwOrm23FQuzoA1iZGYwV49eY72yq2r2R7vDRGp
fxfGcemh3mbUM+yTaUdZ8sb9PoFaEo4iD3FeuMJMTo3jfrXJe/1E6LBDoiUas21Z
x4D9lcOs0meo57yOznnK8wCva2BhOXpCJF7z5AkyjlKzhch1PmZ9Ww7Ukx7rtzTP
EN8FtNYIf3A=
=GOv3
-----END PGP SIGNATURE-----

--Sig_/nJPEA/dcLqL3.W+B6xbyAT4--
