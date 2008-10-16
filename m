From: Neil Brown <neilb@suse.de>
Subject: PULL REQUEST  assorted md fixes etc for 2.6.28
Date: Thu, 16 Oct 2008 15:12:48 +1100
Message-ID: <18678.48960.359352.48245@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Nothing earth shattering here.  Just cleanups and little bugs and a
couple of minor improvements.

Thanks,
NeilBrown


The following changes since commit 278429cff8809958d25415ba0ed32b59866ab1a8:
  Linus Torvalds (1):
        Merge branch 'i2c-for-linus' of git://jdelvare.pck.nerim.net/jdelvare-2.6

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

Andre Noll (6):
      md: linear.c: Fix typo in comment.
      md: linear.c: Remove pointless initialization of curr_offset.
      md: linear.c: Remove broken debug code.
      md: linear: Represent dev_info->size and dev_info->offset in sectors.
      md: linear.c: Make two local variables sector-based.
      md: Convert remaining 1k representations in linear.c to sectors.

Chris Webb (1):
      md: Fix rdev_size_store with size == 0

NeilBrown (5):
      md: Allow metadata_version to be updated for externally managed metadata.
      md: Don't try to set an array to 'read-auto' if it is already in that state.
      md: Remove unnecessary #includes, #defines, and function declarations.
      md: remove space after function name in declaration and call.
      md: Relax minimum size restrictions on chunk_size.

Stephen Rothwell (1):
      md: build failure due to missing delay.h

Sven Wegener (1):
      md: check for memory allocation failure in faulty personality

 drivers/md/faulty.c         |    2 +
 drivers/md/linear.c         |  133 +++++++++++++++++--------------------------
 drivers/md/md.c             |   73 ++++++++++--------------
 drivers/md/multipath.c      |    9 ---
 drivers/md/raid0.c          |    5 --
 drivers/md/raid1.c          |    1 +
 drivers/md/raid10.c         |    6 +-
 drivers/md/raid5.c          |   42 +++++++-------
 drivers/md/raid6.h          |    9 ---
 include/linux/raid/linear.h |   10 ++-
 include/linux/raid/md.h     |   32 ++---------
 11 files changed, 122 insertions(+), 200 deletions(-)
