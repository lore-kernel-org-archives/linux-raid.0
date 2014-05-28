From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/3]raid5: adjust order of some operations in
 handle_stripe
Date: Wed, 28 May 2014 14:54:35 +1000
Message-ID: <20140528145435.3713a236@notabene.brown>
References: <20140522112431.GA10509@kernel.org>
	<20140528125937.5555437e@notabene.brown>
	<20140528034507.GA1650@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3okbYAhksbPXwbE6E5K7JoJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140528034507.GA1650@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3okbYAhksbPXwbE6E5K7JoJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 May 2014 11:45:07 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Wed, May 28, 2014 at 12:59:37PM +1000, NeilBrown wrote:
> > On Thu, 22 May 2014 19:24:31 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > >=20
> > > This is to revert ef5b7c69b7a1b8b8744a6168b6f. handle_stripe_clean_ev=
ent()
> > > handles finished stripes, which really should be the first thing to d=
o. The
> > > original changelog says checking reconstruct_state should be the firs=
t as
> > > handle_stripe_clean_event can clear some dev->flags and impact checki=
ng
> > > reconstruct_state code path. It's unclear to me why this happens, bec=
ause I
> > > thought written finish and reconstruct_state equals to *_result can't=
 happen in
> > > the same time.
> >=20
> > "unclear to me" "I thought" are sufficient to justify a change, though =
they
> > are certainly sufficient to ask a question.
> >=20
> > Are you asking a question or submitting a change?
> >=20
> > You may well be correct that if reconstruct_state is not
> > reconstruct_state_idle, then handle_stripe_clean_event cannot possible =
be
> > called.  In that case, maybe we should change the code flow to make tha=
t more
> > obvious, but certainly the changelog comment should be clear about exac=
tly
> > why.
>=20
> I'm sorry, it's more like a question. I really didn't understand why we h=
ave
> ef5b7c69b7a1b8b8744a6168b6f, so I'm not 100% sure about. It would be grea=
t you
> can help share a hint.

It's a while ago and I don't remember, but I suspect that I added that patch
because handle_stripe_clean_event was about to change to clear R5_UPTODATE,
and this code which was previously *after* handle_stripe_clean_event tested
R5_UPTODATE (and could BUG if it wasn't set).

You may well be right that the two pieces of code cannot both run in the one
invocation of handle_stripe().  I haven't analysed the code closely to be
sure, but on casual reflection it seems likely.  However we always need to =
be
careful of races in unusual situations.

If that is correct, and if there are two (or more) different situations in
which handle_stripe runs, maybe one after IO has completed and one after
reconstruction has completed, and one when new devices have been added,
then there might be value in clearly delineating these so we don't bother
testing for cases that cannot happen.

If it is not correct, then your proposed change might be dangerous.


> =20
> > >=20
> > > I also moved checking reconstruct_state code path after handle_stripe=
_dirtying.
> > > If that code sets reconstruct_state to reconstruct_state_idle, the or=
der change
> > > will make us miss one handle_stripe_dirtying. But the stripe will be =
eventually
> > > handled again when written is finished.
> >=20
> > You haven't said here why this patch is a good thing, only why it isn't
> > obviously bad.  I really need some justification to make a change and y=
ou
> > haven't provided any, at least not in this changelog comment.
>=20
> ok, I'll add more about this.
> =20
> > Maybe we need a completely different approach.
> > Instead of repeatedly shuffling code inside handle_stripe(), how about =
we put
> > all of handle_stripe inside a loop which runs as long as STRIPE_HANDLE =
is set
> > and sh->count =3D=3D 1.
> > ie.
> >=20
> > 	if (test_and_set_bit_lock(STRIPE_ACTIVE, &sh->state)) {
> > 		/* already being handled, ensure it gets handled
> > 		 * again when current action finishes */
> > 		set_bit(STRIPE_HANDLE, &sh->state);
> > 		return;
> > 	}
> >=20
> >         do {
> > 	        clear_bit(STRIPE_HANDLE, &sh->state);
> >                 __handle_stripe(sh);
> >         } while (test_bit(STRIPE_HANDLE, &sh->state)
> >                  && atomic_read(&sh->count) =3D=3D 1);
> > 	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
> >=20
> >=20
> > where the rest of the current handle_stripe() goes in to __handle_strip=
e().
> >=20
> > Would that address your performance concerns, or is there still too much
> > overhead?
>=20
> Let me try. One issue here is we still have massive cache miss when check=
ing
> stripe/dev state. I suppose this doesn't help but data should prove.

That would be great - thanks.
If you can identify exactly where the cache misses are causing a problem, we
might be able to optimise around that.

NeilBrown

--Sig_/3okbYAhksbPXwbE6E5K7JoJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4VsCznsnt1WYoG5AQJhmRAAjA9KL4CTgduboUYEsdEPVWZlqgXYNMoj
trd/8+W00Mf8rUbv7+FClfqlBvBarcGWFxULvyJkjVUmdNY+40oopjYVV8cbmXqk
x6ITdqehbZ3ILNYXP539UoPwMARIegJ0dYV/zYi/WnIJbofSrGav4NeqpxUonq+D
zSufBxWSkIpeZ0O0yPzWZ6Ibn1Qz1E4TNjAzwyt9GoXxbBgLziW97n5NTMC4r+JJ
K7Wn/jTxnsBjkN78wTEqTfAO7IzwQ6dshETMSNOhm+z6WmO+8dtVgs7Ysnqy4XWh
NuBtXasiqngTHnYz0LiUALYUJu4z2mnYxPB4oDjwV32f6uTie2g8QNEOs3vuYNPZ
c4I5h9rnFtLhM3ekZ8gAijV38/M8wMWZlfDI7q+S4fdamfplbMvFyPmY1+gJihE8
1BX1aFdlHfLb+O3MAGjvommsQo2IH5pk0yxfuSbRw4dkF8c422xY2E42jsmaw50X
EsRr3l0EhucOGP+XrQq5qlyMlAonEx4AlPyOB7WPqNXABN/7Z8ZElYuoWFH3Riok
8g0ePdIT/VVdH7LWtnbgU+3mPBy+9CZjf5Nk8doehiSnKB6mcY094AKlTcJ3b9xp
p5gJLUWkTitVh8TvPmzL4sVU7NAbjZwYvE2ahaJ5IFJkQF+eBqH3ZzGywt73fXEv
yMUv4cd3fhg=
=WQDQ
-----END PGP SIGNATURE-----

--Sig_/3okbYAhksbPXwbE6E5K7JoJ--
