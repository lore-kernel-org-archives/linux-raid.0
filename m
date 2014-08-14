From: NeilBrown <neilb@suse.de>
Subject: Re: Bigger stripe size
Date: Thu, 14 Aug 2014 14:11:51 +1000
Message-ID: <20140814141151.15d473c2@notabene.brown>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735863D351@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/_WcO6N8TUUaLAvf1z.2pqWz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735863D351@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "shli@kernel.org" <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/_WcO6N8TUUaLAvf1z.2pqWz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Aug 2014 07:21:20 +0000 Markus Stockhausen
<stockhausen@collogia.de> wrote:

> Hello you two,
>=20
> I saw Shaohua's patches for making the stripe size in raid4/5/6 configura=
ble.
> If I got it right Neil likes the idea but does not agree with the kind of=
 the
> implementation.
>=20
> The patch is quite big an intrusive so I guess that any other design will=
 have
> the same complexitiy. Neils idea about linking stripe headers sounds reas=
onable
> but will make it neccessary to "look at the linked neighbours" for some o=
perations.
> Whatever "look" means programmatically. So I would like to hear your feed=
back
> about the following desing.
>=20
> Will it make sense to work with per-stripe sizes? E.g.
>=20
> User reads/writes 4K -> Work on a 4K stripe.
> User reads/writes 16K -> Work on a 16K stripe.
>=20
> Difficulties.
>=20
> - avoid overlapping of "small" and "big" stripes
> - split stripe cache in different sizes
> - Can we allocate multi-page memory to have continous work-areas?
> - ...
>=20
> Benefits.
>=20
> - Stripe handling unchanged.
> - paritiy calculation more efficient
> -  ...
>=20
> Other ideas?

I fear that we are chasing the wrong problem.

The scheduling of stripe handling is currently very poor.  If you do a large
sequential write which should map to multiple full-stripe writes, you still
get a lot of reads.  This is bad.
The reason is that limited information is available to the raid5 driver
concerning what is coming next and it often guesses wrongly.

I suspect that it can be made a lot cleverer but I'm not entirely sure how.
A first step would be to "watch" exactly what happens in terms of the way
that requests come down, the timing of 'unplug' events, and the actual
handling of stripes.  'blktrace' could provide most or all of the raw data.

Then determine what the trace "should" look like and come up with a way for
raid5 too figure that out and do it.
I suspect that might involve are more "clever" queuing algorithm, possibly
keeping all the stripe_heads sorted, possibly storing them in an RB-tree.

Once you have that queuing in place so that the pattern of write requests
submitted to the drives makes sense, then it is time to analyse CPU efficie=
ncy
and find out where double-handling is happening, or when "batching" or
re-ordering of operations can make a difference.
If the queuing algorithm collects contiguous sequences of stripe_heads
together, then processes a batch of them in succession make provide the same
improvements as processing fewer larger stripe_heads.

So: first step is to get the IO patterns optimal.  Then look for ways to
optimise for CPU time.

NeilBrown

--Sig_/_WcO6N8TUUaLAvf1z.2pqWz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+w3Bznsnt1WYoG5AQLHow//VsAygJwDuI22i1Uk38WgTv3Ws0zeoTaG
etTWTnOGSEyMGSZoqpwSNmJd0Os8Le0gpUfpJFZQPteEVdSqV+cLdpJP5MOBmIJX
1MRH81zR99ItgaVmnRWKkcVNvMZQfUjhGsmp9w+10DQyt6v7r9otnyEcin/AYg7x
DujLfghScSB8cPkxDKa8NYc4H02nu02JAOeQILP2R42HmLCOJRCqGL9YPcQpfew/
AOtVKKV7Ved06fQETOtQCxdCMTBuVs4IJr1LcoHSOp8K3v6qEIY1b3CrZL1+PEbV
ceV4bz/UC4M1HYnJGCW/I+NFn4v0n+4N0Xuy5Krz6n9wjhlubOKUZB2YeGPSsEXK
5AeGt/CQ/xgfKuDlVC0eJii6AGE6Du8DexMfcr0RdUEkPwKAGO7YEXq5WUfkVJlu
c/5EDulX/82AvgHW2XbWHYgZWApmOcOf2uF/gcjE/TMWOcn7kNxmRVgoW2/cdrS4
CetKWWyWEvygIDX08ScO6nSTNQ1O8wkQEB31f9BqUFM0VHtJp6hU9FQC9DdcBbIS
HhoJ0EllLAJhV6YNwGa39zgtpb8Hkcjm4KIKloWVz0p5UmyYawwOrimSVpv6hYIA
y8mrE+v0UbTldTQx4AKqvOsw22zOEplPz4QNTJyWgigpUq3Q8PWNkQXMGPMtD+8w
FmeJlZVoGkY=
=Q54O
-----END PGP SIGNATURE-----

--Sig_/_WcO6N8TUUaLAvf1z.2pqWz--
