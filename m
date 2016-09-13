From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.8-rc6
Date: Tue, 13 Sep 2016 09:56:23 -0700
Message-ID: <20160913165623.GA13578@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi Linus,
A few bug fixes for MD.
- Guoqing fixed a bug compiling md-cluster in kernel
- I fixed a potential deadlock in raid5-cache superblock write, a hang in raid5
  reshape resume and a race condition introduced in -rc4

Please pull!

Thanks,
Shaohua

The following changes since commit 86a1679860babbacd61fc1e8c0c0f43641d5860d:

  Merge tag 'md/4.8-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/shli/md (2016-08-30 11:24:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.8-rc6

for you to fetch changes up to c94455558337eece474eebb6a16b905f98930418:

  raid5: fix a small race condition (2016-09-09 11:09:19 -0700)

----------------------------------------------------------------
Guoqing Jiang (1):
      md-cluster: make md-cluster also can work when compiled into kernel

Shaohua Li (3):
      raid5-cache: fix a deadlock in superblock write
      raid5: guarantee enough stripes to avoid reshape hang
      raid5: fix a small race condition

 drivers/md/md.c          | 12 ++++--------
 drivers/md/raid5-cache.c | 46 +++++++++++++++-------------------------------
 drivers/md/raid5.c       | 14 ++++++++++++--
 3 files changed, 31 insertions(+), 41 deletions(-)
