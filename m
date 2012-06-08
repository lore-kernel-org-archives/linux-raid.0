From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 6/8] raid5: make_request use batch stripe release
Date: Fri, 8 Jun 2012 16:42:11 +1000
Message-ID: <20120608164211.53ab6ec5@notabene.brown>
References: <20120604080152.098975870@kernel.org>
	<20120604080335.029329200@kernel.org>
	<20120607112345.1429436b@notabene.brown>
	<20120607063358.GB779@kernel.org>
	<20120607173310.2a3f147b@notabene.brown>
	<20120607075816.GA915@kernel.org>
	<20120608061657.GA785@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Qj.N346k.pCi.25oiK7Go0."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120608061657.GA785@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/Qj.N346k.pCi.25oiK7Go0.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Jun 2012 14:16:57 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Thu, Jun 07, 2012 at 03:58:16PM +0800, Shaohua Li wrote:
> > On Thu, Jun 07, 2012 at 05:33:10PM +1000, NeilBrown wrote:
> > > On Thu, 7 Jun 2012 14:33:58 +0800 Shaohua Li <shli@kernel.org> wrote:
> > >=20
> > > > On Thu, Jun 07, 2012 at 11:23:45AM +1000, NeilBrown wrote:
> > > > > On Mon, 04 Jun 2012 16:01:58 +0800 Shaohua Li <shli@kernel.org> w=
rote:
> > > > >=20
> > > > > > make_request() does stripe release for every stripe and the str=
ipe usually has
> > > > > > count 1, which makes previous release_stripe() optimization not=
 work. In my
> > > > > > test, this release_stripe() becomes the heaviest pleace to take
> > > > > > conf->device_lock after previous patches applied.
> > > > > >=20
> > > > > > Below patch makes stripe release batch. When maxium strips of a=
 batch reach,
> > > > > > the batch will be flushed out. Another way to do the flush is w=
hen unplug is
> > > > > > called.
> > > > > >=20
> > > > > > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > > > >=20
> > > > > I like the idea of a batched release.
> > > > > I don't like the per-cpu variables... and I don't think it is saf=
e to only
> > > > > allocate them for_each_present_cpu without support cpu-hot-plug.
> > > > >=20
> > > > > I would much rather keep a list of stripes (linked on ->lru) in s=
truct
> > > > > md_plug_cb (or maybe in some structure which contains that) and r=
elease them
> > > > > all on unplug - and only on unplug.
> > > > >=20
> > > > > Maybe pass a size to mddev_check_unplugged, and it allocates that=
 much more
> > > > > space.  Get mddev_check_unplugged to return the md_plug_cb struct=
ure.
> > > > > If the new space is NULL, then list_head_init it, and change the =
cb.callback
> > > > > to a raid5 specific function.
> > > > > Then add any stripe to the md_plug_cb, and in the unplug function=
, release
> > > > > them all.
> > > > >=20
> > > > > Does that make sense?
> > > > >=20
> > > > > Also I would rather the batched stripe release code were defined =
in the same
> > > > > patch that used it.  It isn't big enough to justify a separate pa=
tch.
> > > >=20
> > > > The stripe->lru need protection of device_lock, so I can't use a li=
st. An array
> > > > is preferred. I really didn't like the idea to allocate memory espe=
cially when
> > > > allocating an array. I'll fix the code for cpuhotplug.
> > >=20
> > > You don't need device_lock to use ->lru.
> > > Currently the lru is not used when sh->count is not-zero unless
> > > STRIPE_EXPANDING is set - and we never attach IO requests if STRIPE_E=
XPANDING
> > > is set.
> > > So when make_request wants to release a stripe_head, ->lru is current=
ly
> > > unused.
> > > So we can use it to put the stripe on a per-thread list without locki=
ng.
> > >=20
> > > We need another stripe_head flag to say "is on a per-thread unplug li=
st" to
> > > avoid racing between processes, but we don't need a spinlock for that.
> > > ie.
> > >   if (!test_and_set(STRIPE_ON_UNPLUG_LIST, &sh->state))
> > >            list_add(&plug->list, &sh->lru);
> > >=20
> > > or similar.
> >=20
> > I did see some BUG_ON trigger when I access ->lru without device_lock h=
old
> > before, for example get_active_stripe will remove it from list. Maybe c=
an use
> > the same bit to avoid it. Let me try.
>=20
> Thinking a bit more, the STRIPE_ON_UNPLUG_LIST bit can't avoid races. For
> example,
> Task 1 hit a stripe, assume stripe count 0 (could not be 0 too):
> it does:
> 1. inc count
> 2. set STRIPE_ON_UNPLUG_LIST
> 3. add stripe to plug list
> 4. unplug to release the stripe
> Between 3 and 4, task 2 hit the stripe, it does:
> A: inc count. Since the bit set, do nothing more
> B: unplug
> If the order is 3, A, 4, B. Task1 will not release the stripe, since the
> count is 2. Tasks2 will not release the stripe, since stripe isn't in its
> list. The stripe will never be handled.

"Since the bit set, do nothing" isn't correct - we need to release the
reference.
So it should be
   if (!test_and_set_bit(STRIPE_ON_UNPLUG_LIST, &sh->state))
          list_add(&sh->lru, &plug->list);
   else
          release_stripe(&sh);

We expect that in most cases release_stripe will just decrement the counter
and not need to take the lock.
Then the unplug takes the lock and calls __release_stripe() on all the
stripes.  So the stripe always gets released, either immediately or
at unplug.

So my initial attempt at a code fragment was incomplete.

Thanks,
NeilBrown


--Sig_/Qj.N346k.pCi.25oiK7Go0.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9Gewznsnt1WYoG5AQIHGA/7BBGGthcse8OU4SXCNUYTz395Fb3Lf8Xy
GIdMblbNhMmRktG90WM0PcSWhWwqRtYZBSdaKshuM18wq7SySdZjJYtGHBVIuoo8
7B7y6jR/JL6VO5/+VIhRr25Tbi0kMe+MjoqrcX1TF3kgC5KbsEGGonv/oGGtCQH0
AkWsHCil1xBW8WGgZ0Sd3rlFjsV8eqXn7ya0a3DwjY+tOITHJC5WZR7ylWNLoz5G
VPgp8a+0SebSmk2Ib91b9C3quXRxloNohtfcAnEdG+GtYIj3cIRUtx5F8iVwi4cP
yy+p86NdFqyVmThZ2A6ZYxa9cPy6/Jd6fbxT9Um/vq9I5DCHF8qAzBQ1YOLRWaHb
lVyyopI3s2VAnpj5x8iwwan8ZSvzkTkInwf++p0gjQ9kiLJ3uFU7TFO5gNfOq4iE
UmsrY0qxnoTnpf3saBOKXH/H77+PxjOWkl8FSacTtVc5GlWa9tdj0NJsnnmHUqrq
xyvojRFxSYHOWj1azHgXILEwsVdZzcZHq+rpnBfCSJzUcR+SO7lFvToCBG37lLfU
T3UlyrDsTGK89+XlqJVLiP/MLV+Re1ZWrAq6H7JgwPOpuykZ+o86uA876DKap8re
+bMt7/32ZE7zsXJyRprwaCbLb4KI4+N0pc6Kk8NlbS1pFL8WLzPRF59uL9YsA9t7
Hmujzwy9ITw=
=GAPC
-----END PGP SIGNATURE-----

--Sig_/Qj.N346k.pCi.25oiK7Go0.--
