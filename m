From: Gilles Espinasse <g.esp@free.fr>
Subject: [PATCH 2/3] Allow escape by ctrl-c broken by --no-error change
Date: Sat, 20 Oct 2012 18:03:51 +0200
Message-ID: <1350749031-5482-1-git-send-email-g.esp@free.fr>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: Gilles Espinasse <g.esp@free.fr>
List-Id: linux-raid.ids

Signed-off-by: Gilles Espinasse <g.esp@free.fr>
---
 test |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/test b/test
index 2bb482c..8339d06 100755
--- a/test
+++ b/test
@@ -68,8 +68,13 @@ cleanup() {
 	done
 }
 
+ctrl-c() {
+	exitonerror=1
+}
+
 do_setup() {
-  trap cleanup 0 1 2 3 15
+  trap cleanup 0 1 3 15
+  trap ctrl-c 2
 
   devlist=
   for d in 0 1 2 3 4 5 6 7 8 9 10 11 12
-- 
1.7.2.5

