Return-Path: <SRS0=jE/M=B5=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D95A9C433DF
	for <linux-raid@archiver.kernel.org>; Wed, 19 Aug 2020 09:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C093B2072D
	for <linux-raid@archiver.kernel.org>; Wed, 19 Aug 2020 09:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgHSJDS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Aug 2020 05:03:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:49839 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgHSJDR (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 Aug 2020 05:03:17 -0400
IronPort-SDR: eDo3ToXFX6Egz2+A4fvjwRi2XaCyzitImplDsnpC9489Dr+4FhDtAypy84stTR1pk07dJHxkDM
 xP7tBUktAOTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="142887083"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="142887083"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 02:03:16 -0700
IronPort-SDR: tCS2Jr6XD8sZeNPj2zI4lHlFylSLZSo8eBWxwI/0eYqUH5a+mLbzlfXr5OrkCun/LObOe/gLIs
 6Wqz7UWkNZEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="400768622"
Received: from linux-3rn9.igk.intel.com ([10.102.102.97])
  by fmsmga001.fm.intel.com with ESMTP; 19 Aug 2020 02:03:15 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes.sorensen@gmail.com
Subject: [PATCH] Make target to install binaries only
Date:   Wed, 19 Aug 2020 11:03:12 +0200
Message-Id: <20200819090312.16994-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Make install causes installation of binaries, udev and man.
This commit contains new target make install-bin, which
results in installation of binaries only.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Makefile | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 15d05d14..92150dbf 100644
--- a/Makefile
+++ b/Makefile
@@ -245,9 +245,7 @@ $(MON_OBJS) : $(INCL) mdmon.h
 sha1.o : sha1.c sha1.h md5.h
 	$(CC) $(CFLAGS) -DHAVE_STDINT_H -o sha1.o -c sha1.c
 
-install : mdadm mdmon install-man install-udev
-	$(INSTALL) -D $(STRIP) -m 755 mdadm $(DESTDIR)$(BINDIR)/mdadm
-	$(INSTALL) -D $(STRIP) -m 755 mdmon $(DESTDIR)$(BINDIR)/mdmon
+install : install-binaries install-man install-udev
 
 install-static : mdadm.static install-man
 	$(INSTALL) -D $(STRIP) -m 755 mdadm.static $(DESTDIR)$(BINDIR)/mdadm
@@ -297,6 +295,10 @@ install-systemd: systemd/mdmon@.service
 	done
 	if [ -f /etc/SuSE-release -o -n "$(SUSE)" ] ;then $(INSTALL) -D -m 755 systemd/SUSE-mdadm_env.sh $(DESTDIR)$(LIB_DIR)/mdadm_env.sh ;fi
 
+install-binaries: mdadm mdmon
+	$(INSTALL) -D $(STRIP) -m 755 mdadm $(DESTDIR)$(BINDIR)/mdadm
+	$(INSTALL) -D $(STRIP) -m 755 mdmon $(DESTDIR)$(BINDIR)/mdmon
+
 uninstall:
 	rm -f $(DESTDIR)$(MAN8DIR)/mdadm.8 $(DESTDIR)$(MAN8DIR)/mdmon.8 $(DESTDIR)$(MAN4DIR)/md.4 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5 $(DESTDIR)$(BINDIR)/mdadm
 
-- 
2.16.4

