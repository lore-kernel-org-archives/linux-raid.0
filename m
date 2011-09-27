From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 5/8] Move code to get_data_disks() function
Date: Tue, 27 Sep 2011 14:05:13 +0200
Message-ID: <20110927120513.4890.6242.stgit@gklab-128-013.igk.intel.com>
References: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Move code to function for code reuse.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm.h |    1 +
 util.c  |   10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 8f3e786..4bbf660 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1165,6 +1165,7 @@ extern unsigned long long get_component_size(int fd);
 extern void remove_partitions(int fd);
 extern int test_partition(int fd);
 extern int test_partition_from_id(dev_t id);
+extern int get_data_disks(int level, int layout, int raid_disks);
 extern unsigned long long calc_array_size(int level, int raid_disks, int layout,
 				   int chunksize, unsigned long long devsize);
 extern int flush_metadata_updates(struct supertype *st);
diff --git a/util.c b/util.c
index 0ea7e0d..50c98c1 100644
--- a/util.c
+++ b/util.c
@@ -703,6 +703,12 @@ void print_r10_layout(int layout)
 unsigned long long calc_array_size(int level, int raid_disks, int layout,
 				   int chunksize, unsigned long long devsize)
 {
+	devsize &= ~(unsigned long long)((chunksize>>9)-1);
+	return get_data_disks(level, layout, raid_disks) * devsize;
+}
+
+int get_data_disks(int level, int layout, int raid_disks)
+{
 	int data_disks = 0;
 	switch (level) {
 	case 0: data_disks = raid_disks; break;
@@ -713,8 +719,8 @@ unsigned long long calc_array_size(int level, int raid_disks, int layout,
 	case 10: data_disks = raid_disks / (layout & 255) / ((layout>>8)&255);
 		break;
 	}
-	devsize &= ~(unsigned long long)((chunksize>>9)-1);
-	return data_disks * devsize;
+
+	return data_disks;
 }
 
 #if !defined(MDASSEMBLE) || defined(MDASSEMBLE) && defined(MDASSEMBLE_AUTO)

