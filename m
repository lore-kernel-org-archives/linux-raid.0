Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B78C54EE9
	for <linux-raid@archiver.kernel.org>; Wed,  7 Sep 2022 20:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiIGUEM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Sep 2022 16:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiIGUEI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Sep 2022 16:04:08 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77749F0DA
        for <linux-raid@vger.kernel.org>; Wed,  7 Sep 2022 13:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=fen2VH+SzmoZrCn8W7IKzWQcNqJNmRiMy/PoSWrjZhk=; b=JYldLoAesTGEsVWxf2ikGOCElb
        nFTemN6VQt9WbCPRDF4whz/iVWmNnP0pBJhlLQ9FXAcZ4GFolEikngYGUFz0Ws+5gMFxHmgT+zo6U
        u9p5Q/II99xWkCVR/mMHFk9KauVeKWoNe4KjvG0m7hwO2A+30YQeIkWqfV5SNMsLrFilTFJWxIM1J
        vnPH6GUEem5zeFJvec+iiMKBAQNa/HV4OxRs6XrHpWIn2QpnDfVi4WxdVh4CuO3aYCvLTVI85uKzK
        4F0x6fp6gfg8IPit5VaNsDG2tGDcC+xqwS2+ojjDHdkv1Z0L2DBadr7aI6EDlcAyBCeYxvUnfLzoD
        f3D+CZ0w==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oW1HH-000vwl-EK; Wed, 07 Sep 2022 14:04:04 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oW1HF-000rM2-A2; Wed, 07 Sep 2022 14:04:01 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>, Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Wed,  7 Sep 2022 14:03:54 -0600
Message-Id: <20220907200355.205045-2-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220907200355.205045-1-logang@deltatee.com>
References: <20220907200355.205045-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm 1/2] mdadm: Add --discard option for Create
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
 Create.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ReadMe.c |  1 +
 mdadm.c  |  4 +++
 mdadm.h  |  2 ++
 4 files changed, 82 insertions(+)

diff --git a/Create.c b/Create.c
index e06ec2ae96a1..db99da1e8571 100644
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
@@ -91,6 +97,63 @@ int default_layout(struct supertype *st, int level, int verbose)
 	return layout;
 }
 
+static int discard_device(const char *devname, unsigned long long size)
+{
+	uint64_t range[2] = {0, size};
+	unsigned long buf[4096 / sizeof(unsigned long)];
+	unsigned long i;
+	int fd;
+
+	fd = open(devname, O_RDWR | O_EXCL);
+	if (fd < 0) {
+		pr_err("could not open device for discard: %s\n", devname);
+		return 1;
+	}
+
+	if (ioctl(fd, BLKDISCARD, &range)) {
+		pr_err("discard failed on '%s': %m\n", devname);
+		goto out_err;
+	}
+
+	if (read(fd, buf, sizeof(buf)) != sizeof(buf)) {
+		pr_err("failed to readback '%s' after discard: %m\n", devname);
+		goto out_err;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(buf); i++) {
+		if (buf[i]) {
+			pr_err("device did not read back zeros after discard on '%s': %lx\n",
+			       devname, buf[i]);
+			goto out_err;
+		}
+	}
+
+	close(fd);
+	return 0;
+
+out_err:
+	close(fd);
+	return 1;
+}
+
+static int discard_devices(struct context *c, struct mddev_dev *devlist,
+			   unsigned long long size)
+{
+	struct mddev_dev *dv;
+
+	for (dv = devlist; dv; dv = dv->next) {
+		if (!strcmp(dv->devname, "missing"))
+			continue;
+
+		if (c->verbose)
+			pr_err("discarding all data on: %s\n", dv->devname);
+		if (discard_device(dv->devname, size))
+			return 1;
+	}
+
+	return 0;
+}
+
 int Create(struct supertype *st, char *mddev,
 	   char *name, int *uuid,
 	   int subdevs, struct mddev_dev *devlist,
@@ -603,6 +666,18 @@ int Create(struct supertype *st, char *mddev,
 		}
 	}
 
+	if (s->discard) {
+		if (discard_devices(c, devlist, (s->size << 10) +
+				    (st->data_offset << 9)))
+			return 1;
+
+		/* All disks are zero so if there are none missing assume
+		 * the array is clean
+		 */
+		if (first_missing >= s->raiddisks)
+			s->assume_clean = 1;
+	}
+
 	/* If this is raid4/5, we want to configure the last active slot
 	 * as missing, so that a reconstruct happens (faster than re-parity)
 	 * FIX: Can we do this for raid6 as well?
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
index 972adb524dfb..8dee85a54a6a 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -602,6 +602,10 @@ int main(int argc, char *argv[])
 			s.assume_clean = 1;
 			continue;
 
+		case O(CREATE, Discard):
+			s.discard = 1;
+			continue;
+
 		case O(GROW,'n'):
 		case O(CREATE,'n'):
 		case O(BUILD,'n'): /* number of raid disks */
diff --git a/mdadm.h b/mdadm.h
index 941a5f3823a0..99769be57ac5 100644
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
+	int	discard;
 	int	write_behind;
 	unsigned long long size;
 	unsigned long long data_offset;
-- 
2.30.2

