From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.15-rc2
Date: Thu, 7 Dec 2017 15:21:05 -0800
Message-ID: <20171207232105.m5dnahcd5n2ifsys@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Please pull some MD fixes. The notable one is a raid5-cache deadlock bug with
dm-raid, others are not significant.

Thanks,
Shaohua

The following changes since commit a0651c7fa2c088a605f63792279859608ed7f2c8:

  Merge tag 'powerpc-4.15-3' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux (2017-12-01 08:40:17 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.15-rc2

for you to fetch changes up to 18022a1bd3709b74ca31ef0b28fccd52bcd6c504:

  md/raid1/10: add missed blk plug (2017-12-01 12:19:48 -0800)

----------------------------------------------------------------
Nate Dailey (1):
      md: limit mdstat resync progress to max_sectors

Shaohua Li (1):
      md/raid1/10: add missed blk plug

Song Liu (1):
      md/r5cache: move mddev_lock() out of r5c_journal_mode_set()

bingjingc (1):
      md/raid5: correct degraded calculation in raid5_error

 drivers/md/md.c          |  4 +++-
 drivers/md/raid1.c       |  4 ++++
 drivers/md/raid10.c      |  4 ++++
 drivers/md/raid5-cache.c | 22 +++++++++-------------
 drivers/md/raid5.c       |  2 +-
 5 files changed, 21 insertions(+), 15 deletions(-)
