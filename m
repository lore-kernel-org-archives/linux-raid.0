Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27713C4320A
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 14:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09CFB6108C
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 14:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238225AbhHLO6w (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 Aug 2021 10:58:52 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:58857 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238209AbhHLO6t (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 Aug 2021 10:58:49 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1M1pk0-1mGP571gUa-002HB7; Thu, 12 Aug 2021 16:58:17 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     michael.weiss@aisec.fraunhofer.de
Cc:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH 2/3] dm integrity: log audit events for dm-integrity target
Date:   Thu, 12 Aug 2021 16:57:43 +0200
Message-Id: <20210812145748.4460-3-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
References: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:rOLBkevwnsuHTTeZxM6wyt3brTUugDPPIMca4NeT5aNr5Kik2K3
 hbgMjJU3VBouB/E3nUPL+YruThvT5ydbySJdhQQjp8WZ+i8fV4e7zNcqUaHlGg+3mWghOU6
 K6p+C/8Q3QwxaneRe71C77r9c3+iVHn6DpNPthcNFIqMrXD2v78B6HcfF7hF20FXqZFmQ/r
 XqHpyX2+hQc8xP0Czd8+A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9iymdaMASiE=:IqAZLDakQwY8KYD1WVLKr6
 eMEkKavfwisAuuGYlxUrnYIeV/athXgT6btHoE8H0t7nB/FqltKrAESfO3muhoduz0tXy75wc
 11HmxSlbY5J38iQvaLosjbYYrdshRKB8gGqU92CQV7pnZyVWywqwL28kIdo6FKmlqblGAGa/l
 uhgglf9rOSsQA4Qj3dvUbBzNLcKZ/kQ1XSqKSPiZ6Dmoa8isMjMKEKfdbZeNMqUAKYI9R13SA
 FfxoimEewhlqjZvkUYstnjAzfu2WjBERdGGHuwU2cD0746Z2OKtkmWBEZdflLz9XYXajgDoLK
 VcJIPMdwxd23oiBw0PisFUZ2TyLx4NVFShRtaSYrbQFN4MR0QWug6HrD110fjLJBtFKj3tF32
 I+Z3B3Aw5Mit7VVyXVX1LscPdMKa6wKMpsNt7pfg/L9UJemiLpNoeQ5syi/r+VrsHnVe+MCHR
 iOP0scM8ewXtB/uG+HFyg7xxRBqho0M2TdDXAgpEfffBk89bHkpfsja7+2hCAIsGgJAXi2voq
 LbHKQ3YvEop7qNxrtudHXymQol092aKcQ3neNwwnLDCWGLKSHkcpSWeTRAEa9aatC3bNHG5zw
 u2tcWKF0Ck9EBGNq3qDJ8fRB9nB9HrL2K90RwcSyc6g8EPN5RTLZU4yh3sAoA9ZyGedk1PA73
 pC8Ho2Ml59oHogl87ATtQ3UdA6uV6Qr0hezffJ2XLsFrbsHO6D8InCJUM9fJcsCzgPtEp2NRO
 ocpS/vLJV9dJ1kouM2STssnQ/csYKV6RMIBTEdPLBXW/9JsBS3CivVcwLDW4Xo7W/sydsbh36
 WH6JXPwSlPClySI5bAI5eybtamL94EqeoFaw5BCEY6wjxKCxaBEuiRR/4laj7QxzYgRq40hEc
 V/v3z/ub4ddREG4PVseA==
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

