From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] md - various fixed for 2.6.30
Date: Tue, 26 May 2009 13:06:32 +1000
Message-ID: <18971.23736.279996.704625@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
 a few more md fixes turned up through on going testing.

 A couple involve refining the user-space interface (sysfs) so that
 some of the recent features can be used reliably.

 The 'bitmap' fix isn't strictly a bug fix, but is reduces a fair
 amount of CPU wastage.

 The "don't use locked_ioctl" patch is again strictly not a bug fix,
 but it is so trivial it didn't seem worth leaving it for .31.
 It just tells the block layer that md doesn't need lock_kernel, even
 for ioctls.

Thanks,
NeilBrown


The following changes since commit 59a3759d0fe8d969888c741bb33f4946e4d3750d:
  Linus Torvalds (1):
        Linux 2.6.30-rc7

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (7):
      md: always update level / chunk_size / layout when writing v1.x metadata.
      md: improve errno return when setting array_size
      md: bitmap: improve bitmap maintenance code.
      md: export 'frozen' resync state through sysfs
      md: raid5: avoid sector values going negative when testing reshape progress.
      md: don't update curr_resync_completed without also updating reshape_position.
      md: don't use locked_ioctl.

 drivers/md/bitmap.c |   13 +++++++------
 drivers/md/md.c     |   31 +++++++++++++++++++++----------
 drivers/md/raid5.c  |    6 +++---
 3 files changed, 31 insertions(+), 19 deletions(-)
