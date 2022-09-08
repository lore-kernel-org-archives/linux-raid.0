Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD305C54EE9
	for <linux-raid@archiver.kernel.org>; Thu,  8 Sep 2022 23:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiIHXI6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Sep 2022 19:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiIHXI4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Sep 2022 19:08:56 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CE692F46
        for <linux-raid@vger.kernel.org>; Thu,  8 Sep 2022 16:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=y+TWp17UxjXVLSvcyYmMKsCV3LhQxqUpWmFuHbZIm9A=; b=kPmgsXpePOw2mAFRirLm7Rwrf3
        ZOCCoOeSB8ImLF1hdGGVDweALboiJWJpfiLOmRWJj0S88H3V6RQTKck+f0E9mBolMipxcN5H9M9U9
        5xg6oMs2efO1tyXTMMByUeCX6sz3dryaM3uNwu8hLcp0kGVvSSq6O1a7T6nPjMt4t2svIX8hl0oPm
        boTthVPWXxdWun1HJEBN0hDJTNfvDcK69QjPksJJCWI+58/u4NiWVAf+M22i5PYWS8kv/09/6oa3Z
        mf8nEpJEqxyuwnOSq88hMq1EsFc48ZKWEhzrol7R0XMaNA6RPtJDDNRdBhzkI+vV0C1i1klJU80Hm
        QmtOx6Cw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oWQde-001qIU-Rt; Thu, 08 Sep 2022 17:08:52 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oWQdd-0001Vb-W8; Thu, 08 Sep 2022 17:08:50 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>, Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Thu,  8 Sep 2022 17:08:46 -0600
Message-Id: <20220908230847.5749-2-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220908230847.5749-1-logang@deltatee.com>
References: <20220908230847.5749-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v2 1/2] mdadm: Add --discard option for Create
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add the --discard option for Create which will send BLKDISCARD requests to
all disks before assembling the array. This is a fast way to know the
current state of all the disks. If the discard request zeros the data
on the disks (as is common but not universal) then the array is in a
state with correct parity. Thus the initial sync may be skipped.

After issuing each discard request, check if the first page of the
block device is zero. If it is, it is safe to assume the entire
disk should be zero. If it's not report an error.

If all the discard requests are successful and there are no missing
disks thin it is safe to set assume_clean as we know the array is clean.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 Create.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 ReadMe.c |  1 +
 mdadm.c  |  4 ++++
 mdadm.h  |  2 ++
 4 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/Create.c b/Create.c
index e06ec2ae96a1..52bb88bccd53 100644
--- a/Create.c
+++ b/Create.c
@@ -26,6 +26,12 @@
 #include	"md_u.h"
 #include	"md_p.h"
 #include	<ctype.h>
+#include	<sys/ioctl.h>
+
+#ifndef BLKDISCARD
+#define BLKDISCARD _IO(0x12,119)
+#endif
+#include	<fcntl.h>
 
 static int round_size_and_verify(unsigned long long *size, int chunk)
 {
@@ -91,6 +97,38 @@ int default_layout(struct supertype *st, int level, int verbose)
 	return layout;
 }
 
