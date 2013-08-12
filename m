From: Shaohua Li <shli@kernel.org>
Subject: [patch 1/3] raid5: rename stripe_hash()
Date: Mon, 12 Aug 2013 10:24:35 +0800
Message-ID: <20130812022529.570639835@kernel.org>
References: <20130812022434.507702228@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-rename-function.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, djbw@fb.com
List-Id: linux-raid.ids

Rename the function, since I'll introduce another hash.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-08-12 10:01:00.317008594 +0800
+++ linux/drivers/md/raid5.c	2013-08-12 10:02:14.780071212 +0800
@@ -79,7 +79,8 @@ static struct workqueue_struct *raid5_wq
 #define HASH_MASK		(NR_HASH - 1)
 #define MAX_STRIPE_BATCH	8
 
-static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector_t sect)
+static inline struct hlist_head *stripe_hash_list(struct r5conf *conf,
+						sector_t sect)
 {
 	int hash = (sect >> STRIPE_SHIFT) & HASH_MASK;
 	return &conf->stripe_hashtbl[hash];
@@ -356,7 +357,7 @@ static inline void remove_hash(struct st
 
 static inline void insert_hash(struct r5conf *conf, struct stripe_head *sh)
 {
-	struct hlist_head *hp = stripe_hash(conf, sh->sector);
+	struct hlist_head *hp = stripe_hash_list(conf, sh->sector);
 
 	pr_debug("insert_hash(), stripe %llu\n",
 		(unsigned long long)sh->sector);
@@ -462,7 +463,7 @@ static struct stripe_head *__find_stripe
 	struct stripe_head *sh;
 
 	pr_debug("__find_stripe, sector %llu\n", (unsigned long long)sector);
-	hlist_for_each_entry(sh, stripe_hash(conf, sector), hash)
+	hlist_for_each_entry(sh, stripe_hash_list(conf, sector), hash)
 		if (sh->sector == sector && sh->generation == generation)
 			return sh;
 	pr_debug("__stripe %llu not in cache\n", (unsigned long long)sector);

