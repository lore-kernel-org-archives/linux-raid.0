From: NeilBrown <neilb@suse.de>
Subject: [GIT PULL REQUEST] md updates for 3.14
Date: Fri, 24 Jan 2014 12:09:29 +1100
Message-ID: <20140124120929.1807f12b@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3ef5uk5qJ8tD.4wkjpoODcD"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux RAID <linux-raid@vger.kernel.org>, Ian Kumlien <ian.kumlien@gmail.com>, Ethan Wilson <ethan.wilson@shiftmail.org>, Nicolas Schichan <nschichan@freebox.fr>, Richard Michael <rmichael@edgeofthenet.org>, Andrei Warkentin <andreiw@vmware.com>
List-Id: linux-raid.ids

--Sig_/3ef5uk5qJ8tD.4wkjpoODcD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 just a few bugfixes for md.

The following changes since commit 8313b8e57f55b15e5b7f7fc5d1630bbf686a9a97:

  md: fix problem when adding device to read-only array with bitmap. (2014-=
01-14 16:44:08 +1100)

are available in the git repository at:

  git://neil.brown.name/md tags/md/3.14

for you to fetch changes up to 7da9d450ab2843bf1db378c156acc6304dbc1c2b:

  md/raid5: close recently introduced race in stripe_head management. (2014=
-01-22 11:45:03 +1100)

----------------------------------------------------------------
md updates for 3.14

All bug fixes, two tagged for -stable.

----------------------------------------------------------------
NeilBrown (6):
      md: Change handling of save_raid_disk and metadata update during reco=
very.
      md: allow a partially recovered device to be hot-added to an array.
      md/raid10: avoid fullsync when not necessary.
      md: ensure metadata is writen after raid level change.
      md/raid5: fix long-standing problem with bitmap handling on write fai=
lure.
      md/raid5: close recently introduced race in stripe_head management.

Nicolas Schichan (1):
      md: check command validity early in md_ioctl().

 drivers/md/md.c                | 76 +++++++++++++++++++++++++++++++-------=
----
 drivers/md/raid10.c            |  3 +-
 drivers/md/raid5.c             |  9 ++---
 include/uapi/linux/raid/md_p.h |  6 +++-
 4 files changed, 68 insertions(+), 26 deletions(-)

--Sig_/3ef5uk5qJ8tD.4wkjpoODcD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUuG9STnsnt1WYoG5AQLM1A//UbUkVeor38CXX/iEy/HKCzIydApvZTAi
BV7e2GI7c5UQf0xEzKf3u2HIh1us1mCrxxOdDMy7ANCKhWPao+9X0Kb5JhQb+4RE
sRedUFB/x97ZvaaaEPNKnRIU3othRIR/+wGJZ40gX7ecNMuMfbSjYo/M6a8DP0Hn
fsNGiherjlpSLrto5CmbAoXcdbcoIfhPw7gNHhnJmoxYiqdUsIZ4D2Xngzpwf7rF
9B9eAerZuAYZ/aClQxRpVY3DIeymSaubduxCjfeZ5Gnbk5NA4tD/+/1TOQHbQ5g1
ExU2OZ3u8dRV8QG3CLeNhMxHlkj1rMpAereViQ37DpHpJNgsqTxqhMXasGCXtvPH
lvCXP5jJ6QirW/Vt5C4S7nD0TeI2FYip73n8n4Y3cefKdPRV24m33cwzD7Glo5J6
7QCVrrFjSLzZ31fsF0TpyscFtOCaSAqeW4P5V3m1lb2xxsaDRwE4xlDBGIcJwalv
KcanV0zow/1FejfZoVVVe/fuk7f3Ll0DBwqsO4hTgk+tAtrYEMI1k4XEidAwGUe6
1W9tDMrlqnMYijGWXrTMeSAOe2xx15kTj5N1GrS/eR4i51nGeXORaVD4xL9tGHmT
/pEi9dsN5K+GAeXbxsHUJeCmxK3p8xmGBjFb/I3xKF6jRCec1oKyyfluIr8m+tg6
mVwIirvFdPo=
=avX/
-----END PGP SIGNATURE-----

--Sig_/3ef5uk5qJ8tD.4wkjpoODcD--
