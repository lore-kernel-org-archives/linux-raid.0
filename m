From: Roman Mamedov <rm@romanrm.ru>
Subject: Recovering from an URE on a RAID5 rebuild/resize
Date: Fri, 25 Jan 2013 17:14:59 +0600
Message-ID: <20130125171459.5f855c92@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lPZH7xqNy43SaduMbKHlRA_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lPZH7xqNy43SaduMbKHlRA_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

Recently there has been some talk on this list, about probability of seeing=
 an
URE during a RAID5 rebuild on modern large (e.g. 2TB) drives.

I would like to ask for some advice of what would be the best way to proceed
when such an URE is encountered. This is mostly theoretical, no real situat=
ion
at hand at the moment.

As I understand, a RAID5 that is being resized or rebuilt, has no redundanc=
y;
it is essentially as reliable as a RAID0 of total members-1, or even less.

So on an unreadable sector that mdadm needs to read (because it has no
redundancy to recover it from), mdadm will:

  - mark the corresponding array member as "failed";
  - mark the one that was being rebuilt/resized onto as "spare";
  - and the whole array as down and "not enough members to start the array".

Let's assume only a couple of sectors on that member were unreadable, and t=
hen
their readability was restored (either by drive replacement or by overwriti=
ng
them to making the drive remap), and I would be okay with losing data that =
was
in those sectors.

What would be the best way to proceed from there?


--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/lPZH7xqNy43SaduMbKHlRA_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlECaTMACgkQTLKSvz+PZwg4gACZAb9s/eqkTOLcov4NquXJ7Tca
Ci0An0d02YHvqqNYYzxeG/MilgggSOx/
=kng8
-----END PGP SIGNATURE-----

--Sig_/lPZH7xqNy43SaduMbKHlRA_--
