From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] a few more md patches for 2.6.30
Date: Mon, 20 Apr 2009 17:52:25 +1000
Message-ID: <18924.10681.98103.247886@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>, Christoph Hellwig <hch@lst.de>
List-Id: linux-raid.ids


Hi Linus, 
 a few more md fixes / enhancements.
 The enhancements are fairly minor and essentially finish off various
 threads begun in previous pull.

Thanks,
NeilBrown


The following changes since commit 0882e8dd3aad33eca41696d463bb896e6c8817eb:
  Linus Torvalds (1):
        Linux 2.6.30-rc2

are available in the git repository at:

  git://neil.brown.name/md for-linus

Christoph Hellwig (1):
      md: tiny md.h cleanups

NeilBrown (4):
      md: allow setting newly added device to 'in_sync' via sysfs.
      md: improve usefulness and accuracy of sysfs file md/sync_completed.
      md: update sync_completed and reshape_position even more often.
      md: support bitmaps on RAID10 arrays larger then 2 terabytes

 drivers/md/bitmap.c |    7 ++++---
 drivers/md/md.c     |   41 ++++++++++++++++++++++++++++-------------
 drivers/md/md.h     |   21 +++++++++++++--------
 drivers/md/raid5.c  |    7 ++++++-
 4 files changed, 51 insertions(+), 25 deletions(-)
