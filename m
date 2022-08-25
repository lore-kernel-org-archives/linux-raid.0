Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198C7ECAAA3
	for <linux-raid@archiver.kernel.org>; Thu, 25 Aug 2022 22:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243874AbiHYW4L (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 Aug 2022 18:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244254AbiHYW4I (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 Aug 2022 18:56:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0FBC2EAB
        for <linux-raid@vger.kernel.org>; Thu, 25 Aug 2022 15:56:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5C35A37A65;
        Thu, 25 Aug 2022 22:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661468161; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V/V/YDkoXU+9ZHXmhyGqonXA2L9PLZ9zw7WVpzNIM34=;
        b=Y8RokynaGds2PwejZ3ri1WQKTJ8NQdAarPCP4RRq9EyA3glYQE42duWso/BhTuwUAJx05D
        11g5hYjYWHt927ZAlBKzI7YJ04bFccn2TCwUpmL/R6c6R4ZQOm3j9gEE0yFHgqv9NQ9Po9
        cx8YJkntiWPCXY9onfNxZUYPUBcNjAE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661468161;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V/V/YDkoXU+9ZHXmhyGqonXA2L9PLZ9zw7WVpzNIM34=;
        b=S9Y9y6TG9TdsNwlY2lp7hd9Fj2ZTyEfqDkcX0En6bFX1VpOeSFA6PlLKR/llI4IcT0OscX
        YzbPbZpLG4SsuQBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EF5E613517;
        Thu, 25 Aug 2022 22:55:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pC3bKf/9B2M3egAAMHmgww
        (envelope-from <neilb@suse.de>); Thu, 25 Aug 2022 22:55:59 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Jes Sorensen" <jes@trained-monkey.org>
Cc:     "Mariusz Tkaczyk" <mariusz.tkaczyk@linux.intel.com>,
        "Paul Menzel" <pmenzel@molgen.mpg.de>, linux-raid@vger.kernel.org
Subject: [PATCH v3] super1: report truncated device
In-reply-to: <571bde96-e70d-9c87-1544-49790844d160@trained-monkey.org>
References: <165758762945.25184.10396277655117806996@noble.neil.brown.name>,
 <cff69e79-d681-c9d6-c719-8b10999a558a@molgen.mpg.de>,
 <165768409124.25184.3270769367375387242@noble.neil.brown.name>,
 <20220721101907.00002fee@linux.intel.com>,
 <165855103166.25184.12700264207415054726@noble.neil.brown.name>,
 <20220725094238.000014f0@linux.intel.com>,
 <1c04ce1c-cf02-2891-cb88-c5f91a80f620@trained-monkey.org>,
 <166138706173.27490.18440987438153337183@noble.neil.brown.name>,
 <20220825095917.00002549@linux.intel.com>,
 <571bde96-e70d-9c87-1544-49790844d160@trained-monkey.org>
Date:   Fri, 26 Aug 2022 08:55:56 +1000
Message-id: <166146815642.27490.8510532689362169941@noble.neil.brown.name>
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
 super1.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/super1.c b/super1.c
index 71af860c0e3e..58345e68b97c 100644
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
+	       (__le64_to_cpu(sb->resync_offset)+1) ? "active":"clean",
+	       (info.space_after > INT64_MAX)       ? " TRUNCATED DEVICE" : "");
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
@@ -2322,6 +2328,21 @@ static int load_super1(struct supertype *st, int fd, c=
har *devname)
 	if (st->data_offset =3D=3D INVALID_SECTORS)
 		st->data_offset =3D __le64_to_cpu(super->data_offset);
=20
+	if (st->minor_version >=3D 1 &&
+	    st->ignore_hw_compat =3D=3D 0 &&
+	    (dsize < (__le64_to_cpu(super->data_offset) +
+		      __le64_to_cpu(super->size))
+	     ||
+	     dsize < (__le64_to_cpu(super->data_offset) +
+		      __le64_to_cpu(super->data_size)))) {
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
2.37.1

