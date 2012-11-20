From: kbuild test robot <fengguang.wu@intel.com>
Subject: [md:for-next 15/15] drivers/md/md.c:7583:7: warning: passing
 argument 2 of 'test_bit' from incompatible pointer type
Date: Tue, 20 Nov 2012 08:10:22 +0800
Message-ID: <50aaca6e.3hxZdatB3VCNPuRZ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

tree:   git://neil.brown.name/md for-next
head:   ef59c0770a46e77abba72994170ffe121e56a362
commit: ef59c0770a46e77abba72994170ffe121e56a362 [15/15] md: Use ->curr_resync as last completed request when cleanly aborting resync.
config: make ARCH=m68k allyesconfig

All warnings:

drivers/md/md.c: In function 'md_do_sync':
drivers/md/md.c:7583:7: warning: passing argument 2 of 'test_bit' from incompatible pointer type [enabled by default]
arch/m68k/include/asm/bitops.h:156:19: note: expected 'const long unsigned int *' but argument is of type 'sector_t *'

vim +7583 +/test_bit drivers/md/md.c

^1da177e Linus Torvalds 2005-04-16  7567   out:
7c2c57c9 majianpeng     2012-07-03  7568  	blk_finish_plug(&plug);
^1da177e Linus Torvalds 2005-04-16  7569  	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
^1da177e Linus Torvalds 2005-04-16  7570  
^1da177e Linus Torvalds 2005-04-16  7571  	/* tell personality that we are finished */
57afd89f NeilBrown      2005-06-21  7572  	mddev->pers->sync_request(mddev, max_sectors, &skipped, 1);
^1da177e Linus Torvalds 2005-04-16  7573  
dfc70645 NeilBrown      2008-05-23  7574  	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
5fd6c1dc NeilBrown      2006-06-26  7575  	    mddev->curr_resync > 2) {
5fd6c1dc NeilBrown      2006-06-26  7576  		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
5fd6c1dc NeilBrown      2006-06-26  7577  			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
5fd6c1dc NeilBrown      2006-06-26  7578  				if (mddev->curr_resync >= mddev->recovery_cp) {
5fd6c1dc NeilBrown      2006-06-26  7579  					printk(KERN_INFO
61df9d91 NeilBrown      2006-10-03  7580  					       "md: checkpointing %s of %s.\n",
61df9d91 NeilBrown      2006-10-03  7581  					       desc, mdname(mddev));
ef59c077 majianpeng     2012-11-19  7582  					if (test_bit(MD_RECOVERY_ERROR,
ef59c077 majianpeng     2012-11-19 @7583  						&mddev->recovery_cp))
ef59c077 majianpeng     2012-11-19  7584  						mddev->recovery_cp =
ef59c077 majianpeng     2012-11-19  7585  							mddev->curr_resync_completed;
ef59c077 majianpeng     2012-11-19  7586  					else
ef59c077 majianpeng     2012-11-19  7587  						mddev->recovery_cp =
ef59c077 majianpeng     2012-11-19  7588  							mddev->curr_resync;
5fd6c1dc NeilBrown      2006-06-26  7589  				}
5fd6c1dc NeilBrown      2006-06-26  7590  			} else
5fd6c1dc NeilBrown      2006-06-26  7591  				mddev->recovery_cp = MaxSector;

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
