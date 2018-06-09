From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.18-rc
Date: Sat, 9 Jun 2018 10:32:35 -0700
Message-ID: <20180609173235.GA110796@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
A few fixes of MD for this merge window. Mostly bug fixes:
- raid5 stripe batch fix from Amy
- Read error handling for raid1 FailFast device from Gioh
- raid10 recovery NULL pointer dereference fix from Guoqing
- Support write hint for raid5 stripe cache from Mariusz
- Fixes for device hot add/remove from Neil and Yufen
- Improve flush bio scalability from Xiao

There is a merge conflict, I attached the fix below. Please pull!

Thanks,
Shaohua

The following changes since commit 83beed7b2b26f232d782127792dd0cd4362fdc41:

  Merge branch 'fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal (2018-04-20 10:56:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-next

for you to fetch changes up to 5a409b4f56d50b212334f338cb8465d65550cd85:

  MD: fix lock contention for flush bios (2018-05-21 09:30:26 -0700)

----------------------------------------------------------------
Amy Chiang (1):
      md/raid5: Assigning NULL to sh->batch_head before testing bit R5_Overlap of a stripe

Gioh Kim (1):
      md/raid1: add error handling of read error from FailFast device

Guoqing Jiang (1):
      raid10: check bio in r10buf_pool_free to void NULL pointer dereference

Mariusz Dabrowski (1):
      raid5: copy write hint from origin bio to stripe

NeilBrown (1):
      md: fix two problems with setting the "re-add" device state.

Xiao Ni (1):
      MD: fix lock contention for flush bios

Yufen Yu (2):
      md: fix an error code format and remove unsed bio_sector
      md: fix NULL dereference of mddev->pers in remove_and_add_spares()

 drivers/md/md.c     | 165 +++++++++++++++++++++++++++++++++++-----------------
 drivers/md/md.h     |  22 ++++---
 drivers/md/raid1.c  |   4 +-
 drivers/md/raid10.c |  10 ++--
 drivers/md/raid5.c  |  12 +++-
 drivers/md/raid5.h  |   1 +
 6 files changed, 144 insertions(+), 70 deletions(-)


diff --cc drivers/md/md.c
index 22203eba1e6e,6b4e2f29fe4e..000000000000
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@@ -5489,16 -5518,34 +5510,32 @@@ int md_run(struct mddev *mddev
  		sysfs_notify_dirent_safe(rdev->sysfs_state);
  	}
  
 -	if (mddev->bio_set == NULL) {
 -		mddev->bio_set = bioset_create(BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 -		if (!mddev->bio_set)
 -			return -ENOMEM;
 +	if (!bioset_initialized(&mddev->bio_set)) {
 +		err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 +		if (err)
 +			return err;
  	}
 -	if (mddev->sync_set == NULL) {
 -		mddev->sync_set = bioset_create(BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 -		if (!mddev->sync_set) {
 -			err = -ENOMEM;
 -			goto abort;
 -		}
 +	if (!bioset_initialized(&mddev->sync_set)) {
 +		err = bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 +		if (err)
 +			return err;
  	}
+ 	if (mddev->flush_pool == NULL) {
+ 		mddev->flush_pool = mempool_create(NR_FLUSH_INFOS, flush_info_alloc,
+ 						flush_info_free, mddev);
+ 		if (!mddev->flush_pool) {
+ 			err = -ENOMEM;
+ 			goto abort;
+ 		}
+ 	}
+ 	if (mddev->flush_bio_pool == NULL) {
+ 		mddev->flush_bio_pool = mempool_create(NR_FLUSH_BIOS, flush_bio_alloc,
+ 						flush_bio_free, mddev);
+ 		if (!mddev->flush_bio_pool) {
+ 			err = -ENOMEM;
+ 			goto abort;
+ 		}
+ 	}
  
  	spin_lock(&pers_lock);
  	pers = find_pers(mddev->level, mddev->clevel);
@@@ -5654,6 -5703,26 +5693,17 @@@
  	sysfs_notify_dirent_safe(mddev->sysfs_action);
  	sysfs_notify(&mddev->kobj, NULL, "degraded");
  	return 0;
 -
+ abort:
+ 	if (mddev->flush_bio_pool) {
+ 		mempool_destroy(mddev->flush_bio_pool);
+ 		mddev->flush_bio_pool = NULL;
+ 	}
+ 	if (mddev->flush_pool){
+ 		mempool_destroy(mddev->flush_pool);
+ 		mddev->flush_pool = NULL;
+ 	}
 -	if (mddev->bio_set) {
 -		bioset_free(mddev->bio_set);
 -		mddev->bio_set = NULL;
 -	}
 -	if (mddev->sync_set) {
 -		bioset_free(mddev->sync_set);
 -		mddev->sync_set = NULL;
 -	}
+ 
+ 	return err;
  }
  EXPORT_SYMBOL_GPL(md_run);
  
@@@ -5864,8 -5933,22 +5914,16 @@@ void md_stop(struct mddev *mddev
  	 * This is called from dm-raid
  	 */
  	__md_stop(mddev);
+ 	if (mddev->flush_bio_pool) {
+ 		mempool_destroy(mddev->flush_bio_pool);
+ 		mddev->flush_bio_pool = NULL;
+ 	}
+ 	if (mddev->flush_pool) {
+ 		mempool_destroy(mddev->flush_pool);
+ 		mddev->flush_pool = NULL;
+ 	}
 -	if (mddev->bio_set) {
 -		bioset_free(mddev->bio_set);
 -		mddev->bio_set = NULL;
 -	}
 -	if (mddev->sync_set) {
 -		bioset_free(mddev->sync_set);
 -		mddev->sync_set = NULL;
 -	}
 +	bioset_exit(&mddev->bio_set);
 +	bioset_exit(&mddev->sync_set);
  }
  
  EXPORT_SYMBOL_GPL(md_stop);
