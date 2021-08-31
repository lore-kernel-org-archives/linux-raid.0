Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2144C43214
	for <linux-raid@archiver.kernel.org>; Tue, 31 Aug 2021 19:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C38261057
	for <linux-raid@archiver.kernel.org>; Tue, 31 Aug 2021 19:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbhHaTUu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Aug 2021 15:20:50 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:53223 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240550AbhHaTUs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Aug 2021 15:20:48 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MBUuP-1m8pEM2qEB-00D0Q0; Tue, 31 Aug 2021 21:19:37 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-audit@redhat.com
Subject: [PATCH v3 2/3] dm integrity: log audit events for dm-integrity target
Date:   Tue, 31 Aug 2021 21:18:39 +0200
Message-Id: <20210831191845.7928-3-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210831191845.7928-1-michael.weiss@aisec.fraunhofer.de>
References: <20210831191845.7928-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:xMpaKCifDBlWiap1NWcMqokj8Q0hSpe1CN+SAJHuNzYCwloEljw
 frIfBUwGO8fQvZ48qefSTUONJ3EV2CPcWglYVt0oBMT71sCmEVtlqiVek0PY2SfPAukYGJ2
 CbWVbxlniEi6zqieiK3Fdc3o6kIuuAzTTk2XzgSGFCzK8hamBnZLqdEdYuIP2NORIScDycC
 FcTeBVyEZKfEbpgs0WJMw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:s+hL10tXHM4=:bos7SG8c6LXn0dXAkvwEIA
 GdgLrBvYT/wBCZMk4zBsIbf668hp/Jj1MjVxrHcWOpH0men8H+1CRRlFVfKhG38dA4PKdawaC
 76qSs9c1LZwV58tJDU2t6FnWcdp4Se+OOq+ktNe75nMuXtsVCe7PxME8tQxF2UcgINaTc7TYI
 fEJaBfYPNcJFwiJFk0LOu4J8Vd+/XGc+/ig+GJpaSr0KZS44IUQeoXSnNed3xlJrMDvpDvgXJ
 hhSN0ANDtoMW6014UZ0ctzQgy2jSKCNzPNnz6sZKPKNGJ74vx88d33IdUFBUW80jLgIz2keSn
 w1AXY423IDQ0li18GESLsQslWBOMrynTfe8UK4BUvTSVAR2a/qbAaKv4TinJlUEcEs8Yfv4Q2
 K5o2bwlddUbzjfjJkqJ4O2DtkyKd6f9oTK7+YMZv11RpgBHjWIURFIgxLlU1kbQG3Gcz0GYg+
 Km42nPCSN1c0Vn+AJNhjFY/dchZGDRSku/spUzcqasO8It5JkGk58Ux0sKNl1v7B6as1ND374
 mSveiN9snx1XmFbhR3pUV7F8f3JNdqAx6QtThk9NvOUeUtfulr5pSk+9OrkFLn5waZH/61hp2
 DTaDhCKOD+ML3171/BP/S5pXh88PCR0HY+M+MYYBPkh2+2uxW1Zr3+8k7IePILn3W3M+lBS2+
 ZexPEh8HYZA2GQPy26GpBRh0g7DOfbMF1zUm7o/vYls7KfatKDzYwNtd3YJdkUT5je1J8X1+J
 sPXqZIkUGnAz+hW7d5fku998ciqU6N3W9a3yxw3AHE7gXvAbmi0xVHkzneQ=
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

dm-integrity signals integrity violations by returning I/O errors
to user space. To identify integrity violations by a controlling
instance, the kernel audit subsystem can be used to emit audit
events to user space. We use the new dm-audit submodule allowing
to emit audit events on relevant I/O errors.

The construction and destruction of integrity device mappings are
also relevant for auditing a system. Thus, those events are also
logged as audit events.

Signed-off-by: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
---
 drivers/md/dm-integrity.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 20f2510db1f6..a881ead4b506 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -23,6 +23,8 @@
 #include <linux/async_tx.h>
 #include <linux/dm-bufio.h>
 
+#include "dm-audit.h"
+
 #define DM_MSG_PREFIX "integrity"
 
 #define DEFAULT_INTERLEAVE_SECTORS	32768
