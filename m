From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 4/4] mdadm/test: Get rid of tests/check
Date: Wed, 19 Jul 2017 19:11:15 +0800
Message-ID: <1500462675-6463-5-git-send-email-zlliu@suse.com>
References: <1500462675-6463-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1500462675-6463-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

The tests/check is not useful due to check()
in 'test' has covered various checking.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 tests/check | 35 -----------------------------------
 1 file changed, 35 deletions(-)
 delete mode 100644 tests/check

diff --git a/tests/check b/tests/check
deleted file mode 100644
index f4ed6d5..0000000
--- a/tests/check
+++ /dev/null
@@ -1,35 +0,0 @@
-
-case $1 in
- raid* | linear )
-   grep -s "active $1 " /proc/mdstat > /dev/null || {
-		echo >&2 "ERROR active $1 not found" ; cat /proc/mdstat ; exit 1;}
-  ;;
- resync | recovery )
-   sleep 0.1
-   grep -s $1 /proc/mdstat > /dev/null || {
-		echo >&2 ERROR no $1 happening; cat /proc/mdstat; exit 1; }
-  ;;
-
-  nosync )
-    sleep 0.5
-    grep -s 're[synccovery]* =' > /dev/null /proc/mdstat && {
-		echo >&2 "ERROR resync or recovery is happening!"; cat /proc/mdstat ; exit 1; }
-  ;;
-
- wait )
-   sleep 0.1
-   while grep 're[synccovery]* =' > /dev/null /proc/mdstat
-   do sleep 2;
-   done
-   ;;
-
- state )
-    grep -s "blocks.*\[$2\]\$" /proc/mdstat > /dev/null || {
-		echo >&2 "ERROR state $2 not found!"; cat /proc/mdstat ; exit 1; }
-    sleep 0.5
-   ;;
-
- * ) echo >&2 ERROR unknown check $1 ; exit 1;
-esac
-
-exit 0
-- 
1.8.3.1

