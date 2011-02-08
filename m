From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST] md updates for 2.6.38
Date: Tue, 8 Feb 2011 15:20:44 +1100
Message-ID: <20110208152044.06dfc9ba@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
 here are a few more md updates.
 most are bugs in relatively recent code.
 This is small "enhancement" in there in that raid1->raid0 conversion is now
 possible.  That is largely just an extension to the other conversions that
 were added in the merge window.

 One fix (from Chris Mason) is tagged for -stable.

Thanks,
NeilBrown


The following changes since commit 1f0324caefd39985e9fe052fac97da31694db31e:

  Merge branch 'stable/bug-fixes-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen (2011-01-28 12:24:34 +1000)

are available in the git repository at:

  git://neil.brown.name/md for-linus

Chris Mason (1):
      md_make_request: don't touch the bio after calling make_request

Krzysztof Wojcik (2):
      Add raid1->raid0 takeover support
      FIX: md: process hangs at wait_barrier after 0->10 takeover

NeilBrown (8):
      md: revert change to raid_disks on failure.
      md: simplify some 'if' conditionals in raid5_start_reshape.
      md: fix the test for finding spares in raid5_start_reshape.
      md: don't abort checking spares as soon as one cannot be added.
      md: Remove the AllReserved flag for component devices.
      md: Don't use remove_and_add_spares to remove failed devices from a read-only array
      md: don't clear curr_resync_completed at end of resync.
      md: Don't allow slot_store while resync/recovery is happening.

 drivers/md/md.c     |   47 +++++++++++++++++++++++++++------------
 drivers/md/md.h     |    2 -
 drivers/md/raid0.c  |   40 ++++++++++++++++++++++++++++++++++
 drivers/md/raid10.c |    6 +++-
 drivers/md/raid5.c  |   60 +++++++++++++++++++++++++-------------------------
 5 files changed, 106 insertions(+), 49 deletions(-)
