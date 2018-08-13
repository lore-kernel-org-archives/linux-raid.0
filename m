From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.19-rc1
Date: Mon, 13 Aug 2018 11:45:57 -0700
Message-ID: <20180813184557.GA8056@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
A few MD fixes for 4.19-rc1:
- Several md-cluster fixes from Guoqing
- A data corruption fix from BingJing
- Other cleanups
Please pull!

Thanks,
Shaohua

The following changes since commit 06c85639897cf3ea6a11c5cb6929fb0d9d7efea5:

  Merge tag 'acpi-4.18-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2018-07-05 09:52:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-next

for you to fetch changes up to d63e2fc804c46e50eee825c5d3a7228e07048b47:

  md/raid5: fix data corruption of replacements after originals dropped (2018-08-02 11:22:06 -0700)

----------------------------------------------------------------
Anna-Maria Gleixner (2):
      drivers/md/raid5: Use irqsave variant of atomic_dec_and_lock()
      drivers/md/raid5: Do not disable irq on release_inactive_stripe_list() call

BingJing Chang (1):
      md/raid5: fix data corruption of replacements after originals dropped

Colin Ian King (1):
      md/r5cache: remove redundant pointer bio

Guoqing Jiang (3):
      md-cluster: clear another node's suspend_area after the copy is finished
      md-cluster: show array's status more accurate
      md-cluster: don't send msg if array is closing

 drivers/md/md-cluster.c  | 47 +++++++++++++++++++++++++++++++++++------------
 drivers/md/md.c          | 17 +++++++++++++++++
 drivers/md/md.h          |  1 +
 drivers/md/raid5-cache.c |  2 --
 drivers/md/raid5.c       | 12 ++++++++----
 5 files changed, 61 insertions(+), 18 deletions(-)
