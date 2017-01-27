From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.10-rc6
Date: Fri, 27 Jan 2017 13:34:06 -0800
Message-ID: <20170127213406.fdd4qk3rs6q5fx3s@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi,

Please pull MD fixes. This pull fixes several corner cases for raid5 cache,
which is merged into this cycle.

Thanks,
Shaohua

The following changes since commit 557ed56cc75e0a33c15ba438734a280bac23bd32:

  Merge tag 'sound-4.10-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2017-01-12 14:45:59 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.10-rc6

for you to fetch changes up to 2e38a37f23c98d7fad87ff022670060b8a0e2bf5:

  md/r5cache: disable write back for degraded array (2017-01-24 11:26:06 -0800)

----------------------------------------------------------------
Shaohua Li (1):
      md/raid5-cache: delete meaningless code

Song Liu (5):
      md/r5cache: read data into orig_page for prexor of cached data
      md/raid5: move comment of fetch_block to right location
      md/r5cache: flush data only stripes in r5l_recovery_log()
      md/r5cache: shift complex rmw from read path to write path
      md/r5cache: disable write back for degraded array

 drivers/md/md.c          |   5 ++
 drivers/md/raid5-cache.c | 106 ++++++++++++++++++++++++++++++++++-------
 drivers/md/raid5.c       | 121 ++++++++++++++++++++++++++++++++++++-----------
 drivers/md/raid5.h       |   7 +++
 4 files changed, 194 insertions(+), 45 deletions(-)
