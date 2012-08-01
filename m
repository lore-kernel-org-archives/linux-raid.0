From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: OT: silent data corruption reading from hard drives
Date: Wed, 1 Aug 2012 19:03:18 +0600
Message-ID: <20120801190318.05d2431e@natsu>
References: <50191ADE.10809@fastmail.fm>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kZMO8+sIrWObcSkZWp1VM3+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50191ADE.10809@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: matt <listy@fastmail.fm>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kZMO8+sIrWObcSkZWp1VM3+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 01 Aug 2012 08:02:38 -0400
matt <listy@fastmail.fm> wrote:

> Quick intro: Last year I was having problems with an md array
> continuously having a mismatch_cnt in the tens of thousands,
> inexplicably.  After a week or two of hardware swapping and such, I
> narrowed it down to bad reads of the hard drive block devices.  I used
> scripts that would repetitively do something like this on all my drives:
>       dd if=3D/dev/sdk1 bs=3D1024 count=3D50000000 |md5sum -b
> Some devices would intermittently get different results.  I ended up
> resolving (?) it by replacing the cheapo (Syba) SATA controller cards
> with other cheapo (Rosewill) ones.  I've been fine for about a year
> since then.

Syba was mentioned in a bad context last time we discussed this here, somew=
here
down the thread: http://comments.gmane.org/gmane.linux.raid/33346
I don't remember if you have participated in that discussion, if not, have =
an
entertaining read. Is your new Rosewill card also Silicon Image based?

> Is silent data corruption like this simply to be expected when using cheap
> commodity hardware?

I'd say no. There are known good and known bad hardware, where both good and
bad is most easily measured by the amount (or lack of) problem reports you =
hear
or can find. One method to do that is asking a searching engine about "<chip
name> data corruption".

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/kZMO8+sIrWObcSkZWp1VM3+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAZKRYACgkQTLKSvz+PZwgKqgCdFZrG2KQ9ICbCwIZf95KaOm8D
PacAn1uq3jzEcpRjNY7iqeTE9lbUQrMN
=M0Uh
-----END PGP SIGNATURE-----

--Sig_/kZMO8+sIrWObcSkZWp1VM3+--
