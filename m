From: mwilck@arcor.de
Subject: [PATCH 28/39] test/10-ddf-create: fix comments
Date: Mon,  8 Jul 2013 23:50:37 +0200
Message-ID: <1373320248-7520-2-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Comments should reflect the changes in the script.
---
 tests/10ddf-create |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tests/10ddf-create b/tests/10ddf-create
index 6f1f51d..be3f3c3 100644
--- a/tests/10ddf-create
+++ b/tests/10ddf-create
@@ -2,7 +2,8 @@
 # Test basic DDF functionality.
 #
 # Create a container with 5 drives
-# create a small raid0 across them all, then a 2disk raid1
+# create a small raid0 across them all, 
+# then a small raid10 using 4 drives, then a 2disk raid1
 # and a 3disk raid5 using the remaining space
 #
 # add some data, tear down the array, reassemble
-- 
1.7.1
