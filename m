From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] more minor updates for md in 2.6.27
Date: Fri, 15 Aug 2008 14:54:34 +1000
Message-ID: <18597.3082.389905.592324@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
  a few more bug fixes and minor improvements for md in 2.6.27.
Thanks,
NeilBrown


The following changes since commit 30a2f3c60a84092c8084dfe788b710f8d0768cd4:
  Linus Torvalds (1):
        Linux 2.6.27-rc3

are available in the git repository at:

  git://neil.brown.name/md for-linus

Dan Williams (1):
      md: cancel check/repair requests when recovery is needed

NeilBrown (6):
      Make writes to md/safe_mode_delay immediately effective.
      Restore force switch of md array to readonly at reboot time.
      Fail safely when trying to grow an array with a write-intent bitmap.
      Don't let a blocked_rdev interfere with read request in raid5/6
      Allow faulty devices to be removed from a readonly array.
      Allow raid10 resync to happening in larger chunks.

 drivers/md/md.c     |   33 ++++++++++++++++++++++++++++++---
 drivers/md/raid10.c |    9 +++++----
 drivers/md/raid5.c  |   32 ++++++++++++++++++++++++--------
 3 files changed, 59 insertions(+), 15 deletions(-)
