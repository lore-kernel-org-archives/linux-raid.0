From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST] Several bug fixes for md in 3.7
Date: Sat, 24 Nov 2012 06:40:01 +1100
Message-ID: <20121124064001.5a205e7f@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lWDu.JgA0yHM9lC3y7OvzVQ"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: George Spelvin <linux@horizon.com>, Shaohua Li <shli@kernel.org>, majianpeng <majianpeng@gmail.com>, zhuwenfeng@kedacom.com, linux RAID <linux-raid@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/lWDu.JgA0yHM9lC3y7OvzVQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Coming a bit late to the -rc party, but here are some bug fixes found
recently through testing, regular usages, and code inspection.

Most worrying is a data corruption risk when 'replacing' devices in a RAID1=
0.
Maybe most interesting is that generic DISCARD support requires granularity=
 to
be a power of two, so RAID5 cannot make the  granularity be one-stripe in
most cases.  This probably makes DISCARD on raid5 less than useful.
Hopefully the generic code will get fixed.

NeilBrown


The following changes since commit ed30be077e705e0dff53bfc51d23feb8aeeab78f:

  MD RAID10: Fix oops when creating RAID10 arrays via dm-raid.c (2012-10-31=
 11:42:30 +1100)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.7-fixes

for you to fetch changes up to 884162df2aadd7414bef4935e1a54976fd4e3988:

  md/raid10: decrement correct pending counter when writing to replacement.=
 (2012-11-22 15:12:42 +1100)

----------------------------------------------------------------
Several bug fixes for md in 3.7

 - raid5 discard has problems
 - raid10 replacement devices have problems
 - bad block lock seqlock usage has problems
 - dm-raid doesn't free everything

----------------------------------------------------------------
NeilBrown (6):
      md: make sure everything is freed when dm-raid stops an array.
      md/raid5: round discard alignment up to power of 2.
      md/raid5: move resolving of reconstruct_state earlier in     stripe_h=
andle.
      md/raid5: Make sure we clear R5_Discard when discard is finished.
      md/raid10: close race that lose writes lost when replacement complete=
s.
      md/raid10: decrement correct pending counter when writing to replacem=
ent.

majianpeng (2):
      md: Reassigned the parameters if read_seqretry returned true in func =
md_is_badblock.
      md: Avoid write invalid address if read_seqretry returned true.

 drivers/md/md.c     |  27 ++++++++---
 drivers/md/raid10.c | 131 +++++++++++++++++++++++++++---------------------=
----
 drivers/md/raid5.c  |  79 ++++++++++++++++---------------
 3 files changed, 132 insertions(+), 105 deletions(-)

--Sig_/lWDu.JgA0yHM9lC3y7OvzVQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK/RETnsnt1WYoG5AQIDVA/9E3fFaOIN3uPca9gTUxjdsfVMz31IhFfN
XwV4cI4vS4iJz4LqbtHXHvpWejDcM1/+gSq/t1ptJkAF7JU4JvOennHsjx0GP0py
daLXd4w764Rji1sos+LB019tdFUmGyKsHJ8MsETB+1Q4nDqZGbn1yTlPetkYtOL7
VLpTrE2LtGfpQBtEIcg98m6dycZ+m5CkUsEYeBUUGcLs3sh/3haIySNl35L7CokR
emihkbC48Yd6WUV+90hT9KAoRZsXZY6b7WRvHZPbAThSwNPtGc+iFaExOD3lLFDN
Zc1MDMcp/j43ptxhvvekdXJBBgHMMZOxWFnd8k601EKSkjUFzDAUZNgZxqaxjAq+
SY2PWQgotF8Ab4b5jU+AcRgDt7VALEAJBbPcosFTg72JDWgDnYmHXHmu7aIsuKLX
4T4zD8S669ZKwdBERZEn3TGSUIsQqylSWBqTuog0g89IRVpXchBdRkpXEF00o7vU
qlwX3bD+573mpCNUVJbQ85G0hTknTOda05yoO3eQIJ9LAEK/l+tWIGQ1Cbnz1LUE
se6Os/wjOXB8gcy0LMzv7AAeJrSeOLdmORYR6GF5a1XTmpGQKTnF3F5VcUd/mhjG
cqSp+VXAemj9WTUHW6PXw/pGgeJCL5hZkQ5Uv/u55FKs8HCtmd3/duRZBFTSuO+P
UGs4chpwwjY=
=ELKL
-----END PGP SIGNATURE-----

--Sig_/lWDu.JgA0yHM9lC3y7OvzVQ--
