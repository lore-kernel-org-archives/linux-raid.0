From: Neil Brown <neil@brown.name>
Subject: [GIT PULL REQUEST] md bugfix
Date: Sun, 11 Oct 2015 16:30:59 +1100
Message-ID: <87lhba2cq4.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain


The following changes since commit da6fb7a9e5bd6f04f7e15070f630bdf1ea502841:

  md/bitmap: don't pass -1 to bitmap_storage_alloc. (2015-10-02 17:24:13 +1000)

are available in the git repository at:

  git://neil.brown.name/md tags/md/4.3-rc4-fix

for you to fetch changes up to a452744bcbf706eac65abb4c98496a366820c60a:

  crash in md-raid1 and md-raid10 due to incorrect list manipulation (2015-10-09 08:33:46 +1100)

----------------------------------------------------------------
One bug fix for raid1/raid10.

Very careless bug earler in 4.3-rc, now fixed :-)

----------------------------------------------------------------
Mikulas Patocka (1):
      crash in md-raid1 and md-raid10 due to incorrect list manipulation

 drivers/md/raid1.c  | 4 ++--
 drivers/md/raid10.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)



--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWGfQUAAoJEDnsnt1WYoG5kcEP/inqieUmObgexTzPsecpy/Wh
xoCtnw+tM71bZMMbn8BOwGryDfw+6P4gI4SbeVj3n4IsF4pztRObdB0mTSkrzLBG
T1Ca0Gz26qi5LrxE1zQHlw0TCbyJdFo8y0HnUj11Y6oMhuENF5pNFC9uS0rockWR
Rd13trXJSlSKKVw1MGFbuj58EqPZ9B8OkguEmgsrW53yFJpPj0XBN+auo9TBPBT6
6tbo1YQpuAAYAy3Unmx+dheMGj89EktLhEPA5ybsjfMymk5Q9znsoMeRlV7y8436
bLrRkjs/2Ce46aHwk6ovM5PwNLxNzeQgkj24gpK7emcGPs/cR2sNg/ZP/80o1qcR
/Xbymm8nT51ovxe392PTjCXQWw4sxF1xvG0zXtUhHr8u5Tasqc3I77qGPNLkHUTl
6G+ARwNBmk/jNkrRZenYz8yY6/xf/GjUoyp0BSU12pYsEI5mAXq5nG1JKSCepmHM
5tnnK1iZoMnqXDP4M/Nz3GvVvO1iFL2RCubDQDrD9hPmzLOLlgdxf6rmWyoAjmy0
L3DHufLj2JSOolFT+U9Xh9Lx/aM/qLdRx9Jw0IWOR0TH8mnojTWX76QoJ8lHAIS4
F/lRIY9SiDLn0sQyxZyRfL+fw04M5kqEpCHU1mo5mytfOMkd4cA9TLLl7jpgkdgT
ueeQy5vFgBAU7wPTv8r/
=Lg/F
-----END PGP SIGNATURE-----
--=-=-=--
