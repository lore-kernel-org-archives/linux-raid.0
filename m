Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFF1C6FD1C
	for <linux-raid@archiver.kernel.org>; Thu, 23 Mar 2023 16:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbjCWQu4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Mar 2023 12:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbjCWQuw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Mar 2023 12:50:52 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BB461B3
        for <linux-raid@vger.kernel.org>; Thu, 23 Mar 2023 09:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679590251; x=1711126251;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5hnr1b1y7JQyEjqzy6pDWmD9bMtur/g0q2NZ9moqews=;
  b=aegpJRHcB0VcXZrvC6jVyZc37/g/bOs/OgPJUbAkkM3Kr0N/AYxBXhyq
   6OREG510om29MyeX2zoYUV/VMS1bB0gnZr6mHrq2WajAQQq5uRyMIs3L8
   WlVKin1tADTCIxirZ7k4WiDklxvg/HnNOrvlUm46+Ta79peGzu+9TBfTb
   0FucSmspp2jbfBH5iRo8jdhVTzCM9sCw6xvRhHwhNWlI059PNM2P0EpAO
   kGvHkjY6qNiBANv93kBOv5R5VN8CMCx+nfevjDIB+59BwmJsGDwUoVgtV
   rrlQUC5zyId+YgytBIDjqIL9lfq+sXISznUoqUQ2hM1sbtxR5+Q7Vajn6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="339588443"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="339588443"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 09:50:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="682374210"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="682374210"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 09:50:49 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de, xni@redhat.com
Subject: [PATCH 3/4] mdadm: define is_devname_ignore()
Date:   Thu, 23 Mar 2023 17:50:16 +0100
Message-Id: <20230323165017.27121-4-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230323165017.27121-1-mariusz.tkaczyk@linux.intel.com>
References: <20230323165017.27121-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Use function instead of direct checks across code.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Incremental.c |  6 ++----
 Monitor.c     |  2 +-
 config.c      | 16 ++++++++++++++--
 mdadm.c       |  5 ++---
 mdadm.h       |  1 +
 5 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index b3dc499a..ebbbd4db 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -202,8 +202,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 	if (!match && rv == 2)
 		goto out;
 
-	if (match && match->devname &&
-	    strcasecmp(match->devname, "<ignore>") == 0) {
+	if (match && match->devname && is_devname_ignore(match->devname) == true) {
 		if (c->verbose >= 0)
 			pr_err("array containing %s is explicitly ignored by mdadm.conf\n",
 				devname);
@@ -1564,8 +1563,7 @@ static int Incremental_container(struct supertype *st, char *devname,
 				break;
 			}
 
-			if (match && match->devname &&
-			    strcasecmp(match->devname, "<ignore>") == 0) {
+			if (match && match->devname && is_devname_ignore(match->devname) == true) {
 				if (c->verbose > 0)
 					pr_err("array %s/%s is explicitly ignored by mdadm.conf\n",
 					       match->container, match->member);
diff --git a/Monitor.c b/Monitor.c
index 3273f2fb..ce8d5802 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -250,7 +250,7 @@ int Monitor(struct mddev_dev *devlist,
 
 			if (mdlist->devname == NULL)
 				continue;
-			if (strcasecmp(mdlist->devname, "<ignore>") == 0)
+			if (is_devname_ignore(mdlist->devname) == true)
 				continue;
 			if (!is_mddev(mdlist->devname))
 				continue;
diff --git a/config.c b/config.c
index f44cc1d3..e61c0496 100644
--- a/config.c
+++ b/config.c
@@ -119,6 +119,18 @@ int match_keyword(char *word)
 	return -1;
 }
 
+/**
+ * is_devname_ignore() - check if &devname is a special "<ignore>" keyword.
+ */
+bool is_devname_ignore(char *devname)
+{
+	static const char keyword[] = "<ignore>";
+
+	if (strcasecmp(devname, keyword) == 0)
+		return true;
+	return false;
+}
+
 /**
  * ident_init() - Set defaults.
  * @ident: ident pointer, not NULL.
@@ -404,7 +416,7 @@ void arrayline(char *line)
 			 *  <ignore>
 			 *  or anything that doesn't start '/' or '<'
 			 */
-			if (strcasecmp(w, "<ignore>") == 0 ||
+			if (is_devname_ignore(w) == true ||
 			    strncmp(w, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0 ||
 			    (w[0] != '/' && w[0] != '<') ||
 			    (strncmp(w, DEV_NUM_PREF, DEV_NUM_PREF_LEN) == 0 &&
@@ -571,7 +583,7 @@ void homehostline(char *line)
 	char *w;
 
 	for (w = dl_next(line); w != line; w = dl_next(w)) {
-		if (strcasecmp(w, "<ignore>") == 0)
+		if (is_devname_ignore(w) == true)
 			require_homehost = 0;
 		else if (home_host == NULL) {
 			if (strcasecmp(w, "<none>") == 0)
diff --git a/mdadm.c b/mdadm.c
index 4685ad6b..cae37177 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -154,7 +154,7 @@ int main(int argc, char *argv[])
 			continue;
 
 		case HomeHost:
-			if (strcasecmp(optarg, "<ignore>") == 0)
+			if (is_devname_ignore(optarg) == true)
 				c.require_homehost = 0;
 			else
 				c.homehost = optarg;
@@ -1749,8 +1749,7 @@ static int scan_assemble(struct supertype *ss,
 			int r;
 			if (a->assembled)
 				continue;
-			if (a->devname &&
-			    strcasecmp(a->devname, "<ignore>") == 0)
+			if (a->devname && is_devname_ignore(a->devname) == true)
 				continue;
 
 			r = Assemble(ss, a->devname,
diff --git a/mdadm.h b/mdadm.h
index 63ec88a0..87fd4a57 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1648,6 +1648,7 @@ extern void print_escape(char *str);
 extern int use_udev(void);
 extern unsigned long GCD(unsigned long a, unsigned long b);
 extern int conf_name_is_free(char *name);
+extern bool is_devname_ignore(char *devname);
 extern int conf_verify_devnames(struct mddev_ident *array_list);
 extern int devname_matches(char *name, char *match);
 extern struct mddev_ident *conf_match(struct supertype *st,
-- 
2.26.2

