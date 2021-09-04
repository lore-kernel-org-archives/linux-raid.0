Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D84BC4332F
	for <linux-raid@archiver.kernel.org>; Sat,  4 Sep 2021 10:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 470C361051
	for <linux-raid@archiver.kernel.org>; Sat,  4 Sep 2021 10:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbhIDKBV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 4 Sep 2021 06:01:21 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:42903 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbhIDKBK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 4 Sep 2021 06:01:10 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1MGQ85-1mCLaN0BKv-00GsJy; Sat, 04 Sep 2021 11:59:58 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Song Liu <song@kernel.org>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v4 2/3] dm integrity: log audit events for dm-integrity target
Date:   Sat,  4 Sep 2021 11:59:29 +0200
Message-Id: <20210904095934.5033-3-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
References: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:RP+JHEoDg5VvsKjeP9S5rZHlghsg8MPUmfTGnKeICw1pmu8IjvF
 OqwSNzXO21A5q/0TqrUIufY8Y/d1CphP5BWCfpcIDQ4qKmXolaojP2QXcW4C9cNvPraIZqA
 s+rz7wh/mfaP+3VwVm+RJQmGuoSBXeGNxAVKb70YQN9e4/6uGIcMW89xYuOKKvWkgwomfMk
 cSJ6eLjIfC+AUxv7vTdUQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:xcpveqbB3/Q=:Drx6HjR5aUtbb/iUMNedIW
 WBml1Bh2K2iDqa7q5vicmyALkVUqFa0TCFD0gy1EGWh5z3GJydcG7UGXdi9rgIqvJIskyQriR
 de/v4tur8L0RyGlEM6gQszd0kR+eZn9PzR2xsO6KQh6oKk+n9542WZ4uwHwcxjvJF2uLCV1Xp
 fqF2Jvr5rG6xS/ZqI1jpgOXyAQA8ZMsICB9scTQQwyA/CEZWxIm4xRBQhzN8JfV8yO/lPfumC
 PT5NAmYZKnvp0TUHhOhoNd48aWzPq//ZRNJNlqfePQAksy7sX3XyqOfbF8kuyHqd5oekorX5w
 f9Uh/yAFaGTEfUqPAC6/p1lyc/EUaQyWmY+DLzXi8VPuR5wxlYkQ5Xbpe3VSaAZElN8k6doCY
 WQG4R4SPjAOxzLF08zgos9AXFqTEW2dwBxidFhtt4fOGr3ZVVvO+SShZAwpq94LgorCc4Bc5A
 rYFX69D6vhWsZpbGzsJPTjHSpeUY5leOVkQb1CskSs44dP0oYB3eTEHXpnKUGAYlHenU12yYo
 PqNB07m/iTY4hA2bokDAqxM+a8GMQdv7umqqhx7k2aRtnrOWG5Eh5ee5hxlwh6pi8PWoRBs8p
 QN2yoktEDXimqWbcrIqx8tIZGD0mM+iFc6YC3lV61zud6ADveT523g2jerbz9cyrHnYxp/x5H
 c2JIUuWNjqiCOvcCQtSztwybhQObbrKZTXGYqi6IcMPq0zBZY9XT4ykVY2/9iay+CsFJCO0vX
 JR/OCqVSvkNpXc14EZy/8iW8EbUQeGms4FEfRllTWBoBsAPPDZ2d+j7Gvxo=
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

