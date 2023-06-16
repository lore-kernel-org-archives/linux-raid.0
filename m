Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E69BEB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 19:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjFPTqH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 15:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjFPTqG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 15:46:06 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C255810D8
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 12:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686944765; x=1718480765;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Sqzwu4+LnJGuobKSoPHX8ZUCMHdZmk1cjlionAi/vhk=;
  b=HszHdT4pG9NLdifjm7mE/5Bf0DXD76VBQ9ZeCRkyz8sJYFS5Zrpg5SiQ
   mkVdznuF3OPRxlC4g9xLQat67mIZJQ+KS5esXtRACPobvzEjnR1saW2iB
   4OJgdwru3iOgBHqLhB18BABBkYGAkeyFdM9yfXpyxTmNV7G5ts/lVxTrw
   5sjci79Ctdu9leZWtq+tx9vUqDl7KvyQlmt6tlHC5JWF0zGs6y+WQ+MHz
   4V7FuAnL2HSMC47lvDRXSQp3+QHtEGOVnSj2UhAXtPgRVyrhmjLSrkegs
   zC23XZW3EZoktV/OCIj2rgoGK8L43jTP7wsZ0SmIEthNnGHcGvENhWDb1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="445679289"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="445679289"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 12:46:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="825853907"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="825853907"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by fmsmga002.fm.intel.com with ESMTP; 16 Jun 2023 12:46:02 -0700
From:   Blazej Kucman <blazej.kucman@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] Add secure gethostname() wrapper
Date:   Fri, 16 Jun 2023 21:45:55 +0200
Message-Id: <20230616194555.6452-1-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

gethostname() func does not ensure null-terminated string
if hostname is longer than buffer length.
For security, a function s_gethostname() has been added
to ensure that "\0" is added to the end of the buffer.
Previously this had to be handled in each place
of the gethostname() call.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 Monitor.c   |  3 +--
 lib.c       | 19 +++++++++++++++++++
 mapfile.c   |  3 +--
 mdadm.c     |  3 +--
 mdadm.h     |  1 +
 super-ddf.c |  3 +--
 6 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 66175968..e74a0558 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -222,11 +222,10 @@ int Monitor(struct mddev_dev *devlist,
 	info.dosyslog = dosyslog;
 	info.test = c->test;
 
-	if (gethostname(info.hostname, sizeof(info.hostname)) != 0) {
+	if (s_gethostname(info.hostname, sizeof(info.hostname)) != 0) {
 		pr_err("Cannot get hostname.\n");
 		return 1;
 	}
-	info.hostname[sizeof(info.hostname) - 1] = '\0';
 
 	if (share){
 		if (check_one_sharer(c->scan) == 2)
diff --git a/lib.c b/lib.c
index fe5c8d2c..8a4b48e0 100644
--- a/lib.c
+++ b/lib.c
@@ -585,3 +585,22 @@ int parse_num(int *dest, const char *num)
 	*dest = temp;
 	return 0;
 }
+
+/**
+ * s_gethostname() - secure get hostname. Assure null-terminated string.
+ *
+ * @buf: buffer for hostname.
+ * @buf_len: buffer length.
+ *
+ * Return: gethostname() result.
+ */
+int s_gethostname(char *buf, int buf_len)
+{
+	assert(buf);
+
+	int ret = gethostname(buf, buf_len);
+
+	buf[buf_len - 1] = 0;
+
+	return ret;
+}
diff --git a/mapfile.c b/mapfile.c
index 34fea179..f1f3ee2c 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -363,8 +363,7 @@ void RebuildMap(void)
 	char *homehost = conf_get_homehost(&require_homehost);
 
 	if (homehost == NULL || strcmp(homehost, "<system>")==0) {
-		if (gethostname(sys_hostname, sizeof(sys_hostname)) == 0) {
-			sys_hostname[sizeof(sys_hostname)-1] = 0;
+		if (s_gethostname(sys_hostname, sizeof(sys_hostname)) == 0) {
 			homehost = sys_hostname;
 		}
 	}
diff --git a/mdadm.c b/mdadm.c
index 076b45e0..e32598cb 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1340,8 +1340,7 @@ int main(int argc, char *argv[])
 	if (c.homehost == NULL && c.require_homehost)
 		c.homehost = conf_get_homehost(&c.require_homehost);
 	if (c.homehost == NULL || strcasecmp(c.homehost, "<system>") == 0) {
-		if (gethostname(sys_hostname, sizeof(sys_hostname)) == 0) {
-			sys_hostname[sizeof(sys_hostname)-1] = 0;
+		if (s_gethostname(sys_hostname, sizeof(sys_hostname)) == 0) {
 			c.homehost = sys_hostname;
 		}
 	}
diff --git a/mdadm.h b/mdadm.h
index 83f2cf7f..f0ceeb78 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1805,6 +1805,7 @@ extern void set_dlm_hooks(void);
 extern void sleep_for(unsigned int sec, long nsec, bool wake_after_interrupt);
 extern bool is_directory(const char *path);
 extern bool is_file(const char *path);
+extern int s_gethostname(char *buf, int buf_len);
 
 #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
 #define ROUND_UP(val, base)	_ROUND_UP(val, (typeof(val))(base))
diff --git a/super-ddf.c b/super-ddf.c
index 7213284e..c5242654 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2364,8 +2364,7 @@ static int init_super_ddf(struct supertype *st,
 	 * Remaining 16 are serial number.... maybe a hostname would do?
 	 */
 	memcpy(ddf->controller.guid, T10, sizeof(T10));
-	gethostname(hostname, sizeof(hostname));
-	hostname[sizeof(hostname) - 1] = 0;
+	s_gethostname(hostname, sizeof(hostname));
 	hostlen = strlen(hostname);
 	memcpy(ddf->controller.guid + 24 - hostlen, hostname, hostlen);
 	for (i = strlen(T10) ; i+hostlen < 24; i++)
-- 
2.35.3

