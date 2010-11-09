From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 04/31] Treat feature as experimental
Date: Tue, 9 Nov 2010 17:00:48 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CA93@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Due to fact that IMSM Windows compatibility was not tested yet, feature has to be treated as experimental until compatibility verification will be performed.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/super-intel.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c index 5caa8fa..279eef2 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -194,6 +194,16 @@ struct bbm_log {
 static char *map_state_str[] = { "normal", "uninitialized", "degraded", "failed" };  #endif
 
+static inline int experimental(void)
+{
+#ifdef EXPERIMENTAL
+	return 1;
+#else
+	fprintf(stderr, Name "(IMSM): To use this feature EXPERIMENTAL compilation flag has to be used.\n");
+	return 0;
+#endif
+}
+
 static __u8 migr_type(struct imsm_dev *dev)  {
 	if (dev->vol.migr_type == MIGR_VERIFY && @@ -5781,6 +5791,13 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 	char buf[PATH_MAX];
 	char *devname = NULL;
 
+	dprintf("imsm: reshape_super called().\n");
+
+	if (experimental() == 0) {
+		dprintf("imsm: Error: Operation not supported without EXPERIMENTAL compilaton flag.\n");
+		return ret_val;
+	}
+
 	devname = devnum2devname(st->devnum);
 	if (devname == NULL) {
 		dprintf("imsm: Error: imsm_reshape_super(): cannot get device name.\n");

