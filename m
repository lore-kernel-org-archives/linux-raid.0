From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 01/19] mdadm/test: improve filtering r10 from raid1 in raidtype
Date: Fri,  2 Feb 2018 14:10:45 +0800
Message-ID: <1517551863-1511-2-git-send-email-zlliu@suse.com>
References: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 test | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test b/test
index 4ddef38..024cb63 100755
--- a/test
+++ b/test
@@ -183,7 +183,7 @@ parse_args() {
 				TESTLIST=($(ls $testdir | grep "linear"))
 				;;
 			raid1 )
-				TESTLIST=($(ls $testdir | grep "[0-9][0-9]r1\|raid1" | grep -vi raid10))
+				TESTLIST=($(ls $testdir | grep "[0-9][0-9]r1\|raid1" | grep -vi "r10\|raid10"))
 				;;
 			raid456 )
 				TESTLIST=($(ls $testdir | grep "[0-9][0-9]r[4-6]\|raid[4-6]"))
-- 
2.6.6

