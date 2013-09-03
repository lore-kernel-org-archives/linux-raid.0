From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 3/3] raid5: relieve lock contention in
 get_active_stripe()
Date: Tue, 3 Sep 2013 16:08:58 +1000
Message-ID: <20130903160858.2175a41b@notabene.brown>
References: <20130812022434.507702228@kernel.org>
	<20130812022549.013010221@kernel.org>
	<20130827131752.4d5ba375@notabene.brown>
	<20130827085330.GA30133@kernel.org>
	<20130828143252.1d48b04b@notabene.brown>
	<20130828063953.GD17163@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//sCc0b7OdVYmfBVi7LtTETo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130828063953.GD17163@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, djbw@fb.com
List-Id: linux-raid.ids

--Sig_//sCc0b7OdVYmfBVi7LtTETo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Aug 2013 14:39:53 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Wed, Aug 28, 2013 at 02:32:52PM +1000, NeilBrown wrote:
> > On Tue, 27 Aug 2013 16:53:30 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > On Tue, Aug 27, 2013 at 01:17:52PM +1000, NeilBrown wrote:
> >=20
> > >=20
> > > > Then get_active_stripe wouldn't need to worry about device_lock at =
all and
> > > > would only need to get the hash lock for the particular sector.  Th=
at should
> > > > make it a lot simpler.
> > >=20
> > > did you mean get_active_stripe() doesn't need device_lock for any cod=
e path?
> > > How could it be safe? device_lock still protects something like handl=
e_list,
> > > delayed_list, which release_stripe() will use while a get_active_stri=
pe can run
> > > concurrently.
> >=20
> > Yes you will still need device_lock to protect list_del_init(&sh->lru),
> > as well as the hash lock.
> > Do you need device_lock anywhere else in there?
>=20
> That's what I mean. So I need get both device_lock and hash_lock. To not
> deadlock, I need release hash_lock and relock device_lock/hash_lock. Sinc=
e I
> release lock, I need recheck if I can find the stripe in hash again. So t=
he
> seqcount locking doesn't simplify things here. I thought the seqlock only=
 fixes
> one race. Did I miss anything?

Can you order the locks so that you take the hash_lock first, then the
device_lock?  That would be a lot simpler.

>=20
> I saw your tree only has seqcount_write lock in one place, but there are =
still
> other places which changing quiesce, degraded. I thought we still need lo=
ck all
> locks like what I did.

Can you be specific?  I thought I had convinced my self that I covered
everything that was necessary, but I might have missed something.

NeilBrown

--Sig_//sCc0b7OdVYmfBVi7LtTETo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUiV8+jnsnt1WYoG5AQJ/XQ//eIV0w97u0lE5Wk40Q7oyClWvTrNt4HvY
4qjTsuhquNLrqiZmwoZQIKCQbwQQn6wQa4CkSrdOrCtQeDAjPmTNcTcDAMtY5rtd
/ne+z3K5fJGZlQFJ10ifGd+G/Teg5ktP8JeH4nC9Ygk3+GGTWTc/whBa0TcSSFqO
57agSz0F5nnX8s9ayYCGKGURx49Bm0+/Svd4F3xOABnPBUrcc3Wv8Okr2peNz5Mj
GYBU96qjhu3YhuaL0roazt3FGex35VCFs7ovBOUEtUOFKRn5GcMXwhQfelIiFIPH
QI0Ih1k2CtKk7Ri19v6DUC3Yy/HZE00uBZkHljVfQSVnasZVt9WS95OyAdqOeyOK
TosJ1FL2zLeek1zfTvdJDL+yjwYgQtVKfryrhpWWcyA531coqKvToqyrNkV+03pz
hdqkBHARrVlisImugtI6kdRJg2M4HrftckM8+nzuJtm2VS4VooP0yQh8E8lpyrCg
eReGSuabg64xwCMEIL/zdyG5FoQWihMVdDBMf+wMS4ekHq7DoLxUXmQofbRRNICm
QVcM/KWGHJhwKQoHuUQ6CjEQYbd8yLGux7EDeog8ez5dizen51kPAAyhAKBo1/dI
pRi/dqr96bCkuJsIVRuKleqApRwAvJjxAQ+ZZcDR0gAGmzVfkNjMV1pYz8jrR0tw
K641i6mHA3U=
=hxlK
-----END PGP SIGNATURE-----

--Sig_//sCc0b7OdVYmfBVi7LtTETo--
