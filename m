From: Lightweight patch manager <patch@luckynet.dynu.com>
Subject: [PATCH][2.5] new list macros for md (7 occ)
Date: Sun, 9 Jun 2002 08:39:29 -0600 (MDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0206090837000.26112-100000@hawkeye.luckynet.adm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This uses the new list macros (list_move*, list_del_init) for the multiple 
devices driver

diff -Nur linus-2.5/drivers/md/lvm-snap.c thunder-2.5/drivers/md/lvm-snap.c
--- linus-2.5/drivers/md/lvm-snap.c	Sun Jun  9 04:14:24 2002
+++ thunder-2.5/drivers/md/lvm-snap.c	Sun Jun  9 05:43:25 2002
@@ -109,11 +109,9 @@
 		    kdev_same(exception->rdev_org, org_dev))
 		{
 			if (i)
-			{
 				/* fun, isn't it? :) */
-				list_del(next);
-				list_add(next, hash_table);
-			}
+				list_move(next, hash_table);
+
 			ret = exception;
 			break;
 		}
diff -Nur linus-2.5/drivers/md/md.c thunder-2.5/drivers/md/md.c
--- linus-2.5/drivers/md/md.c	Sun Jun  9 04:14:25 2002
+++ thunder-2.5/drivers/md/md.c	Sun Jun  9 05:42:52 2002
@@ -626,8 +626,7 @@
 		MD_BUG();
 		return;
 	}
-	list_del(&rdev->same_set);
-	INIT_LIST_HEAD(&rdev->same_set);
+	list_del_init(&rdev->same_set);
 	rdev->mddev->nb_dev--;
 	printk(KERN_INFO "md: unbind<%s,%d>\n", partition_name(rdev->dev),
 						 rdev->mddev->nb_dev);
@@ -680,13 +679,12 @@
 		MD_BUG();
 	unlock_rdev(rdev);
 	free_disk_sb(rdev);
-	list_del(&rdev->all);
-	INIT_LIST_HEAD(&rdev->all);
+	list_del_init(&rdev->all);
+
 	if (rdev->pending.next != &rdev->pending) {
 		printk(KERN_INFO "md: (%s was pending)\n",
 			partition_name(rdev->dev));
-		list_del(&rdev->pending);
-		INIT_LIST_HEAD(&rdev->pending);
+		list_del_init(&rdev->pending);
 	}
 #ifndef MODULE
 	md_autodetect_dev(rdev->dev);
@@ -745,8 +743,7 @@
 		schedule();
 
 	del_mddev_mapping(mddev, mk_kdev(MD_MAJOR, mdidx(mddev)));
-	list_del(&mddev->all_mddevs);
-	INIT_LIST_HEAD(&mddev->all_mddevs);
+	list_del_init(&mddev->all_mddevs);
 	kfree(mddev);
 	MOD_DEC_USE_COUNT;
 }
@@ -1935,8 +1932,7 @@
 					continue;
 				}
 				printk(KERN_INFO "md:  adding %s ...\n", partition_name(rdev->dev));
-				list_del(&rdev->pending);
-				list_add(&rdev->pending, &candidates);
+				list_move(&rdev->pending, &candidates);
 			}
 		}
 		/*
@@ -1963,8 +1959,7 @@
 		printk(KERN_INFO "md: created md%d\n", mdidx(mddev));
 		ITERATE_RDEV_GENERIC(candidates,pending,rdev,tmp) {
 			bind_rdev_to_array(rdev, mddev);
-			list_del(&rdev->pending);
-			INIT_LIST_HEAD(&rdev->pending);
+			list_del_init(&rdev->pending);
 		}
 		autorun_array(mddev);
 	}

-- 
Lightweight patch manager using pine. If you have any objections, tell me.

