From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build warnings after merge of the moduleh tree
Date: Fri, 29 Jul 2011 15:25:48 +1000
Message-ID: <20110729152548.17e093cb01d95077a05d4cec@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

drivers/md/persistent-data/dm-block-manager.c:103:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-block-manager.c:103:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-block-manager.c:103:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-block-manager.c:109:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-block-manager.c:109:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-block-manager.c:109:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-block-manager.c:670:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-block-manager.c:670:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-block-manager.c:670:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-block-manager.c:692:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-block-manager.c:692:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-block-manager.c:692:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-block-manager.c:698:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-block-manager.c:698:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-block-manager.c:698:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-block-manager.c:816:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-block-manager.c:816:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-block-manager.c:816:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-block-manager.c:824:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-block-manager.c:824:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-block-manager.c:824:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-block-manager.c:881:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-block-manager.c:881:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-block-manager.c:881:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-block-manager.c:946:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-block-manager.c:946:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-block-manager.c:946:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-space-map-disk.c:634:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-space-map-disk.c:634:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-space-map-disk.c:634:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-space-map-disk.c:662:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-space-map-disk.c:662:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-space-map-disk.c:662:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-btree.c:146:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-btree.c:146:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-btree.c:146:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-btree.c:293:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-btree.c:293:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-btree.c:293:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-btree.c:301:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-btree.c:301:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-btree.c:301:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-btree.c:378:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-btree.c:378:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-btree.c:378:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-btree.c:756:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-btree.c:756:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-btree.c:756:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-btree.c:765:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-btree.c:765:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-btree.c:765:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-btree.c:801:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-btree.c:801:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-btree.c:801:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-btree.c:857:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-btree.c:857:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-btree.c:857:1: warning: parameter names (without types) in function declaration
drivers/md/persistent-data/dm-btree-remove.c:569:1: warning: data definition has no type or storage class
drivers/md/persistent-data/dm-btree-remove.c:569:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/md/persistent-data/dm-btree-remove.c:569:1: warning: parameter names (without types) in function declaration

I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 29 Jul 2011 15:16:04 +1000
Subject: [PATCH] include export.h to use EXPORT_SYMBOL

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/md/persistent-data/dm-block-manager.c  |    1 +
 drivers/md/persistent-data/dm-btree-remove.c   |    2 ++
 drivers/md/persistent-data/dm-btree.c          |    1 +
 drivers/md/persistent-data/dm-space-map-disk.c |    1 +
 4 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 4ec480c..7b8e84c 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -9,6 +9,7 @@
 #include <linux/dm-io.h>
 #include <linux/slab.h>
 #include <linux/device-mapper.h>
+#include <linux/export.h>
 
 #define DM_MSG_PREFIX "block manager"
 
diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index 72c9705..e7071f6 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -8,6 +8,8 @@
 #include "dm-btree-internal.h"
 #include "dm-transaction-manager.h"
 
+#include <linux/export.h>
+
 /*
  * Removing an entry from a btree
  * ==============================
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 55b8bf3..7cad5e8 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -9,6 +9,7 @@
 #include "dm-transaction-manager.h"
 
 #include <linux/device-mapper.h>
+#include <linux/export.h>
 
 #define DM_MSG_PREFIX "btree"
 
diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
index de31096..26e6e19 100644
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/bitops.h>
 #include <linux/device-mapper.h>
+#include <linux/export.h>
 
 #define DM_MSG_PREFIX "space map disk"
 
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
