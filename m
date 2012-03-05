From: NeilBrown <neilb@suse.de>
Subject: [PULL-REQUEST] 3 fixes for md in 3.3
Date: Tue, 6 Mar 2012 10:17:32 +1100
Message-ID: <20120306101732.0be74651@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/w28foDHfOXMFuHkxtsrWGdb"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/w28foDHfOXMFuHkxtsrWGdb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 hopefully these are in time for 3.3.

thanks,NeilBrown


The following changes since commit 192cfd58774b4d17b2fe8bdc77d89c2ef4e0591d:

  Linux 3.3-rc6 (2012-03-03 17:08:09 -0800)

are available in the git repository at:

  git://neil.brown.name/md/ md-3.3-fixes

for you to fetch changes up to 7a90484825680e7831856105f5fef654e6c02701:

  md/raid10: fix assembling of arrays with replacement devices. (2012-03-06=
 10:12:45 +1100)

----------------------------------------------------------------
(from the branch description for md-scratch local branch)

for-linus
3 fixes for md in 3.3-rc

2 relate to the recently added drive replacement.

One causes read error in RAID10 to sometimes be retried indefinitely.

----------------------------------------------------------------
NeilBrown (3):
      md/raid1: fix buglet in md_raid1_contested.
      md/raid10: fix handling of error on last working device in array.
      md/raid10: fix assembling of arrays with replacement devices.

 drivers/md/raid1.c  |    2 +-
 drivers/md/raid10.c |   38 +++++++++++++++++++++++++++-----------
 2 files changed, 28 insertions(+), 12 deletions(-)

--Sig_/w28foDHfOXMFuHkxtsrWGdb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT1VJjDnsnt1WYoG5AQL73xAAs2+2cXm8BaPEkLemnSfYL+Z3PRZp6fFT
fUvq8AcFQf/1cZLpzb1OUwkSWST4vfSiDOwG0efeVYXKN1ZRVgEa0STAHOFg+C6Z
lUfjPtdrcLT5PUSv+PrWkjFKRtcLttGd2a8F2+JEJyey6lL68zdGufSUypq85F0m
hhUUW4EatQD8dYCdahEtkgm4e7YIi6RDKdbOUxrwq3JAmLIuFka5wx/ob/ZJQnx3
yMS0FwG0tZr4EvSbRyhiAtHEU1SkSWyhFW1K/15/R/sNiMLuxJB8FyU3oUl0K3G9
DqGe99p1jwwTh3grqGwnWQUqobCVJobAMb+fobSclBCouTpeh7/clJt2DquFL6ty
CEPtMXfpD/7MOJdjVaBZrWSpGwIP97tmYNOAtD4igFOGRgpk8wF84khaZWS5CQ3o
JN9pCgPHiyhrRS7E/Q4cm+P64daBAeb+xnI8xSNXSnJyZFnybx4wMKoz4phQ4+0W
Gx6LuI/E7ya9Flp/rT5iks/2vhFckpUtnCPGRBwC/ZoMtmYcPDozg6u0yci3oJpT
x/XAQ2FXFa2Lf+JWkX8ZKdIerI1/7FhdE7Y27BfVT0F8AskTgvxJbGPGeOtnxW1/
Sqmzv3JLqLy4Px80oOlp4di8NN0pXRmm2gAJdlHz2wRkytvLFj/nDX7BUJRS/aVA
yKrS01X0F0I=
=IX38
-----END PGP SIGNATURE-----

--Sig_/w28foDHfOXMFuHkxtsrWGdb--
