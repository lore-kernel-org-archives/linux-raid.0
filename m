From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 03/14] FIX: Do not unblock array accidentally
Date: Fri, 16 Sep 2011 13:54:09 +0200
Message-ID: <20110916115409.5201.37690.stgit@gklab-128-013.igk.intel.com>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

When sysfs_set_array() function is called, it tests if array
can be configured using sysfs. Setting metadata_version entry
can accidentally unblock mdmon when array is under reshape.
To avoid this, blocking character '-' is checked and if is is set,
it is used for array test.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 sysfs.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/sysfs.c b/sysfs.c
index 2146264..903202d 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -541,7 +541,17 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 	ver[0] = 0;
 	if (info->array.major_version == -1 &&
 	    info->array.minor_version == -2) {
+		char buf[1024];
 		strcat(strcpy(ver, "external:"), info->text_version);
+		if (sysfs_get_str(info, NULL, "metadata_version",
+						  buf, 1024) > 0) {
+			/* Testing string should not affect
+			 * monitor blocking functionality
+			 * Set blocking character if present in sysfs already
+			 */
+			if (buf[9] == '-')
+				ver[9] = '-';
+		}
 
 		if ((vers % 100) < 2 ||
 		    sysfs_set_str(info, NULL, "metadata_version",

