From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: resolve make everything compilation error
Date: Mon, 05 Dec 2011 13:08:16 +0100
Message-ID: <20111205120816.30466.14434.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When mdadm is compiled using e.g. 'everything' option, mdasseble
compilation is broken.

Change code to enable mdasseble compilation

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdassemble.c  |    2 +-
 super-intel.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mdassemble.c b/mdassemble.c
index 66e480a..f5bc746 100644
--- a/mdassemble.c
+++ b/mdassemble.c
@@ -85,7 +85,7 @@ int main(int argc, char *argv[]) {
 			rv |= Assemble(array_list->st, array_list->devname,
 				       array_list, NULL, NULL, 0,
 				       readonly, runstop, NULL, NULL, 0,
-				       verbose, force);
+				       verbose, force, 1);
 		}
 	return rv;
 }
diff --git a/super-intel.c b/super-intel.c
index a0672bf..82eba7b 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1014,12 +1014,12 @@ static unsigned long long min_acceptable_spare_size_imsm(struct supertype *st)
 	return rv * 512;
 }
 
+static int is_gen_migration(struct imsm_dev *dev);
+
 #ifndef MDASSEMBLE
 static __u64 blocks_per_migr_unit(struct intel_super *super,
 				  struct imsm_dev *dev);
 
-static int is_gen_migration(struct imsm_dev *dev);
-
 static void print_imsm_dev(struct intel_super *super,
 			   struct imsm_dev *dev,
 			   char *uuid,
@@ -5618,6 +5618,7 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 
 	return 0;
 }
+#endif /* MDASSEMBLE */
 
 static int is_gen_migration(struct imsm_dev *dev)
 {
@@ -5632,7 +5633,6 @@ static int is_gen_migration(struct imsm_dev *dev)
 
 	return 0;
 }
-#endif /* MDASSEMBLE */
 
 static int is_rebuilding(struct imsm_dev *dev)
 {

