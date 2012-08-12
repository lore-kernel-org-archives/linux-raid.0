From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 1/2] fix handling of CPPFLAGS
Date: Sun, 12 Aug 2012 15:24:15 -0400
Message-ID: <1344799457-2478-1-git-send-email-vapier@gentoo.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The current Makefile ends up ignoring the system CPPFLAGS settings,
so make sure we append the variable.  Also, the old metadata logic
has a typo with the flag name.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Makefile |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 315455b..704b374 100644
--- a/Makefile
+++ b/Makefile
@@ -48,12 +48,10 @@ CWFLAGS += -Wp,-D_FORTIFY_SOURCE=2 -O
 endif
 
 ifdef DEBIAN
-CPPFLAGS := -DDEBIAN
-else
-CPPFLAGS :=
+CPPFLAGS += -DDEBIAN
 endif
 ifdef DEFAULT_OLD_METADATA
- CPPFLAG += -DDEFAULT_OLD_METADATA
+ CPPFLAGS += -DDEFAULT_OLD_METADATA
  DEFAULT_METADATA=0.90
 else
  DEFAULT_METADATA=1.2
-- 
1.7.9.7

