From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 4 - Fix module ref counting for md.
Date: Tue, 26 Aug 2003 09:26:05 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19rQir-0002Bm-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

4 assorted fixes and cleanups for md in 2.6.0-test4 - Thanks.

### Comments for ChangeSet

We don't need to explicitly count references as:
 - refcounting already happens for opens of /dev/md?
 -  when an array is active, a daughter module is loaded which
      locks "md" in.
We just need to make sure we clean up properly on unload. (export_array)

Also, xor needs a null module_exit so that it can be unloaded.

 ----------- Diffstat output ------------
 ./drivers/md/md.c  |    3 +--
 ./drivers/md/xor.c |    3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-08-24 07:03:43.000000000 +1000
+++ ./drivers/md/md.c	2003-08-24 08:07:12.000000000 +1000
@@ -179,7 +179,6 @@ static void mddev_put(mddev_t *mddev)
 		mddev_map[mdidx(mddev)] = NULL;
 		blk_put_queue(mddev->queue);
 		kfree(mddev);
-		MOD_DEC_USE_COUNT;
 	}
 	spin_unlock(&all_mddevs_lock);
 }
@@ -201,7 +200,6 @@ static mddev_t * mddev_find(int unit)
 		mddev_map[unit] = new;
 		list_add(&new->all_mddevs, &all_mddevs);
 		spin_unlock(&all_mddevs_lock);
-		MOD_INC_USE_COUNT;
 		return new;
 	}
 	spin_unlock(&all_mddevs_lock);
@@ -3590,6 +3588,7 @@ static __exit void md_exit(void)
 		if (!disks[i])
 			continue;
 		mddev = disk->private_data;
+		export_array(mddev);
 		del_gendisk(disk);
 		put_disk(disk);
 		mddev_put(mddev);

diff ./drivers/md/xor.c~current~ ./drivers/md/xor.c
--- ./drivers/md/xor.c~current~	2003-08-24 07:03:43.000000000 +1000
+++ ./drivers/md/xor.c	2003-08-24 08:07:12.000000000 +1000
@@ -134,7 +134,10 @@ calibrate_xor_block(void)
 	return 0;
 }
 
+static __exit void xor_exit(void) { }
+
 EXPORT_SYMBOL(xor_block);
 MODULE_LICENSE("GPL");
 
 module_init(calibrate_xor_block);
+module_exit(xor_exit);
