Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA4FC4338F
	for <linux-raid@archiver.kernel.org>; Sat, 14 Aug 2021 18:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B216660ED5
	for <linux-raid@archiver.kernel.org>; Sat, 14 Aug 2021 18:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239038AbhHNSfY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 14 Aug 2021 14:35:24 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:46403 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239018AbhHNSfW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 14 Aug 2021 14:35:22 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1M2w0K-1mDrUz3jQa-003NuA; Sat, 14 Aug 2021 20:34:42 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Song Liu <song@kernel.org>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v2 2/3] dm integrity: log audit events for dm-integrity target
Date:   Sat, 14 Aug 2021 20:33:54 +0200
Message-Id: <20210814183359.4061-3-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
References: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:JRxIIEYVu7W68Mlh/36bVLtSpKe0BNTk++rItoE71sb3OJE4Ufu
 BpFoHbvkB//iZsXEAsC2Co76DE0Q+kNrHge4hduygWjDobaWfbxmwELVaBgfF55PCMHu/Xu
 Z2OYf1U6JRGFHRZOU/rJiuc5AddQyTU4f1hIFKYnj4x7Dg5vIu0fUd+T5g22lzULGoNN7OA
 TvyYEd4h2JRHtb+o8C7fQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:X5q4v+IdAAc=:GLSSLqkM8rMdNut5VEXjSC
 EFCqp3ZyUSfNhniV4bY8Ae5uH2LLKaIQqb96xiOyF4bRBgUx1T47x1J6v7ra/5+6AVleC66Wj
 HxVpofC48uR+6RHe2fh9V9HMTbwFZ/tuP8puKHiyF1Oz9kbD7wNKkl9PVpfjKLX/bMmcwRv1Z
 qFqtygxA+TRuhxpq6b41INGjIPU5VFbN0g1DYAyzbLcpPIUHZjjcSN0ftJOMLmwsoAwYvYgKB
 fyd7o8avsSSWg/cxUJ/u5y20CMkhCGBKY3bG8MJgvXetkPdbBrZwLLz1dgsrQWxEnm52lR6VI
 bzoZb9cY7Yq8xLn+F13bSXf4SsB9RbvXXXGr2lEN+gutdvcBt8zMoPQgC97kLCdgbDmWzFtgJ
 c5S7gVrA+yU9hnWNnvUU9Mugi6Xue+qJbUeTI2wMWWRybi+FkcYWYodjNeiq6sLxafPARoIQZ
 LWFiALVNgFudDkpWZrq/m3MZXpaayZ9aSXcH6QtwCbntmC0SMZvzuMRQ+z8KgYLOMVz6ut1Q4
 sAw4t+gsg1Sxf9rZAlPI8zwICiipi6YJKCSwMp1lzH+ZylqIEMpcd9S5tXPgdXBEBjNbQIGVG
 28o8e7dtfmzBWcXFsGvrAnHhVee7XBt+SU0FXrIa294UyOsl/trrQszxmFe9SoCsmrz0qPn1y
 L+POP9fV0dpz9VOH0SydmKDvenhv/NH1aO/te70Ygc6WoS92tE+fP2LzJMRACszxINZ6WKC5x
 VZc6uJ+4G+TMmU8amePPBj1kCpok3Ede4EnYdqFHc062ngqdQ7Gz3VFrTi6Ty3S9TVXmHZ5DJ
 A6zRiFN0VD1VmmmwZSK/S1CD/tS3AvfJpdPmAy8I/FxiofYqUMc73FJtEgi0ksWRSYSAzHTh0
 EhXKyUWaD29BEFm7XU3A==
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
index 20f2510db1f6..fbbb4c3f16cb 100644
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
 
+	dm_audit_log_target(DM_MSG_PREFIX, "ctr", ti, 1);
 	return 0;
 
 bad:
+	dm_audit_log_target(DM_MSG_PREFIX, "ctr", ti, 0);
 	dm_integrity_dtr(ti);
 	return r;
 }
@@ -4566,6 +4582,7 @@ static void dm_integrity_dtr(struct dm_target *ti)
 	free_alg(&ic->journal_mac_alg);
 
 	kfree(ic);
+	dm_audit_log_target(DM_MSG_PREFIX, "dtr", ti, 1);
 }
 
 static struct target_type integrity_target = {
-- 
2.20.1