@@ -539,6 +541,7 @@ static int sb_mac(struct dm_integrity_c *ic, bool wr)
 		}
 		if (memcmp((__u8 *)ic->sb + (1 << SECTOR_SHIFT) - size, result, size)) {
 			dm_integrity_io_error(ic, "superblock mac", -EILSEQ);
+			dm_audit_log_target(DM_MSG_PREFIX, "mac-superblock", ic->ti, 0);
 			return -EILSEQ;
 		}
 	}
@@ -876,8 +879,10 @@ static void rw_section_mac(struct dm_integrity_c *ic, unsigned section, bool wr)
 		if (likely(wr))
 			memcpy(&js->mac, result + (j * JOURNAL_MAC_PER_SECTOR), JOURNAL_MAC_PER_SECTOR);
 		else {
-			if (memcmp(&js->mac, result + (j * JOURNAL_MAC_PER_SECTOR), JOURNAL_MAC_PER_SECTOR))
+			if (memcmp(&js->mac, result + (j * JOURNAL_MAC_PER_SECTOR), JOURNAL_MAC_PER_SECTOR)) {
 				dm_integrity_io_error(ic, "journal mac", -EILSEQ);
+				dm_audit_log_target(DM_MSG_PREFIX, "mac-journal", ic->ti, 0);
+			}
 		}
 	}
 }
@@ -1782,10 +1787,15 @@ static void integrity_metadata(struct work_struct *w)
 			if (unlikely(r)) {
 				if (r > 0) {
 					char b[BDEVNAME_SIZE];
-					DMERR_LIMIT("%s: Checksum failed at sector 0x%llx", bio_devname(bio, b),
-						    (sector - ((r + ic->tag_size - 1) / ic->tag_size)));
+					sector_t s;
+
+					s = sector - ((r + ic->tag_size - 1) / ic->tag_size);
+					DMERR_LIMIT("%s: Checksum failed at sector 0x%llx",
+						    bio_devname(bio, b), s);
 					r = -EILSEQ;
 					atomic64_inc(&ic->number_of_mismatches);
+					dm_audit_log_bio(DM_MSG_PREFIX, "integrity-checksum",
+							 bio, s, 0);
 				}
 				if (likely(checksums != checksums_onstack))
 					kfree(checksums);
@@ -1991,6 +2001,8 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 					if (unlikely(memcmp(checksums_onstack, journal_entry_tag(ic, je), ic->tag_size))) {
 						DMERR_LIMIT("Checksum failed when reading from journal, at sector 0x%llx",
 							    logical_sector);
+						dm_audit_log_bio(DM_MSG_PREFIX, "journal-checksum",
+								 bio, logical_sector, 0);
 					}
 				}
 #endif
@@ -2534,8 +2546,10 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
 
 					integrity_sector_checksum(ic, sec + ((l - j) << ic->sb->log2_sectors_per_block),
 								  (char *)access_journal_data(ic, i, l), test_tag);
-					if (unlikely(memcmp(test_tag, journal_entry_tag(ic, je2), ic->tag_size)))
+					if (unlikely(memcmp(test_tag, journal_entry_tag(ic, je2), ic->tag_size))) {
 						dm_integrity_io_error(ic, "tag mismatch when replaying journal", -EILSEQ);
+						dm_audit_log_target(DM_MSG_PREFIX, "integrity-replay-journal", ic->ti, 0);
+					}
 				}
 
 				journal_entry_set_unused(je2);
@@ -4490,9 +4504,11 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (ic->discard)
 		ti->num_discard_bios = 1;
 
+	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 1);
 	return 0;
 
 bad:
+	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 0);
 	dm_integrity_dtr(ti);
 	return r;
 }
@@ -4566,6 +4582,7 @@ static void dm_integrity_dtr(struct dm_target *ti)
 	free_alg(&ic->journal_mac_alg);
 
 	kfree(ic);
+	dm_audit_log_dtr(DM_MSG_PREFIX, ti, 1);
 }
 
 static struct target_type integrity_target = {
-- 
2.20.1

