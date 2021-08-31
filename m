Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BFE8C43214
	for <linux-raid@archiver.kernel.org>; Tue, 31 Aug 2021 19:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33F8961075
	for <linux-raid@archiver.kernel.org>; Tue, 31 Aug 2021 19:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240693AbhHaTU4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Aug 2021 15:20:56 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:52927 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240564AbhHaTUs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Aug 2021 15:20:48 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MDQqe-1mAjyU11LK-00AWVx; Tue, 31 Aug 2021 21:19:40 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-audit@redhat.com
Subject: [PATCH v3 3/3] dm crypt: log aead integrity violations to audit subsystem
Date:   Tue, 31 Aug 2021 21:18:40 +0200
Message-Id: <20210831191845.7928-4-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210831191845.7928-1-michael.weiss@aisec.fraunhofer.de>
References: <20210831191845.7928-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:IrWO8hNKbUyJGbXkVzHd+rTfxnWDoZDtfPQ4TxlfEze/ruCXXJr
 /D15kCdQ3XnRZyT89l2wgZjhnoLP1M7LGpXR6f8TOEkx6SOc1MMHDa//EcvKMPvgFEeVWiP
 WP5L3h8DnDFkF8lfM/QLvkd43Ado7xyGNgBni4D+aOin0kiBbAuxnWuOuvK3KpUj5yGenw9
 2D8HiY7EzjytAcFhlzasw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Fy0xCcQ7OtE=:siHcSREbi8J5D/whvYvK1T
 COkJZUpBXpa+Ga0aXHql5J2wPTDL2RjcBVNTRkube504ABGTOMoxUbfScQqms09lc6YIH1jM2
 GyrkiqXST+ulIyGRO4SEtYZFrv16oj2rxBT9U26TROq7ELBf+XHy7ThH3DMOAOBepEwVKfz8c
 fGb4/snp8/724GopRka7LrsuK+gHjmFujAdtVqMNItsBsWPIUCk8VdHZZIgueCmPMi9POY0fB
 W8CpeGf7IiHlSHqUpHHB7ocJ+8y/vRcaAmJdMQu/Siv1oIsyp+YcCAomwmyS7nm2gK+jyRUn2
 iTNSSoza1uhZb7YeQkgZWfwfvLGGikS9x266LLm1CYgF7ZuN9uz2EM1U+iOWf/6WSC5q8oMGn
 ZcGcK7kQdxmmHi1kLxFjMl0jvTVMTJWGp9Zsl8nwBd3qnFRCE5MntkY3Mkvuk2v78pVKXYMOQ
 FtqG14mAB9wv9eUo204tyAb9LaYXN9OJR1w/Wy2o3GneoNaTfe8lNwqGS1/rQHi86G/Ayp8VM
 IyAYPj39kut9cRP0QI3GEkkC1+R59pdZkB4ii58gX3zExghCMzdJjNLpt8UMilB0QBFnlPeBU
 /6giM4hcAkS0czHl/x6kl9+LM+1VaMKzosXhZhEIBTmXk9XFGD9IIcQDAMTqqWw84RKgQqquj
 Bz7UplUo0+DVruGesg+fiU9BryTJk2eIOJHM0X4mI4Y1SZlEp18kEe3gJCE/UXljo+Q8PG4T5
 X4d7EdXyLr4OedvWK0d+tXUl5ZmtRVFDU1J7LtigIsFQZxhRlvl+UCgTLO4=
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

