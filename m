From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 19/22] md: add MODULE_DESCRIPTION for all md related
	modules.
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.39483.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Suggested by  Oren Held <orenhe@il.ibm.com>

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/faulty.c     |    1 +
 drivers/md/linear.c     |    1 +
 drivers/md/md.c         |    1 +
 drivers/md/multipath.c  |    1 +
 drivers/md/raid0.c      |    1 +
 drivers/md/raid1.c      |    1 +
 drivers/md/raid10.c     |    1 +
 drivers/md/raid5.c      |    1 +
 drivers/md/raid6algos.c |    1 +
 9 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 87d88db..713acd0 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -360,6 +360,7 @@ static void raid_exit(void)
 module_init(raid_init);
 module_exit(raid_exit);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Fault injection personality for MD");
 MODULE_ALIAS("md-personality-10"); /* faulty */
 MODULE_ALIAS("md-faulty");
 MODULE_ALIAS("md-level--5");
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 3b3f77c..00435bd 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -383,6 +383,7 @@ static void linear_exit (void)
 module_init(linear_init);
 module_exit(linear_exit);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Linear device concatenation personality for MD");
 MODULE_ALIAS("md-personality-1"); /* LINEAR - deprecated*/
 MODULE_ALIAS("md-linear");
 MODULE_ALIAS("md-level--1");
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0ebd6b6..5111587 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7159,5 +7159,6 @@ EXPORT_SYMBOL(md_unregister_thread);
 EXPORT_SYMBOL(md_wakeup_thread);
 EXPORT_SYMBOL(md_check_recovery);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("MD RAID framework");
 MODULE_ALIAS("md");
 MODULE_ALIAS_BLOCKDEV_MAJOR(MD_MAJOR);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index cbc0a99..32a662f 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -581,6 +581,7 @@ static void __exit multipath_exit (void)
 module_init(multipath_init);
 module_exit(multipath_exit);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("simple multi-path personality for MD");
 MODULE_ALIAS("md-personality-7"); /* MULTIPATH */
 MODULE_ALIAS("md-multipath");
 MODULE_ALIAS("md-level--4");
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 122d07a..77605cd 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -567,6 +567,7 @@ static void raid0_exit (void)
 module_init(raid0_init);
 module_exit(raid0_exit);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("RAID0 (striping) personality for MD");
 MODULE_ALIAS("md-personality-2"); /* RAID0 */
 MODULE_ALIAS("md-raid0");
 MODULE_ALIAS("md-level-0");
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index da017f0..2be48a4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2376,6 +2376,7 @@ static void raid_exit(void)
 module_init(raid_init);
 module_exit(raid_exit);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("RAID1 (mirroring) personality for MD");
 MODULE_ALIAS("md-personality-3"); /* RAID1 */
 MODULE_ALIAS("md-raid1");
 MODULE_ALIAS("md-level-1");
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5c71a46..d119b7b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2408,6 +2408,7 @@ static void raid_exit(void)
 module_init(raid_init);
 module_exit(raid_exit);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("RAID10 (striped mirror) personality for MD");
 MODULE_ALIAS("md-personality-9"); /* RAID10 */
 MODULE_ALIAS("md-raid10");
 MODULE_ALIAS("md-level-10");
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8c772b2..7d5808d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5893,6 +5893,7 @@ static void raid5_exit(void)
 module_init(raid5_init);
 module_exit(raid5_exit);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("RAID4/5/6 (striping with parity) personality for MD");
 MODULE_ALIAS("md-personality-4"); /* RAID5 */
 MODULE_ALIAS("md-raid5");
 MODULE_ALIAS("md-raid4");
diff --git a/drivers/md/raid6algos.c b/drivers/md/raid6algos.c
index 8ce102c..bffc61b 100644
--- a/drivers/md/raid6algos.c
+++ b/drivers/md/raid6algos.c
@@ -150,3 +150,4 @@ static void raid6_exit(void)
 subsys_initcall(raid6_select_algo);
 module_exit(raid6_exit);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("RAID6 Q-syndrome calculations");


