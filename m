From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 17/34] imsm: FIX: Fill sys_name in container_content()
Date: Tue, 04 Jan 2011 15:37:52 +0100
Message-ID: <20110104143752.6697.88374.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

If sys_name field is empty structures produced by container_content()
cannot be used for sysfs access.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index de3585e..f07665b 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4517,6 +4517,9 @@ static void update_recovery_start(struct imsm_dev *dev, struct mdinfo *array)
 	rebuild->recovery_start = units * blocks_per_migr_unit(dev);
 }
 
+static int imsm_find_array_minor_by_subdev(int subdev,
+					   int container,
+					   int *minor);
 
 static struct mdinfo *container_content_imsm(struct supertype *st, char *subarray)
 {
@@ -4545,6 +4548,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 		struct mdinfo *this;
 		int slot;
 		char *ep;
+		int minor;
 
 		if (subarray &&
 		    (i != strtoul(subarray, &ep, 10) || *ep != '\0'))
@@ -4575,6 +4579,14 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 
 		super->current_vol = i;
 		getinfo_super_imsm_volume(st, this, NULL);
+
+		if (imsm_find_array_minor_by_subdev(i,
+						    st->container_dev,
+						    &minor) >= 0) {
+			sprintf(this->sys_name, "md%i", minor);
+		}
+
+
 		for (slot = 0 ; slot <  map->num_members; slot++) {
 			unsigned long long recovery_start;
 			struct mdinfo *info_d;

