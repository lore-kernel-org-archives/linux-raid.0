Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E952CC432BE
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 14:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC8306108C
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 14:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238278AbhHLO7A (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 Aug 2021 10:59:00 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:46879 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238219AbhHLO6x (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 Aug 2021 10:58:53 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1Mwwhv-1n3GJb0gg7-00yNa2; Thu, 12 Aug 2021 16:58:20 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     michael.weiss@aisec.fraunhofer.de
Cc:     Song Liu <song@kernel.org>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH 3/3] dm crypt: log aead integrity violations to audit subsystem
Date:   Thu, 12 Aug 2021 16:57:44 +0200
Message-Id: <20210812145748.4460-4-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
References: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:hi75DlmNC+gK0CXxDU0sjhTTyi1egVdFtYQsJdIqde10JuGW9jT
 TPsDrRNsncuUh69Pvfji/1XP0HPWq+lq4I/9TE5MXLvZ7i8SwSZsjqd+ROBtQVpLZ9IWRti
 0J39VfLCltB8admoIpZQFSyP3cQaFVpTaYQsnl0QKyngMYvvlRlJxzVCusRAc/4FwxzoDbO
 klNlxcmjVhKgcKpfg6j+w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:M2BgY4J2R+k=:bJmPmn/zDcpsoZAsXKjfGX
 BYR1WNf7NGfePQ1dnLFArqzOAyISIU0AObypEmI8S8iIj1XilXqmlHCt3bM7mXT4NgAQdLknH
 PNDnc+U1+d05pKS67QgDXgJuTY/n8qbkrGN0aEgmlJ7/Rvyt8cz+/jiqf6cAsFXndyiUNSr2P
 Lj0VLjDVuw2EaCyoXIp4l/8mOgL7xO785Vl8Bn0BpxmliINGGF6Us/zSx4EN/+stf9HV/yxvg
 03kPZtBzs1IGSIhlyLZFtm/3EASiAjcPuW4QKsvnEG1aQwvhBI6dZJNVAiLFa1WDXb5q7qo9i
 J1w0zo/p7Xpa/FFQ3eTkWjJqpzemtC6FCrWW6dYH0GyvtNE0KgyTcYLqiEsRaG8/eNmeWFr1a
 EJ2O0EpmFHr44LMA0MEpIV2jpNcy+N3uzhMwF9ZulfQ2vAYpGETvHnrM89ouEfDLCupwbqqN2
 cbNSUwkK+j2isUQSWD6tWJQegQbgkuLOBQz3hhNFj3alwNWLhdds4efR5vu8pIOim86519lIT
 jEGvy8Cybozd+1VA9ekUlKdu0biL08dAdmWt5I4vGV4DUueKI1fM8z29MS+lrTBRXo/GJ0OJ1
 KHkFbOvAvOf/wneoOrSAn1/c9fsRkVmeeSZIflY5EZhLeDcIp+Litt0l+O7Bv2MjZsZ1+P1vM
 3zhBGo2yodmtTGSCBu2WImWGEXlu3ejg4Z5wt1K2SNY8Tm6JwMk69XMG7iYotpbhcqz44v04s
 M0lPwCdh6BH+FhBrCU01ZDvFq5bOv3t/Qk7B+T3QckIHI9bBgpFVStVv1lxvIsPbEPhGQ0F3o
 mvgbT40gOZmiC40zqRwbq37uLlkZqc6q462wuSZyr9vhhcZxWnjXDt8WykJ8EQMdPs9jep/Uz
 ILYpiZwin/+ZKqBDgTag==
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
 drivers/md/dm-crypt.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 50f4cbd600d5..343aef4dcf5e 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -41,6 +41,8 @@
 
 #include <linux/device-mapper.h>
 
+#include "dm-audit.h"
+
 #define DM_MSG_PREFIX "crypt"
 
 /*
@@ -1122,6 +1124,7 @@ static bool crypt_integrity_hmac(struct crypt_config *cc)
 	return crypt_integrity_aead(cc) && cc->key_mac_size;
 }
 
+
 /* Get sg containing data */
 static struct scatterlist *crypt_get_sg_data(struct crypt_config *cc,
 					     struct scatterlist *sg)
@@ -1362,8 +1365,12 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
 
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
@@ -2173,8 +2180,12 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 
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
@@ -2729,6 +2740,8 @@ static void crypt_dtr(struct dm_target *ti)
 	dm_crypt_clients_n--;
 	crypt_calculate_pages_per_client();
 	spin_unlock(&dm_crypt_clients_lock);
+
+	dm_audit_log_target(DM_MSG_PREFIX, "dtr", ti, 1);
 }
 
 static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
@@ -3357,9 +3370,11 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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

