From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH] relax checks to support 3disk raid6 arrays
Date: Fri, 20 Mar 2009 10:29:02 +0100
Message-ID: <20090320092902.GN17185@skl-net.de>
References: <20090318125324.GL17185@skl-net.de> <18882.57018.465098.201167@notabene.brown> <20090320091436.GM17185@skl-net.de> <49C35FD4.1010102@rabbit.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x9l1eQe8PlYqUxyS"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49C35FD4.1010102@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--x9l1eQe8PlYqUxyS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:20, Peter Rabbitson wrote:

> In the last lines of the patch:
> Name ": at least 4 raid-devices needed for level 6\n");

Thanks, obviously I overlooked this. Of course this omission
only causes mdadm to print an incorrect message.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--x9l1eQe8PlYqUxyS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJw2HeWto1QDEAkw8RAuJVAJ9dLwLQsk5XQTCsBAy/P3e9YcoN2ACfdUQB
EobsqI9UvdknC0OTxTgyHsg=
=9UDe
-----END PGP SIGNATURE-----

--x9l1eQe8PlYqUxyS--
