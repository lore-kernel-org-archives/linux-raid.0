From: NeilBrown <neilb@suse.de>
Subject: [GIT PULL REQUEST] one bugfix for md in 4.0-rc
Date: Mon, 23 Mar 2015 08:17:37 +1100
Message-ID: <20150323081737.5dfb8bf3@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/c0yT5Nv/3c5aV8Z.REh9YQ/"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "Richard W.M. Jones" <rjones@redhat.com>
List-Id: linux-raid.ids

--Sig_/c0yT5Nv/3c5aV8Z.REh9YQ/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit 06e5801b8cb3fc057d88cb4dc03c0b64b2744cda:

  Linux 4.0-rc4 (2015-03-15 17:38:20 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/4.0-rc4-fix

for you to fetch changes up to 0c35bd4723e4a39ba2da4c13a22cb97986ee10c8:

  md: fix problems with freeing private data after ->run failure. (2015-03-=
21 09:40:36 +1100)

----------------------------------------------------------------
One fix for md in 4.0-rc4

Regression in recent patch causes crash on error path.

----------------------------------------------------------------
NeilBrown (1):
      md: fix problems with freeing private data after ->run failure.

 drivers/md/md.c    | 3 ++-
 drivers/md/raid0.c | 2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

--Sig_/c0yT5Nv/3c5aV8Z.REh9YQ/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVQ8xcjnsnt1WYoG5AQIQsRAAllYlpJ5UDZE1rEfmWW6MCWolxbpQQcG+
36rQgKKM6itADwISl2ZjHybUElWuwZcA5EhKPBSahoCn2d4FIAzNC+rsxQx6AB0H
G2YuHIVEVmi6kIrR16c1/NtDtRWLDaCww0Iyip0M2KvcOJWmyl14zWDpoYFyNusn
vPgWRmDEaJayh61akDc5bwQMRTrTuN9o8XPKJwdcRgw46gDMZfSow1sYxQgSabaE
/nQLgIZBstJFQcENeWqfEDNNXmh26evzEi3vI808oW+u2BaTBaMGDFJZV6yJ8Qib
zxqp9jnXvd4Y2tUknHKQNUgOJm4ZypiGSxcz8dkgF14BZXIGujSDXN/jHDVZmiyL
CAyOeqqOLYbpbbX4/aaWCtJ3J/WKRkm4DjzsV807ZYSyiNpb1ytMg8q/nbvQu/Vy
4I00eMkO+BUsrKffPjui0yN9EQOu/CYGoKv8qYq+8LmFYbC7yoy4Ni2WWQy0q1I8
EUvn1nJpZ+TZNRjD6vIF26o5Rg5H6diqnmT3ERNsDO3Hxx28Hi2XWAqDs7iBgGjz
acJGaXHnGbYRtcO+K09Gn5Yf3uFtqIAELGyU0sibuRaz+qvufZIWdUUjac/eHtfu
SaI1DKVS4VeNOYOptkLgUw/JdAZU2GUMn95Mh0CQtK2aVlZFeYRAPOMbPEuIZQiM
KccfGIW2b/0=
=rD7C
-----END PGP SIGNATURE-----

--Sig_/c0yT5Nv/3c5aV8Z.REh9YQ/--
