Return-Path: <SRS0=PPQD=CX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 909FDC433E2
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 05:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CD56214F1
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 05:38:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MH95lyeF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgINFiS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Sep 2020 01:38:18 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22777 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726035AbgINFiP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 14 Sep 2020 01:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600061909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=QGhAx6JgLSm2fDqrnxhITX0iIg9vxsGq8b1kMb3DJYs=;
        b=MH95lyeF2I5IKur1FTwf/J0Mb4DJfvGTf1saIJOY6Nh1OB6bItY+nBYA36zBFftQRof6b1
        3dHhmiNwF1CAQ2GT91sZUjdjjR9CcjFAOOzLWkxiq4J0IuQSvuX3ERhosEVC33XDsXJ6UV
        8DW4eV7IY9rWheHXWMeGLH2IopYS+5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-z0RR81GgOc2MfSuU5qVBng-1; Mon, 14 Sep 2020 01:38:27 -0400
X-MC-Unique: z0RR81GgOc2MfSuU5qVBng-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BE1D801AAB;
        Mon, 14 Sep 2020 05:38:26 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9A894DA72;
        Mon, 14 Sep 2020 05:38:22 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Cc:     colyli@suse.de, ncroxon@redhat.com
Subject: [mdadm PATCH 1/2] Check hostname file empty or not when creating raid device
Date:   Mon, 14 Sep 2020 13:38:14 +0800
Message-Id: <1600061895-16330-2-git-send-email-xni@redhat.com>
In-Reply-To: <1600061895-16330-1-git-send-email-xni@redhat.com>
References: <1600061895-16330-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If /etc/hostname is empty and the hostname is decided by DHCP. There is a risk that the raid
device can't be active after boot. Maybe the network starts after storage. The system can
detect disk first and udev rules are triggered. It wants to assemble the raid device. But the
network hasn't started successfully. So the hostname is not specified. The raid will be treat
as a foreign raid.

So give a warning message if /etc/hostname is empty when creating a raid device.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mdadm.c |  3 +++
 mdadm.h |  1 +
 util.c  | 19 +++++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/mdadm.c b/mdadm.c
index 1b3467f..e551958 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1408,6 +1408,9 @@ int main(int argc, char *argv[])
 	if (c.homehost == NULL && c.require_homehost)
 		c.homehost = conf_get_homehost(&c.require_homehost);
 	if (c.homehost == NULL || strcasecmp(c.homehost, "<system>") == 0) {
+		if (check_hostname())
+			pr_err("Note: The file /etc/hostname is empty. There is a risk the raid\n"
+				"      can't be active after boot\n");
 		if (gethostname(sys_hostname, sizeof(sys_hostname)) == 0) {
 			sys_hostname[sizeof(sys_hostname)-1] = 0;
 			c.homehost = sys_hostname;
diff --git a/mdadm.h b/mdadm.h
index 399478b..3ef1209 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1480,6 +1480,7 @@ extern int parse_cluster_confirm_arg(char *inp, char **devname, int *slot);
 extern int check_ext2(int fd, char *name);
 extern int check_reiser(int fd, char *name);
 extern int check_raid(int fd, char *name);
+extern int check_hostname(void);
 extern int check_partitions(int fd, char *dname,
 			    unsigned long long freesize,
 			    unsigned long long size);
diff --git a/util.c b/util.c
index 579dd42..de5bad0 100644
--- a/util.c
+++ b/util.c
@@ -694,6 +694,25 @@ int check_raid(int fd, char *name)
 	return 1;
 }
 
+/* It checks /etc/hostname has value or not */
+int check_hostname()
+{
+	int fd, ret = 0;
+	char buf[256];
+
+	fd = open("/etc/hostname", O_RDONLY);
+	if (fd < 0) {
+		ret = 1;
+		goto out;
+	}
+
+	if (read(fd, buf, sizeof(buf)) == 0)
+		ret = 1;
+out:
+	close(fd);
+	return ret;
+}
+
 int fstat_is_blkdev(int fd, char *devname, dev_t *rdev)
 {
 	struct stat stb;
-- 
2.7.5

