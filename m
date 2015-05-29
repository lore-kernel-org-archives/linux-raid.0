From: NeilBrown <neilb@suse.de>
Subject: [GIT PULL REQUEST] more md bug fixes for 4.1-rc
Date: Fri, 29 May 2015 16:20:13 +1000
Message-ID: <20150529162013.437422e2@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/G7vr0N7bcKbBdj4C.s68w/w"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

--Sig_/G7vr0N7bcKbBdj4C.s68w/w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 please pull these fixes.
 I think raid5 is all working nicely again now.
 I think there is still a race somewhere in starting the recovery thread, b=
ut
 it is minor and I suspect I'll have it nailed soon.  Not quite this week
 though.

Thanks,
NeilBrown



The following changes since commit 8532e3439087de69bb1b71fd6be2baa6fc196a55:

  md/bitmap: remove rcu annotation from pointer arithmetic. (2015-05-21 09:=
14:41 +1000)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/4.1-rc5-fixes

for you to fetch changes up to 56ccc1125bc141cf63927eda7febff4216dea2d3:

  md: fix race when unfreezing sync_action (2015-05-28 18:04:45 +1000)

----------------------------------------------------------------
Assorted fixes for new RAID5 stripe-batching functionality.

Unfortunately this functionality was merged a little prematurely.
The necessary testing and code review is now complete (or as
complete as it can be) and to code passes a variety of tests
and looks quite sensible.

Also a fix for some recent locking changes - a race was introduced
which causes a reshape request to sometimes fail.  No data safety issues.

----------------------------------------------------------------
NeilBrown (10):
      md/raid5: ensure whole batch is delayed for all required bitmap updat=
es.
      md/raid5: close race between STRIPE_BIT_DELAY and batching.
      md/raid5: Ensure a batch member is not handled prematurely.
      md/raid5: remove condition test from check_break_stripe_batch_list.
      md/raid5: duplicate some more handle_stripe_clean_event code in break=
_stripe_batch_list
      md/raid5: add handle_flags arg to break_stripe_batch_list.
      md/raid5: be more selective about distributing flags across batch.
      md/raid5: call break_stripe_batch_list from handle_stripe_clean_event
      md/raid5: break stripe-batches when the array has failed.
      md: fix race when unfreezing sync_action

 drivers/md/md.c    |  14 ++---
 drivers/md/raid5.c | 146 +++++++++++++++++++++++++++++++------------------=
----
 drivers/md/raid5.h |   5 +-
 3 files changed, 98 insertions(+), 67 deletions(-)

--Sig_/G7vr0N7bcKbBdj4C.s68w/w
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWgFHTnsnt1WYoG5AQIK2hAAv8aLkUtw1wlpNMhMqcbNl2dORvqqwwlK
cjMuLC2DAOD9jDWvakFYLJVOo9r+DbgRzx9euC7oW1ygPekg9BP5CYiRxf+HDFrq
KYctN1awE+nosKl3FZhFdb/lN35QfsWlV+Z8Em1a8s3nxu0XWCEehN0U3CV6rvRo
RTENBrPCWNWRf7QNfOv/aWgzssa/JrRvD58zyhSkhebwQHPlDgMK3CHvocniE5ED
N+07qCeLHTopz19zy/ZCeR1FXyvBF9sDbo0vJEDVZ4r6pQUlSpzqHv+rQMap7POc
8f3Wo08svNFoY/5IGFW0Nn596doKi915KYJw3lYKTYg6yNC5OEEpPoLerNvaZ4Cs
D0pptovuzOhWKl+tCrQr0g0qp1bJqNGM+tuXG7nmgRXMstdKzpbKM/WlkcqnvMaD
kjGW/tfEZvIDm5ADItpGSlHAcqrE/d2Tk2CsJoA3fFqrEjyTpX7GnNA8DjwijW0s
4YCj3CBwV9qWwMCIq/ZWk3onP/02LZvSc7O6IuXnBewUaJYhcfDiFEda6+DMpIq3
eRauJgfPoEPqwOJsjH/6NeXFKooiBK2b82SEpka4ddQo7pnMBhD3FGJuamOM8K8Q
ly08F++vY4DLGWzN60Z2jPpsHPQorZPDx82RbMvMpa+TpI6pN3B8HTpi0J7xrXvl
mPIHmS1vdPk=
=SUuj
-----END PGP SIGNATURE-----

--Sig_/G7vr0N7bcKbBdj4C.s68w/w--
