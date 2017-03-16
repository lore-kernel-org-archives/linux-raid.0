From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.11-rc3
Date: Thu, 16 Mar 2017 09:40:56 -0700
Message-ID: <20170316164056.pot4r65lokskmjns@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi,
Please pull MD fix for 4.11-rc3. This update includes some fixes and cleanups:
- Fix a parity calculation bug of raid5 cache by Song
- Fix a potential deadlock issue by me
- Fix two endian issues by Jason
- Fix a disk limitation issue by Neil
- Other small fixes and cleanup

Thanks,
Shaohua

The following changes since commit ea6200e84182989a3cce9687cf79a23ac44ec4db:

  Merge branch 'core-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2017-03-08 14:45:31 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-linus

for you to fetch changes up to 11353b9d10392e79e32603d2178e75feb25eaf0d:

  md/raid1: fix a trivial typo in comments (2017-03-14 11:10:44 -0700)

----------------------------------------------------------------
Guoqing Jiang (3):
      md-cluster: free md_cluster_info if node leave cluster
      md-cluster: remove useless memset from gather_all_resync_info
      md: move funcs from pers->resize to update_size

Jason Yan (2):
      md: fix super_offset endianness in super_1_rdev_size_change
      md: fix incorrect use of lexx_to_cpu in does_sb_need_changing

NeilBrown (1):
      md: don't impose the MD_SB_DISKS limit on arrays without metadata.

Shaohua Li (3):
      md/raid10: submit bio directly to replacement disk
      md: delete dead code
      md/raid1/10: fix potential deadlock

Song Liu (1):
      md/r5cache: fix set_syndrome_sources() for data in cache

Zhilong Liu (1):
      md/raid1: fix a trivial typo in comments

 drivers/md/md-cluster.c |  2 +-
 drivers/md/md.c         | 27 +++++++++++----------------
 drivers/md/md.h         |  6 ------
 drivers/md/raid1.c      | 29 ++++++++++++++++++++++++-----
 drivers/md/raid10.c     | 41 ++++++++++++++++++++++++++++++++++-------
 drivers/md/raid5.c      |  5 ++---
 6 files changed, 72 insertions(+), 38 deletions(-)
