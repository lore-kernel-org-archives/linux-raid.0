From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] a few fixes for md.
Date: Wed, 18 Aug 2010 16:21:13 +1000
Message-ID: <19563.31705.46643.32601@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>, Christoph Hellwig <hch@lst.de>, Adrian Drzewiecki <adriand@vmware.com>
List-Id: linux-raid.ids


hi Linus,
 here are a few fixes for md.
 One is a regression that came in through the block tree, others are
 assorted minor bugs that we have had for a while.

Thanks,
NeilBrown


The following changes since commit da5cabf80e2433131bf0ed8993abc0f7ea618c73:

  Linux 2.6.36-rc1 (2010-08-15 17:41:37 -0700)

are available in the git repository at:
  git://neil.brown.name/md for-linus

Adrian Drzewiecki (1):
      md: Notify sysfs when RAID1/5/10 disk is In_sync.

NeilBrown (3):
      Update recovery_offset even when external metadata is used.
      md: provide appropriate return value for spare_active functions.
      md raid-1/10 Fix bio_rw bit manipulations again

 drivers/md/md.c     |   44 ++++++++++++++++++--------------------------
 drivers/md/raid1.c  |   21 ++++++++++++---------
 drivers/md/raid10.c |   17 ++++++++++-------
 drivers/md/raid5.c  |   13 ++++++++-----
 4 files changed, 48 insertions(+), 47 deletions(-)
