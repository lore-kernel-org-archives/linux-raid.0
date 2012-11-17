From: Gilles Espinasse <g.esp@free.fr>
Subject: [PATCH] Fix recommended test command
Date: Sat, 17 Nov 2012 13:37:53 +0100
Message-ID: <1353155873-28770-1-git-send-email-g.esp@free.fr>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: Gilles Espinasse <g.esp@free.fr>
List-Id: linux-raid.ids

Signed-off-by: Gilles Espinasse <g.esp@free.fr>

Recommended 'sh ./test' fail with
LANG=C sudo sh ./test
./test: line 73: `ctrl-c': not a valid identifier

Replace '-' by '_' in the ctrl-c function name fix that.
In the same time, update the recommended command to 'bash ./test' to match the shebang
---
 Makefile |    2 +-
 test     |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index d99ea2b..94229fa 100644
--- a/Makefile
+++ b/Makefile
@@ -268,7 +268,7 @@ uninstall:
 	rm -f $(DESTDIR)$(MAN8DIR)/mdadm.8 $(DESTDIR)$(MAN8DIR)/mdmon.8 $(DESTDIR)$(MAN4DIR)/md.4 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5 $(DESTDIR)$(BINDIR)/mdadm
 
 test: mdadm mdmon test_stripe swap_super
-	@echo "Please run 'sh ./test' as root"
+	@echo "Please run 'bash ./test' as root"
 
 clean : 
 	rm -f mdadm mdmon $(OBJS) $(MON_OBJS) $(STATICOBJS) core *.man \
diff --git a/test b/test
index 3f8515f..a3c2a24 100755
--- a/test
+++ b/test
@@ -68,13 +68,13 @@ cleanup() {
 	done
 }
 
-ctrl-c() {
+ctrl_c() {
 	exitonerror=1
 }
 
 do_setup() {
   trap cleanup 0 1 3 15
-  trap ctrl-c 2
+  trap ctrl_c 2
 
   devlist=
   for d in 0 1 2 3 4 5 6 7 8 9 10 11 12
-- 
1.7.2.5

