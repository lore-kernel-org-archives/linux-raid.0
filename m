From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 001 of 9] md: Fix deadlock in md/raid1 and md/raid10 when handling a read error.
Date: Thu, 6 Mar 2008 11:51:34 +0100
Message-ID: <20080306105134.GC32242@skl-net.de>
References: <20080303111240.23302.patches@notabene> <1080303001705.23577@suse.de> <20080303155449.GA32242@skl-net.de> <18380.59250.90214.461186@notabene.brown> <20080304112945.GB32242@skl-net.de> <18383.25889.876350.431676@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOcCNbCCxyk/YU74"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18383.25889.876350.431676@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "K.Tanaka" <k-tanaka@ce.jp.nec.com>
List-Id: linux-raid.ids


--hOcCNbCCxyk/YU74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14:29, Neil Brown wrote:
> > Are you worried about another CPU setting conf->pending_bio_list.head
> > to !=3D NULL after the if statement? If that's an issue I think also
> > the original patch is problematic because the same might happen after
> > the final spin_unlock_irq() but but before flush_pending_writes()
> > returns zero.
>=20
> No.  I'm worried that another CPU might set
> conf->pending_bio_list.head *before* the if statement, but it isn't
> seen by this CPU because of the lack of memory barriers.  The spinlock
> ensures that the memory state is consistent.

But is that enough to avoid the deadlock? I think the following
scenario would be possible with the code in the original patch:

	// suppose conf->pending_bio_list.head=3D=3DNULL ATM

	CPU0:
	int rv =3D 0;
	spin_lock_irq(&conf->device_lock);
	if (conf->pending_bio_list.head) // false
	spin_unlock_irq(&conf->device_lock);

	CPU1:
	conf->pending_bio_list.head =3D something;

	CPU0:
	return rv; // zero

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--hOcCNbCCxyk/YU74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHz8y2Wto1QDEAkw8RAhtFAKCKbgF6u7Gils1P2dV9dheHWq/rxgCfZTDf
44gaYd5FYtLiD55JWkdICA0=
=4FeF
-----END PGP SIGNATURE-----

--hOcCNbCCxyk/YU74--
