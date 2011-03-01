From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/7] Add block_subarray()
Date: Tue, 01 Mar 2011 15:57:15 +0100
Message-ID: <20110301145715.10678.25012.stgit@gklab-128-013.igk.intel.com>
References: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Put code for blocking subarray in to separate function.
This little code/function will be used for blocking arrays from mdmon
monitoring during assembly process. Arrays cannot wait for container
assembly finish, because meanwhile monitor can enable arrays for writing.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 msg.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/msg.c b/msg.c
index 76e74e7..ce2ce00 100644
--- a/msg.c
+++ b/msg.c
@@ -255,6 +255,18 @@ static int unblock_subarray(struct mdinfo *sra, const int unfreeze)
 	return rc;
 }
 
+int block_subarray(struct mdinfo *sra)
+{
+	char buf[64];
+	int rc = 0;
+
+	sprintf(buf, "external:%s\n", sra->text_version);
+	buf[9] = '-';
+	if (sysfs_set_str(sra, NULL, "metadata_version", buf))
+		rc = -1;
+
+	return rc;
+}
 /**
  * block_monitor - prevent mdmon spare assignment
  * @container - container to block
@@ -334,9 +346,7 @@ int block_monitor(char *container, const int freeze)
 		 * takeover in reshape case and spare reassignment in the
 		 * auto-rebuild case)
 		 */
-		sprintf(buf, "external:%s\n", sra->text_version);
-		buf[9] = '-';
-		if (sysfs_set_str(sra, NULL, "metadata_version", buf))
+		if (block_subarray(sra))
 			break;
 		ping_monitor(container);
 

