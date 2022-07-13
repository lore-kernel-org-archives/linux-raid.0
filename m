Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C106C43334
	for <linux-raid@archiver.kernel.org>; Wed, 13 Jul 2022 03:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiGMDsV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Jul 2022 23:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiGMDsU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Jul 2022 23:48:20 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D86D8639
        for <linux-raid@vger.kernel.org>; Tue, 12 Jul 2022 20:48:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 212C21FA6C;
        Wed, 13 Jul 2022 03:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657684096; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fybrxrd9iULv975vO3AhJZPUaS+Rj8IgN/bMEyZXtPM=;
        b=hfvBfS5EQ8OW5527I3wHgS5TkQMrsJYRQjVmhGpj95Oo8YHaTCvJPqYAICdtqcLHfneeUi
        ONDYEuckeCv+FwouDSSUuzOy9cVL0/e1MPfLYLSDy6/4NgEmpM6voRYSrj2EOcAFvWA4HS
        eb2SBIaFB+A9Y7XaPGi78OjSKVltc/M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657684096;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fybrxrd9iULv975vO3AhJZPUaS+Rj8IgN/bMEyZXtPM=;
        b=7r/NlHE+jW09OZXq4CLrkaJkYsAYAPsFK78c1BwYn3emDG3ks+rOiqhBTbx67cNAQdaoDj
        Er1nL3nuUTCn2nAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EB47C13754;
        Wed, 13 Jul 2022 03:48:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cxcBKX5AzmL7VgAAMHmgww
        (envelope-from <neilb@suse.de>); Wed, 13 Jul 2022 03:48:14 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Paul Menzel" <pmenzel@molgen.mpg.de>,
        "Jes Sorensen" <jes@trained-monkey.org>
cc:     linux-raid@vger.kernel.org
Subject: [PATCH mdadm v2] super1: report truncated device
In-reply-to: <cff69e79-d681-c9d6-c719-8b10999a558a@molgen.mpg.de>
References: <165758762945.25184.10396277655117806996@noble.neil.brown.name>,
 <cff69e79-d681-c9d6-c719-8b10999a558a@molgen.mpg.de>
Date:   Wed, 13 Jul 2022 13:48:11 +1000
Message-id: <165768409124.25184.3270769367375387242@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


When the metadata is at the start of the device, it is possible that it
describes a device large than the one it is actually stored on.  When
this happens, report it loudly in --examine.

....
   Unused Space : before=3D1968 sectors, after=3D-2047 sectors DEVICE TOO SMA=
LL
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
    --metadata=3D0.90
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/test started.
mdadm: stopped /dev/md/test
   Unused Space : before=3D1968 sectors, after=3D-2047 sectors DEVICE TOO SMA=
LL
          State : clean TRUNCATED DEVICE
   Unused Space : before=3D1968 sectors, after=3D-2047 sectors DEVICE TOO SMA=
LL
          State : clean TRUNCATED DEVICE

Signed-off-by: NeilBrown <neilb@suse.de>
---
 super1.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/super1.c b/super1.c
index 71af860c0e3e..4d8dba8a5a44 100644
--- a/super1.c
+++ b/super1.c
@@ -406,12 +406,18 @@ static void examine_super1(struct supertype *st, char *=
homehost)
=20
 	st->ss->getinfo_super(st, &info, NULL);
 	if (info.space_after !=3D 1 &&
-	    !(__le32_to_cpu(sb->feature_map) & MD_FEATURE_NEW_OFFSET))
-		printf("   Unused Space : before=3D%llu sectors, after=3D%llu sectors\n",
-		       info.space_before, info.space_after);
-
-	printf("          State : %s\n",
-	       (__le64_to_cpu(sb->resync_offset)+1)? "active":"clean");
+	    !(__le32_to_cpu(sb->feature_map) & MD_FEATURE_NEW_OFFSET)) {
+		printf("   Unused Space : before=3D%llu sectors, ",
+		       info.space_before);
+		if (info.space_after < INT64_MAX)
+			printf("after=3D%llu sectors\n", info.space_after);
+		else
+			printf("after=3D-%llu sectors DEVICE TOO SMALL\n",
+			       UINT64_MAX - info.space_after);
+	}
+	printf("          State : %s%s\n",
+	       (__le64_to_cpu(sb->resync_offset)+1)? "active":"clean",
+	       info.space_after > INT64_MAX ? " TRUNCATED DEVICE" : "");
 	printf("    Device UUID : ");
 	for (i=3D0; i<16; i++) {
 		if ((i&3)=3D=3D0 && i !=3D 0)
@@ -2206,6 +2212,7 @@ static int load_super1(struct supertype *st, int fd, ch=
ar *devname)
 		tst.ss =3D &super1;
 		for (tst.minor_version =3D 0; tst.minor_version <=3D 2;
 		     tst.minor_version++) {
+			tst.ignore_hw_compat =3D st->ignore_hw_compat;
 			switch(load_super1(&tst, fd, devname)) {
 			case 0: super =3D tst.sb;
 				if (bestvers =3D=3D -1 ||
@@ -2312,7 +2319,6 @@ static int load_super1(struct supertype *st, int fd, ch=
ar *devname)
 		free(super);
 		return 2;
 	}
-	st->sb =3D super;
=20
 	bsb =3D (struct bitmap_super_s *)(((char*)super)+MAX_SB_SIZE);
=20
@@ -2322,6 +2328,20 @@ static int load_super1(struct supertype *st, int fd, c=
har *devname)
 	if (st->data_offset =3D=3D INVALID_SECTORS)
 		st->data_offset =3D __le64_to_cpu(super->data_offset);
=20
+	if (st->minor_version >=3D 1 &&
+	    st->ignore_hw_compat =3D=3D 0 &&
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
+	st->sb =3D super;
+
 	/* Now check on the bitmap superblock */
 	if ((__le32_to_cpu(super->feature_map)&MD_FEATURE_BITMAP_OFFSET) =3D=3D 0)
 		return 0;
--=20
2.36.1

