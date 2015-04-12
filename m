From: NeilBrown <neilb@suse.de>
Subject: [GIT PULL REQUEST] md fixes for late 4.0-rc
Date: Mon, 13 Apr 2015 09:20:18 +1000
Message-ID: <20150413092018.0e153eea@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/UaDzugWaQQxWGz7DpKMCbfi"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux RAID <linux-raid@vger.kernel.org>, Joe Landman <joe.landman@gmail.com>, Dave Chinner <david@fromorbit.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>, Simon Kirby <sim@hostway.ca>, Dave Jones <davej@codemonkey.org.uk>
List-Id: linux-raid.ids

--Sig_/UaDzugWaQQxWGz7DpKMCbfi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 two regression fixes for md, one fairly recent and minor (diskstats has=20
 confusing data) and one older and more serious - RAID0 with non-power-of-2
 chunksize corrupts data.  I guess (almost) no-one uses non-power-of-2 chun=
ks.

Thanks,
NeilBrown


The following changes since commit f22e6e847115abc3a0e2ad7bb18d243d42275af1:

  Linux 4.0-rc7 (2015-04-06 15:39:45 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/4.0-rc7-fix

for you to fetch changes up to 47d68979cc968535cb87f3e5f2e6a3533ea48fbd:

  md/raid0: fix bug with chunksize not a power of 2. (2015-04-10 15:36:31 +=
1000)

----------------------------------------------------------------
md fixes for 4.0-rc7

Revert recent change which broke IO accounting.
Fix bug with RAID0 arrays with non-power-of-2 chunk size.

----------------------------------------------------------------
Gu Zheng (1):
      md: fix md io stats accounting broken

NeilBrown (1):
      md/raid0: fix bug with chunksize not a power of 2.

 drivers/md/md.c    | 6 +++++-
 drivers/md/raid0.c | 3 ++-
 2 files changed, 7 insertions(+), 2 deletions(-)

--Sig_/UaDzugWaQQxWGz7DpKMCbfi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSr9tTnsnt1WYoG5AQJtYxAAuq37zOOQ9M7JmQ+bhP5xDOZ5nTtUopRD
EZ/wadEg2AB7jVjrI7/m1aDOb4dYq5ZrpV5e25SvHm6uweBblp30AOMgaYow7CR2
84tAI5g8ht5kHf/HeJJ4PF7hZdIWzXLffKGTBQQvz2eRK03zl+tEXc+b7jEhcHeW
FVoRMMjX2WFOj659QzTPC8j7w6WjQNyFtRzXL+x+yQMscRgmOvS3+cjkC0001qx+
oZc2StEYv4Ze/XSgISnmZQImuy5Yinm+r/PdjJgeEY70TrPitLH2NRFSCJKA8aBx
oJ2lz0c5NEi60WuFf5ZNnawrrhRcstTHb9p4GWAf/YNh/2vU+lgXLnUhWhemJik0
206KzmfQViFSg7zWis1fJfJrpjJb7df8n9+3T+PNwqG8SV5Vck4YX+QfquOvDk7y
dIAPdXTYkYQtheaNuFVMmehleNUBQJ852sik9i+C7lctoW/61RqniaVPQ5JgLEp5
uE4mbCo23A9GsY9ttZDjI6I2BeSGRUn/rPQDgB4txsctYEHcT4cYr94uxhKkBzQO
W0i8UI/duXgQLL/6USWtn17XT/2E0t3x2b9KWgFFRcDvdscS0XT+4OU4EhGzCAA6
sYGmYBVLLqXjKFbkYSvrcl0+r+iQirePHwENwywUQ5h3Ss74DZLm0WVzPU5WJuNA
UlhVoKHS5IM=
=FtKv
-----END PGP SIGNATURE-----

--Sig_/UaDzugWaQQxWGz7DpKMCbfi--
