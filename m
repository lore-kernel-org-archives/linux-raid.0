From: Gilles Espinasse <g.esp@free.fr>
Subject: [PATCH 3/3] Replace --no-error by --keep-going
Date: Sat, 20 Oct 2012 18:04:14 +0200
Message-ID: <1350749054-5519-1-git-send-email-g.esp@free.fr>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: Gilles Espinasse <g.esp@free.fr>
List-Id: linux-raid.ids

Signed-off-by: Gilles Espinasse <g.esp@free.fr>

Suggest to replace by the option name that 'make' use.
no error is only a developper hope.
---
 test |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/test b/test
index 8339d06..c5b1982 100755
--- a/test
+++ b/test
@@ -252,7 +252,7 @@ do_help() {
   echo "    --disable-multipath         Disable any tests involving multipath"
   echo "    --logdir=<directory>        Directory to save logfiles in"
   echo "    --save-logs                 Save all logs in <logdir>"
-  echo "    --no-error                  Don't stop on error, ie. run all tests"
+  echo "    --keep-going                Don't stop on error, ie. run all tests"
   echo "    setup                       Setup test environment and exit"
   echo "    cleanup                     Cleanup test environment"
   echo "    <prefix>                    Run tests with <prefix>"
@@ -289,7 +289,7 @@ parse_args() {
 	fi
       fi
       ;;
-    --no-error)
+    --keep-going)
       exitonerror=0
       ;;
     --disable-multipath)
-- 
1.7.2.5

