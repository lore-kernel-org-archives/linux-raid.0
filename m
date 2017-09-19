From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.14-rc2
Date: Tue, 19 Sep 2017 08:22:30 -0700
Message-ID: <20170919151340.pgkmo3isq634lpyy@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
2 small patches fix long live raid5 stripe batch bugs, one from Dennis and the
other from me. Please pull!

Thanks,
Shaohua

The following changes since commit e8a27f836f165c26f867ece7f31eb5c811692319:

  md/bitmap: disable bitmap_resize for file-backed bitmaps. (2017-08-31 22:57:03 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-next

for you to fetch changes up to 184a09eb9a2fe425e49c9538f1604b05ed33cfef:

  md/raid5: preserve STRIPE_ON_UNPLUG_LIST in break_stripe_batch_list (2017-09-05 22:51:13 -0700)

----------------------------------------------------------------
Dennis Yang (1):
      md/raid5: preserve STRIPE_ON_UNPLUG_LIST in break_stripe_batch_list

Shaohua Li (1):
      md/raid5: fix a race condition in stripe batch

 drivers/md/raid5.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)
