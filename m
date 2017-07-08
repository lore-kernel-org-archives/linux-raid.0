From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.13
Date: Fri, 7 Jul 2017 18:09:29 -0700
Message-ID: <20170708010929.3ztmrjo76wj4rtkh@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi,
Please pull MD update for 4.13. This update only includes several bug fixes:

- Neil Brown fixes a deadlock in MD suspend and a potential bug in bio allocation.
- Mikulas Patocka fixes a signal issue
- Guoqing Jiang fixes a typo in FailFast test
- Other trival fixes

Please note, there is a merge conflict with block tree and causes build error,
which could be fixed by this one:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c4d41b03324b..8cdca0296749 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5450,7 +5450,7 @@ int md_run(struct mddev *mddev)
 			return -ENOMEM;
 	}
 	if (mddev->sync_set == NULL) {
-		mddev->sync_set = bioset_create(BIO_POOL_SIZE, 0);
+		mddev->sync_set = bioset_create(BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 		if (!mddev->sync_set)
 			return -ENOMEM;
 	}

Thanks,
Shaohua


The following changes since commit 63f700aab4c11d46626de3cd051dae56cf7e9056:

  Merge tag 'xtensa-20170612' of git://github.com/jcmvbkbc/linux-xtensa (2017-06-13 15:09:10 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-next

for you to fetch changes up to 7184ef8bab0cb865c3cea9dd1a675771145df0af:

  MD: fix sleep in atomic (2017-07-03 14:38:59 -0700)

----------------------------------------------------------------
Guoqing Jiang (2):
      md/raid10: fix FailFast test for wrong device
      md/raid1: remove unused bio in sync_request_write

Lidong Zhong (1):
      md: change the initialization value for a spare device spot to MD_DISK_ROLE_SPARE

Mikulas Patocka (1):
      md: don't use flush_signals in userspace processes

NeilBrown (2):
      md: fix deadlock between mddev_suspend() and md_write_start()
      md: use a separate bio_set for synchronous IO.

Shaohua Li (2):
      MD: fix a null dereference
      MD: fix sleep in atomic

 drivers/md/faulty.c    |  5 +++--
 drivers/md/linear.c    |  7 ++++---
 drivers/md/md.c        | 47 ++++++++++++++++++++++++++++++++++++++---------
 drivers/md/md.h        |  7 +++++--
 drivers/md/multipath.c |  8 ++++----
 drivers/md/raid0.c     |  7 ++++---
 drivers/md/raid1.c     | 20 ++++++++++++--------
 drivers/md/raid10.c    | 16 +++++++++-------
 drivers/md/raid5.c     | 22 +++++++++++++---------
 9 files changed, 92 insertions(+), 47 deletions(-)
