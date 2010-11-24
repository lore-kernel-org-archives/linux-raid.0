From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] md fixes for 2.6.37
Date: Wed, 24 Nov 2010 17:43:52 +1100
Message-ID: <20101124174352.20f9e974@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
 as few little fixes for md.
 Two are flags for stable,
 The other is only relevant to 2.6.37 as it relates to the barrier -> flush
 conversion for block devices.

Thanks,
NeilBrown


The following changes since commit 3561d43fd289f590fdae672e5eb831b8d5cf0bf6:

  Linux 2.6.37-rc3 (2010-11-21 15:18:56 -0800)

are available in the git repository at:
  git://neil.brown.name/md for-linus

Darrick J. Wong (1):
      md: Call blk_queue_flush() to establish flush/fua support

Justin Maggard (1):
      md: fix return value of rdev_size_change()

NeilBrown (1):
      md/raid1: really fix recovery looping when single good device fails.

 drivers/md/md.c    |    6 ++++--
 drivers/md/raid1.c |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)
