From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.12-rc4
Date: Fri, 2 Jun 2017 09:19:28 -0700
Message-ID: <20170602161928.ttyedwasje6wnsny@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Several patches for MD. One notable is making flush bios sync, others fix small
issues. Please pull!

Thanks,
Shaohua

The following changes since commit 08332893e37af6ae779367e78e444f8f9571511d:

  Linux 4.12-rc2 (2017-05-21 19:30:23 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.12-rc4

for you to fetch changes up to 5a8948f8a32ba56c17b3fb75d318ac98157f3ba5:

  md: Make flush bios explicitely sync (2017-05-31 09:25:53 -0700)

----------------------------------------------------------------
Guoqing Jiang (1):
      md-cluster: fix potential lock issue in add_new_disk

Jan Kara (1):
      md: Make flush bios explicitely sync

Kyungchan Koh (1):
      md: uuid debug statement now in processor byte order.

Nix (1):
      md: report sector of stripes with check mismatches

 drivers/md/bitmap.c      |  8 ++++----
 drivers/md/md-cluster.c  |  4 +++-
 drivers/md/md.c          |  2 +-
 drivers/md/raid5-cache.c |  4 ++--
 drivers/md/raid5-ppl.c   |  4 ++--
 drivers/md/raid5.c       | 18 ++++++++++++++----
 6 files changed, 26 insertions(+), 14 deletions(-)
