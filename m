From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC]raid5: add an option to avoid copy data from bio to stripe
 cache
Date: Tue, 29 Apr 2014 17:07:25 +1000
Message-ID: <20140429170725.0b4687a8@notabene.brown>
References: <20140428065841.GA28726@kernel.org>
	<20140428101748.GA17026@infradead.org>
	<20140428204407.226c88e4@notabene.brown>
	<20140429020124.GA24123@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4vl.J3avhnlE8/6xupugyyl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140429020124.GA24123@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4vl.J3avhnlE8/6xupugyyl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Apr 2014 10:01:24 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Mon, Apr 28, 2014 at 08:44:07PM +1000, NeilBrown wrote:
> > On Mon, 28 Apr 2014 03:17:48 -0700 Christoph Hellwig <hch@infradead.org>
> > wrote:
> >=20
> > > On Mon, Apr 28, 2014 at 02:58:41PM +0800, Shaohua Li wrote:
> > > >=20
> > > > The stripe cache has two goals:
> > > > 1. cache data, so next time if data can be found in stripe cache, d=
isk access
> > > > can be avoided.
> > >=20
> > > I think this is mostly a side effect.  We have a much larger and bett=
er
> > > tuned page cache to take care of this.
> > >=20
> > > > 2. stable data. data is copied from bio to stripe cache and calcula=
ted parity.
> > > > data written to disk is from stripe cache, so if upper layer change=
s bio data,
> > > > data written to disk isn't impacted.
> > > >=20
> > > > In my environment, I can guarantee 2 will not happen.
> > >=20
> > > Why just in your environment?  Now that we got stable pages in the pa=
ge
> > > cache this should always be the case.
> >=20
> > Hmm... I hadn't realised that we were guaranteed stabled pages always (=
if
> > requested).  It seems that we are.
> >=20
> > >=20
> > > > Of course, this shouldn't be enabled by default, so I added an opti=
on to
> > > > control it.
> > >=20
> > > Unless careful benchmarking in various scenarious shows adverse effec=
ts
> > > this should be the default.  And if we can find adverse effects we ne=
ed
> > > to look into them.
> >=20
> > Certainly some benchmarking is needed.
> >=20
> > We should set
> >=20
> >  mddev->queue->backing_dev_info.capabilities |=3D BDI_CAP_STABLE_WRITES
> >=20
> > if and only iff 'skip_copy' is set. Then test various cases just to con=
firm
> > that it is generally an improvement.
>=20
> IIRC, we switched from 'force wait page writeback' to 'wait page writebac=
k if
> required' because of performance issues reported, so we shoudn't always e=
nable
> BDI_CAP_STABLE_WRITES. Is it safe to set/clear BDI_CAP_STABLE_WRITES at
> runtime, if we use 'skip_copy' to control it? Ofcourse, we don't need run=
time
> changing the setting, but we need a mechanism to setup it before array ru=
ns.

So for md/RAID5 the trade off is:
 - If we set BDI_CAP_STABLE_WRITES then processes might sometimes have to w=
ait
   for the writeout to complete where otherwise they would not
 - If we don't then RAID5 *always* has to copy the page into the stripe cac=
he.

It isn't at all clear to me which is best.  It is very possible that copying
costs a lot.  But then waiting for read-modify-write cycles can be a real
cost too....

I think it is perfectly safe to change BDI_CAP_STABLE_WRITES while the array
is suspended. So
  mddev_suspend(mddev);
  change BDI_CAP_STABLE_WRITES
  mddev_resume(mddev);

should be safe.

>=20
> As of performance, the 'skip_copy' is very helpful (> 30% boost) for my r=
aid5
> array (with 6 fast PCIe SSD) for 1M request size workload. Nothing change=
d for
> 4k randwrite workload.

It would be really good to see comparison for sequential and random loads on
various filesytems with both rotating and SSD devices, in RAID5 and RAID6,
with various numbers of devices.
:-)

If you'd like to update your patch to adjust BDI_CAP_STABLE_WRITES when
skip_copy is changed, I'll apply it so that people can test it.

Thanks,
NeilBrown


--Sig_/4vl.J3avhnlE8/6xupugyyl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU19PrTnsnt1WYoG5AQLPWBAAlF2S7uaDvyxGS5wTBZemXyst5MWFrK3B
1OiB1vmLrOnEqgR5fN5YNa0h2zZ9H1OIr4ROXr71+QM6FZhRbExK1oiPlrjYo3Og
hNzSLtNBBPoO7agnO2PtMV1llVutwzufDoKDhdgHrVtznlc6PbfS5UsLWqJB+EY0
itKK2BVhaUcRYDeMHKjZvYge0Qu2LyjuV0B2CSwCYzGEarEAbm2iQ79xNM1o2T/y
TSfIAuq/GJr4nFTUR6ubECTxHKQENzwyFWfFyAnw1nmf1S7H3MdpqeWQTs84xkIo
K6ep9mlfJw2UEW/QV3zD67BnwO0d2oSPMgKpjmOUTClJPRWawczpQMaPn8P0wvhR
igpk2bJjNjdoW1xinnXo7gug1QVycAoctVkSMH+ibg/Q2jsBq2REoCZNyq4p+2n1
ObJZTEL9PnKpBldjDhNGUQHPuUTZ+3KjDTAmfNau+s43rJGdyOXjBgA0Iuuzizwr
RWSLxA/L3asNnv+8TmfZJjQVZXj/Vrmu3WMmxcVrYysjrqmA8eSzWcaQghj/Cs1u
JwH6wL06+3i2X3i9HROprwNAzWPNtzltzb+8v6ipSQ64Tdy20JRJ8j6Y4Ae25qWi
Yvcby99LHxHCNiNdDyM23iFM+WAcKhjpvE1CQzh6+MzheTnL2J925zw8asx4MZl3
vnRHSeBsjqQ=
=geAa
-----END PGP SIGNATURE-----

--Sig_/4vl.J3avhnlE8/6xupugyyl--
