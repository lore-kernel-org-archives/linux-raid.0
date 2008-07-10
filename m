From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 0/5] md: sector_t conversions
Date: Thu, 10 Jul 2008 11:15:33 +0200
Message-ID: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

here is the first batch of patches that aim to change the internal
representations of sizes of raid devices from 1K blocks to 512 byte
sectors.

Patches 1-3 change the internal functions update_size(),
calc_dev_size() and calc_dev_sboffset() so that they take/return a
sector count instead of a block count. Patch 4 changes the semantics
of rdev->sb_offset so that its value now represents the number of the
start sector instead of the start block. Patch 5 removes some macros
that have become unused due to this conversion.

These changes are all simple and straight-forward, but it's easy to
make mistakes because there's no help from the compiler. So please
review carefully.


 drivers/md/bitmap.c       |   10 ++--
 drivers/md/md.c           |  111 +++++++++++++++++++++------------------------
 include/linux/raid/md_k.h |    2 +-
 include/linux/raid/md_p.h |    3 -
 4 files changed, 58 insertions(+), 68 deletions(-)

Regards
Andre
