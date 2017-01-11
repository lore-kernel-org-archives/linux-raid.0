From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.10-rc3
Date: Wed, 11 Jan 2017 10:15:23 -0800
Message-ID: <20170111181523.6urbotv24ifnhjpl@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi,

Please pull MD update for 4.10-rc3. Basically one fix for raid5 cache which is
merged in this cycle, others are trival fixes.

Thanks,
Shaohua

The following changes since commit 0c744ea4f77d72b3dcebb7a8f2684633ec79be88:

  Linux 4.10-rc2 (2017-01-01 14:31:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.10-rc3

for you to fetch changes up to 32cd7cbbacf700885a2316275f188f2d5739b5f4:

  md/raid5: Use correct IS_ERR() variation on pointer check (2017-01-09 13:58:10 -0800)

----------------------------------------------------------------
Colin Ian King (1):
      md/r5cache: fix spelling mistake on "recoverying"

JackieLiu (1):
      md/raid5-cache: removes unnecessary write-through mode judgments

Jes Sorensen (1):
      md/raid5: Use correct IS_ERR() variation on pointer check

Robert LeBlanc (2):
      md/raid1: Refactor raid1_make_request
      md/raid10: Refactor raid10_make_request

Shaohua Li (1):
      md: cleanup mddev flag clear for takeover

Song Liu (2):
      md/r5cache: simplify handling of sh->log_start in recovery
      md/r5cache: assign conf->log before r5l_load_log()

 drivers/md/md.h          |   8 ++
 drivers/md/raid0.c       |  12 ++-
 drivers/md/raid1.c       | 275 +++++++++++++++++++++++++----------------------
 drivers/md/raid10.c      | 245 +++++++++++++++++++++++------------------
 drivers/md/raid5-cache.c |  36 +++----
 drivers/md/raid5.c       |   7 +-
 6 files changed, 322 insertions(+), 261 deletions(-)
