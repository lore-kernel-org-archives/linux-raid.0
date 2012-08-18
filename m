From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST] md: 2 patches, both heading for -stable
Date: Sat, 18 Aug 2012 10:03:16 +1000
Message-ID: <20120818100316.79b269e2@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/W5HT/sQnJTs6yM=VdF_kTK0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux RAID <linux-raid@vger.kernel.org>, Ivan Vasilyev <ivan.vasilyev@gmail.com>
List-Id: linux-raid.ids

--Sig_/W5HT/sQnJTs6yM=VdF_kTK0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.6-fixes

for you to fetch changes up to e0ee778528bbaad28a5c69d2e219269a3a096607:

  md/raid10: fix problem with on-stack allocation of r10bio structure. (201=
2-08-18 09:51:42 +1000)

----------------------------------------------------------------
2 fixes for md, tagged for -stable

----------------------------------------------------------------
NeilBrown (2):
      md: Don't truncate size at 4TB for RAID0 and Linear
      md/raid10: fix problem with on-stack allocation of r10bio structure.

 drivers/md/md.c     |  9 ++++++---
 drivers/md/raid10.c | 30 +++++++++++++++++++-----------
 drivers/md/raid10.h |  2 +-
 3 files changed, 26 insertions(+), 15 deletions(-)


Thanks,
NeilBrown

--Sig_/W5HT/sQnJTs6yM=VdF_kTK0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUC7bxDnsnt1WYoG5AQLQLw//RFeJdxBlu3qNHV6lBKYpIqIP12hGK2mU
SCDgjKxSc1KYF1ueHrX/GiVtMf/yHi5k1jbJA5MUyORMUPNq1QA84CjmxgKPA6s5
TRsSzqRLYw+9YJ18oi1Sx1DIiM3VNQJuwtHnbR6LZdkdsbQxesGrlNgqGHflGCX1
d/UQp30wNUNhjgY7eY4rbm3LTEyO+OBenSeFr4WpptEuxl7eynY8qOqL8BjFJ3uy
p8g/HM2nmDKKiQAD06NPxvCGvtbvTpqDhky2n4IAYBAekX8QZkwOFFDYnuWG4qk0
OWBeak0bJL/t5bH1l/G26IzA02Koh3DNLvgw/Ah5zcYoatJldadzAkgYChhAcU4p
j8HyHQNBb0cngx1lO5seA2S882YVE9lXe7yiK5UFR80kutW404aodNSlMkO0xC7W
Po8I96z473ezKJGnc1b4V8GnyKN2Hkj7IgmDjQw3LidwtAFDk1q4CcOf/JF3liFj
t57BPHzIhL8ZAgEEPG8YkWIwhu7mwRnHCr58bhr1DXMRe2OT4Z+vBh3dk98x3z2z
3SkEYM5NlVac17oEVBjSaAyKamgkS2gJUrhn/1xcLNqZvoW4lG0vsjSl8M+ZjvaW
mQnnLF4LS9feyUWqXaojUvMqaJObN+CeZDv81S7SauNFdFzgRQFSHJKcb8fAu890
Kzrv2VgLhXc=
=Q+4w
-----END PGP SIGNATURE-----

--Sig_/W5HT/sQnJTs6yM=VdF_kTK0--
