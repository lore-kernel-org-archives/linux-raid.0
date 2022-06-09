Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9EDCCA473
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 21:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345429AbiFIVL5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Jun 2022 17:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345391AbiFIVLo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Jun 2022 17:11:44 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C22626EEA3
        for <linux-raid@vger.kernel.org>; Thu,  9 Jun 2022 14:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=CUai+BYhwX8qDVpPq+JF2gq73b4UAJsSsckC4YJA9bU=; b=TKpLuxqAB/QkV3rz5JNQC+8GRw
        3KlJEZXbPkp2VR436ppCW04i0ev/aYKx4UGX40z2qhD+isNjEKX2TTpPrmTwLHO3AgFHiWThj7SHC
        Xnj5To40jjhu0FtQSbANCR/8W0P8IUIhbq6Wfv2XzZg2JJ3e87XVL5Dm6+MJxnlODLv83nkTPwI6l
        3F87YZkUFg7XffulIbhr7CmaUrGJR3LYR1kidGnIGRGncud9Y+GSzA8CTb3AFyFWcoEwTUjToAZLX
        l1T4+ZV5CkG1rR9/5z+VAOFHaFM7jHSOSGzXi1+N7aN/YnqleKp5iIfoqtvAJ2rTV9wfQ5mt3VWOp
        yvGMS2pA==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1nzPRJ-0037Xn-R4; Thu, 09 Jun 2022 15:11:42 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1nzPRE-0001LX-Hb; Thu, 09 Jun 2022 15:11:32 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>
Cc:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Thu,  9 Jun 2022 15:11:19 -0600
Message-Id: <20220609211130.5108-4-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220609211130.5108-1-logang@deltatee.com>
References: <20220609211130.5108-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v1 03/14] DDF: Fix NULL pointer dereference in validate_geometry_ddf()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

A relatively recent patch added a call to validate_geometry() in
Manage_add() that has level=LEVEL_CONTAINER and chunk=NULL.

This causes some ddf tests to segfault which aborts the test suite.

To fix this, avoid dereferencing chunk when the level is
LEVEL_CONTAINER or LEVEL_NONE.

Fixes: 1f5d54a06df0 ("Manage: Call validate_geometry when adding drive to external container")
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 super-ddf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index d3c7a4082046..6bd357cf9b82 100644
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
2.30.2

