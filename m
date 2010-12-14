From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] md bug fixes
Date: Tue, 14 Dec 2010 18:22:17 +1100
Message-ID: <20101214182217.484f280a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



Hi Linus,
 here are a few bug fixes for md.
 Some of the patches are actually clean-up rather than bug-fix,
 but I that make the bugfix simpler to review.

Thanks,
NeilBrown


The following changes since commit 6313e3c21743cc88bb5bd8aa72948ee1e83937b6:

  Merge branches 'x86-fixes-for-linus', 'perf-fixes-for-linus' and 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-12-08 06:40:59 -0800)

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (5):
      md: remove handling of flush_pending in md_submit_flush_data
      md: move code in to submit_flushes.
      md: fix possible deadlock in handling flush requests.
      md: fix bug with re-adding of partially recovered device.
      md: protect against NULL reference when waiting to start a raid10.

 drivers/md/md.c     |   39 ++++++++++++++++++++-------------------
 drivers/md/raid10.c |    2 +-
 2 files changed, 21 insertions(+), 20 deletions(-)
