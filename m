From: Shaohua Li <shli@fb.com>
Subject: Re: [md:devel 46/50] drivers/md/raid5-cache.c:710:1371: error: call
 to '__cmpxchg_wrong_size' declared with attribute error: Bad argument size
 for cmpxchg
Date: Wed, 19 Aug 2015 14:45:28 -0700
Message-ID: <20150819214526.GA2455428@devbig257.prn2.facebook.com>
References: <201508191412.vxUg51nb%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201508191412.vxUg51nb%fengguang.wu@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 19, 2015 at 02:44:13PM +0800, kbuild test robot wrote:
> tree:   git://neil.brown.name/md devel
> head:   da63d1b483fa5a9604d65974eb442a110ee41e89
> commit: ae7d339ebdd2b176a49442a8315cfe30173b5854 [46/50] raid5: log reclaim support
> config: i386-allyesconfig (attached as .config)
> reproduce:
>   git checkout ae7d339ebdd2b176a49442a8315cfe30173b5854
>   # save the attached .config to linux build tree
>   make ARCH=i386 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    drivers/md/raid5-cache.c: In function 'r5l_wake_reclaim':
> >> drivers/md/raid5-cache.c:710:1371: error: call to '__cmpxchg_wrong_size' declared with attribute error: Bad argument size for cmpxchg
>      } while (cmpxchg(&log->reclaim_target, target, space) != target);
>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ^
>    drivers/md/raid5-cache.c: In function 'r5l_do_reclaim':
> >> drivers/md/raid5-cache.c:620:631: error: call to '__xchg_wrong_size' declared with attribute error: Bad argument size for xchg
>      sector_t reclaim_target = xchg(&log->reclaim_target, 0);

Thanks for the reporting. Here is the fix for the issues.


From d5c0fdd525b5ea95d4b7ef178ff6010aaa9b0e81 Mon Sep 17 00:00:00 2001
Message-Id: <d5c0fdd525b5ea95d4b7ef178ff6010aaa9b0e81.1440020586.git.shli@fb.com>
From: Shaohua Li <shli@fb.com>
Date: Wed, 19 Aug 2015 14:38:20 -0700
Subject: [PATCH] raid5: fix some build issues

Fix some build issues. I change the reclaim_target to 'unsigned long' so
we can use xchg. It can overflow in 32bit in theory, but don't think
it's a real issue.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c          | 2 +-
 drivers/md/raid5-cache.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4775029..9843ba3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1657,7 +1657,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 			set_bit(Faulty, &rdev->flags);
 			break;
 		case MD_DISK_ROLE_JOURNAL: /* journal device */
-			if (!(sb->feature_map & MD_FEATURE_JOURNAL)) {
+			if (!(le32_to_cpu(sb->feature_map) & MD_FEATURE_JOURNAL)) {
 				/* journal device without journal feature */
 				printk(KERN_WARNING
 				  "md: journal device provided without "
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 52feb90..681621d 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -69,7 +69,7 @@ struct r5l_log {
 	struct kmem_cache *io_kc;
 
 	struct md_thread *reclaim_thread;
-	sector_t reclaim_target; /* number of space that need to be reclaimed.
+	unsigned long reclaim_target; /* number of space that need to be reclaimed.
 				  * if it's 0, reclaim spaces used by io_units
 				  * which are in IO_UNIT_STRIPE_END state (eg,
 				  * reclaim dones't wait for specific io_unit
-- 
1.8.1

