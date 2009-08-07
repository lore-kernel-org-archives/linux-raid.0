From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH/Resend] md: Push down data integrity code to personalities.
Date: Fri, 7 Aug 2009 18:46:54 +0200
Message-ID: <20090807164654.GC21495@skl-net.de>
References: <20090701083802.GC9910@skl-net.de> <19026.50240.504728.428875@notabene.brown> <20090713085442.GJ9910@skl-net.de> <19058.31706.803177.77914@notabene.brown> <20090803164030.GI5174@skl-net.de> <19066.20143.666654.818111@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19066.20143.666654.818111@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13:31, Neil Brown wrote:
> > Thanks. Sorry if this is a FAQ, but how can one tell whether a given
> > function may be called in interrupt context? Is there a better way
> > than recursively checking all its callers?
>=20
> I think you just have to 'know'. :-(
> Some functions which mustn't be called from interrupts are
> 'documented' as such by calling "might_sleep()", but there is no
> similar documentation for the reverse.

There's exactly one call to might_sleep() in drivers/md/*.c ;)

> All ->bi_endio routines are called from interrupts.. or maybe
> from softirqs or something similar.  I think the important point is
> that they are called without a process context, so they cannot sleep
> (i.e. no kmalloc unless you use GFP_ATOMIC, no mutex_lock, no
> wait_event etc) and should use spin_lock_irqsave or spin_lock_bh
> rather than a bare spin_lock.

So spin_lock_irqsave() and friends are other indicators that the
function in question might be called from interrupts while kmalloc(...,
GFP_KERNEL) indicates the converse, i.e. that the function is called
with process context.

Thanks for the explanation.
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKfFp+Wto1QDEAkw8RAnwYAKCgVAnP0GTm3aPiHG13r9uDjneFTACZAVtV
u4tex/jH7jDYkCdkVelTjag=
=YdQB
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
