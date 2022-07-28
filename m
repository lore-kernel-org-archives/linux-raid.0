Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C089C04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238109AbiG1MWg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236688AbiG1MWP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:22:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896766BC15
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:22:13 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 41E491FE12;
        Thu, 28 Jul 2022 12:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c1rqadXQIDd0mDlfcRXIeYzSDDoI4r8BwnWvvCKvV4E=;
        b=ww1eNAU/drPVLS3u2Cl0v7CxIn3GGORHfh98GBNDBth7JCil90rrgxOafEXTYs86gGcvRV
        GXfnTADTIroK7uhLJbw0duNCusv9bS/0+qLpl2Oc7uMdi0q5fs/2dF0NQPHVlcFvL88bkZ
        6gT7aC0jL/T95GFoaXJK0HVu3tKRM/8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010932;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c1rqadXQIDd0mDlfcRXIeYzSDDoI4r8BwnWvvCKvV4E=;
        b=xo4v1ISJOgbvYmQI/dmXF3s/ZDAduF/BYX7fUZEAnbMffd0142l0BfpAqu8jUBF+oYJmx8
        2R2OpC6rTCh7zyBw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id C2D472C141;
        Thu, 28 Jul 2022 12:22:09 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 16/23] super1: report truncated device
Date:   Thu, 28 Jul 2022 20:20:54 +0800
Message-Id: <20220728122101.28744-17-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: NeilBrown <neilb@suse.de>

When the metadata is at the start of the device, it is possible that it
describes a device large than the one it is actually stored on.  When
this happens, report it loudly in --examine.

....
   Unused Space : before=1968 sectors, after=-2047 sectors DEVICE TOO SMALL
          State : clean TRUNCATED DEVICE
....

Also report in --assemble so that the failure which the kernel will
report will be explained.

mdadm: Device /dev/sdb is not large enough for data described in superblock
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdb has no superblock - assembly aborted

Scenario can be demonstrated as follows:

mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/test started.
mdadm: stopped /dev/md/test
   Unused Space : before=1968 sectors, after=-2047 sectors DEVICE TOO SMALL
          State : clean TRUNCATED DEVICE
   Unused Space : before=1968 sectors, after=-2047 sectors DEVICE TOO SMALL
          State : clean TRUNCATED DEVICE

Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Coly Li <colyli@suse.de>
---
 super1.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/super1.c b/super1.c
index 71af860c..4d8dba8a 100644
--- a/super1.c
+++ b/super1.c
@@ -406,12 +406,18 @@ static void examine_super1(struct supertype *st, char *homehost)
 
 	st->ss->getinfo_super(st, &info, NULL);
 	if (info.space_after != 1 &&
-	    !(__le32_to_cpu(sb->feature_map) & MD_FEATURE_NEW_OFFSET))
-		printf("   Unused Space : before=%llu sectors, after=%llu sectors\n",
-		       info.space_before, info.space_after);
-
-	printf("          State : %s\n",
-	       (__le64_to_cpu(sb->resync_offset)+1)? "active":"clean");
+	    !(__le32_to_cpu(sb->feature_map) & MD_FEATURE_NEW_OFFSET)) {
+		printf("   Unused Space : before=%llu sectors, ",
+		       info.space_before);
+		if (info.space_after < INT64_MAX)
+			printf("after=%llu sectors\n", info.space_after);
+		else
+			printf("after=-%llu sectors DEVICE TOO SMALL\n",
+			       UINT64_MAX - info.space_after);
+	}
+	printf("          State : %s%s\n",
+	       (__le64_to_cpu(sb->resync_offset)+1)? "active":"clean",
+	       info.space_after > INT64_MAX ? " TRUNCATED DEVICE" : "");
 	printf("    Device UUID : ");
 	for (i=0; i<16; i++) {
 		if ((i&3)==0 && i != 0)
@@ -2206,6 +2212,7 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 		tst.ss = &super1;
 		for (tst.minor_version = 0; tst.minor_version <= 2;
 		     tst.minor_version++) {
+			tst.ignore_hw_compat = st->ignore_hw_compat;
 			switch(load_super1(&tst, fd, devname)) {
 			case 0: super = tst.sb;
 				if (bestvers == -1 ||
@@ -2312,7 +2319,6 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 		free(super);
 		return 2;
 	}
-	st->sb = super;
 
 	bsb = (struct bitmap_super_s *)(((char*)super)+MAX_SB_SIZE);
 
@@ -2322,6 +2328,20 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 	if (st->data_offset == INVALID_SECTORS)
 		st->data_offset = __le64_to_cpu(super->data_offset);
 
+	if (st->minor_version >= 1 &&
+	    st->ignore_hw_compat == 0 &&
+	    (__le64_to_cpu(super->data_offset) +
+	     __le64_to_cpu(super->size) > dsize ||
+	     __le64_to_cpu(super->data_offset) +
+	     __le64_to_cpu(super->data_size) > dsize)) {
+		if (devname)
+			pr_err("Device %s is not large enough for data described in superblock\n",
+			       devname);
+		free(super);
+		return 2;
+	}
+	st->sb = super;
+
 	/* Now check on the bitmap superblock */
 	if ((__le32_to_cpu(super->feature_map)&MD_FEATURE_BITMAP_OFFSET) == 0)
 		return 0;
-- 
2.35.3

