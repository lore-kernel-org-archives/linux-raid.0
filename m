Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2033C6FD19
	for <linux-raid@archiver.kernel.org>; Mon, 13 Mar 2023 03:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjCMDph (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 12 Mar 2023 23:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjCMDpd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 12 Mar 2023 23:45:33 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78272360A8
        for <linux-raid@vger.kernel.org>; Sun, 12 Mar 2023 20:45:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2F76522AB4;
        Mon, 13 Mar 2023 03:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678679129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ezkKjWE1IkDRXLSbKlEKlCvi1goNhfhZXqX8dSPA9Tk=;
        b=CqXR4FzZBicXjDjLm5HFlvgi6wjyL2vIHGeYmsYzcjV8loJoIxbE3PIal5EP9PI2brJ7Qp
        lISFEzWD2akKL0GjaogDgcI7I//Qpi/K3Ewb3xIwzF4IIfZ4brtc8A3exa2BgjZCYf3EW2
        vqaChSv/eFjbFAzqzCGKxyZr+spIqCI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678679129;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ezkKjWE1IkDRXLSbKlEKlCvi1goNhfhZXqX8dSPA9Tk=;
        b=U0B3NK4SESUZJt+Rh2z1rEnbctQ0K1oxtBaLSAvhT5iHOyyXtCVvXvi2811sUCxZQHeGN/
        aHWfzwXWIq5IGfCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4C3F713463;
        Mon, 13 Mar 2023 03:45:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eeMXAFecDmSHCAAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 13 Mar 2023 03:45:27 +0000
Subject: [PATCH 2/6] Improvements for IMSM_NO_PLATFORM testing.
From:   NeilBrown <neilb@suse.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Date:   Mon, 13 Mar 2023 14:42:58 +1100
Message-ID: <167867897868.11443.7240557073570592164.stgit@noble.brown>
In-Reply-To: <167867886675.11443.523512156999408649.stgit@noble.brown>
References: <167867886675.11443.523512156999408649.stgit@noble.brown>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Factor out IMSM_NO_PLATFORM testing into a single function that caches
the result.

Allow mdmon to explicitly set the result to "1" so that we don't need
the ENV var in the unit file

Check if the kernel command line contains "mdadm.imsm.test=1" and in
that case assert NO_PLATFORM.  This simplifies testing in a virtual
machine.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 mdadm.h                |    2 ++
 mdmon.c                |    6 ++++++
 super-intel.c          |   43 ++++++++++++++++++++++++++++++++++++++++---
 systemd/mdmon@.service |    3 ---
 4 files changed, 48 insertions(+), 6 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 1674ce1307b2..16acb2dd1ce4 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1258,6 +1258,8 @@ extern struct superswitch super0, super1;
 extern struct superswitch super_imsm, super_ddf;
 extern struct superswitch mbr, gpt;
 
+void imsm_set_no_platform(int v);
+
 struct metadata_update {
 	int	len;
 	char	*buf;
diff --git a/mdmon.c b/mdmon.c
index 60ba318253b9..f557e12c6533 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -318,6 +318,12 @@ int main(int argc, char *argv[])
 		{NULL, 0, NULL, 0}
 	};
 
+	/*
+	 * mdmon should never complain due to lack of a platform,
+	 * that is mdadm's job if at all.
+	 */
+	imsm_set_no_platform(1);
+
 	while ((opt = getopt_long(argc, argv, "thaF", options, NULL)) != -1) {
 		switch (opt) {
 		case 'a':
diff --git a/super-intel.c b/super-intel.c
index e155a8ae99cb..a514dea6f95c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -629,6 +629,43 @@ static const char *_sys_dev_type[] = {
 	[SYS_DEV_VMD] = "VMD"
 };
 
+static int no_platform = -1;
+
+static int check_no_platform(void)
+{
+	static const char search[] = "mdadm.imsm.test=1";
+	int fd;
+	char buf[1024];
+	int n = 0;
+
+	if (no_platform >= 0)
+		return no_platform;
+
+	if (check_env("IMSM_NO_PLATFORM")) {
+		no_platform = 1;
+		return 1;
+	}
+	fd = open("/proc/cmdline", O_RDONLY);
+	if (fd >= 0) {
+		n = read(fd, buf, sizeof(buf)-1);
+		close(fd);
+	}
+	if (n >= (int)sizeof(search)) {
+		buf[n] = 0;
+		if (strstr(buf, search) != NULL) {
+			no_platform = 1;
+			return 1;
+		}
+	}
+	no_platform = 0;
+	return 0;
+}
+
+void imsm_set_no_platform(int v)
+{
+	no_platform = v;
+}
+
 const char *get_sys_dev_type(enum sys_dev_type type)
 {
 	if (type >= SYS_DEV_MAX)
@@ -2699,7 +2736,7 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 	int result=1;
 
 	if (enumerate_only) {
-		if (check_env("IMSM_NO_PLATFORM"))
+		if (check_no_platform())
 			return 0;
 		list = find_intel_devices();
 		if (!list)
@@ -4722,7 +4759,7 @@ static int find_intel_hba_capability(int fd, struct intel_super *super, char *de
 		       devname);
 		return 1;
 	}
-	if (!is_fd_valid(fd) || check_env("IMSM_NO_PLATFORM")) {
+	if (!is_fd_valid(fd) || check_no_platform()) {
 		super->orom = NULL;
 		super->hba = NULL;
 		return 0;
@@ -10697,7 +10734,7 @@ static int imsm_get_allowed_degradation(int level, int raid_disks,
  ******************************************************************************/
 int validate_container_imsm(struct mdinfo *info)
 {
-	if (check_env("IMSM_NO_PLATFORM"))
+	if (check_no_platform())
 		return 0;
 
 	struct sys_dev *idev;
diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
index cb6482d9ff29..e7ee17a8bf91 100644
--- a/systemd/mdmon@.service
+++ b/systemd/mdmon@.service
@@ -12,9 +12,6 @@ Before=initrd-switch-root.target
 Documentation=man:mdmon(8)
 
 [Service]
-# mdmon should never complain due to lack of a platform,
-# that is mdadm's job if at all.
-Environment=IMSM_NO_PLATFORM=1
 # The mdmon starting in the initramfs (with dracut at least)
 # cannot see sysfs after root is mounted, so we will have to
 # 'takeover'.  As the '--offroot --takeover' don't hurt when


