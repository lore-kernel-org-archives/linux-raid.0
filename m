From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST] md bug fix for 3.18
Date: Mon, 17 Nov 2014 10:03:44 +1100
Message-ID: <20141117100344.1618836d@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/P3zkI2XMKzTV_eS4evbI0AT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/P3zkI2XMKzTV_eS4evbI0AT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://neil.brown.name/md tags/md/3.18-fix

for you to fetch changes up to 45eaf45dfa4850df16bc2e8e7903d89021137f40:

  md: Always set RECOVERY_NEEDED when clearing RECOVERY_FROZEN (2014-11-17 =
09:17:46 +1100)

----------------------------------------------------------------
One fix for md for 3.18.

This fixes a regression introduced in 3.13.

----------------------------------------------------------------
NeilBrown (1):
      md: Always set RECOVERY_NEEDED when clearing RECOVERY_FROZEN

 drivers/md/md.c | 4 ++++
 1 file changed, 4 insertions(+)

--Sig_/P3zkI2XMKzTV_eS4evbI0AT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVGktUDnsnt1WYoG5AQJ2Rg/+Pwizip2mSD0kBniuDuDuZAetEc0q3uZX
a/0Nfsv+cG27wrn03vSEbcfgpQaStZKsB6pnV6gtESYqpQlGx5NhZAc9qbzNl4T4
tT7rL54/2Lcuy5ai8ATJ1FK2nTNY91TfWB4I/5r219jvGUUqcFHigjJocXjq3nXl
G9v436u+ITFgkIT12C7RxLP15J27mU6wqZu0PFrEaTAyV+nad9BkH3FOv+v8kDt8
KEIfnAcBsDh4XaWBrmD5srenqYznuSmA3YkWTjReG6+i1XiDNSwkYhKl43RzcYoa
u7WeSPMXs//RrBS1AdVzH/Zsstyh3McZCfmjCdRXJ31EB1myPCQrxROfqfpsZElG
tNyan7VpUuFphuF7GmQRAWv9IKVqTap+J9YnS9lRPwcKteDnI4ev+dc1XRL+OjbD
1FRfuOxFzfBct1qoLJRTFVEGD/RCsYnHTGgute/ke5P+aApisqlB6a1DII6hS4lb
9JOEB+qtHeKS4yv+eilUUoy8esXskJBtdUoEn3Lh1XobtpRwtAOaq1sDf6LAeECK
ehe9cwJK4+g7l9DGmALPiI1YDHtgcw1R+HwLAdIiBBUH7UiiZuSNB0dp51Q/ldJQ
FJD6W4RTiUUUKFQQA4tOymplfUnEsYEV8aCs+AOCIHuGxrcNToS0zdkcE8ibS+92
HYhJ5owRKgo=
=LtDz
-----END PGP SIGNATURE-----

--Sig_/P3zkI2XMKzTV_eS4evbI0AT--
