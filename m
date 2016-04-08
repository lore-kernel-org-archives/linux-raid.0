From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD fix for 4.6-rc2
Date: Fri, 8 Apr 2016 14:34:21 -0700
Message-ID: <20160408213421.GA6279@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

Hi Linus,

Could you please pull the MD fixes for 4.6-rc2? This update mainly fixes bugs.
- Fix error handling from Guoqing
- Fix a crash when a disk is hotremoved from me
- fix a dead loop from Wei Fang

Thanks,
Shaohua

The following changes since commit c05c2ec96bb8b7310da1055c7b9d786a3ec6dc0c:

  Merge branch 'parisc-4.6-2' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux (2016-03-31 07:55:14 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.6-rc2-fix

for you to fetch changes up to f9a67b1182e5abfcfcec24762ea95a77332f035e:

  md/bitmap: clear bitmap if bitmap_create failed (2016-04-01 13:05:50 -0700)

----------------------------------------------------------------
Guoqing Jiang (1):
      md/bitmap: clear bitmap if bitmap_create failed

Shaohua Li (1):
      MD: add rdev reference for super write

Wei Fang (2):
      md:raid1: fix a dead loop when read from a WriteMostly disk
      md: fix a trivial typo in comments

 drivers/md/bitmap.c | 19 +++++++++++--------
 drivers/md/md.c     |  5 ++++-
 drivers/md/raid1.c  |  2 +-
 3 files changed, 16 insertions(+), 10 deletions(-)
