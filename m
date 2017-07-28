From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.13-rc3
Date: Fri, 28 Jul 2017 08:05:55 -0700
Message-ID: <20170728150555.yfxhk2ame36iceoo@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
This update fixes several bugs, 3 of them are suitable for stable:
- An initialization issue fixed by Ming
- A bio clone race issue fixed by me
- An async tx flush issue fixed by Ofer
- Other cleanups

Thanks,
Shaohua

The following changes since commit 4ec9f7a18b9fcef6e8f7c13279b48e3bb5d4d704:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2017-07-21 11:20:58 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-next

for you to fetch changes up to ed9b66d21866ae3bf16557406258ebe6c00a9a84:

  MD: fix warnning for UP case (2017-07-25 15:18:13 -0700)

----------------------------------------------------------------
Guoqing Jiang (1):
      md: simplify code with bio_io_error

Ming Lei (3):
      md: remove 'idx' from 'struct resync_pages'
      md: raid1/raid10: initialize bvec table via bio_add_page()
      md: raid1-10: move raid1/raid10 common code into raid1-10.c

Ofer Heifetz (1):
      md/raid5: add thread_group worker async_tx_issue_pending_all

Shaohua Li (2):
      md/raid1: fix writebehind bio clone
      MD: fix warnning for UP case

 drivers/md/md.c       |  2 +-
 drivers/md/md.h       | 54 ----------------------------------
 drivers/md/raid1-10.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid1.c    | 68 +++++++++++++-----------------------------
 drivers/md/raid10.c   | 25 +++++-----------
 drivers/md/raid5.c    | 11 ++++---
 6 files changed, 115 insertions(+), 126 deletions(-)
 create mode 100644 drivers/md/raid1-10.c
