From: Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>
Subject: [PATCH, v2] Makefile: add EXTRAVERSION support
Date: Fri, 15 May 2020 11:23:14 +0200
Message-ID: <20200515092314.2711-1-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Add optional EXTRAVERSION parameter to Makefile and allow to mark version
by user friendly label. It might be useful when creating custom
spins of mdadm, or labeling some instance in between major releases.

Signed-off-by: Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>
---

V2: rename LABEL to EXTRAVERSION.

 Makefile | 3 ++-
 ReadMe.c | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index a33319a8..0a20b758 100644
--- a/Makefile
+++ b/Makefile
@@ -105,7 +105,8 @@ VERSION = $(shell [ -d .git ] && git describe HEAD | sed 's/mdadm-//')
 VERS_DATE = $(shell [ -d .git ] && date --iso-8601 --date="`git log -n1 --format=format:%cd --date=iso --date=short`")
 DVERS = $(if $(VERSION),-DVERSION=\"$(VERSION)\",)
 DDATE = $(if $(VERS_DATE),-DVERS_DATE="\"$(VERS_DATE)\"",)
-CFLAGS += $(DVERS) $(DDATE)
+DEXTRAVERSION = $(if $(EXTRAVERSION),-DEXTRAVERSION="\" - $(EXTRAVERSION)\"",)
+CFLAGS += $(DVERS) $(DDATE) $(DEXTRAVERSION)
 
 # The glibc TLS ABI requires applications that call clone(2) to set up
 # TLS data structures, use pthreads until mdmon implements this support
diff --git a/ReadMe.c b/ReadMe.c
index eaf10423..06b8f7ee 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -33,7 +33,10 @@
 #ifndef VERS_DATE
 #define VERS_DATE "2018-10-01"
 #endif
-char Version[] = "mdadm - v" VERSION " - " VERS_DATE "\n";
+#ifndef EXTRAVERSION
+#define EXTRAVERSION ""
+#endif
+char Version[] = "mdadm - v" VERSION " - " VERS_DATE EXTRAVERSION "\n";
 
 /*
  * File: ReadMe.c
-- 
2.25.0
