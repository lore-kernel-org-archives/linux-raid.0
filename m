Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D095C43217
	for <linux-raid@archiver.kernel.org>; Thu,  7 Apr 2022 17:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346101AbiDGRYF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Apr 2022 13:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346080AbiDGRX5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Apr 2022 13:23:57 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D92664F4;
        Thu,  7 Apr 2022 10:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=ufB2LkWT2Jw65+K7Phw9dSX65Jk1XnoBPX/BNd0+QAU=; b=jiA9PBwX2dbEkxAmEkfpVbWNjb
        SLD4FQw2KkNztUq+G4EmSofYkyuwTapK+PYBqiap4XInK75Ne5uOxRA9hlT01/DswjYsdKrEp0/j3
        ZesRYekEYuNwEJU8Dh4mHjsFnoiFAemg3rIIIUu62xBam9Br960AXvFMVi9NkPQ5t54flyv4gcMSn
        uZ2JK0pW1nAgvleHvX0/9V2fz8iJPef8qxHfsitItFIOt+Vekm/qO0tLOlgg4AroqiWGhw1o37QKB
        jdEUYBZv06ohgg0DyrBQlEfu66Hu7+zypdhKyw/72X77tNPOnau+DTQUXzRfNRzwLjCxaHjx6xia5
        iNC0xu6Q==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ncVRf-002CRg-HF; Thu, 07 Apr 2022 10:57:20 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ncVRf-0002Q4-0w; Thu, 07 Apr 2022 10:57:19 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Thu,  7 Apr 2022 10:57:08 -0600
Message-Id: <20220407165713.9243-3-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220407165713.9243-1-logang@deltatee.com>
References: <20220407165713.9243-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, guoqing.jiang@linux.dev, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v1 2/7] md/raid5: Un-nest struct raid5_percpu definition
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Sparse reports many warnings of the form:
  drivers/md/raid5.c:1476:16: warning: dereference of noderef expression

This is because all struct raid5_percpu definitions get marked as
__percpu when really only the pointer in r5conf should have that
annotation.

Fix this by moving the defnition of raid5_precpu out of the definition
of struct r5conf.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/raid5.h | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 9e8486a9e445..61bc2e1f1b4e 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -560,6 +560,16 @@ struct r5pending_data {
 	struct bio_list bios;
 };
 
+struct raid5_percpu {
+	struct page	*spare_page; /* Used when checking P/Q in raid6 */
+	void		*scribble;  /* space for constructing buffer
+				     * lists and performing address
+				     * conversions
+				     */
+	int             scribble_obj_size;
+	local_lock_t    lock;
+};
+
 struct r5conf {
 	struct hlist_head	*stripe_hashtbl;
 	/* only protect corresponding hash list and inactive_list */
@@ -635,15 +645,7 @@ struct r5conf {
 					    */
 	int			recovery_disabled;
 	/* per cpu variables */
-	struct raid5_percpu {
-		struct page	*spare_page; /* Used when checking P/Q in raid6 */
-		void		*scribble;  /* space for constructing buffer
-					     * lists and performing address
-					     * conversions
-					     */
-		int             scribble_obj_size;
-		local_lock_t    lock;
-	} __percpu *percpu;
+	struct raid5_percpu __percpu *percpu;
 	int scribble_disks;
 	int scribble_sectors;
 	struct hlist_node node;
-- 
2.30.2

