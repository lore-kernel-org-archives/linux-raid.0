From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.9-rc3
Date: Fri, 4 Nov 2016 17:43:51 -0700
Message-ID: <20161105004351.ck7ikmhhqdtel6qe@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi Linus,

Please pull MD changes for 4.9-rc3. There are several bug fixes queued:
- Fix raid5-cache recovery bugs
- Fix discard IO error handling for raid1/10
- Fix array sync writes bogus position to superblock
- Fix IO error handling for raid array with external metadata

Thanks,
Shaohua


The following changes since commit 07d9a380680d1c0eb51ef87ff2eab5c994949e69:

  Linux 4.9-rc2 (2016-10-23 17:10:14 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.9-rc3

for you to fetch changes up to 1217e1d1999ed6c9c1e1b1acae0a74ab70464ae2:

  md: be careful not lot leak internal curr_resync value into metadata. -- (all) (2016-10-28 22:04:05 -0700)

----------------------------------------------------------------
NeilBrown (1):
      md: be careful not lot leak internal curr_resync value into metadata. -- (all)

Shaohua Li (3):
      RAID1: ignore discard error
      RAID10: ignore discard error
      raid5-cache: correct condition for empty metadata write

Tomasz Majchrzak (2):
      md: report 'write_pending' state when array in sync
      raid1: handle read error also in readonly mode

Zhengyuan Liu (2):
      md/raid5: initialize next_checkpoint field before use
      md/raid5: write an empty meta-block when creating log super-block

 drivers/md/md.c          | 10 +++++-----
 drivers/md/raid1.c       | 26 +++++++++++++++-----------
 drivers/md/raid10.c      |  7 +++++--
 drivers/md/raid5-cache.c |  6 +++++-
 4 files changed, 30 insertions(+), 19 deletions(-)
