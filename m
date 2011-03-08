From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 04/14] Some guid manipulation utilities has been added.
Date: Tue, 8 Mar 2011 15:20:45 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEC8D@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

From d2fb127f9af0de29f763d3813f58455c588f26eb Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Tue, 8 Mar 2011 13:41:09 +0100
Subject: [PATCH 04/14] Some guid manipulation utilities has been added.

It will be used for reading efi variables with capabilities.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 platform-intel.c |    9 +++++++++
 platform-intel.h |   15 +++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 95e3a1a..31d76f1 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -294,6 +294,15 @@ static const struct imsm_orom *find_imsm_hba_orom(enum sys_dev_type hba_id)
 	return NULL;
 }
 
+#define GUID_STR_MAX	37  /* according to GUID format: 
+			     * xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" */
+
+#define EFI_GUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7) \
+((struct efi_guid) \
+{{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
+  (b) & 0xff, ((b) >> 8) & 0xff, \
+  (c) & 0xff, ((c) >> 8) & 0xff, \
+  (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
 
 /* 
  * backward interface compatibility 
diff --git a/platform-intel.h b/platform-intel.h
index 549ced5..0cba6c7 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -197,6 +197,21 @@ struct sys_dev {
 	struct sys_dev *next;
 };
 
+struct efi_guid {
+	__u8 b[16];
+};
+
+static inline char *guid_str(char *buf, struct efi_guid guid)
+{
+	sprintf(buf, "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
+		     "%02x%02x-%02x%02x%02x%02x%02x%02x",
+		 guid.b[3], guid.b[2], guid.b[1], guid.b[0],
+		 guid.b[5], guid.b[4], guid.b[7], guid.b[6],
+		 guid.b[8], guid.b[9], guid.b[10], guid.b[11],
+		 guid.b[12], guid.b[13], guid.b[14], guid.b[15]);
+	return buf;
+}
+
 char *diskfd_to_devpath(int fd);
 struct sys_dev *find_driver_devices(const char *bus, const char *driver);
 struct sys_dev *find_intel_devices(void);
-- 
1.6.4.2

