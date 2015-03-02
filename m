From: NeilBrown <neilb@suse.de>
Subject: [GIT PULL REQUEST] md fixes for 4.0
Date: Mon, 2 Mar 2015 11:03:18 +1100
Message-ID: <20150302110318.5f4cfbac@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/fAxgJjO1ljWHeZ4CIRAd+p3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Mei <eric.mei@seagate.com>, =?UTF-8?B?VG9tw6HFoQ==?= Hodek <tomas.hodek@volny.cz>, Dark Penguin <darkpenguin@yandex.ru>, linux RAID <linux-raid@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/fAxgJjO1ljWHeZ4CIRAd+p3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

The following changes since commit c517d838eb7d07bbe9507871fab3931deccff539:

  Linux 4.0-rc1 (2015-02-22 18:21:14 -0800)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/4.0-fixes

for you to fetch changes up to 750f199ee8b578062341e6ddfe36c59ac8ff2dcb:

  md: mark some attributes as pre-alloc (2015-02-25 11:38:46 +1100)

----------------------------------------------------------------
3 md fixes for 4.0

- fix a read-balance problem that was reported 2 years ago, but
  that I never noticed the report :-(
- fix for rare RAID6 problem causing incorrect bitmap updates when
  two devices fail.
- add __ATTR_PREALLOC annotation now that it is possible.

----------------------------------------------------------------
Eric Mei (1):
      raid5: check faulty flag for array status during recovery.

NeilBrown (1):
      md: mark some attributes as pre-alloc

Tom=C3=A1=C5=A1 Hodek (1):
      md/raid1: fix read balance when a drive is write-mostly.

 drivers/md/md.c    | 14 ++++++++------
 drivers/md/raid1.c |  5 +++--
 drivers/md/raid5.c | 13 +++++++++----
 3 files changed, 20 insertions(+), 12 deletions(-)

--Sig_/fAxgJjO1ljWHeZ4CIRAd+p3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVPOoxjnsnt1WYoG5AQJyARAArGRm4cCgynHKNkZeQTUsxIW7NufOKbme
VsTLhqXErdgTYEfe3NCb/B+9anCRxNkBRz7iC1aZK1+zr+bXHDYzlAnbFk3Ddiiv
I2Vq7bK36m8ko0q2vZuyytJp+34fVyoGYNXKp4Rv1c6nKQK0VYJYh7RbYXz2yFUE
QZjYNRDU6km4VX2eC+rZ3Yc8e0kHjQIvPH5GWUmBic7TxlaRfdQuWK+7JmP0Lfxg
92gijoJr4f2fkXQn/oU0f5Hkan6b6NBnVEuXLQakvem196pOsdFujwqFoBIp9+2q
gvO+AfIrX9nGxvuqGPn3RO6RYQoONjsEMmYuNI5YyRKNxczxlhnPXXioxc+BNMAE
lP7VgI6xYpEEkp85nZdz3QUxJjGKHmYstRl0Nia6/21U1K7xTScxEwPlJglCleaT
SXATd07J2tBsjADSuhDm9nBfy92XCms32Nwk0MdcMHAfInyDmp+GoshLCEMBzmn+
v8/VMHu2z+qqEcmNQ3lWZUJLki1Xh7IMaeWcmE6S+FYb/uM4LIvY86DirLsLcN2i
9u+zLa3kZsKVwLojT8+7rTGIO1Z/jcwY+DZwT3iWQA3zSoSJr5OXe5eHUjaVjXDC
D0GcozrMG7T/E5HorYh6IwE5oBaaXAvqahDYwyMOPik7NHR2zQ2kVMs2B/SC0h6+
YGs0hYcC2aA=
=MtnY
-----END PGP SIGNATURE-----

--Sig_/fAxgJjO1ljWHeZ4CIRAd+p3--
