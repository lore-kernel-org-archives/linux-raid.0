Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C00C4338F
	for <linux-raid@archiver.kernel.org>; Sat, 14 Aug 2021 18:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B86F660F39
	for <linux-raid@archiver.kernel.org>; Sat, 14 Aug 2021 18:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239085AbhHNSff (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 14 Aug 2021 14:35:35 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:60663 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239044AbhHNSf1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 14 Aug 2021 14:35:27 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1MsI4Q-1n4JvY1XQ2-00th0a; Sat, 14 Aug 2021 20:34:46 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Song Liu <song@kernel.org>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v2 3/3] dm crypt: log aead integrity violations to audit subsystem
Date:   Sat, 14 Aug 2021 20:33:55 +0200
Message-Id: <20210814183359.4061-4-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
References: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:CtoNFbEPV+8vqd27K0MnUwjFtAOw4axb5mfVZuAB5lwMuU7vLD7
 LG+BqLl4mtMr28N9LOxMPgHZ4MK5i50M6Q9smlyXuQ2WsFal4LxZQBCw4T0xBSt0b4P5Sc2
 M1OskO1MB8QXSnNwbyXYLmM5yIOgRLt0q0wCOpum2mojGFMZCGWPZGzjc5jS6jTp3AbLWa8
 pqomu0QeuppvzAGyhozaQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:+j3i/Gx0nXI=:lGogq2PrmQmbJOoU4JQ8Bu
 HAsUK52kNoePuQt8BO3ZSA8QRj7zItln8iyNRuHxl9s1EerAQPfRNEy3zfmfdwz+ls+o9O15W
 APi3zCwu8DV9izQv71XocknUUqtQ/Y/9c6BNRqZgSpgvEzVYFBPxzDYEuQpoUxkbIl0f65p7O
 glhJ6xZ6kMrL8I6bMtMRuEVke1BtBBmVtfP1afBTlcbsrGSA7n4U4oMuf3pbpX4AhKnT4JeV5
 k4FNlxcnoOZmPbdO7FH0I6vAGRxhB94k3xa3IBPDKqAbjmUZTn60wj2cDxcEpZC+KCyPcgnL/
 5P46+rXIzV0kTy3hy1ypzrXL4zNRRGIVl7MTEGIK/V0ApSS8y2E0gvUe9gsPPzx2FA7zaHeew
 PN9fcHBFWQgc5hZAloClyaHQcdg/YOAa9XREO0W1nf2z7Mkx/ieD4vw/dRsVR8Vlnv9uWc1WP
 CMImBlY70hAgCaB8/tszaYeeSG18mHyOfszLFaZu0BbvrZc7OqZptyPxY9wAYQ8RGUhVYqgLl
 gZgiEDxhucrioOmMv86XG7HkGrTFXKFgpeMnVGdbierKP2ZyIULtndJ2zNpw4p43ttuCL1DHW
 qtM9Dk7vS1j4jOPxn5WGVwyVd911HwvKHoVLbwwhkgoCqR6A2XeKdD4+bayar7UKr1+KImws7
 vRc1rHpXOqVeAS5lSQmfVLwlXvJfPbg1YylM0bjobAiHH0O8YMm0z5wSNPT8NWZ9t1dI3QBF0
 q+2rVCp7IVHyBuWmZKO2w6kIY81Rt6JPmth1BC0QApvN7Ryuul9D84M7DqJYEXl+BuC5r9xkd
 6O2xUCs6k0CLWTWoHDbXh/Ar9+vsHrGl7vWrwqZQD6E08Kq+Q1Ft6Irmia5MxNCMl7YrKVhsv
 5SL3t8JrhdT8pWxIJtkg==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Since dm-crypt target can be stacked on dm-integrity targets to
provide authenticated encryption, integrity violations are recognized
here during aead computation. We use the dm-audit submodule to
signal those events to user space, too.

The construction and destruction of crypt device mappings are also
logged as audit events.

Signed-off-by: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
---
 drivers/md/dm-crypt.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 50f4cbd600d5..2a336eacb50c 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -41,6 +41,8 @@
 
 #include <linux/device-mapper.h>
 
+#include "dm-audit.h"
+
 #define DM_MSG_PREFIX "crypt"
 
 /*
@@ -1362,8 +1364,12 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
 
 	if (r == -EBADMSG) {
 		char b[BDEVNAME_SIZE];
-		DMERR_LIMIT("%s: INTEGRITY AEAD ERROR, sector %llu", bio_devname(ctx->bio_in, b),
-			    (unsigned long long)le64_to_cpu(*sector));
+		sector_t s = le64_to_cpu(*sector);
+
+		DMERR_LIMIT("%s: INTEGRITY AEAD ERROR, sector %llu",
+			    bio_devname(ctx->bio_in, b), s);
+		dm_audit_log_bio(DM_MSG_PREFIX, "integrity-aead",
+				 ctx->bio_in, s, 0);
 	}
 
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
@@ -2173,8 +2179,12 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 
 	if (error == -EBADMSG) {
 		char b[BDEVNAME_SIZE];
-		DMERR_LIMIT("%s: INTEGRITY AEAD ERROR, sector %llu", bio_devname(ctx->bio_in, b),
-			    (unsigned long long)le64_to_cpu(*org_sector_of_dmreq(cc, dmreq)));
+		sector_t s = le64_to_cpu(*org_sector_of_dmreq(cc, dmreq));
+
+		DMERR_LIMIT("%s: INTEGRITY AEAD ERROR, sector %llu",
+			    bio_devname(ctx->bio_in, b), s);
+		dm_audit_log_bio(DM_MSG_PREFIX, "integrity-aead",
+				 ctx->bio_in, s, 0);
 		io->error = BLK_STS_PROTECTION;
 	} else if (error < 0)
 		io->error = BLK_STS_IOERR;
@@ -2729,6 +2739,8 @@ static void crypt_dtr(struct dm_target *ti)
 	dm_crypt_clients_n--;
 	crypt_calculate_pages_per_client();
 	spin_unlock(&dm_crypt_clients_lock);
+
+	dm_audit_log_target(DM_MSG_PREFIX, "dtr", ti, 1);
 }
 
 static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
@@ -3357,9 +3369,11 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_flush_bios = 1;
 	ti->limit_swap_bios = true;
 
+	dm_audit_log_target(DM_MSG_PREFIX, "ctr", ti, 1);
 	return 0;
 
 bad:
+	dm_audit_log_target(DM_MSG_PREFIX, "ctr", ti, 0);
 	crypt_dtr(ti);
 	return ret;
 }
-- 
2.20.1

