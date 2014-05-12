From: NeilBrown <neilb@suse.de>
Subject: [GIT PULL REQUEST] two bug fixes for md - both tagged  for -stable.
Date: Mon, 12 May 2014 11:12:00 +1000
Message-ID: <20140512111200.32a4b189@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VCMJLpP3E3/HKtFnqUCaFpq"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux RAID <linux-raid@vger.kernel.org>, Chris Murphy <lists@colorremedies.com>
List-Id: linux-raid.ids

--Sig_/VCMJLpP3E3/HKtFnqUCaFpq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:

  Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/3.15-fixes

for you to fetch changes up to 0f62fb220aa4ebabe8547d3a9ce4a16d3c045f21:

  md: avoid possible spinning md thread at shutdown. (2014-05-06 09:49:31 +=
1000)

----------------------------------------------------------------
Two bugfixes for md in 3.15

Both tagged for -stable.

----------------------------------------------------------------
NeilBrown (2):
      md/raid10: call wait_barrier() for each request submitted.
      md: avoid possible spinning md thread at shutdown.

 drivers/md/md.c     |  3 ++-
 drivers/md/raid10.c | 13 +++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

--Sig_/VCMJLpP3E3/HKtFnqUCaFpq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU3Af4Dnsnt1WYoG5AQIS7A//Ub+Zm2xu+MZTbqBviyd5ZW7N5YDVJ1CA
dLutVSX7o37CsMzVlV3spBsuDS3rmtVx9LjCsi+QYwQq9jgWs0Y1WQO778ndWmXI
CXucKw3pS6zFDIwZusO0iIz+8CNoKY/9hDoav/oIY7+7p5TbrbNQTei8LmIlUf+K
yXyHNFz/q8+oyGQDgAoBt+PRrGm+PE5hERjZChnxBrkQA4/Q10Nd7CpvsXXKmYnI
pCox/TRw1ZnQeI2Vg9Gm5IDBfzaSHYrWrGEgFws9zz2KfoBhT5+SQmdJtWeQ0Gp8
FFzv08O0/7tO/kc1CY2bDa2SI8iKN6fr+sT13q5gNxL4bYuBsBwQrHaIyb64VMZ5
uYiYn3R2jM2Ms2Iqu4KSxwNTIOf421bH+F5tc1IYqrK9crJUUnq31bCqrBYtOzal
OuhOuLc49P1e+MURqqqxKr3gDMmnqVE8qNbT6lCuq1CT2prQFj4wQRwme1n5k8M4
kusocxs6LKbDeQowbtm1+f5BB87C9dbkOZxYg8XwxiZ0gMMJnsFKH2NP6wT8GCq4
VWjWq6zufMkEZ8BeMVhCGys/YGLH/fuPVrfFtW0DmEdWhuUT3u+CetU5WU+HQc1W
Ye9KF624gTLHMvxC5A2NHKWf9LN3gpkZR3wCKFFA9kf1BoIyRZCMoSSBbTY+7ZRn
FMHD8TTJiYQ=
=7Ke4
-----END PGP SIGNATURE-----

--Sig_/VCMJLpP3E3/HKtFnqUCaFpq--
