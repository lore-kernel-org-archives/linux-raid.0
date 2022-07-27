Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF707C04A68
	for <linux-raid@archiver.kernel.org>; Wed, 27 Jul 2022 21:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiG0Vw4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Jul 2022 17:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiG0Vwy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Jul 2022 17:52:54 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827203056A
        for <linux-raid@vger.kernel.org>; Wed, 27 Jul 2022 14:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=9y4CXWIdEBNhjAN/cDX7ljs9aRLNnfKs9+cayWcmCmY=; b=dI6NBR+Iu2X7wVqTNHsNnrah9s
        Gf8mkV+RUrLMkPVlLwPt+cDs8xJnSyA8NiDq0jxJXebWSfgDJqbtRcxdPXwEGfYzO1YrtcQ3iuV8c
        H9Fr/XpEYjP4EMqCwVmIEptmHwDal+rq/FY+cz71MEf/OuL9GLy4yclT9bdvarqhi1UbQETfRLbzt
        6VD+OWIjyUCbX6wI5IXDwp453oy6qVtBs6bxzrfxdDFVUuPdyfQJxGhHrkSMPWEfX3h0emNDb/dC3
        zhMZ74xsLd4NbIxgjaXYSNOrRztEbVLsHblQ/nWc6Zc2LCKbtfrlr9o9lHMQHXx9wrbNr0ECkijoC
        gB+Z6Tfw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oGoxX-001qTg-2Z; Wed, 27 Jul 2022 15:52:52 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oGoxU-000VaP-I4; Wed, 27 Jul 2022 15:52:48 -0600
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
Date:   Wed, 27 Jul 2022 15:52:46 -0600
Message-Id: <20220727215246.121365-3-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220727215246.121365-1-logang@deltatee.com>
References: <20220727215246.121365-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v3 2/2] mdadm: Don't open md device for CREATE and ASSEMBLE
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The mdadm command tries to open the md device for most modes, first
thing, no matter what. When running to create or assemble an array,
in most cases, the md device will not exist, the open call will fail
and everything will proceed correctly.

However, when running tests, a create or assembly command may be run
shortly after stopping an array and the old md device file may still
be around. Then, if create_on_open is set in the kernel, a new md
device will be created when mdadm does its initial open.

When mdadm gets around to creating the new device with the new_array
parameter it issues this error:

   mdadm: Fail to create md0 when using
   /sys/module/md_mod/parameters/new_array, fallback to creation via node

This is because an mddev was already created by the kernel with the
earlier open() call and thus the new one being created will fail with
EEXIST. The mdadm command will still successfully be created due to
falling back to the node creation method. However, the error message
itself will fail any test that's running it.

This issue is a race condition that is very rare, but a recent change
in the kernel caused this to happen more frequently: about 1 in 50
times.

To fix this, don't bother trying to open the md device for CREATE,
ASSEMBLE and BUILD commands, as the file descriptor will never be used
anyway even if it is successfully openned. The mdfd has not been used
for these commands since:

   7f91af49ad09 ("Delay creation of array devices for assemble/build/create")

The checks that were done on the open device can be changed to being
done with stat.

Side note: it would be nice to disable create_on_open as well to help
solve this, but it seems the work for this was never finished. By default,
mdadm will create using the old node interface when a name is specified
unless the user specifically puts names=yes in a config file, which
doesn't seem to be common or desirable to require this..

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 lib.c   | 12 ++++++++++++
 mdadm.c | 40 ++++++++++++++++++++--------------------
 mdadm.h |  1 +
 3 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/lib.c b/lib.c
index 7e3e3d473995..e395b28d7d07 100644
--- a/lib.c
+++ b/lib.c
@@ -164,6 +164,18 @@ char *stat2devnm(struct stat *st)
 	return devid2devnm(st->st_rdev);
 }
 
+bool stat_is_md_dev(struct stat *st)
+{
+	if ((S_IFMT & st->st_mode) != S_IFBLK)
+		return false;
+	if (major(st->st_rdev) == MD_MAJOR)
+		return true;
+	if (major(st->st_rdev) == (unsigned)get_mdp_major())
+		return true;
+
+	return false;
+}
+
 char *fd2devnm(int fd)
 {
 	struct stat stb;
diff --git a/mdadm.c b/mdadm.c
index 56722ed997a2..db6524a9994a 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1349,6 +1349,9 @@ int main(int argc, char *argv[])
 
 	if (mode == MANAGE || mode == BUILD || mode == CREATE ||
 	    mode == GROW || (mode == ASSEMBLE && ! c.scan)) {
+		struct stat stb;
+		int ret;
+
 		if (devs_found < 1) {
 			pr_err("an md device must be given in this mode\n");
 			exit(2);
@@ -1361,6 +1364,12 @@ int main(int argc, char *argv[])
 			mdfd = open_mddev(devlist->devname, 1);
 			if (mdfd < 0)
 				exit(1);
+
+			ret = fstat(mdfd, &stb);
+			if (ret) {
+				pr_err("fstat failed on %s.\n", devlist->devname);
+				exit(1);
+			}
 		} else {
 			char *bname = basename(devlist->devname);
 
@@ -1368,30 +1377,21 @@ int main(int argc, char *argv[])
 				pr_err("Name %s is too long.\n", devlist->devname);
 				exit(1);
 			}
-			/* non-existent device is OK */
-			mdfd = open_mddev(devlist->devname, 0);
-		}
-		if (mdfd == -2) {
-			pr_err("device %s exists but is not an md array.\n", devlist->devname);
-			exit(1);
-		}
-		if ((int)ident.super_minor == -2) {
-			struct stat stb;
-			if (mdfd < 0) {
+
+			ret = stat(devlist->devname, &stb);
+			if (ident.super_minor == -2 && ret != 0) {
 				pr_err("--super-minor=dev given, and listed device %s doesn't exist.\n",
-					devlist->devname);
+				       devlist->devname);
+				exit(1);
+			}
+
+			if (!ret && !stat_is_md_dev(&stb)) {
+				pr_err("device %s exists but is not an md array.\n", devlist->devname);
 				exit(1);
 			}
-			fstat(mdfd, &stb);
-			ident.super_minor = minor(stb.st_rdev);
-		}
-		if (mdfd >= 0 && mode != MANAGE && mode != GROW) {
-			/* We don't really want this open yet, we just might
-			 * have wanted to check some things
-			 */
-			close(mdfd);
-			mdfd = -1;
 		}
+		if (ident.super_minor == -2)
+			ident.super_minor = minor(stb.st_rdev);
 	}
 
 	if (s.raiddisks) {
diff --git a/mdadm.h b/mdadm.h
index 05ef881f4709..69f498b4ff59 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1664,6 +1664,7 @@ void *super1_make_v0(struct supertype *st, struct mdinfo *info, mdp_super_t *sb0
 extern char *stat2kname(struct stat *st);
 extern char *fd2kname(int fd);
 extern char *stat2devnm(struct stat *st);
+bool stat_is_md_dev(struct stat *st);
 extern char *fd2devnm(int fd);
 extern void udev_block(char *devnm);
 extern void udev_unblock(void);
-- 
2.30.2

