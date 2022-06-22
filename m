Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76631C43334
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 20:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiFVUZj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 16:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiFVUZb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 16:25:31 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2204736B52
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 13:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=1Z+gvJ7TIB1L/2+vRP0VUeKRzgFrLn64ehbFv0319z4=; b=rOgArZ55bAUSV7EqtAf075FmKP
        pNJzu9ibdlY2IsBrV1Flyxq1Rh5SydZcpmqZBuvpSOi9smlJ0FtjZlt+/CmpzwFHVRlJIpryEzDBA
        5n36jFiMpPck+dop0P5Jluf4KQZ7XLR0/yQrhL+KlgE6oBydDY1+8BcG1i8zIw9GmFoqdnjeVPyEq
        ao5Tgbutbykm0aRnb8tfd5KLAUI2l+4e11+KbsZnvMqCf0+a/oMIC5wBBqpF2zBaLH2o6gloBUGp0
        hakScbks5y/BFmpthzfXrTc6deI5kgailaHAJh3/qlRPbMDDAT6dOc3xXvn0I9PnML61vG+krZHPr
        bKE53LAw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46uk-00EGyZ-Qr; Wed, 22 Jun 2022 14:25:28 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46ug-0009MD-VX; Wed, 22 Jun 2022 14:25:23 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>
Cc:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Wed, 22 Jun 2022 14:25:07 -0600
Message-Id: <20220622202519.35905-3-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622202519.35905-1-logang@deltatee.com>
References: <20220622202519.35905-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v2 02/14] DDF: Cleanup validate_geometry_ddf_container()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Move the function up so that the function declaration is not necessary
and remove the unused arguments to the function.

No functional changes are intended but will help with a bug fix in the
next patch.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-ddf.c | 88 ++++++++++++++++++++++++-----------------------------
 1 file changed, 39 insertions(+), 49 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index abbc8b09c617..9d867f6910f3 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -503,13 +503,6 @@ struct ddf_super {
 static int load_super_ddf_all(struct supertype *st, int fd,
 			      void **sbp, char *devname);
 static int get_svd_state(const struct ddf_super *, const struct vcl *);
-static int
-validate_geometry_ddf_container(struct supertype *st,
-				int level, int layout, int raiddisks,
-				int chunk, unsigned long long size,
-				unsigned long long data_offset,
-				char *dev, unsigned long long *freesize,
-				int verbose);
 
 static int validate_geometry_ddf_bvd(struct supertype *st,
 				     int level, int layout, int raiddisks,
@@ -3322,6 +3315,42 @@ static int reserve_space(struct supertype *st, int raiddisks,
 	return 1;
 }
 
+static int
+validate_geometry_ddf_container(struct supertype *st,
+				int level, int raiddisks,
+				unsigned long long data_offset,
+				char *dev, unsigned long long *freesize,
+				int verbose)
+{
+	int fd;
+	unsigned long long ldsize;
+
+	if (level != LEVEL_CONTAINER)
+		return 0;
+	if (!dev)
+		return 1;
+
+	fd = dev_open(dev, O_RDONLY|O_EXCL);
+	if (fd < 0) {
+		if (verbose)
+			pr_err("ddf: Cannot open %s: %s\n",
+			       dev, strerror(errno));
+		return 0;
+	}
+	if (!get_dev_size(fd, dev, &ldsize)) {
+		close(fd);
+		return 0;
+	}
+	close(fd);
+	if (freesize) {
+		*freesize = avail_size_ddf(st, ldsize >> 9, INVALID_SECTORS);
+		if (*freesize == 0)
+			return 0;
+	}
+
+	return 1;
+}
+
 static int validate_geometry_ddf(struct supertype *st,
 				 int level, int layout, int raiddisks,
 				 int *chunk, unsigned long long size,
@@ -3347,11 +3376,9 @@ static int validate_geometry_ddf(struct supertype *st,
 		level = LEVEL_CONTAINER;
 	if (level == LEVEL_CONTAINER) {
 		/* Must be a fresh device to add to a container */
-		return validate_geometry_ddf_container(st, level, layout,
-						       raiddisks, *chunk,
-						       size, data_offset, dev,
-						       freesize,
-						       verbose);
+		return validate_geometry_ddf_container(st, level, raiddisks,
+						       data_offset, dev,
+						       freesize, verbose);
 	}
 
 	if (!dev) {
@@ -3449,43 +3476,6 @@ static int validate_geometry_ddf(struct supertype *st,
 	return 1;
 }
 
-static int
-validate_geometry_ddf_container(struct supertype *st,
-				int level, int layout, int raiddisks,
-				int chunk, unsigned long long size,
-				unsigned long long data_offset,
-				char *dev, unsigned long long *freesize,
-				int verbose)
-{
-	int fd;
-	unsigned long long ldsize;
-
-	if (level != LEVEL_CONTAINER)
-		return 0;
-	if (!dev)
-		return 1;
-
-	fd = dev_open(dev, O_RDONLY|O_EXCL);
-	if (fd < 0) {
-		if (verbose)
-			pr_err("ddf: Cannot open %s: %s\n",
-			       dev, strerror(errno));
-		return 0;
-	}
-	if (!get_dev_size(fd, dev, &ldsize)) {
-		close(fd);
-		return 0;
-	}
-	close(fd);
-	if (freesize) {
-		*freesize = avail_size_ddf(st, ldsize >> 9, INVALID_SECTORS);
-		if (*freesize == 0)
-			return 0;
-	}
-
-	return 1;
-}
-
 static int validate_geometry_ddf_bvd(struct supertype *st,
 				     int level, int layout, int raiddisks,
 				     int *chunk, unsigned long long size,
-- 
2.30.2

