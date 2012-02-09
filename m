From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST] two md updates for 3.3
Date: Thu, 9 Feb 2012 12:16:13 +1100
Message-ID: <20120209121613.3392fb87@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P+Bg6tZ7CqnVoQV8cKoNPMq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids

--Sig_/P+Bg6tZ7CqnVoQV8cKoNPMq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,

The following changes since commit 307729c8bc5b5a41361af8af95906eee7552acb1:

  md/raid1: perform bad-block tests for WriteMostly devices too. (2012-01-1=
1 08:35:17 +1100)

are available in the git repository at:

  git://neil.brown.name/md/ md-3.3-fixes

for you to fetch changes up to db91ff55bdf06736b849afc1b1fce5763bbb8d5d:

  md: two small fixes to handling interrupt resync. (2012-02-07 12:01:51 +1=
100)

----------------------------------------------------------------
(from the branch description for md-scratch local branch)

for-linus
Some simple md-related fixes.

1/ two small fixes to ensure we handle an interrupted resync properly.
2/ avoid loading the bitmap multiple times in dm-raid

----------------------------------------------------------------
Jonathan Brassow (1):
      Prevent DM RAID from loading bitmap twice.

NeilBrown (1):
      md: two small fixes to handling interrupt resync.

 drivers/md/dm-raid.c |   12 +++++++++---
 drivers/md/md.c      |    5 +++--
 2 files changed, 12 insertions(+), 5 deletions(-)


Thanks,
NeilBrown

--Sig_/P+Bg6tZ7CqnVoQV8cKoNPMq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzMeXTnsnt1WYoG5AQJ9UA/9FXOTkewvlmIBXURw+A9otratwIHsAsD/
3vTt+YV1rMs+0zKsD+9ZzEbaoH7uesZ4lBks8aOFA46IfoJRu4GGjyOBDOV7eEg2
AqvSiHQaJl9T4uYyuoiJEQOgAZXQAgMAEEBpS33OBMbYmYemTgMmyrosB1VPiTpL
yAP8XPNQcVZFOpNHPjFve6mruakuB9VCdV7enVOYyrqzWK5MgQNUBQnUGQKhl7Sd
6Y/4lgOdtyxMZp4YQin+5koWDl1JbD7PZZVPj5m5Jymtp/P8Uw8Lf7lKBfZDWRMw
tgjimSW4ZdCkiVP9oeUscFv5hs0wjQDJaS0TSmJ4p5YirA8k6nqSX+HF3m3AXJFF
EvxvLmqYjsKy0mjiM3bafkwcO9Xdmc69tp3ycHj73IQ6fJ3rI9qcw9jeJ365oU5T
8CWFE64a32DFo1yLKfF37xEV5udqXvLTMJz9soxMQ3WpW7LUAHk5eWk6Chzz0Zkq
JJr+QVLAztUwCfxQm7LwDZQV6rgoAxrCor87r5p+0JD421qopDPiiR5xyNOfSN73
VLFUqgJeE7lf6jhwP4CgcTrMeSwbWGXeWTZSYIVarV+rRsfOYhH1Mtr5wl1YKyRF
a+cguh67bhDZN+cOaWC9QSbhd0Xih+TVuqQsgdg3h8zLviKjhAg/HQ/cfv7q24iI
XlDd16yJxos=
=SLu2
-----END PGP SIGNATURE-----

--Sig_/P+Bg6tZ7CqnVoQV8cKoNPMq--
