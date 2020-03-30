From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH v2] md/raid0: add config parameters to specify zone layout
Date: Mon, 30 Mar 2020 12:00:45 -0400
Message-ID: <1585584045-11263-1-git-send-email-jbaron@akamai.com>
References: <d8433599-cd4f-80a1-d9f7-8ddad1693850@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d8433599-cd4f-80a1-d9f7-8ddad1693850@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: rdunlap@infradead.org, songliubraving@fb.com
Cc: neilb@suse.de, guoqing.jiang@cloud.ionos.com, agk@redhat.com, snitzer@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Let's add some CONFIG_* options to directly configure the raid0 layout
if you know in advance how your raid0 array was created. This can be
simpler than having to manage module or kernel command-line parameters.

If the raid0 array was created by a pre-3.14 kernel, use
RAID0_ORIG_LAYOUT. If the raid0 array was created by a 3.14 or newer
kernel then select RAID0_ALT_MULTIZONE_LAYOUT. Otherwise, the default
setting is RAID0_LAYOUT_NONE, in which case the current behavior of
needing to specify a module parameter raid0.default_layout=1|2 is
preserved.

Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
Changes in v2:
- Cleaned up text (Randy Dunlap)

 drivers/md/Kconfig | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid0.c |  7 +++++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index d6d5ab2..cf6baa1 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -79,6 +79,61 @@ config MD_RAID0
 
 	  If unsure, say Y.
 
+choice
+	prompt "RAID0 Layout"
+	default RAID0_LAYOUT_NONE
+	depends on MD_RAID0
+	help
+	  A change was made in Linux 3.14 that unintentionally changed the
+	  the layout for RAID0. This can result in data corruption if a pre-3.14
+	  and a 3.14 or later kernel both wrote to the array. However, if the
+	  devices in the array are all of the same size then the layout would
+	  have been unaffected by this change, and there is no risk of data
+	  corruption from this issue.
+
+	  Unfortunately, the layout can not be determined by the kernel. If the
+	  array has only been written to by a 3.14 or later kernel it's safe to
+	  set RAID0_ALT_MULTIZONE_LAYOUT. If it has only been written to by a
+	  pre-3.14 kernel it's safe to select RAID0_ORIG_LAYOUT. If it has been
+	  written by both then select RAID0_LAYOUT_NONE, which will not
+	  configure the array. The array can then be examined for corruption.
+
+	  For new arrays you may choose either layout version. Neither version
+	  is inherently better than the other.
+
+	  Alternatively, these parameters can also be specified via the module
+	  parameter raid0.default_layout=<N>. N=2 selects the 'new' or multizone
+	  layout, while N=1 selects the 'old' layout or original layout. If
+	  unset the array will not be configured.
+
+	  The layout can also be written directly to the raid0 array via the
+	  mdadm command, which can be auto-detected by the kernel. See:
+	  <https://www.kernel.org/doc/html/latest/admin-guide/md.html#multi-zone-raid0-layout-migration>
+
+config RAID0_ORIG_LAYOUT
+	bool "raid0 layout for arrays only written to by a pre-3.14 kernel"
+	help
+	  If the raid0 array was only created and written to by a pre-3.14 kernel.
+
+config RAID0_ALT_MULTIZONE_LAYOUT
+	bool "raid0 layout for arrays only written to by a 3.14 or newer kernel"
+	help
+	  If the raid0 array was only created and written to by a 3.14 or later
+	  kernel.
+
+config RAID0_LAYOUT_NONE
+	bool "raid0 layout must be specified via a module parameter"
+	help
+	  If a raid0 array was written to by both a pre-3.14 and a 3.14 or
+	  later kernel, you may have data corruption. This option will not
+	  auto configure the array and thus you can examine the array offline
+	  to determine the best way to proceed. With RAID0_LAYOUT_NONE
+	  set, the choice for raid0 layout can be set via a module parameter
+	  raid0.default_layout=<N>. Or the layout can be written directly
+	  to the raid0 array via the mdadm command.
+
+endchoice
+
 config MD_RAID1
 	tristate "RAID-1 (mirroring) mode"
 	depends on BLK_DEV_MD
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 322386f..576eaa6 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -19,7 +19,14 @@
 #include "raid0.h"
 #include "raid5.h"
 
+#if defined(CONFIG_RAID0_ORIG_LAYOUT)
+static int default_layout = RAID0_ORIG_LAYOUT;
+#elif defined(CONFIG_RAID0_ALT_MULTIZONE_LAYOUT)
+static int default_layout = RAID0_ALT_MULTIZONE_LAYOUT;
+#else
 static int default_layout = 0;
+#endif
+
 module_param(default_layout, int, 0644);
 
 #define UNSUPPORTED_MDDEV_FLAGS		\
-- 
2.7.4
