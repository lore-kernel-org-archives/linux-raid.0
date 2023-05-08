Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF06C77B7F
	for <linux-raid@archiver.kernel.org>; Mon,  8 May 2023 13:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbjEHNbE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 May 2023 09:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjEHNbD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 May 2023 09:31:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D887A2B43D
        for <linux-raid@vger.kernel.org>; Mon,  8 May 2023 06:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683552615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FXs2yNMKGw8AEdxyDu281hcnMWMtIqxsexpkHfkY4M0=;
        b=jGnbHJaiNQLxRYAlurg2MARwvd5dmPqFWfj+t92zd/FwdHzmEzu46e2T7wpbhLEymZ8ZG2
        kaJwVqwnMGMTZAIDBYmgH7tXqHXQJ15XVO/veawXLQwZINQkRYJN5i5MuAQOl/k44RQFcN
        PluyMXBlLxUzZLy1pTKppkjYmOpg0zg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-tgnbuEp8PhW3uiO1JYPyOw-1; Mon, 08 May 2023 09:30:14 -0400
X-MC-Unique: tgnbuEp8PhW3uiO1JYPyOw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C96C80101C;
        Mon,  8 May 2023 13:30:14 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-29.pek2.redhat.com [10.72.12.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2E112166B41;
        Mon,  8 May 2023 13:30:12 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/1] Stop mdcheck_continue timer when mdcheck_start service can finish check
Date:   Mon,  8 May 2023 21:30:10 +0800
Message-Id: <20230508133010.42313-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

mdcheck_continue is triggered by mdcheck_start timer. It's used to
continue check action if the raid is too big and mdcheck_start
service can't finish check action. If mdcheck start can finish check
action, it doesn't need to mdcheck continue service anymore. So stop
it when mdcheck start service can finish check action.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 misc/mdcheck | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/misc/mdcheck b/misc/mdcheck
index 700c3e252e72..f56972c8ed10 100644
--- a/misc/mdcheck
+++ b/misc/mdcheck
@@ -140,7 +140,13 @@ do
 		echo $a > $fl
 		any=yes
 	done
-	if [ -z "$any" ]; then exit 0; fi
+	if [ -z "$any" ]; then
+		#mdcheck_continue.timer is started by mdcheck_start.timer.
+		#When he check action can be finished in mdcheck_start.service,
+		#it doesn't need mdcheck_continue anymore.
+		systemctl stop mdcheck_continue.timer
+		exit 0;
+	fi
 	sleep 120
 done
 
-- 
2.32.0 (Apple Git-132)

