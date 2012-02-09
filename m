From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: Add missed '0' case for reshape position verification
Date: Thu, 09 Feb 2012 10:09:03 +0100
Message-ID: <20120209090903.5288.26129.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

Reading sysfs entry that is '0' long should cause an error.
Reshape position cannot be empty.

Absence of reshape position should be ignored. It is possible
that we are about raid0 reshape continuation and it is before takeover.
This means that according metadata (changed by mdmon) it should be reshaped
but md knows nothing about it at this moment. Reshape continuation
in reshape_array() will change it to raid4 and reshape position appears
in sysfs.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index e295a5f..1da5ea3 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1874,11 +1874,14 @@ release:
 */
 static int verify_reshape_position(struct mdinfo *info, int level)
 {
-	int ret_val = 0;
+	int ret_val;
 	char buf[40];
+	int rv;
 
 	/* read sync_max, failure can mean raid0 array */
-	if (sysfs_get_str(info, NULL, "sync_max", buf, 40) > 0) {
+	rv = sysfs_get_str(info, NULL, "sync_max", buf, 40);
+
+	if (rv > 0) {
 		char *ep;
 		unsigned long long position = strtoull(buf, &ep, 0);
 
@@ -1906,6 +1909,11 @@ static int verify_reshape_position(struct mdinfo *info, int level)
 				ret_val = 1;
 			}
 		}
+	} else if (rv == 0) {
+		/* for valid sysfs entry, 0-length content
+		 * should be indicated as error
+		 */
+		ret_val = -1;
 	}
 
 	return ret_val;

