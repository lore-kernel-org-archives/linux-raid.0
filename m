From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC]raid5: add an option to avoid copy data from bio to stripe
 cache
Date: Mon, 28 Apr 2014 20:44:07 +1000
Message-ID: <20140428204407.226c88e4@notabene.brown>
References: <20140428065841.GA28726@kernel.org>
	<20140428101748.GA17026@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yRTAuyOmXdIVIJM61WG6Z9l"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140428101748.GA17026@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/yRTAuyOmXdIVIJM61WG6Z9l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Apr 2014 03:17:48 -0700 Christoph Hellwig <hch@infradead.org>
wrote:

> On Mon, Apr 28, 2014 at 02:58:41PM +0800, Shaohua Li wrote:
> >=20
> > The stripe cache has two goals:
> > 1. cache data, so next time if data can be found in stripe cache, disk =
access
> > can be avoided.
>=20
> I think this is mostly a side effect.  We have a much larger and better
> tuned page cache to take care of this.
>=20
> > 2. stable data. data is copied from bio to stripe cache and calculated =
parity.
> > data written to disk is from stripe cache, so if upper layer changes bi=
o data,
> > data written to disk isn't impacted.
> >=20
> > In my environment, I can guarantee 2 will not happen.
>=20
> Why just in your environment?  Now that we got stable pages in the page
> cache this should always be the case.

Hmm... I hadn't realised that we were guaranteed stabled pages always (if
requested).  It seems that we are.

>=20
> > Of course, this shouldn't be enabled by default, so I added an option to
> > control it.
>=20
> Unless careful benchmarking in various scenarious shows adverse effects
> this should be the default.  And if we can find adverse effects we need
> to look into them.

Certainly some benchmarking is needed.

We should set

 mddev->queue->backing_dev_info.capabilities |=3D BDI_CAP_STABLE_WRITES

if and only iff 'skip_copy' is set. Then test various cases just to confirm
that it is generally an improvement.

NeilBrown

--Sig_/yRTAuyOmXdIVIJM61WG6Z9l
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU14w9znsnt1WYoG5AQK0/RAAoFiC2/Z14Gg2BcjHWOub4ygQnpemsqQs
th1LHHxBL5OJyyr5fo4mqGV6G0tuve5i4BGp2+Xa5/Hm+Ch4s/dgM4mzf/n5gHeg
8QjrITa18rnx2Sw9Xcc7JNSlb5BFSPTv1JXOWWI5vQJrSUcgvtzmhV4wxz/m5B0s
o9XEoIJQRl7Om3UNhV2tUAbnKhtAWDrI9YN7IIqWeypB7DajXqLDCu/yRFeeXb+c
+geeSRqFonwRd/RmeCD/TJulMtOA2oOEKwTzbv0uzdqGHBON4I+WILtEBxumLbWn
IADS1YCYLv0Fkl/LXl5pGwQGab+2dZNdaHiR3lZSrupi+K+yyZnoWRB27+2y4l7q
LMuYPRlehi4lK2q4iEvCRt29zMZkFuht/H6bHO0dQFBG7MPt6aTX74Ncfo0djaUi
WvT9LVwREEJgKwphfiKKZCzNLBH/F1EgxZRfPPAYxfPM89rL27ABYRyV90AL64Ws
YfFKyxfZsF1TxTtG2BX7+NHI2LK2dkUp47Z0k8MTPDc94akjxTf8VGBPCOlBsofM
tnN8vsMoLrV0QITCdj0jhAyeOQO13B4IoR4X2LQZcQuBo4g//XL3igsloyrWJRAG
2YDZUnW0u6xExQ3J3nyxUrgZihg0F/rIHNNXMO6GLjgv+9oUSVTzRryainl3NSgF
dLiJgKII5Cw=
=m2/l
-----END PGP SIGNATURE-----

--Sig_/yRTAuyOmXdIVIJM61WG6Z9l--
