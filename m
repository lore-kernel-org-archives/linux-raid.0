From: Jes.Sorensen@redhat.com
Subject: [PATCH] Fix --no-error in test script
Date: Tue, 29 May 2012 15:17:54 +0200
Message-ID: <1338297474-5256-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

b8e91a32cdaa2a6dea8b0dd54365ede33d5a9a60 was applied incorrectly.
It changed the name of the variable set when specifying --no-error,
without changing the places checking it.

Set it back as it was to make --no-error work correctly again.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 test |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test b/test
index 586e988..80e1915 100755
--- a/test
+++ b/test
@@ -284,7 +284,7 @@ parse_args() {
       fi
       ;;
     --no-error)
-      exit_on_error=0
+      exitonerror=0
       ;;
     --disable-multipath)
       unset MULTIPATH
-- 
1.7.10.2

