From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 001 of 9] md: Fix deadlock in md/raid1 and md/raid10 when handling a read error.
Date: Tue, 4 Mar 2008 12:29:45 +0100
Message-ID: <20080304112945.GB32242@skl-net.de>
References: <20080303111240.23302.patches@notabene> <1080303001705.23577@suse.de> <20080303155449.GA32242@skl-net.de> <18380.59250.90214.461186@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18380.59250.90214.461186@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "K.Tanaka" <k-tanaka@ce.jp.nec.com>
List-Id: linux-raid.ids


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17:08, Neil Brown wrote:
> > Do we really need to take the spin lock in the common case where
> > conf->pending_bio_list.head is NULL? If not, the above could be
> > optimized to the slightly faster and better readable
> >=20
> > 	struct bio *bio;
> >=20
> > 	if (!conf->pending_bio_list.head)
> > 		return 0;
> > 	spin_lock_irq(&conf->device_lock);
> > 	bio =3D bio_list_get(&conf->pending_bio_list);
> > 	...
> > 	spin_unlock_irq(&conf->device_lock);
> > 	return 1;
>=20
> Maybe... If I write a memory location inside a spinlock, then after
> the spinlock is dropped, I read that location on a different CPU,
> am I always guaranteed to see the new value? or do I need some sort of
> memory barrier?

Are you worried about another CPU setting conf->pending_bio_list.head
to !=3D NULL after the if statement? If that's an issue I think also
the original patch is problematic because the same might happen after
the final spin_unlock_irq() but but before flush_pending_writes()
returns zero.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHzTKpWto1QDEAkw8RAsLrAJ9xo+yD3tz27pvcbzesm8Nh8ZdtaQCgjR7R
9lrN2eYRzk52Ro4oSTF5jDY=
=AEaC
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
