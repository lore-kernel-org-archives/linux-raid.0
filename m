From: Andre Noll <maan@systemlinux.org>
Subject: Re: Proper partition type for components with V1.x superblocks?
Date: Wed, 11 Jun 2008 13:23:19 +0200
Message-ID: <20080611112319.GB4981@skl-net.de>
References: <484F9A3E.7020709@rabbit.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <484F9A3E.7020709@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:26, Peter Rabbitson wrote:

> The subject pretty much says it all - it obviously is not 0xFD, since the=
re=20
> is nothing to autodetect. Is there some best practice/semi-standard way o=
f=20
> marking a raid component partition as such?

Nobody really cares about the partition type these days. I usually
stick to the default 83 (Linux) for software raid partitions and
never encountered any problems.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIT7WnWto1QDEAkw8RAhkXAJ9WR8xKFnktlXfTky9yIWEm2NKPcACfdis3
c4MmWmRyOHWd+ENEvQs+Jdg=
=r3hv
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
