From: mwilck@arcor.de
Subject: [PATCH 6/6] mdmon: allow disabling "@dmon" command name at compile time
Date: Fri, 16 Aug 2013 20:22:00 +0200
Message-ID: <1376677320-12816-7-git-send-email-mwilck@arcor.de>
References: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

mdmon sets its command name to "@dmon" on distributions using systemd
to tell systemd not to kill it during shutdown.

Some older tools (e.g. the anaconda loader on RHEL6 during installation)
look specifically for "mdmon" and won't work with "@dmon". They can't be
fixed any more. So, this patch introduces the macro SYSTEMD to disable
changing the command name. Default is to assume that mdmon is started
by systemd.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 Makefile |    4 +++-
 mdmon.c  |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index e8da3a5..5970b90 100644
--- a/Makefile
+++ b/Makefile
@@ -77,11 +77,13 @@ MAP_PATH = $(MAP_DIR)/$(MAP_FILE)
 MDMON_DIR = $(RUN_DIR)
 # place for autoreplace cookies
 FAILED_SLOTS_DIR = $(RUN_DIR)/failed-slots
+# set SYSTEMD to 1 for distributions where mdmon is started by systemd
+SYSTEMD = 1
 SYSTEMD_DIR=/lib/systemd/system
 DIRFLAGS = -DMAP_DIR=\"$(MAP_DIR)\" -DMAP_FILE=\"$(MAP_FILE)\"
 DIRFLAGS += -DMDMON_DIR=\"$(MDMON_DIR)\"
 DIRFLAGS += -DFAILED_SLOTS_DIR=\"$(FAILED_SLOTS_DIR)\"
-CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(DIRFLAGS)
+CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(DIRFLAGS) -DSYSTEMD=$(SYSTEMD)
 
 VERSION = $(shell [ -d .git ] && git describe HEAD | sed 's/mdadm-//')
 VERS_DATE = $(shell [ -d .git ] && date --date="`git log -n1 --format=format:%cd --date=short`" '+%0dth %B %Y' | sed -e 's/1th/1st/' -e 's/2th/2nd/' -e 's/11st/11th/' -e 's/12nd/12th/')
diff --git a/mdmon.c b/mdmon.c
index f0b0623..132b469 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -298,6 +298,7 @@ int main(int argc, char *argv[])
 		{NULL, 0, NULL, 0}
 	};
 
+#if (SYSTEMD == 1)
 	if (in_initrd()) {
 		/*
 		 * set first char of argv[0] to @. This is used by
@@ -306,6 +307,7 @@ int main(int argc, char *argv[])
 		 */
 		argv[0][0] = '@';
 	}
+#endif
 
 	while ((opt = getopt_long(argc, argv, "thaF", options, NULL)) != -1) {
 		switch (opt) {
-- 
1.7.3.4
