From: NeilBrown <neilb@suse.com>
Subject: [GIT PULL REQUEST] md fixes for 4.4-rc
Date: Sun, 20 Dec 2015 09:15:54 +1100
Message-ID: <87io3u6q5h.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Mikulas Patocka <mpatocka@redhat.com>, Pawel Baldysiak <pawel.baldysiak@intel.com>, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain


The following changes since commit 9f9499ae8e6415cefc4fe0a96ad0e27864353c89:

  Linux 4.4-rc5 (2015-12-13 17:42:58 -0800)

are available in the git repository at:

  git://neil.brown.name/md tags/md/4.4-rc5-fixes

for you to fetch changes up to cb01c5496d2d9c0c862443561df16ff122db348f:

  Fix remove_and_add_spares removes drive added as spare in slot_store (2015-12-18 15:19:16 +1100)

----------------------------------------------------------------
4 fixes for md in 4.4-rc5

- 2 recently introduced regressions fixed.
- one older bug in RAID10 - tagged for -stable since 4.2
- one minor sysfs api improvement.

----------------------------------------------------------------
Artur Paszkiewicz (1):
      md/raid10: fix data corruption and crash during resync

Goldwyn Rodrigues (1):
      Fix remove_and_add_spares removes drive added as spare in slot_store

Mikulas Patocka (1):
      md: fix bug due to nested suspend

Shaohua Li (1):
      MD: change journal disk role to disk 0

 drivers/md/md.c     | 22 +++++++++++++++-------
 drivers/md/md.h     |  8 ++++++--
 drivers/md/raid10.c |  4 +++-
 3 files changed, 24 insertions(+), 10 deletions(-)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWddcaAAoJEDnsnt1WYoG5dr4P/itvXej2/IwYwqfCght/mni+
AgzHZmb47A2njAW/BL76ItFSoAk44X65TnWQp6LtT3PN618Wz8T5tIZdgXnK6aFU
MSOkrd14mahjR355GJkuZEDWBdfJnveojJzFYs+g0yYPJjm28oqDPNugZIfAfCfh
MRkBo2CRUcXIrpcqF0a2fh6/+EmHKUaqaCaZHrv2xt3/126AqNrWJOJXo7c2CRUC
LXpuLoKB9JCs6tUjl11LrFpPg7IlJw5YPczYzo+ilbd1XcmwM52Sfz+GjQTgsjgo
2/wtQS1N9aW1C2j9IjVkUWFUjI8+bbs++0vNvZiGxaWtbT6OwqrQOW9lhqpXA+bo
HXwxuAR7lzJwF7x9s4DlYI5ykyWFLhDNOgsqIybCx+0ro0yPaoe5zdbV2jzkmy9G
k9B/wsRnsU3/hhN94APhWxkRqgBkZCtbkT981pynCv5N30DZA50hT5hybPJJMHld
8OVz0/mgSGpNKcarZpBQyKI69e8C3Kp6kPIX00Z0Fp+a2PPPR2fnFf3I75M3DjSD
lTH/ggkY58hQ4CMtpzNi+bewzJSjslEdn4sbFwE8qR9+h0n6ahQ7WC2Li43uitvt
URSpgBQkNesKs9h5nCoGLhiKwZutXXK5+2muIcy6Tyryl1kcHW07/oyNe0TewSWf
yL5Fou6dWpEfOKP50sjR
=cHvm
-----END PGP SIGNATURE-----
--=-=-=--
