From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 3/7] bcache: drop select COMPACTION
Date: Fri, 11 May 2012 12:46:26 -0700
Message-ID: <20120511194626.25770.91068.stgit@dwillia2-linux.jf.intel.com>
References: <20120511194327.25770.79292.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120511194327.25770.79292.stgit-p8uTFz9XbKgaePuBGzJMJzMJUdESFZ8XQQ4Iyu8u01E@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: neilb-l3A5Bk7waGM@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

It's not a build dependency, although it may be strongly recommended.

Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/block/bcache/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/bcache/Kconfig b/drivers/block/bcache/Kconfig
index 019f133..9acd870 100644
--- a/drivers/block/bcache/Kconfig
+++ b/drivers/block/bcache/Kconfig
@@ -1,7 +1,6 @@
 
 config BCACHE
 	tristate "Block device as cache"
-	select COMPACTION
 	select CLOSURES
 	---help---
 	Allows a block device to be used as cache for other devices; uses
