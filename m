From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 2/2] mdassemble: split dietlibc logic into dedicated target
Date: Sun, 12 Aug 2012 15:24:16 -0400
Message-ID: <1344799457-2478-2-git-send-email-vapier@gentoo.org>
References: <1344799457-2478-1-git-send-email-vapier@gentoo.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1344799457-2478-1-git-send-email-vapier@gentoo.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This lets people run `make mdassemble` and get a sane build by default.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 .gitignore |    1 +
 Makefile   |    3 +++
 2 files changed, 4 insertions(+)

diff --git a/.gitignore b/.gitignore
index 7200741..fcbe069 100644
--- a/.gitignore
+++ b/.gitignore
@@ -4,6 +4,7 @@
 /mdadm
 /mdadm.8
 /mdadm.udeb
+/mdassemble
 /mdmon
 /swap_super
 /test_stripe
diff --git a/Makefile b/Makefile
index 704b374..72f609e 100644
--- a/Makefile
+++ b/Makefile
@@ -180,6 +180,9 @@ raid6check : raid6check.o mdadm.h $(CHECK_OBJS)
 	$(CC) $(CXFLAGS) $(LDFLAGS) -o raid6check raid6check.o $(CHECK_OBJS)
 
 mdassemble : $(ASSEMBLE_SRCS) $(INCL)
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(ASSEMBLE_FLAGS) -o mdassemble $(ASSEMBLE_SRCS)  $(STATICSRC)
+
+mdassemble.diet : $(ASSEMBLE_SRCS) $(INCL)
 	rm -f $(OBJS)
 	$(DIET_GCC) $(ASSEMBLE_FLAGS) -o mdassemble $(ASSEMBLE_SRCS)  $(STATICSRC)
 
-- 
1.7.9.7

