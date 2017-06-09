From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.12-rc5
Date: Fri, 9 Jun 2017 09:32:33 -0700
Message-ID: <20170609163233.7qbmycvsjrd7c62i@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
One bug fix from Neil Brown for MD. The bug is introduced in this cycle. Please
pull!

Thanks,
Shaohua

The following changes since commit 3c2993b8c6143d8a5793746a54eba8f86f95240f:

  Linux 4.12-rc4 (2017-06-04 16:47:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.12-rc5

for you to fetch changes up to a415c0f10627913793709ddb75add09d2ea334dc:

  md: initialise ->writes_pending in personality modules. (2017-06-05 16:04:35 -0700)

----------------------------------------------------------------
NeilBrown (1):
      md: initialise ->writes_pending in personality modules.

 drivers/md/md.c     | 16 ++++++++++++----
 drivers/md/md.h     |  1 +
 drivers/md/raid1.c  |  2 ++
 drivers/md/raid10.c |  3 +++
 drivers/md/raid5.c  |  3 +++
 5 files changed, 21 insertions(+), 4 deletions(-)
