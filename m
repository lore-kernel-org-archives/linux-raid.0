From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 3/3] raid5: relieve lock contention in
 get_active_stripe()
Date: Wed, 4 Sep 2013 16:41:32 +1000
Message-ID: <20130904164132.177701e0@notabene.brown>
References: <20130812022434.507702228@kernel.org>
	<20130812022549.013010221@kernel.org>
	<20130827131752.4d5ba375@notabene.brown>
	<20130827085330.GA30133@kernel.org>
	<20130828143252.1d48b04b@notabene.brown>
	<20130828063953.GD17163@kernel.org>
	<20130903160858.2175a41b@notabene.brown>
	<20130903070228.GA25041@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dIz9er8c18a=BP/8aSzscyn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130903070228.GA25041@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, djbw@fb.com
List-Id: linux-raid.ids

--Sig_/dIz9er8c18a=BP/8aSzscyn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Sep 2013 15:02:28 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Tue, Sep 03, 2013 at 04:08:58PM +1000, NeilBrown wrote:
> > On Wed, 28 Aug 2013 14:39:53 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > On Wed, Aug 28, 2013 at 02:32:52PM +1000, NeilBrown wrote:
> > > > On Tue, 27 Aug 2013 16:53:30 +0800 Shaohua Li <shli@kernel.org> wro=
te:
> > > >=20
> > > > > On Tue, Aug 27, 2013 at 01:17:52PM +1000, NeilBrown wrote:
> > > >=20
> > > > >=20
> > > > > > Then get_active_stripe wouldn't need to worry about device_lock=
 at all and
> > > > > > would only need to get the hash lock for the particular sector.=
  That should
> > > > > > make it a lot simpler.
> > > > >=20
> > > > > did you mean get_active_stripe() doesn't need device_lock for any=
 code path?
> > > > > How could it be safe? device_lock still protects something like h=
andle_list,
> > > > > delayed_list, which release_stripe() will use while a get_active_=
stripe can run
> > > > > concurrently.
> > > >=20
> > > > Yes you will still need device_lock to protect list_del_init(&sh->l=
ru),
> > > > as well as the hash lock.
> > > > Do you need device_lock anywhere else in there?
> > >=20
> > > That's what I mean. So I need get both device_lock and hash_lock. To =
not
> > > deadlock, I need release hash_lock and relock device_lock/hash_lock. =
Since I
> > > release lock, I need recheck if I can find the stripe in hash again. =
So the
> > > seqcount locking doesn't simplify things here. I thought the seqlock =
only fixes
> > > one race. Did I miss anything?
> >=20
> > Can you order the locks so that you take the hash_lock first, then the
> > device_lock?  That would be a lot simpler.
>=20
> Looks impossible. For example, in handle_active_stripes() we release seve=
ral
> stripes, we can't take hash_lock first.

"impossible" just takes a little longer :-)

do_release_stripe gets called with only device_lock held.  It gets passed an
(initially) empty list_head too.
If it wants to add the stripe to an inactive list it puts it on the given
list_head instead.

release_stripe(), after calling do_release_stripe() calls some function to
grab the appropriate hash_lock for each stripe in the list_head and add it
to that inactive list.

release_stripe_list() might collect some stripes from from __release_stripe
that need to go on an inactive list.  It arranges for them to be put on the
right list, with the right lock, next time device_lock is dropped.  That
might be in handle_active_stripes()

activate_bit_delay might similarly collect stripes, which are handled the
same way as those collected by release_stripe_list.
etc.

i.e. the hash_locks protect the various inactive lists.  device_lock protec=
ts
all the others.  If we need to add something to an inactive list while
holding device_lock we delay until device_lock can be dropped.

> =20
> > > I saw your tree only has seqcount_write lock in one place, but there =
are still
> > > other places which changing quiesce, degraded. I thought we still nee=
d lock all
> > > locks like what I did.
> >=20
> > Can you be specific?  I thought I had convinced my self that I covered
> > everything that was necessary, but I might have missed something.
>=20
> For example, raid5_quiesce() will change quiesce which get_active_stripe(=
) will
> use. So my point is get_active_stripe() still need get device_lock. Appea=
rs you
> agree get_active_stripe() need get device_lock. Maybe I confused your
> comments.

raid5_quiesce might reasonably take all of the hash_locks and then the
device_lock - it is expected to be a rare event and can afford to be heavy
handed.
get_active_stripe() should only take device_lock for list_del_init(&sh->lru=
).

What else have I missed?

Thanks,
NeilBrown


--Sig_/dIz9er8c18a=BP/8aSzscyn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUibWHDnsnt1WYoG5AQImvw/9GkeU/3FfZiouYK6D5IAZ/6/SaG82WW23
GDP2LYvte4yZKnjNtbN3ujswCG+YPWmivttORrIABeStdcNS62T7zL6rziKOEkpr
3SzpMGxQgbF7EyXUU0HZYPUY6zVV32CFqXLdm3THetC0KVDoGMv2cM/qh97LekO4
fiH13SgV4ahpxVpmUJ3kk8F2IRN09xdfLkNw//9epZGwjvU9SbkQ9KVT8W4w+cGW
1CopravFlEosjNIRDrZ684dgnOXWWzKaqTR+Z6NcrH3oHgEcE/pdm2/N6/P7OzMk
deI10dM2RXOnAP2bfEM36bNUBNr09CBlZaBzTw4iWyfChVkEuncJMA8r6ibrf9qG
72jLw2HNZJw+IwCR6SrUaOQARN29nHTJH63VMB1EDAgqGYLGtboe1DV+eXR11B2m
gYEC/zKtz9JwuYC8mJZMYhbd6yW/H1+PRN1mtpB59tcEC/R48k5vJoKOlEGxfv80
XtAECju1yhaLBqM+M3UZFVa349D6g0p/JKjcnJUp+G++mm0UXv0vS7r9mkT1EIU6
f2oxW3TcIo388zbaxN7mb93abVfDbkxLWHF5qLUyJa505Cg8Z2MT47YNT4d5356V
FzwokXEzuPKvbxgDW2JNLnYLCbu2uJuwaXTUNCMjvLV86jCz5l7HHjzVnUCYZLOz
TvbIWaRiMNQ=
=fx/b
-----END PGP SIGNATURE-----

--Sig_/dIz9er8c18a=BP/8aSzscyn--
