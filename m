From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 00/16] md patches for 2.6.40
Date: Wed, 11 May 2011 16:30:30 +1000
Message-ID: <20110511062743.21263.72802.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm slowly working through getting bad-block-logs working, but it
looks like it won't be ready for 2.6.40 (so many distractions.... and
the code is rather complex and hard to test).

However while doing that coding I found several opportunities to clean
up existing code and various bug reports have come in that need
addressing.

So here are that patches that I currently plan to submit for 2.6.40.
They are all in my for-next branch so should appear in -next shortly.

As always, any review is most welcome.

Thanks,
NeilBrown


---

NeilBrown (16):
      md: allow resync_start to be set while an array is active.
      md/raid10:  reformat some loops with less indenting.
      md/raid10: remove unused variable.
      md/raid10: make more use of 'slot' in raid10d.
      md/raid10: some tidying up in fix_read_error
      md/raid1: improve handling of pages allocated for write-behind.
      md/raid1: try fix_sync_read_error before process_checks.
      md/raid1: tidy up new functions: process_checks and fix_sync_read_error.
      md/raid1: split out two sub-functions from sync_request_write
      md: make error_handler functions more uniform and correct.
      md/multipath: discard ->working_disks in favour of ->degraded
      md/raid1: clean up read_balance.
      md: simplify raid10 read_balance
      md/bitmap: fix saving of events_cleared and other state.
      md: reject a re-add request that cannot be honoured.
      md: Fix race when creating a new md device.


 drivers/md/bitmap.c    |   10 +
 drivers/md/md.c        |   23 ++
 drivers/md/multipath.c |   60 +++---
 drivers/md/multipath.h |    1 
 drivers/md/raid1.c     |  506 ++++++++++++++++++++++++------------------------
 drivers/md/raid1.h     |    4 
 drivers/md/raid10.c    |  424 +++++++++++++++++++---------------------
 drivers/md/raid5.c     |   41 ++--
 8 files changed, 535 insertions(+), 534 deletions(-)

-- 
Signature

