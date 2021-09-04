Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BF0C433EF
	for <linux-raid@archiver.kernel.org>; Sat,  4 Sep 2021 10:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B714960F5D
	for <linux-raid@archiver.kernel.org>; Sat,  4 Sep 2021 10:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbhIDKBX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 4 Sep 2021 06:01:23 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:59119 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235794AbhIDKBN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 4 Sep 2021 06:01:13 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1MPrXf-1mYmI73emh-00MsL2; Sat, 04 Sep 2021 12:00:00 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Song Liu <song@kernel.org>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v4 3/3] dm crypt: log aead integrity violations to audit subsystem
Date:   Sat,  4 Sep 2021 11:59:30 +0200
Message-Id: <20210904095934.5033-4-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
References: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:m7H31RjTq/RWlxT0KJCzKnzsf7xGhGsSA9GOUbq9dzTVKL/B/7E
 jiH4G8fgCUfwOS9K75NuJ55TlCa9LC0plVPCbW1MrUVzDN6X94zAy6Lzu5Oq9/N4YSxFWyE
 WGCJPiibYXhNJZ1n5NlSWdjZ46F2jK/lBj3h+ijX+CdmeR4d1Y00s8aImbzta1eL1JxNatA
 7rDkahC9w0SDGMCfK5Wjw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ierr4Vfsyso=:EhRe4ISPaUlcG6i3McEf7O
 qngGcL7ENkdo2/WQ7yStDQDdzMMDQl34lGyu4YUbnrOSu53lnObo/SgijGvp5/zh0tI9PH9TE
 jJk/H10YFhOqyAiy2TcT2M8gqZtc5eYIo45eD4dHCQWIdt0bTKVu01+gTnmzKa4KfmVxfN+Xe
 SacYQ7OH9zr8+93UHOBk2eP82Lmw1ihvfdnxMDF/gBzp+ugt2SEAGHzW9nUbu7CTaWWYIXHIc
 OJyoZrpmdXJ7HaWwIyD6bRYMJmNJGh1Hpw1N5/x18yk/x+rSOAnd5rrKzRrSy4hnAaTAxAfsz
 b3TIew59B/K349tgeWrfts4VgbA/lKK5JsBXK3+Zgv/fA2NF/EMInAD5ozOxpl+9KbMb3lPqZ
 zTylnxWwmpFj3txgIP6VnduHOLjlpTtth2GrbT33RuEHAPJCbgQePTMdFxQDSyuau4/fmDEI7
 t5FxMAOei85VlXWniT/kKwOev7cIF07tVH39u6tiqrYn8tGl9YWg3ZEXtUX1K1m+D5Z1t3NbL
 ZVdslYRirn2bcZnaC9wCKbV8+ON63p8NtnBSijtsw0lFWL5F8C59quFSRIw+czmPlGCacvW52
 r/RjS6gwrhkYp1PFuSMm880r/wG8rFGJe9HKiFz+FG/uQWDElr7B4Z7oMZPsh02xcjdiBB5ek
 HAtxoiGx77qEuphxkHeSK/abudZmVjGunKe6V+yKsjBXwiVMttjD0PAhL0KU87JmEG62woU1S
 YFt91GbTHEcRUTNCUtlUC5V+JFm394orRBxe0Sq7598j7x0RexSsfqK/PIY=
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
index 50f4cbd600d5..5e02002345fa 100644
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
+	dm_audit_log_dtr(DM_MSG_PREFIX, ti, 1);
 }
 
 static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
@@ -3357,9 +3369,11 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_flush_bios = 1;
 	ti->limit_swap_bios = true;
 
+	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 1);
 	return 0;
 
 bad:
+	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 0);
 	crypt_dtr(ti);
 	return ret;
 }
-- 
2.20.1

