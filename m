Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1EBC04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238152AbiG1MVe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237478AbiG1MVZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:21:25 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACA51262C
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:21:24 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A08B91FD87;
        Thu, 28 Jul 2022 12:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010883; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=imbINS7jZLrAJSaNz2OID/swAbvkKmMAQbgeDI2ttJA=;
        b=tdvgm55zgjuScpB0UwOUU2gM+7IDWzJh7otKay1O6LDaoGWPN4GjR4QC16Te1rziJJSei1
        B51VP/ysb+6GaTs2Jf2lStuZ28cOBYLo4YXP6fZyPHaZjBy/f59t4rX7vciZgrzhQNdXXX
        V/Ymg3u7JMEoWUfHtuk/wJXnrFj3tFY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010883;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=imbINS7jZLrAJSaNz2OID/swAbvkKmMAQbgeDI2ttJA=;
        b=TNibIsBAGtD/VSzi93cGIuBF/+8gJsDNV5/ZluvWJFCUrPMGns28UCh7AetjJOOZKqSdsh
        Xp+CdRanR10ClyCw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 377F02C141;
        Thu, 28 Jul 2022 12:21:20 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 03/23] DDF: Fix NULL pointer dereference in validate_geometry_ddf()
Date:   Thu, 28 Jul 2022 20:20:41 +0800
Message-Id: <20220728122101.28744-4-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

A relatively recent patch added a call to validate_geometry() in
Manage_add() that has level=LEVEL_CONTAINER and chunk=NULL.

This causes some ddf tests to segfault which aborts the test suite.

To fix this, avoid dereferencing chunk when the level is
LEVEL_CONTAINER or LEVEL_NONE.

Fixes: 1f5d54a06df0 ("Manage: Call validate_geometry when adding drive to external container")
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 super-ddf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 9d867f69..949e7d15 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3369,9 +3369,6 @@ static int validate_geometry_ddf(struct supertype *st,
 	 * If given BVDs, we make an SVD, changing all the GUIDs in the process.
 	 */
 
-	if (*chunk == UnSet)
-		*chunk = DEFAULT_CHUNK;
-
 	if (level == LEVEL_NONE)
 		level = LEVEL_CONTAINER;
 	if (level == LEVEL_CONTAINER) {
@@ -3381,6 +3378,9 @@ static int validate_geometry_ddf(struct supertype *st,
 						       freesize, verbose);
 	}
 
+	if (*chunk == UnSet)
+		*chunk = DEFAULT_CHUNK;
+
 	if (!dev) {
 		mdu_array_info_t array = {
 			.level = level,
-- 
2.35.3

