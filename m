From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] 2 md fixes for 2.6.33
Date: Wed, 10 Feb 2010 11:36:16 +1100
Message-ID: <19313.65408.650435.144571@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,
 please pull these two md fixes.  They don't actually fix anything in
 the regression list, but I am on the trail of the one reported
 regression that is md related - I just hope to fix it in sysfs rather
 than in md...

Thanks,
NeilBrown


The following changes since commit 6339204ecc2aa2067a99595522de0403f0854bb8:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (2):
      md: fix 'degraded' calculation when starting a reshape.
      md: fix some lockdep issues between md and sysfs.

 drivers/md/md.c    |   14 +++++---------
 drivers/md/raid5.c |   14 ++++++++------
 2 files changed, 13 insertions(+), 15 deletions(-)
