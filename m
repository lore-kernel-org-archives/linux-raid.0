From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.16-rc1
Date: Tue, 30 Jan 2018 13:34:35 -0800
Message-ID: <20180130213435.m2c4x7m6csnp5ls5@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Some small fixes for MD 4.16:
- Fix raid5-cache potential problems if raid5 cache isn't fully recovered
- Fix a wait-within-wait warning in raid1/10
- Make raid5-PPL support disks with writeback cache enabled
Please pull!

Thanks,
Shaohua

The following changes since commit 50c4c4e268a2d7a3e58ebb698ac74da0de40ae36:

  Linux 4.15-rc3 (2017-12-10 17:56:26 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-next

for you to fetch changes up to 1532d9e87e8b2377f12929f9e40724d5fbe6ecc5:

  raid5-ppl: PPL support for disks with write-back cache enabled (2018-01-15 14:29:42 -0800)

----------------------------------------------------------------
NeilBrown (1):
      md/raid1,raid10: silence warning about wait-within-wait

Song Liu (2):
      md: introduce new personality funciton start()
      md/r5cache: print more info of log recovery

Tomasz Majchrzak (1):
      raid5-ppl: PPL support for disks with write-back cache enabled

 Documentation/md/raid5-ppl.txt |   7 +-
 drivers/md/dm-raid.c           |   9 +++
 drivers/md/md.c                |  31 ++++++--
 drivers/md/md.h                |   9 +++
 drivers/md/raid1.c             |  11 +++
 drivers/md/raid10.c            |  12 +++
 drivers/md/raid5-cache.c       |  31 +++++---
 drivers/md/raid5-log.h         |  30 ++++++++
 drivers/md/raid5-ppl.c         | 167 ++++++++++++++++++++++++++++++++++++++---
 drivers/md/raid5.c             |  16 +++-
 10 files changed, 285 insertions(+), 38 deletions(-)