+static int discard_device(struct context *c, int fd, const char *devname,
+			  unsigned long long offset, unsigned long long size)
+{
+	uint64_t range[2] = {offset, size};
+	unsigned long buf[4096 / sizeof(unsigned long)];
+	unsigned long i;
+
+	if (c->verbose)
+		printf("discarding data from %lld to %lld on: %s\n",
+		       offset, size, devname);
+
+	if (ioctl(fd, BLKDISCARD, &range)) {
+		pr_err("discard failed on '%s': %m\n", devname);
+		return 1;
+	}
+
+	if (pread(fd, buf, sizeof(buf), offset) != sizeof(buf)) {
+		pr_err("failed to readback '%s' after discard: %m\n", devname);
+		return 1;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(buf); i++) {
+		if (buf[i]) {
+			pr_err("device did not read back zeros after discard on '%s': %lx\n",
+			       devname, buf[i]);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 int Create(struct supertype *st, char *mddev,
 	   char *name, int *uuid,
 	   int subdevs, struct mddev_dev *devlist,
@@ -607,7 +645,7 @@ int Create(struct supertype *st, char *mddev,
 	 * as missing, so that a reconstruct happens (faster than re-parity)
 	 * FIX: Can we do this for raid6 as well?
 	 */
-	if (st->ss->external == 0 && s->assume_clean == 0 &&
+	if (st->ss->external == 0 && s->assume_clean == 0 && s->discard == 0 &&
 	    c->force == 0 && first_missing >= s->raiddisks) {
 		switch (s->level) {
 		case 4:
@@ -624,8 +662,8 @@ int Create(struct supertype *st, char *mddev,
 	/* For raid6, if creating with 1 missing drive, make a good drive
 	 * into a spare, else the create will fail
 	 */
-	if (s->assume_clean == 0 && c->force == 0 && first_missing < s->raiddisks &&
-	    st->ss->external == 0 &&
+	if (s->assume_clean == 0 && s->discard == 0 && c->force == 0 &&
+	    first_missing < s->raiddisks && st->ss->external == 0 &&
 	    second_missing >= s->raiddisks && s->level == 6) {
 		insert_point = s->raiddisks - 1;
 		if (insert_point == first_missing)
@@ -686,7 +724,7 @@ int Create(struct supertype *st, char *mddev,
 	     (insert_point < s->raiddisks || first_missing < s->raiddisks)) ||
 	    (s->level == 6 && (insert_point < s->raiddisks ||
 			       second_missing < s->raiddisks)) ||
-	    (s->level <= 0) || s->assume_clean) {
+	    (s->level <= 0) || s->assume_clean || s->discard) {
 		info.array.state = 1; /* clean, but one+ drive will be missing*/
 		info.resync_start = MaxSector;
 	} else {
@@ -945,6 +983,15 @@ int Create(struct supertype *st, char *mddev,
 				}
 				if (fd >= 0)
 					remove_partitions(fd);
+
+				if (s->discard &&
+				    discard_device(c, fd, dv->devname,
+						   dv->data_offset << 9,
+						   s->size << 10)) {
+					ioctl(mdfd, STOP_ARRAY, NULL);
+					goto abort_locked;
+				}
+
 				if (st->ss->add_to_super(st, &inf->disk,
 							 fd, dv->devname,
 							 dv->data_offset)) {
diff --git a/ReadMe.c b/ReadMe.c
index 7f94847e9769..544a057f83a0 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -138,6 +138,7 @@ struct option long_options[] = {
     {"size",	  1, 0, 'z'},
     {"auto",	  1, 0, Auto}, /* also for --assemble */
     {"assume-clean",0,0, AssumeClean },
+    {"discard",	  0, 0, Discard },
     {"metadata",  1, 0, 'e'}, /* superblock format */
     {"bitmap",	  1, 0, Bitmap},
     {"bitmap-chunk", 1, 0, BitmapChunk},
diff --git a/mdadm.c b/mdadm.c
index 972adb524dfb..049cdce1cdd2 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -602,6 +602,10 @@ int main(int argc, char *argv[])
 			s.assume_clean = 1;
 			continue;
 
+		case O(CREATE, Discard):
+			s.discard = true;
+			continue;
+
 		case O(GROW,'n'):
 		case O(CREATE,'n'):
 		case O(BUILD,'n'): /* number of raid disks */
diff --git a/mdadm.h b/mdadm.h
index 941a5f3823a0..a1e0bc9f01ad 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -433,6 +433,7 @@ extern char Version[], Usage[], Help[], OptionHelp[],
  */
 enum special_options {
 	AssumeClean = 300,
+	Discard,
 	BitmapChunk,
 	WriteBehind,
 	ReAdd,
@@ -593,6 +594,7 @@ struct shape {
 	int	bitmap_chunk;
 	char	*bitmap_file;
 	int	assume_clean;
+	bool	discard;
 	int	write_behind;
 	unsigned long long size;
 	unsigned long long data_offset;
-- 
2.30.2

