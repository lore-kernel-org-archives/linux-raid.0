From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST] md updates for 3.2-rc
Date: Fri, 9 Dec 2011 14:52:28 +1100
Message-ID: <20111209145228.3bdbd999@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_gQh8OrOA/mV8W3WA=R+1U."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, Adam Kwolek <adam.kwolek@intel.com>
List-Id: linux-raid.ids

--Sig_/_gQh8OrOA/mV8W3WA=R+1U.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 please pull these 7 md patches.
 They fixes some races with sysfs access to md devices and fix some bugs
 in the new bad-block-management code.

Thanks,
NeilBrown


The following changes since commit 5611cc4572e889b62a7b4c72a413536bf6a9c416:

  Linux 3.2-rc4 (2011-12-01 14:56:01 -0800)

are available in the git repository at:
  git://neil.brown.name/md/ for-linus

  last commit being 5d8c71f9e5fbdd95650be00294d238e27a363b5c

Adam Kwolek (1):
      md: raid5 crash during degradation

NeilBrown (6):
      md/lock: ensure updates to page_attrs are properly locked.
      md: refine interpretation of "hold_active =3D=3D UNTIL_IOCTL".
      md: take a reference to mddev during sysfs access.
      md: bad blocks shouldn't cause a Blocked status on a Faulty device.
      md: ensure new badblocks are handled promptly.
      md/raid5: never wait for bad-block acks on failed device.

 drivers/md/bitmap.c |    4 ++++
 drivers/md/md.c     |   27 +++++++++++++++++++++++----
 drivers/md/raid5.c  |    8 +++++---
 3 files changed, 32 insertions(+), 7 deletions(-)

--Sig_/_gQh8OrOA/mV8W3WA=R+1U.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuGF/Dnsnt1WYoG5AQK8Kg/+JWiAMJ+lWo4xFDjVGvMOdfYcI2ErM5sg
X0F5wWyFVpYPC11TMvV+826seRHHW59aALu5f7kS52IDDfW/rGY5kQcm8mBSrYck
OIoidQJgtyaJnraDVlpUd1g14hqj45i6ZqO356I4TZppitNxu8bkCsEStlZ7VSJO
1GkqjtnxR2oI8ZQfSaB9OkVCjhcNOyXsuhyFJtD8xzolWHTsQXyDrOi7kkqIfTR+
gQMj5QeXLHAtWNrrYw4GpwuWHVW34IZzuCdrA/zPNSTuocKoBjiApG4A7UiW1LeR
WZVYeYc2BzzNR8npEBKx8hDGDmmC7FvflyYeRUXi6Rb4XIoyQvX9ol1R8ru2K8/n
eTZ/pMHpREghrf09U7LvEBPbyhKkCh0BEn5AY/cQdv9uafofl9ggYmntBHYseWlr
rlze8s25tusqZHcx1BqyFOfRHbcuiak+mG1RvkpQU27tckaUoaovQqBNPD/wPavf
s8QuUOEK1BckCfu15I2LjI+ftc1uUShxFtrtsJgHxcFiZvoP3QqECI1+w9UPO8YS
iaUvUOjz8cietDlRsXcpfKTgzcaqahUQt9zkApJPYCbRbDIPDmqWr3vEhBebWeSN
3WUbHW20MIJmAILzZ4iNNcI05ilaCSDX7Wx8iC494AKg+B2ynvwSxh8kcZ0743W5
1bvSJzz20zQ=
=VUEi
-----END PGP SIGNATURE-----

--Sig_/_gQh8OrOA/mV8W3WA=R+1U.--
