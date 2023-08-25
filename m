Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5BCC71133
	for <linux-raid@archiver.kernel.org>; Fri, 25 Aug 2023 12:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244904AbjHYM4l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Aug 2023 08:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245076AbjHYM4i (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Aug 2023 08:56:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3329C2119
        for <linux-raid@vger.kernel.org>; Fri, 25 Aug 2023 05:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692968147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NDxRjgO5mrxxt6j3TrodLbP1d/T2WrUB6f8dsRaj19g=;
        b=QjV5TbZ8h3Ez4Rz9OGphzGrkMcHt2iNo51vVjLciAsWQyMEFgcCQncNFGugw5XAOmbr4wW
        rgn3v6WwRDlcnoPSb87qx3pN3HEbJ64evlo2mRvRdMquAaZTnPW45XdBJpHT6x25bj+n30
        S9bO38FlJ8fkLyGlMMczQQNk/G/Z0e4=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-TFXiFCLIN1u3ivIrf2i1hA-1; Fri, 25 Aug 2023 08:55:45 -0400
X-MC-Unique: TFXiFCLIN1u3ivIrf2i1hA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DF8D38210AD;
        Fri, 25 Aug 2023 12:55:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94AFF112131B;
        Fri, 25 Aug 2023 12:55:43 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com
Subject: [PATCH V2 1/1] mdadm: Stop mdcheck_continue timer when mdcheck_start service can finish check
Date:   Fri, 25 Aug 2023 20:55:41 +0800
Message-Id: <20230825125541.76501-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

mdcheck_continue is triggered by mdcheck_start timer. It's used to
continue check action if the raid is too big and mdcheck_start
service can't finish check action. If mdcheck start can finish check
action, it doesn't need to mdcheck continue service anymore. So stop
it when mdcheck start service can finish check action.

Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
v2: fix typo errors and add spaces at the beginning of comments
 misc/mdcheck | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/misc/mdcheck b/misc/mdcheck
index 700c3e252e72..f87999d3e797 100644
--- a/misc/mdcheck
+++ b/misc/mdcheck
@@ -140,7 +140,13 @@ do
 		echo $a > $fl
 		any=yes
 	done
-	if [ -z "$any" ]; then exit 0; fi
+	# mdcheck_continue.timer is started by mdcheck_start.timer.
+	# When the check action can be finished in mdcheck_start.service,
+	# it doesn't need mdcheck_continue anymore.
+	if [ -z "$any" ]; then
+		systemctl stop mdcheck_continue.timer
+		exit 0;
+	fi
 	sleep 120
 done
 
-- 
2.32.0 (Apple Git-132)

