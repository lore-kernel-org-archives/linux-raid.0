From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 008 of 29] md: Close race in md_probe
Date: Mon, 30 Jun 2008 09:52:42 +0200
Message-ID: <20080630075242.GI23944@skl-net.de>
References: <20080627164503.9671.patches@notabene> <1080627065010.10418@suse.de> <20080627122153.GE4981@skl-net.de> <18533.31198.932488.652568@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+ZmrHH5cGjskQnY1"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18533.31198.932488.652568@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


--+ZmrHH5cGjskQnY1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09:38, Neil Brown wrote:

> mddev_find gets a reference on the mddev, so it cannot become stale.
> md_probe does not return what it gets from mddev_find until getting
> the disks_mutex lock and checking the contents, so it is sure to
> return a good mddev.

I see. Thanks for the clarification.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--+ZmrHH5cGjskQnY1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIaJDKWto1QDEAkw8RAk/YAKCJMh5ACAsVV0B9VU0nb1b951ktTACffS8R
p2HFYvQpT4dsTWl1IU0Qx90=
=IPs+
-----END PGP SIGNATURE-----

--+ZmrHH5cGjskQnY1--
