From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.19-rc2
Date: Fri, 7 Sep 2018 11:36:50 -0700
Message-ID: <20180907183650.GA54020@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Please pull MD fixes for 4.19-rc2:
- Fix a locking issue for md-cluster from Guoqing
- Fix a sync crash for raid10 from Ni
- Fix a reshape bug with raid5 cache enabled from Me

Thanks,
Shaohua

The following changes since commit 420f51f4ab6bce6e580390729fadb89c31123636:

  Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux (2018-08-31 09:20:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.19-rc2

for you to fetch changes up to 41a95041126522a921fb73df22cbdd520dfdebad:

  md-cluster: release RESYNC lock after the last resync message (2018-08-31 17:38:10 -0700)

----------------------------------------------------------------
Guoqing Jiang (1):
      md-cluster: release RESYNC lock after the last resync message

Shaohua Li (1):
      md/raid5-cache: disable reshape completely

Xiao Ni (1):
      RAID10 BUG_ON in raise_barrier when force is true and conf->barrier is 0

 drivers/md/md-cluster.c | 10 +++++-----
 drivers/md/raid10.c     |  5 ++++-
 drivers/md/raid5-log.h  |  5 +++++
 drivers/md/raid5.c      |  6 +++---
 4 files changed, 17 insertions(+), 9 deletions(-)
