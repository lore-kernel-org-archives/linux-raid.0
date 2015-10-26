From: Neil Brown <neil@brown.name>
Subject: [GIT PULL REQUEST] md fixes for 4.3-rc
Date: Mon, 26 Oct 2015 15:25:58 +0900
Message-ID: <87h9ledu2x.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Jes Sorensen <jes.sorensen@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain


Hi Linus,
 I meant to get this to you before -rc7, but what with all the travel
 plans..

 anyway, here are a few of bug-fixes worthy of 4.3.

Thanks,
NeilBrown

The following changes since commit 7379047d5585187d1288486d4627873170d0005a:

  Linux 4.3-rc6 (2015-10-18 16:08:42 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/4.3-rc6-fixes

for you to fetch changes up to 8bce6d35b308d73cdb2ee273c95d711a55be688c:

  md/raid10: fix the 'new' raid10 layout to work correctly. (2015-10-24 16:24:25 +1100)

----------------------------------------------------------------
Some raid1/raid10 fixes.

Two fixes for bugs that are in both raid1 and raid10.
Both related to bad-block-lists and at least one needs
to be back ported to 3.1.

Also a revision for the "new" layout in raid10.
This "new" code (which aims to improve robustness) actually
reduces robustness in some cases.
It probably isn't in use at all as not public user-space code
makes use of these new layouts.
However just in case someone has their own code, it would be
good to get the WARNing out for them sooner.

----------------------------------------------------------------
Jes Sorensen (2):
      md/raid1: submit_bio_wait() returns 0 on success
      md/raid10: submit_bio_wait() returns 0 on success

NeilBrown (3):
      md/raid1: don't clear bitmap bit when bad-block-list write fails.
      md/raid10: don't clear bitmap bit when bad-block-list write fails.
      md/raid10: fix the 'new' raid10 layout to work correctly.

 drivers/md/raid1.c  | 13 +++++++++----
 drivers/md/raid10.c | 39 ++++++++++++++++++++++++++++++++-------
 2 files changed, 41 insertions(+), 11 deletions(-)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWLcd2AAoJEDnsnt1WYoG5mR8P/j3a6H/zJhVFQWg7yfNE2njA
OfLfpxzvaZuFlsPW25tvBKAuxVnmQ98TKpXLgHOPgp+dqaqGb4WBmu8vWY5d5D+o
ezzLxZsSkN3tdW4GY5ZywVOlnGvGhwZG/PDP6colRxKBIBIGvqM/aJMTyxFNAIQW
wZQXXGrcvDvtjTYoeNDQ2ihuVJsCvpIAX8DTAFhlDuOPnSlOB9/JFq1VzreQIU21
o9woND20xaeMjR5bhDozMoTUurdbHrNAqtJ2w6e0AOra61CY/RYfJKySMBfvSRns
OfrGyCme+nPRERbZ/Z/4vHO4XW7KGS5ox4jMrGG7GU+tdfpaPYHZXl8DlTBOO51n
vxt2OVvBCIbFa15ovWUH/JJVPTKo363zyTXCexDF8TaTY8SfGEg8SQBn7UJvMB7h
8+gqM9uEfrvZRAKnTcHCnOUDfshd5maqO314sxgsbuPXj0wvFpBjd+j54MiGuAv/
R6NNsT34iKUnNUt5tSl3jEJgx2LA7MDwBG0luYPIbYwgH5LGLDFQKJbW153wTd1u
3M4uGRLDIUjUaGBZ8p8eAQUItqNnHS7ygKVwmKxVWhJnjtATsvj/T/m8jBermWTM
JlzA0dIfZgta1EMK/05Hbu2/RPtWdPOdIvj3yuPDykTso8Vh92aqej+g5D5zk/P+
5Mdc/eRTRvbI6qUKkiUw
=4bro
-----END PGP SIGNATURE-----
--=-=-=--
