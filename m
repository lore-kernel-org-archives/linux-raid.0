Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B32AC76196
	for <linux-raid@archiver.kernel.org>; Thu, 23 Mar 2023 16:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbjCWQuu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Mar 2023 12:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbjCWQut (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Mar 2023 12:50:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6FAE4
        for <linux-raid@vger.kernel.org>; Thu, 23 Mar 2023 09:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679590248; x=1711126248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XaddPF4ZQiFFZ+4hF2OdX4seUdOLQYfHcO04ZjSGdlw=;
  b=UMpY9UnSaTNoFDZYn5rOwW0CK10DDeH6Ew0CQUPKwJROjfHgKwukaO2R
   fAA4NjBD8J7Abs3Xin+6LRA9vXjw6xMv8804vIxTB66vTZUrUqCiA2gY9
   p77bR8c6fLaW8y/oaaglLjvOdwr0gbeqNUBvbtQNr8HQza6ICUMubIjSt
   0JP6kBb0gpLHBuZ1lZEvnuADGHKdZSZ2DlED9GnBkD+RmY9ToiymtJfZM
   0Vvqa4c6q6Hrjp2PkhdPF+Ose27wWNzW3Af7TMHWY1GoWweAFsMBVKEQg
   MOnqxIa49L82ZWuqmaX0Ci7agF4wpw+Ts6z0A4Jn2y5ppn83+qDXvxCz9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="339588430"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="339588430"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 09:50:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="682374204"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="682374204"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 09:50:47 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de, xni@redhat.com
Subject: [PATCH 2/4] mdadm: define DEV_NUM_PREF
Date:   Thu, 23 Mar 2023 17:50:15 +0100
Message-Id: <20230323165017.27121-3-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230323165017.27121-1-mariusz.tkaczyk@linux.intel.com>
References: <20230323165017.27121-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Use define instead of inlines. Add _LEN define.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 config.c |  4 ++--
 mdadm.h  |  8 ++++++++
 mdopen.c | 10 +++++-----
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/config.c b/config.c
index 59d5bfb6..f44cc1d3 100644
--- a/config.c
+++ b/config.c
@@ -407,8 +407,8 @@ void arrayline(char *line)
 			if (strcasecmp(w, "<ignore>") == 0 ||
 			    strncmp(w, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0 ||
 			    (w[0] != '/' && w[0] != '<') ||
-			    (strncmp(w, "/dev/md", 7) == 0 &&
-			     is_number(w + 7)) ||
+			    (strncmp(w, DEV_NUM_PREF, DEV_NUM_PREF_LEN) == 0 &&
+			     is_number(w + DEV_NUM_PREF_LEN)) ||
 			    (strncmp(w, "/dev/md_d", 9) == 0 &&
 			     is_number(w + 9))) {
 				/* This is acceptable */;
diff --git a/mdadm.h b/mdadm.h
index cb644fd8..63ec88a0 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -100,6 +100,14 @@ struct dlm_lksb {
 #define DEFAULT_BITMAP_DELAY 5
 #define DEFAULT_MAX_WRITE_BEHIND 256
 
+/* DEV_NUM_PREF is a subpath to numbered MD devices, e.g. /dev/md1 or directory name.
+ * DEV_NUM_PREF_LEN is a length with Null byte excluded.
+ */
+#ifndef DEV_NUM_PREF
+#define DEV_NUM_PREF "/dev/md"
+#define DEV_NUM_PREF_LEN (sizeof(DEV_NUM_PREF) - 1)
+#endif /* DEV_NUM_PREF */
+
 /* DEV_MD_DIR points to named MD devices directory.
  * DEV_MD_DIR_LEN is a length with Null byte excluded.
  */
diff --git a/mdopen.c b/mdopen.c
index ed86df60..b270fdd5 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -411,11 +411,11 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 			make_parts(devname, parts);
 
 		if (strcmp(chosen, devname) != 0) {
-			if (mkdir("/dev/md",0700) == 0) {
-				if (chown("/dev/md", ci->uid, ci->gid))
-					perror("chown /dev/md");
-				if (chmod("/dev/md", ci->mode| ((ci->mode>>2) & 0111)))
-					perror("chmod /dev/md");
+			if (mkdir(DEV_NUM_PREF, 0700) == 0) {
+				if (chown(DEV_NUM_PREF, ci->uid, ci->gid))
+					perror("chown " DEV_NUM_PREF);
+				if (chmod(DEV_NUM_PREF, ci->mode | ((ci->mode >> 2) & 0111)))
+					perror("chmod " DEV_NUM_PREF);
 			}
 
 			if (dev && strcmp(chosen, dev) == 0)
-- 
2.26.2

