From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 20/22] md: revise Kconfig help for MD_MULTIPATH
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.72402.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Oren Held <orenhe@il.ibm.com>
List-Id: linux-raid.ids

Make it clear in the config message that MD_MULTIPATH is not under
active development.

Cc: Oren Held <orenhe@il.ibm.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/Kconfig |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 2158377..acb3a4e 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -185,11 +185,10 @@ config MD_MULTIPATH
 	tristate "Multipath I/O support"
 	depends on BLK_DEV_MD
 	help
-	  Multipath-IO is the ability of certain devices to address the same
-	  physical disk over multiple 'IO paths'. The code ensures that such
-	  paths can be defined and handled at runtime, and ensures that a
-	  transparent failover to the backup path(s) happens if a IO errors
-	  arrives on the primary path.
+	  MD_MULTIPATH provides a simple multi-path personality for use
+	  the MD framework.  It is not under active development.  New
+	  projects should consider using DM_MULTIPATH which has more
+	  features and more testing.
 
 	  If unsure, say N.
 


