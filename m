From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH] Monitor: do not move partitions to external container
Date: Fri, 3 Dec 2010 23:13:48 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010C173482@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

From de798c689a31f939aca41ef4d21199525d581fe8 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 3 Dec 2010 15:23:41 +0100
Subject: [PATCH] Monitor: do not move partitions to external container
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

Since we are allowing moving spares between different metadata arrays
we need to ensure that external metadata array does not get a partition for a spare.
Arrays on partitions are not supported for external metadata
so do not take such spare from a native array.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |    4 ++++
 mdadm.h   |    1 +
 util.c    |   13 +++++++++++++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 61550ee..f7de9ff 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -798,6 +798,10 @@ static dev_t choose_spare(struct state *from, struct state *to,
 		    from->devstate[d] == 0) {
 			struct dev_policy *pol;
 			unsigned long long dev_size;
+			
+			if (to->metadata->ss->external &&
+			    test_partition_from_id(from->devid[d]))
+				continue;
 
 			if (min_size &&
 			    dev_size_from_id(from->devid[d], &dev_size) &&
diff --git a/mdadm.h b/mdadm.h
index a0126eb..28d983d 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1073,6 +1073,7 @@ extern int ask(char *mesg);
 extern unsigned long long get_component_size(int fd);
 extern void remove_partitions(int fd);
 extern int test_partition(int fd);
+extern int test_partition_from_id(dev_t id);
 extern unsigned long long calc_array_size(int level, int raid_disks, int layout,
 				   int chunksize, unsigned long long devsize);
 extern int flush_metadata_updates(struct supertype *st);
diff --git a/util.c b/util.c
index 4b41e2b..070b58a 100644
--- a/util.c
+++ b/util.c
@@ -295,6 +295,19 @@ int test_partition(int fd)
 	return 1;
 }
 
+int test_partition_from_id(dev_t id)
+{
+	char buf[20];
+	int fd, rv;
+
+	sprintf(buf, "%d:%d", major(id), minor(id));
+	fd = dev_open(buf, O_RDONLY);
+	if (fd < 0)
+		return -1;
+	rv = test_partition(fd);
+	close(fd);
+	return rv;
+}
 
 int enough(int level, int raid_disks, int layout, int clean,
 	   char *avail, int avail_disks)
-- 
1.7.1

