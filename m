From: Andre Noll <maan@systemlinux.org>
Subject: Re: Why do I need 4 disks for a raid6?
Date: Wed, 18 Mar 2009 13:18:25 +0100
Message-ID: <20090318121825.GL32416@skl-net.de>
References: <87ljr4hsk9.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S6vg04ofUPzW4qJg"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87ljr4hsk9.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--S6vg04ofUPzW4qJg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20:12, Goswin von Brederlow wrote:

> I'm wondering why the kernel requires a raid6 to have at least 4
> disks (of which at most 2 can be missing). Why not 3 disks?

Yes, this limitation looks a bit arbitrary. I can not see any reason
why raid6 requires at least four disks. Probably it even works without
any significant changes if some of the checks are being relaxed.

> Now for the raid6 case. With only 1 data disk and 2 parity disks all 3
> disks should end up with identical data on them. In effect this should
> be a 3 disk raid1, a cpu intensive one.

In fact, it wouldn't be much more CPU intensive than raid5 because
the math to "calculate" the Q parity would obviously not involve any
GF multiplications at all.

> So back to my original question: Why does the kernel require 4 disks
> for a raid6 instead of allowing 3?

Dunno. Maybe Dan, Neil or HPA can tell the reason for imposing this
limitation.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--S6vg04ofUPzW4qJg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJwOaRWto1QDEAkw8RArqpAJ9sI6C0jGd+DbGKnL6/ZJ2axj1f2wCgqkMH
fdW9d4U1OmwF9B8U+FX1KiQ=
=FNh0
-----END PGP SIGNATURE-----

--S6vg04ofUPzW4qJg--
