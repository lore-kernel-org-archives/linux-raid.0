From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] md: various bug fixes
Date: Mon, 28 Jun 2010 14:06:39 +1000
Message-ID: <19496.8143.920908.225279@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
  Please consider pulling the following changes for 2.6.35.
  They are:

   - fixes for regressions introduced in -rc1 (Restore partition....)
   - fixes for enhancements added in -rc1 which were not yet perfect
        (mostly relating to 'takeover' of one level by another)
   - fixes for bugs of longer standing.
     One of these was poor handling of multiple device failure when converting
      a RAID5 to a RAID6 with several more devices.  This bug exposed 
      several issues and covers the "md/raid5:*" patches.

Thanks,
NeilBrown



The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:

  Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)

are available in the git repository at:
  git://neil.brown.name/md/ for-linus

Maciej Trela (3):
      md: fix raid10 takeover: use new_layout for setup_conf
      md: clear layout after ->raid0 takeover
      md: enable raid4->raid0 takeover

NeilBrown (8):
      Restore partition detection of newly created md arrays.
      md: fix handling of array level takeover that re-arranges devices.
      md/raid5: avoid oops when number of devices is reduced then increased.
      md: Don't update ->recovery_offset when reshaping an array to fewer devices.
      md/raid5: More careful check for "has array failed".
      md/raid5: Allow recovered part of partially recovered devices to be in-sync
      md/raid5: add a missing 'continue' in a loop.
      md/raid5: don't include 'spare' drives when reshaping to fewer devices.

Prasanna S. Panchamukhi (1):
      md: raid10: Fix null pointer dereference in fix_read_error()

 drivers/md/md.c     |   38 +++++++++++--
 drivers/md/md.h     |    3 +
 drivers/md/raid0.c  |   21 ++++----
 drivers/md/raid0.h  |    3 -
 drivers/md/raid10.c |   46 ++++++----------
 drivers/md/raid10.h |    5 --
 drivers/md/raid5.c  |  150 +++++++++++++++++++++++++++++++++++++++++----------
 7 files changed, 187 insertions(+), 79 deletions(-)
