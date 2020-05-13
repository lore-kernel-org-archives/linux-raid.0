From: Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>
Subject: [PATCH] Makefile: add LABEL support
Date: Wed, 13 May 2020 13:00:36 +0200
Message-ID: <20200513110036.19724-1-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Add optional LABEL parameter to Makefile and allow to mark version
by user friendly label. It might be useful when creating custom
spins of mdadm, or labeling some instance in between major releases.

Signed-off-by: Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>
---
 Makefile | 3 ++-
 ReadMe.c | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index a33319a8..9c129c54 100644
--- a/Makefile
+++ b/Makefile
@@ -105,7 +105,8 @@ VERSION = $(shell [ -d .git ] && git describe HEAD | sed 's/mdadm-//')
 VERS_DATE = $(shell [ -d .git ] && date --iso-8601 --date="`git log -n1 --format=format:%cd --date=iso --date=short`")
 DVERS = $(if $(VERSION),-DVERSION=\"$(VERSION)\",)
 DDATE = $(if $(VERS_DATE),-DVERS_DATE="\"$(VERS_DATE)\"",)
-CFLAGS += $(DVERS) $(DDATE)
+DLABEL = $(if $(LABEL),-DLABEL="\" - $(LABEL)\"",)
+CFLAGS += $(DVERS) $(DDATE) $(DLABEL)
 
 # The glibc TLS ABI requires applications that call clone(2) to set up
 # TLS data structures, use pthreads until mdmon implements this support
diff --git a/ReadMe.c b/ReadMe.c
index eaf10423..883136df 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -33,7 +33,10 @@
 #ifndef VERS_DATE
 #define VERS_DATE "2018-10-01"
 #endif
-char Version[] = "mdadm - v" VERSION " - " VERS_DATE "\n";
+#ifndef LABEL
+#define LABEL ""
+#endif
+char Version[] = "mdadm - v" VERSION " - " VERS_DATE LABEL "\n";
 
 /*
  * File: ReadMe.c
-- 
2.25.0
