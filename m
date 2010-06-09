From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 23/23] imsm: Treat expansion as experimental feature
Date: Wed, 9 Jun 2010 15:45:03 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11EECE900@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

(Online Capacity Expansion for IMSM)
To use Online Capacity Expansion with IMSM's metadata mdadm has to be compiled with EXPERIMENTAL flag.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c index db4055d..2cba6af 100644
--- a/super-intel.c
+++ b/super-intel.c
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
 	if (dev->vol.migr_type == MIGR_VERIFY && @@ -1751,6 +1761,11 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 		int len;
 		char *p;
 
+		if (experimental() == 0) {
+			dprintf("imsm: Error: Operation not supported (mdadm: update_grow_array)\n");
+			return 1;
+		}
+
 		/* prepare metadata update
 		*/
 

