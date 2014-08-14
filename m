From: NeilBrown <neilb@suse.de>
Subject: Re: Bigger stripe size
Date: Thu, 14 Aug 2014 17:17:32 +1000
Message-ID: <20140814171732.7921b617@notabene.brown>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735863D351@EXCHANGE.collogia.de>
	<20140814141151.15d473c2@notabene.brown>
	<12EF8D94C6F8734FB2FF37B9FBEDD1735863D7F2@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/x9z2QIrcFMFrQ+A0JAxz+hN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735863D7F2@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "shli@kernel.org" <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/x9z2QIrcFMFrQ+A0JAxz+hN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Aug 2014 06:33:51 +0000 Markus Stockhausen
<stockhausen@collogia.de> wrote:

> > Von: NeilBrown [neilb@suse.de]
> > Gesendet: Donnerstag, 14. August 2014 06:11
> > An: Markus Stockhausen
> > Cc: shli@kernel.org; linux-raid@vger.kernel.org
> > Betreff: Re: Bigger stripe size
> > ...
> > >
> > > Will it make sense to work with per-stripe sizes? E.g.
> > >
> > > User reads/writes 4K -> Work on a 4K stripe.
> > > User reads/writes 16K -> Work on a 16K stripe.
> > >
> > > Difficulties.
> > >
> > > - avoid overlapping of "small" and "big" stripes
> > > - split stripe cache in different sizes
> > > - Can we allocate multi-page memory to have continous work-areas?
> > > - ...
> > >
> > > Benefits.
> > >
> > > - Stripe handling unchanged.
> > > - paritiy calculation more efficient
> > > -  ...
> > >
> > > Other ideas?
> >=20
> > I fear that we are chasing the wrong problem.
> >=20
> > The scheduling of stripe handling is currently very poor.  If you do a =
large
> > sequential write which should map to multiple full-stripe writes, you s=
till
> > get a lot of reads.  This is bad.
> > The reason is that limited information is available to the raid5 driver
> > concerning what is coming next and it often guesses wrongly.
> >=20
> > I suspect that it can be made a lot cleverer but I'm not entirely sure =
how.
> > A first step would be to "watch" exactly what happens in terms of the w=
ay
> > that requests come down, the timing of 'unplug' events, and the actual
> > handling of stripes.  'blktrace' could provide most or all of the raw d=
ata.
> >
>=20
> Thanks for that info. I did not expect to find so basic challenges in the=
 code ...
> Could you explain what you mean with unplug events? Maybe you can give me
> the function in raid5.c that would be the right place to understand bette=
r how
> changed data "leaves" the stripes and puts it on freelists again.

When data is submitted to any block device the code normally calls
blk_start_plug() and when it has submitted all the requests that it wants to
submit it calls blk_end_plug().  If any code ever needs to 'schedule()', e.=
g.
to wait for memory to be freed, and the equivalent of blk_end_plug() is
called so that any pending requests are sent in their way.

md/raid5 checks if a plug is currently in force using blk_check_plugged().
If it is, then new requests are queued internally and not released until
raid5_unplug() is called.

The net result of this is  to gather multiple small requests together.  It
helps with scheduling but not completely.

There are two important parts to understand in raid5.

make_request() is how a request (struct bio) is given to raid5.  It finds
which stripe_heads to attach it too and does so using add_stripe_bio().
When each strip_head is released (release_stripe()) they are put on a queue
(if they are otherwise idle).

The second part is handle_stripe().  This is called as needed by raid5d.
It plucks a stripe_head off the list, figures out what to do with it, and
does it.  Once the data has been written return_io() is called on all the
bios that are finished with and their owner (e.g. the filesystem) it told
that the write (or read) is complete.

Each stripe_head represents a 4K strip across all devices.  So for an array
with 64K chunks,  a "full stripe write" requires 16 different stripe_heads =
to
be assembled and worked on.  This currently all happens one stripe_head at a
time.

Once you have digested all that, ask some more questions :-)

NeilBrown




>=20
> >=20
> > Then determine what the trace "should" look like and come up with a way=
 for
> > raid5 too figure that out and do it.
> > I suspect that might involve are more "clever" queuing algorithm, possi=
bly
> > keeping all the stripe_heads sorted, possibly storing them in an RB-tre=
e.
> >=20
> > Once you have that queuing in place so that the pattern of write reques=
ts
> > submitted to the drives makes sense, then it is time to analyse CPU eff=
iciency
> > and find out where double-handling is happening, or when "batching" or
> > re-ordering of operations can make a difference.
> > If the queuing algorithm collects contiguous sequences of stripe_heads
> > together, then processes a batch of them in succession make provide the=
 same
> > improvements as processing fewer larger stripe_heads.
> >=20
> > So: first step is to get the IO patterns optimal.  Then look for ways to
> > optimise for CPU time.
> >=20
> > NeilBrown
>=20
> Markus

--Sig_/x9z2QIrcFMFrQ+A0JAxz+hN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+xijDnsnt1WYoG5AQLXRxAAnSgDjqZT4+yzqrm+bZf+djR2e1mtlFz+
bZwHo68qT312HQXPZGpzmcm0jtGskJMTVN3TcPt2vAyHUZBt0swKYeItLZPQuK78
9+tRT0t8x2hxsTpY3vtqfh1+LRK98HovmtouCfFo9FqVs9YcqJJJKSdGp6olfvCf
Ik+gZGmdWE2DjFL80k5Fs3Fl4lr6njHAFL2eC1+EV/y2C8BGPdq/wPEKTLFdtpmq
9Bs6i+i+ncqn68TzBVHslo9KC0JQ/H+saFUvX82k3NI0UZb3+Bvw16zg95uhCKuW
3uZjKV99Wp4YvAnWSG5NWWr6d+McnUR2MWcflf3xUQDnn5vfIqtnRC0bfKwodBdk
PmH2dh0zXKvV6VgLOKTJ04pOTW/NE8JHmI6ZI8elyabF2qIODhFNKjeh9lcr8yjn
mT7HyxgCdcnekrxak/MiYJSrMVkYG4RP+IraFtbBEaPeef9EvyV+hPYNOykbzX0Q
DAdt/Ci6Mia1/48nvpdd2LIZiMml0ex0vUYxsFNEl3bSZazVfNxom3WOOD7OJbRa
uoZxR0zoJktF8hlCPMmaHoOpuwIuvByVz+BghV6Qo40Js7ijU1C9SyzjnEBvqn99
jsdeJ76AFa8OkCMFoncc0MppwLcuVkr4mYTSOUBgk3S2QONYbqGWNppSRr5qtv/x
1bJpcJDiQv0=
=lQyb
-----END PGP SIGNATURE-----

--Sig_/x9z2QIrcFMFrQ+A0JAxz+hN--
