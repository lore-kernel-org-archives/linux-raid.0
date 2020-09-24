Return-Path: <SRS0=HtB1=DB=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B85EC4363D
	for <linux-raid@archiver.kernel.org>; Thu, 24 Sep 2020 22:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37245221EB
	for <linux-raid@archiver.kernel.org>; Thu, 24 Sep 2020 22:42:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=wiktel.com header.i=@wiktel.com header.b="pmEPVejv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgIXWmb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Sep 2020 18:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIXWmb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 24 Sep 2020 18:42:31 -0400
X-Greylist: delayed 343 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Sep 2020 15:42:31 PDT
Received: from smtp1.wiktel.com (smtp1.wiktel.com [IPv6:2600:2600::151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321EAC0613CE
        for <linux-raid@vger.kernel.org>; Thu, 24 Sep 2020 15:42:31 -0700 (PDT)
Received: from watermelon.coderich.net (thief-pool-117-74.mncable.net [24.225.117.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp1.wiktel.com (Postfix) with ESMTPSA id 4By8zh5GX3zxjR;
        Thu, 24 Sep 2020 17:36:48 -0500 (CDT)
From:   rlaager@wiktel.com
To:     linux-raid@vger.kernel.org
Cc:     rlaager@wiktel.com
Subject: [PATCH 2/2] mdcheck: Set a tag of mdcheck
Date:   Thu, 24 Sep 2020 17:36:39 -0500
Message-Id: <20200924223639.23087-2-rlaager@wiktel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200924223639.23087-1-rlaager@wiktel.com>
References: <20200924223639.23087-1-rlaager@wiktel.com>
X-bounce-key: wiktel.com-1;rlaager@wiktel.com;1600987008;/q21Q1gQLBcphU53fEuQRp+sSS8;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=wiktel.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references; s=wiktel1; bh=H
        mmOWxz1Whbe4osxfyoz/ZJUqmbzy1pk/kGzZNQiXZo=; b=pmEPVejvCpJuVakRb
        QEqqkVi7Jgum1q+kxaRt3gQxXfARcXRaBPNFHl7m8XVsyg5iKA8EHvLtvtm+XwMo
        pDCBUI0uLw9mKws/6Hak382quOwXMDGnZ3KQrFHwaJLp+8u7h1yscSTl4+abqZV6
        2+nA3uL8U8jtG08+5BKCPAw0BZ/9yqpdzAMWnHAH2VFd++UFFmoyvI0DLofR8Tau
        6ldCEf+ZYP3nWmRIcPNOTwzHJbmvXcUcvM5btTPv5mvOiWAOfZZ2EyzD5mCELrl7
        q2OM/EX3AE7ZkrIKsUg++JDhOTVd+Wk6dIudkM82Vr2dgl6wGJmBZdEaAnUgrM38
        LRtoQ==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Richard Laager <rlaager@wiktel.com>

For syslog messages, the tag is normally the daemon/script name.  This
changes the log messages from using "root: mdcheck ..." to
"mdcheck: ...".

Signed-off-by: Richard Laager <rlaager@wiktel.com>
---
 misc/mdcheck | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/misc/mdcheck b/misc/mdcheck
index 299cf10..acfda10 100644
--- a/misc/mdcheck
+++ b/misc/mdcheck
@@ -94,14 +94,14 @@ do
 	if [ -z "$cont" ]
 	then
 		start=0
-		logger -p daemon.info mdcheck start checking $dev
+		logger -p daemon.info -t mdcheck start checking $dev
 	elif [ -z "$MD_UUID" -o ! -f "$fl" ]
 	then
 		# Nothing to continue here
 		continue
 	else
 		start=`cat "$fl"`
-		logger -p daemon.info mdcheck continue checking $dev from $start
+		logger -p daemon.info -t mdcheck continue checking $dev from $start
 	fi
 
 	cnt=$[cnt+1]
@@ -131,7 +131,7 @@ do
 
 		if [ "`cat $sys/md/sync_action`" != 'check' ]
 		then
-			logger -p daemon.info mdcheck finished checking $dev
+			logger -p daemon.info -t mdcheck finished checking $dev
 			eval MD_${i}_fl=
 			rm -f $fl
 			continue;
@@ -162,5 +162,5 @@ do
 	fi
 	echo idle > $sys/md/sync_action
 	cat $sys/md/sync_min > $fl
-	logger -p daemon.info mdcheck pause checking $dev at `cat $fl`
+	logger -p daemon.info -t mdcheck pause checking $dev at `cat $fl`
 done
-- 
2.17.1

