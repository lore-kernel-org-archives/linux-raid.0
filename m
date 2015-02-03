From: NeilBrown <neilb@suse.de>
Subject: [GIT PULL REQUEST] 2 fixes for md in 3.19
Date: Wed, 4 Feb 2015 08:35:23 +1100
Message-ID: <20150204083523.7e573cbb@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/EBO9WZv6CZKIO_qzuBulhOZ"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Fengguang Wu <fengguang.wu@intel.com>, Mikulas Patocka <mpatocka@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-raid.ids

--Sig_/EBO9WZv6CZKIO_qzuBulhOZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit 59343cd7c4809cf7598789e1cd14563780ae4239:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2015-01-27=
 13:55:36 -0800)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/3.19-fixes

for you to fetch changes up to d95901433436aeb921eac58bfd8a2aa77f110384:

  md/bitmap: fix a might_sleep() warning. (2015-02-02 17:08:03 +1100)

----------------------------------------------------------------
Two fixes for md

1/ Another live lock, needs backporting
2/ work-around false positive with new warnings.

----------------------------------------------------------------
NeilBrown (2):
      md/raid5: fix another livelock caused by non-aligned writes.
      md/bitmap: fix a might_sleep() warning.

 drivers/md/bitmap.c | 13 +++++++++++++
 drivers/md/raid5.c  |  5 +++++
 2 files changed, 18 insertions(+)

--Sig_/EBO9WZv6CZKIO_qzuBulhOZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNE/HDnsnt1WYoG5AQIIAg/8C0+U+4TBZ9svFC9RYz01wsiPfqP0GtAK
uX4pIA3mrEulygBzc+3OURADh8Cbwm3/86ou+o7ug7MpLXrUFzkgOVDD2i1J0HqO
W5vRQbrH+vgFYfC7sCzf9DX7Jqwa+96p1tfV7VaWW5nToQIp3U8HAMcpLuC9BR7Q
YDU+fMeQIMPxiEZ2p+Upm0KRZJ4wgjE9hBLa9/2Q58+it4l+HAVCgSQktGDN7XIA
FFBFfsY8ZRICEEdcs9csUtxPgwjLt4qWbIY8LplfuDbtUDdD5U5PhrK/+cdT83Sd
STgXfvadXihP/qKQBB0/fyUq1vEPrvz+JshWcWhDjY1o7HP6v1nymffrnvHcK5Mm
HpnythFcz/1D6gDC4+/PDblemOfBBTwGOM0DLtNNfZRKVL+I/5C3JrAItUW4addd
nnj9M00CjzBL6QPFCZ10BGzlG/7C1Iz2RM+ukO/yB7/ZHrati3MbOSlR3FkYARRG
rntm9aA565Ew8QcXrihg07M0hjEH5N7r6bJsn/G6J3rlY2G5K1D8shtlG73mq2fC
tlt89SicI7f8vw0c6RfeMdGj4hMTdAYvJRODbTRMMJtoNED9tiLqwmBpo5JPzTcC
H8SBYjm/vhpDqOCOCHNAtMD/xg5ys636GdIAdeL1NF7gRnMahNvMeX0QqgSqi/+G
bJV4+EnYyAA=
=CyzQ
-----END PGP SIGNATURE-----

--Sig_/EBO9WZv6CZKIO_qzuBulhOZ--
