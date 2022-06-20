Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE396C43334
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 16:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239277AbiFTQLf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 12:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240774AbiFTQLa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 12:11:30 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0BC205F2
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 09:11:28 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AD6D821ABD;
        Mon, 20 Jun 2022 16:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655741487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8xFwqkL0GpCx/s3eX7RIordGfa/QyehxAAped5EHFyg=;
        b=Eadp3I4D3SGxXncvEbe2apJWxbPahk9TRf0n1N8zYc/Floj6LoLM7ptYQU4l8qoo6ln1b6
        dp/D+jDIG4WZFwEsYvtmW2DwVHRJJjSsSIRCT1bANoUYTz3K7Rtf2zNbKYpRm3YUI8J5IU
        y3F9kD8XT6WsTvcqeLatLrDmKZZRvbQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655741487;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8xFwqkL0GpCx/s3eX7RIordGfa/QyehxAAped5EHFyg=;
        b=dU+rJeU/o0SHNOYFhcgEbBHMTG6qa8WgeD6yWilVqSQEidMRWM31noG7LICFX5I0h4/Hl2
        Pq9ca0qlZbmJoWCg==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 5CFF62C141;
        Mon, 20 Jun 2022 16:11:25 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Kinga Tanska <kinga.tanska@intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 2/6] util: replace ioctl use with function
Date:   Tue, 21 Jun 2022 00:10:39 +0800
Message-Id: <20220620161043.3661-3-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220620161043.3661-1-colyli@suse.de>
References: <20220620161043.3661-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Kinga Tanska <kinga.tanska@intel.com>

Replace using of ioctl calling to get md array info with
special function prepared to it.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util.c b/util.c
index cc94f96e..38f0420e 100644
--- a/util.c
+++ b/util.c
@@ -267,7 +267,7 @@ int md_array_active(int fd)
 		 * GET_ARRAY_INFO doesn't provide access to the proper state
 		 * information, so fallback to a basic check for raid_disks != 0
 		 */
-		ret = ioctl(fd, GET_ARRAY_INFO, &array);
+		ret = md_get_array_info(fd, &array);
 	}
 
 	return !ret;
-- 
2.35.3

