From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2 07/12] md: mddev_find_container helper function
Date: Mon,  5 Dec 2016 16:31:08 +0100
Message-ID: <20161205153113.7268-8-artur.paszkiewicz@intel.com>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This allows finding the parent container of a subarray for external
metadata arrays.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/md.c | 37 +++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |  3 +++
 2 files changed, 40 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7028d54..5a14f8e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -595,6 +595,43 @@ static struct mddev *mddev_find(dev_t unit)
 	goto retry;
 }
 
+struct mddev *mddev_find_container(struct mddev *subarray)
+{
+	struct mddev *mddev, *ret = NULL;
+	char *container_name;
+	int len = 0;
+	int i;
+
+	if (!subarray->external)
+		return NULL;
+
+	container_name = subarray->metadata_type + 1;
+	i = 0;
+	while (container_name[i]) {
+		if (container_name[i] == '/') {
+			len = i;
+			break;
+		}
+		i++;
+	}
+	if (len == 0)
+		return NULL;
+
+	spin_lock(&all_mddevs_lock);
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
+		char *name = mdname(mddev);
+		if (strlen(name) == len &&
+				strncmp(name, container_name, len) == 0) {
+			ret = mddev;
+			break;
+		}
+	}
+	spin_unlock(&all_mddevs_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mddev_find_container);
+
 static struct attribute_group md_redundancy_group;
 
 void mddev_unlock(struct mddev *mddev)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d1e56f8..ca0b68f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -711,4 +711,7 @@ static inline int mddev_is_clustered(struct mddev *mddev)
 {
 	return mddev->cluster_info && mddev->bitmap_info.nodes > 1;
 }
+
+extern struct mddev *mddev_find_container(struct mddev *subarray);
+
 #endif /* _MD_MD_H */
-- 
2.10.1

