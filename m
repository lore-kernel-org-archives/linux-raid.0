Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F993EB64DC
	for <linux-raid@archiver.kernel.org>; Mon, 17 Jul 2023 13:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjGQNkn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 Jul 2023 09:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjGQNkl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 17 Jul 2023 09:40:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E256DA3
        for <linux-raid@vger.kernel.org>; Mon, 17 Jul 2023 06:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689601241; x=1721137241;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5ofqwanZpun13N/YztoZ4d0JnasdVTc9nFGNbCteiGc=;
  b=cbpT5zy3xqJa7mrta0dpVag27ZDC25nOnZ9ViIlJFrHPd792zgcDjUIG
   oSSxoCpXXE/pIG4KIC9r0y5UHrF/GlXXDtKDgWOlls2XiRxCwXW/Mh3UJ
   KJ2DbDoAIvTmfn4Ao4nMRzAO/8V8sSSi648UchRDcg6ygYZWfWvH5kjjP
   hib7oupqhES67XUbqk04X4R3FzMBc8bmubzqabsP5Jl7X6EhxE6LG40cz
   RzcTyFQEFIdfiPhvFZNDBNbOSn1jrL0H6UAfsOZYleTcCHQxB4ixjW8hR
   gcnNHKiU6Kjx4MbCfO4N9BiTKwC/wh42X/Ok4cTCgelhlJ3mwcv0iIb6n
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="350795420"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="350795420"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2023 06:40:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="813337610"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="813337610"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.104.85])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Jul 2023 06:40:39 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] Add compiler defenses flags
Date:   Mon, 17 Jul 2023 15:19:10 +0200
Message-Id: <20230717131910.22713-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It is essential to avoid buffer overflows and similar bugs as much as
possible.

According to Intel rules we are obligated to verify certain
compiler flags, so it will be much easier if they are added to the
Makefile.

Add gcc flags for prevention of buffer overflows, format string vulnerabilities,
stack protection to prevent stack overwrites and aslr enablement through -fPIE.
Also make the flags configurable.

The changes were verified on gcc versions 7.5, 8.3, 9.2, 10 and 12.2.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 Makefile | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
index 5eac1a4e..b3aa36f6 100644
--- a/Makefile
+++ b/Makefile
@@ -30,7 +30,7 @@
 
 # define "CXFLAGS" to give extra flags to CC.
 # e.g.  make CXFLAGS=-O to optimise
-CXFLAGS ?=-O2
+CXFLAGS ?=-O2 -D_FORTIFY_SOURCE=2
 TCC = tcc
 UCLIBC_GCC = $(shell for nm in i386-uclibc-linux-gcc i386-uclibc-gcc; do which $$nm > /dev/null && { echo $$nm ; exit; } ; done; echo false No uclibc found )
 #DIET_GCC = diet gcc
@@ -50,14 +50,30 @@ ifeq ($(origin CC),default)
 CC := $(CROSS_COMPILE)gcc
 endif
 CXFLAGS ?= -ggdb
-CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
+CWFLAGS ?= -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -Wformat -Wformat-security -Werror=format-security -fstack-protector-strong -fPIE -Warray-bounds
 ifdef WARN_UNUSED
-CWFLAGS += -Wp,-D_FORTIFY_SOURCE=2 -O3
+CWFLAGS += -Wp -O3
 endif
 
-FALLTHROUGH := $(shell gcc -v --help 2>&1 | grep "implicit-fallthrough" | wc -l)
-ifneq "$(FALLTHROUGH)"  "0"
-CWFLAGS += -Wimplicit-fallthrough=0
+ifeq ($(origin FALLTHROUGH), undefined)
+	FALLTHROUGH := $(shell gcc -Q --help=warnings 2>&1 | grep "implicit-fallthrough" | wc -l)
+	ifneq "$(FALLTHROUGH)"  "0"
+	CWFLAGS += -Wimplicit-fallthrough=0
+	endif
+endif
+
+ifeq ($(origin FORMATOVERFLOW), undefined)
+	FORMATOVERFLOW := $(shell gcc -Q --help=warnings 2>&1 | grep "format-overflow" | wc -l)
+	ifneq "$(FORMATOVERFLOW)"  "0"
+	CWFLAGS += -Wformat-overflow
+	endif
+endif
+
+ifeq ($(origin STRINGOPOVERFLOW), undefined)
+	STRINGOPOVERFLOW := $(shell gcc -Q --help=warnings 2>&1 | grep "stringop-overflow" | wc -l)
+	ifneq "$(STRINGOPOVERFLOW)"  "0"
+	CWFLAGS += -Wstringop-overflow
+	endif
 endif
 
 ifdef DEBIAN
@@ -116,10 +132,12 @@ CFLAGS += -DUSE_PTHREADS
 MON_LDFLAGS += -pthread
 endif
 
+LDFLAGS = -Wl,-z,now,-z,noexecstack
+
 # If you want a static binary, you might uncomment these
-# LDFLAGS = -static
+# LDFLAGS += -static
 # STRIP = -s
-LDLIBS = -ldl
+LDLIBS = -ldl -pie
 
 # To explicitly disable libudev, set -DNO_LIBUDEV in CXFLAGS
 ifeq (, $(findstring -DNO_LIBUDEV,  $(CXFLAGS)))
@@ -209,14 +227,13 @@ mdadm.Os : $(SRCS) $(INCL)
 	$(CC) -o mdadm.Os $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -DHAVE_STDINT_H -Os $(SRCS) $(LDLIBS)
 
 mdadm.O2 : $(SRCS) $(INCL) mdmon.O2
-	$(CC) -o mdadm.O2 $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -DHAVE_STDINT_H -O2 -D_FORTIFY_SOURCE=2 $(SRCS) $(LDLIBS)
+	$(CC) -o mdadm.O2 $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -DHAVE_STDINT_H -O2 $(SRCS) $(LDLIBS)
 
 mdmon.O2 : $(MON_SRCS) $(INCL) mdmon.h
-	$(CC) -o mdmon.O2 $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(MON_LDFLAGS) -DHAVE_STDINT_H -O2 -D_FORTIFY_SOURCE=2 $(MON_SRCS) $(LDLIBS)
+	$(CC) -o mdmon.O2 $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(MON_LDFLAGS) -DHAVE_STDINT_H -O2 $(MON_SRCS) $(LDLIBS)
 
-# use '-z now' to guarantee no dynamic linker interactions with the monitor thread
 mdmon : $(MON_OBJS) | check_rundir
-	$(CC) $(CFLAGS) $(LDFLAGS) $(MON_LDFLAGS) -Wl,-z,now -o mdmon $(MON_OBJS) $(LDLIBS)
+	$(CC) $(CFLAGS) $(LDFLAGS) $(MON_LDFLAGS) -o mdmon $(MON_OBJS) $(LDLIBS)
 msg.o: msg.c msg.h
 
 test_stripe : restripe.c xmalloc.o mdadm.h
-- 
2.26.2

