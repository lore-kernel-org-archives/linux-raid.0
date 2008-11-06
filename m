From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] 3 bugfixes for md
Date: Thu, 6 Nov 2008 19:49:51 +1100
Message-ID: <18706.44975.75760.733547@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Two of these are for stable as well.
The other is primarily a revert of a recent commit which I've since
discoverred is somewhat broken. :-(

Thanks,
NeilBrown


The following changes since commit 45beca08dd8b6d6a65c5ffd730af2eac7a2c7a03:
  Linus Torvalds (1):
        Linux v2.6.28-rc3

are available in the git repository at:

  git://neil.brown.name/md for-linus

Andre Noll (1):
      md: linear: Fix a division by zero bug for very small arrays.

NeilBrown (2):
      md: revert the recent addition of a call to the BLKRRPART ioctl.
      md: fix bug in raid10 recovery.

 drivers/md/linear.c |    2 ++
 drivers/md/md.c     |    6 ------
 drivers/md/raid10.c |    2 +-
 3 files changed, 3 insertions(+), 7 deletions(-)
