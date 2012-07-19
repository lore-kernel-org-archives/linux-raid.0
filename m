From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST] 3 more md bugfixes .. they just keep coming...
Date: Thu, 19 Jul 2012 16:01:23 +1000
Message-ID: <20120719160123.76076070@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/s_I5gAXleNbgD++nNssl4_J"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Lyakas <alex.bolshoy@gmail.com>, majianpeng <majianpeng@gmail.com>, Brian Downing <bdowning@lavos.net>, lkml <linux-kernel@vger.kernel.org>, linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/s_I5gAXleNbgD++nNssl4_J
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Thanks,
NeilBrown


The following changes since commit 84a1caf1453c3d44050bd22db958af4a7f99315c:

  Linux 3.5-rc7 (2012-07-14 15:40:28 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.5-fixes

for you to fetch changes up to 58e94ae18478c08229626daece2fc108a4a23261:

  md/raid1: close some possible races on write errors during resync (2012-0=
7-19 15:59:18 +1000)

----------------------------------------------------------------
md: 3 bugfixes for 3.5-rc

One of the bugs was introduced in 3.5-rc1.  Others have
been there for longer.

----------------------------------------------------------------
NeilBrown (3):
      md: fix bug in handling of new_data_offset
      md: avoid crash when stopping md array races with closing other open =
fds.
      md/raid1: close some possible races on write errors during resync

 drivers/md/md.c    |   37 ++++++++++++++++++++++++-------------
 drivers/md/raid1.c |   10 ++++++++--
 2 files changed, 32 insertions(+), 15 deletions(-)

--Sig_/s_I5gAXleNbgD++nNssl4_J
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAeisznsnt1WYoG5AQJN+RAAnSS0rhPzaVk9hFVfuBSfKBSmOmJxoGmV
SrHkzraOfYfN8U6h79cDXHTdiSoiHEREiPy/bw8PtisbtVbKMovsYZ8+VcM+3vdf
pas92gc0exoRaU10orYxAes8ZNswH1ajRJVccrBfL8m/w9dYaqCDuEZCzVUD7Dqh
sanrBolNwha53PJomLAeYhNTpyDqd5tchcX5eDc6efXT1OtbchStUctX6Q/hj2QC
lGBBmUqk7VkK4RsDPKUrC7R2hmhOYfT+2k2kyBHdhHgz1Px1kG0W9/1PDPSzAZam
ZfEIdy8sPAutPK/cJjh2DNN6cX1BvyN/AD0yAZ3U0sKh5Fwglzl/94jcTnRvIkOO
CXsH+YrrwUXEMIxDj1LaCFRkIVKu2ABtq3/EI7wFvcrCmltpWxCUgM1KRAhU2tLQ
rHn5cfytxnHM2dmRij7geLnfpyW1YXPConwfoMxHJcjZk6QkOURZ1LNVURmOQ9Hp
bfXRD1tka7BthFNz1dONnG4U+INeht7bzGtmzust7plIATIryNcsNyANyuNL8ziK
lDpwb521g7luaf2hI9zLu/cmhlFMhgal7Q7X+ltJuzWRgzhVGHrvaDn0MT8gfgkW
aGB3+5MtBytreQQCY8hMjE5ysv1xW0AbfirjmQsvovNvqJXkUufQb7UsMbWLNzBl
49PXMHPWNGE=
=6sUH
-----END PGP SIGNATURE-----

--Sig_/s_I5gAXleNbgD++nNssl4_J--
