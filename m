Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042FFC19F29
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238256AbiG1MWK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238303AbiG1MV5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:21:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FD86BC39
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:21:56 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8EC3A373A7;
        Thu, 28 Jul 2022 12:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010915; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dUrIywqQpJJnp1J5TLsm1u5QK1QX+0GMFCL+DlI5xsY=;
        b=kaNkAGv/FwbgQYSj9fJhg+HBLj4ZqgXDgynXdTENQmekKbKe9RgJB+gIvL21q1DIuW5Tjc
        WSlcHDy3bmGFRi48ntJxD+c+TGmOAIM8Rl5MxZnjPg6ZUKPwFta8iAQjzMiEKvWP2u943z
        Za8JmtGZEUhnAV7AUOE7MSzy+pcJdHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010915;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dUrIywqQpJJnp1J5TLsm1u5QK1QX+0GMFCL+DlI5xsY=;
        b=adPN4WTB96RSI8G7tBnomwRuI87oU+Ej/7F+R+grWe9lm7QyRZa8nprrtRzMGSS0bHEzXN
        Jo/sOkYMqrdNlUDA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 7065C2C141;
        Thu, 28 Jul 2022 12:21:51 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org,
        Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 11/23] tests/02lineargrow: clear the superblock at every iteration
Date:   Thu, 28 Jul 2022 20:20:49 +0800
Message-Id: <20220728122101.28744-12-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

This fixes 02lineargrow test as prior metadata causes --add operation
to misbehave.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Coly Li <colyli@suse.de>
---
 tests/02lineargrow | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/02lineargrow b/tests/02lineargrow
index e05c219d..595bf9f2 100644
--- a/tests/02lineargrow
+++ b/tests/02lineargrow
@@ -20,4 +20,6 @@ do
   testdev $md0 3 $sz 1
 
   mdadm -S $md0
+  mdadm --zero /dev/loop2
+  mdadm --zero /dev/loop3
 done
-- 
2.35.3

