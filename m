From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 0/3] count rdev->corrected_errors after final re-read
Date: Wed, 29 Jun 2011 01:47:23 +0900
Message-ID: <1309279646-4950-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

This patchset tries fix rdev->corrected_errors counting. Read errors
are considered to corrected if write-back and re-read cycle is finished
without further problems. Thus moving the rdev->corrected_errors
counting after the re-reading looks more reasonable IMHO.

For resync case in RAID10, rdev->corrected_errors are increased right
after the first read failure. This seems need an improvement though
it's not handled in this series.

The patches are against 'for-next' branch on git://neil.brown.name/md.

Thanks.


Namhyung Kim (3):
  md/raid1: move rdev->corrected_errors counting
  md/raid5: move rdev->corrected_errors counting
  md/raid10: move rdev->corrected_errors counting

 drivers/md/raid1.c  |   17 ++++++-----------
 drivers/md/raid10.c |    2 +-
 drivers/md/raid5.c  |    5 +----
 3 files changed, 8 insertions(+), 16 deletions(-)

-- 
1.7.6

