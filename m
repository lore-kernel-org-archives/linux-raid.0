From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.13-rc2
Date: Tue, 18 Jul 2017 11:49:34 -0700
Message-ID: <20170718184934.lu3fioskpjvh7qib@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Please pull 3 MD fixes:
- raid5-ppl fix by Artur. This one is introduced in this release cycle.
- raid5 reshape fix by Xiao. This is an old bug and will be added to stable.
- Bitmap fix by Guoqing.

Thanks,
Shaohua

The following changes since commit af3c8d98508d37541d4bf57f13a984a7f73a328c:

  Merge tag 'drm-for-v4.13' of git://people.freedesktop.org/~airlied/linux (2017-07-09 18:48:37 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.13-rc2

for you to fetch changes up to 6409e84ec58fc4c0085d8921f8e01815dc871971:

  raid5-ppl: use BIOSET_NEED_BVECS when creating bioset (2017-07-12 09:26:37 -0700)

----------------------------------------------------------------
Artur Paszkiewicz (1):
      raid5-ppl: use BIOSET_NEED_BVECS when creating bioset

Guoqing Jiang (1):
      md/bitmap: don't read page from device with Bitmap_sync

Xiao Ni (1):
      Raid5 should update rdev->sectors after reshape

 drivers/md/bitmap.c    | 3 ++-
 drivers/md/md.h        | 4 +++-
 drivers/md/raid5-ppl.c | 2 +-
 drivers/md/raid5.c     | 4 +---
 4 files changed, 7 insertions(+), 6 deletions(-)
