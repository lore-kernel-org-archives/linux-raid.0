From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 3 of 3 - Make ITERATE_MDDEV work on non-SMP
Date: Thu, 20 Jun 2002 10:07:12 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15633.7344.603781.403606@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org, Reuben Farrelly <reuben@reub.net>
List-Id: linux-raid.ids


For an SMP kernel, spin_lock() et.al. are functions.
For a UP kernel, they are statements that must be terminated
by a ';'.  This is not quite the same thing, and hence spin_lock()
cannot be using inside a parenthesised expession.

This patch changes ITERATE_MDDEV to use gcc's "statement expressions"
instead which has the benefit of making the conditionals
more readable.



 ----------- Diffstat output ------------
 ./drivers/md/md.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

--- ./drivers/md/md.c	2002/06/19 23:29:01	1.3
+++ ./drivers/md/md.c	2002/06/19 23:53:56	1.4
@@ -144,17 +144,17 @@
  */
 #define ITERATE_MDDEV(mddev,tmp)					\
 									\
-	for (spin_lock(&all_mddevs_lock), 				\
-		     (tmp = all_mddevs.next),				\
-		     (mddev = NULL);					\
-	     (void)(tmp != &all_mddevs &&				\
-			mddev_get(list_entry(tmp, mddev_t, all_mddevs))),\
-		     spin_unlock(&all_mddevs_lock),			\
-		     (mddev ? mddev_put(mddev):(void)NULL),		\
-		     (mddev = list_entry(tmp, mddev_t, all_mddevs)),	\
-		     (tmp != &all_mddevs);				\
-	     spin_lock(&all_mddevs_lock),				\
-		     (tmp = tmp->next)					\
+	for (({ spin_lock(&all_mddevs_lock); 				\
+		tmp = all_mddevs.next;					\
+		mddev = NULL;});					\
+	     ({ if (tmp != &all_mddevs)					\
+			mddev_get(list_entry(tmp, mddev_t, all_mddevs));\
+		spin_unlock(&all_mddevs_lock);				\
+		if (mddev) mddev_put(mddev);				\
+		mddev = list_entry(tmp, mddev_t, all_mddevs);		\
+		tmp != &all_mddevs;});					\
+	     ({ spin_lock(&all_mddevs_lock);				\
+		tmp = tmp->next;})					\
 		)
 
 static mddev_t *mddev_map[MAX_MD_DEVS];
