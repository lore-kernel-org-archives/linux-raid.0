From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 1/4] Monitor: devid should be dev_t
Date: Fri, 26 Nov 2010 18:24:43 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010C009E3A@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

From 42041aafe4cae9704dd65a572e4b3c459728ccb3 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 26 Nov 2010 12:49:33 +0100
Subject: [PATCH 1/4] Monitor: devid should be dev_t
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

For consistency with makedev().
int is not sufficient.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   14 +++++++-------
 mdadm.h   |    2 +-
 util.c    |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index f1d0c9d..beaaa55 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -44,7 +44,7 @@ struct state {
 	int active, working, failed, spare, raid;
 	int expected_spares;
 	int devstate[MaxDisks];
-	unsigned devid[MaxDisks];
+	dev_t devid[MaxDisks];
 	int percent;
 	int parent_dev; /* For subarray, devnum of parent.
 			 * For others, NoMdDev
@@ -705,7 +705,7 @@ unsigned long long min_spare_size_required(struct state *st)
 }
 
 static int move_spare(struct state *from, struct state *to,
-		      int devid,
+		      dev_t devid,
 		      struct alert_info *info)
 {
 	struct mddev_dev devlist;
@@ -774,11 +774,11 @@ static int check_donor(struct state *from, struct state *to,
 	return 1;
 }
 
-static int choose_spare(struct state *from, struct state *to,
+static dev_t choose_spare(struct state *from, struct state *to,
 			struct domainlist *domlist)
 {
 	int d;
-	int dev = 0;
+	dev_t dev = 0;
 	unsigned long long min_size
 		= min_spare_size_required(to);
 
@@ -805,7 +805,7 @@ static int choose_spare(struct state *from, struct state *to,
 	return dev;
 }
 
-static int container_choose_spare(struct state *from, struct state *to,
+static dev_t container_choose_spare(struct state *from, struct state *to,
 				  struct domainlist *domlist)
 {
 	/* This is similar to choose_spare, but we cannot trust devstate,
@@ -818,7 +818,7 @@ static int container_choose_spare(struct state *from, struct state *to,
 	struct mdinfo *disks, *d;
 	unsigned long long min_size
 		= min_spare_size_required(to);
-	int dev;
+	dev_t dev = 0;
 
 	if (fd < 0)
 		return 0;
@@ -888,7 +888,7 @@ static void try_spare_migration(struct state *statelist, struct alert_info *info
 				domain_add(&domlist, to->spare_group);
 
 			for (from=statelist ; from ; from=from->next) {
-				int devid;
+				dev_t devid;
 				if (!check_donor(from, to, domlist))
 					continue;
 				if (from->metadata->ss->external)
diff --git a/mdadm.h b/mdadm.h
index f9a53fe..48a202d 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -794,7 +794,7 @@ static inline struct supertype *guess_super(int fd) {
 extern struct supertype *dup_super(struct supertype *st);
 extern int get_dev_size(int fd, char *dname, unsigned long long *sizep);
 extern int must_be_container(int fd);
-extern int dev_size_from_id(unsigned id, unsigned long long *size);
+extern int dev_size_from_id(dev_t id, unsigned long long *size);
 extern void get_one_disk(int mdfd, mdu_array_info_t *ainf,
 			 mdu_disk_info_t *disk);
 void wait_for(char *dev, int fd);
diff --git a/util.c b/util.c
index 2a20644..fde58eb 100644
--- a/util.c
+++ b/util.c
@@ -1123,7 +1123,7 @@ struct supertype *super_by_fd(int fd, char **subarrayp)
 }
 #endif /* !defined(MDASSEMBLE) || defined(MDASSEMBLE) && defined(MDASSEMBLE_AUTO) */
 
-int dev_size_from_id(unsigned int id, unsigned long long *size)
+int dev_size_from_id(dev_t id, unsigned long long *size)
 {
 	char buf[20];
 	int fd;
-- 
1.7.1

