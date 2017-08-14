From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.13-rc5
Date: Mon, 14 Aug 2017 09:41:52 -0700
Message-ID: <20170814164152.mjbewehyeytyfawd@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Please pull MD fixes. This update fixes several bugs:
- Fixes a rcu stall issue introduced in 4.12 by Neil Brown.
- Fixes two raid5 cache race conditions by Song Liu.

Thanks,
Shaohua

The following changes since commit 16f73eb02d7e1765ccab3d2018e0bd98eb93d973:

  Linux 4.13-rc3 (2017-07-30 12:40:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.13-rc5

for you to fetch changes up to afc1f55ca44e257f69da8f43e0714a76686ae8d1:

  MD: not clear ->safemode for external metadata array (2017-08-11 20:42:06 -0700)

----------------------------------------------------------------
NeilBrown (2):
      md: always clear ->safemode when md_check_recovery gets the mddev lock.
      md: fix test in md_write_start()

Shaohua Li (1):
      MD: not clear ->safemode for external metadata array

Song Liu (2):
      md/r5cache: call mddev_lock/unlock() in r5c_journal_mode_set
      md/r5cache: fix io_unit handling in r5l_log_endio()

 drivers/md/md.c          |  5 +++-
 drivers/md/raid5-cache.c | 61 ++++++++++++++++++++++++++++++++++++------------
 2 files changed, 50 insertions(+), 16 deletions(-)
