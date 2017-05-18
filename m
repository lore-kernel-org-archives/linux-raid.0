From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.12-rc2
Date: Thu, 18 May 2017 11:27:08 -0700
Message-ID: <20170518182708.re2a6ow3b7auh2td@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi,

Please pull MD update for 4.12-rc2. This update mainly fixes bugs:
- Several bug fixes for raid5-cache from Song Liu, mainly handle journal disk error
- Fix bad block handling in choosing raid1 disk from Tomasz Majchrzak
- Simplify external metadata array sysfs handling from Artur Paszkiewicz
- Optimize raid0 discard handling from me, now raid0 will dispatch large
  discard IO directly to underlayer disks.

Thanks,
Shaohua

The following changes since commit 4ac4d584886a4f47f8ff3bca0f32ff9a2987d3e5:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2017-05-04 12:26:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.12-rc2

for you to fetch changes up to d82dd0e34d0347be201fd274dc84cd645dccc064:

  raid1: prefer disk without bad blocks (2017-05-12 14:41:15 -0700)

----------------------------------------------------------------
Artur Paszkiewicz (1):
      md: don't return -EAGAIN in md_allow_write for external metadata arrays

Julia Cartwright (1):
      md/raid5: make use of spin_lock_irq over local_irq_disable + spin_lock

Shaohua Li (2):
      md/md0: optimize raid0 discard handling
      md/raid1/10: avoid unnecessary locking

Song Liu (3):
      md/raid5-cache: in r5l_do_submit_io(), submit io->split_bio first
      md/r5cache: gracefully handle journal device errors for writeback mode
      md/r5cache: handle sync with data in write back cache

Tomasz Majchrzak (1):
      raid1: prefer disk without bad blocks

 drivers/md/md.c          |  20 ++++----
 drivers/md/md.h          |   2 +-
 drivers/md/raid0.c       | 116 +++++++++++++++++++++++++++++++++++++++++------
 drivers/md/raid1.c       |  21 ++++-----
 drivers/md/raid10.c      |   7 ++-
 drivers/md/raid5-cache.c |  47 ++++++++++++++-----
 drivers/md/raid5-log.h   |   3 +-
 drivers/md/raid5.c       |  79 +++++++++++++++++++-------------
 8 files changed, 209 insertions(+), 86 deletions(-)
