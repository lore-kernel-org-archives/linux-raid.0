Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FC9C433FE
	for <linux-raid@archiver.kernel.org>; Fri,  4 Nov 2022 14:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiKDOCj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Nov 2022 10:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKDOCi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Nov 2022 10:02:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EDF29C
        for <linux-raid@vger.kernel.org>; Fri,  4 Nov 2022 07:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667570499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=gwpf6QvtF9eBIL8sNmBmNgzLeSlhx6dByMDqjuI4Z64=;
        b=isDt7e4Xm57EcKGBOzR7zIk7T1bemdAF+OEdiVus17GCurx2WWX+b6t03ydtzWvGecet9x
        9mz6PwnVYL4JIbARFs/pNXYeet53lbOQ9TjMTgZRcBM9B6XAQOaH198kRiq8WR+aq5iZyi
        UuUcl0AWcZcNWJ+Yok3xzWq0Jo6e4PQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-qebt06USPPebw-9rVWNHVg-1; Fri, 04 Nov 2022 10:01:22 -0400
X-MC-Unique: qebt06USPPebw-9rVWNHVg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C9FA3C0F675;
        Fri,  4 Nov 2022 14:01:22 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DFB6202279C;
        Fri,  4 Nov 2022 14:01:22 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 2A4E1Mm8004026;
        Fri, 4 Nov 2022 10:01:22 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 2A4E1MYe004022;
        Fri, 4 Nov 2022 10:01:22 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Fri, 4 Nov 2022 10:01:22 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     NeilBrown <neilb@suse.de>, Jes Sorensen <jsorensen@fb.com>
cc:     Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com
Subject: [PATCH] mdadm: fix compilation failure on the x32 ABI
Message-ID: <alpine.LRH.2.21.2211040957470.19553@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi

Here I'm sending a patch for the mdadm utility. It fixes compile failure 
on the x32 ABI.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

The x32 ABI has 32-bit long and 64-bit time_t. Consequently, it reports 
printf arguments mismatch when attempting to print time using the "%ld" 
format specifier.

Fix this by converting times to long long and using %lld when printing
them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 monitor.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: mdadm/monitor.c
===================================================================
--- mdadm.orig/monitor.c	2022-11-04 14:25:52.000000000 +0100
+++ mdadm/monitor.c	2022-11-04 14:28:05.000000000 +0100
@@ -449,9 +449,9 @@ static int read_and_act(struct active_ar
 	}
 
 	gettimeofday(&tv, NULL);
-	dprintf("(%d): %ld.%06ld state:%s prev:%s action:%s prev: %s start:%llu\n",
+	dprintf("(%d): %lld.%06lld state:%s prev:%s action:%s prev: %s start:%llu\n",
 		a->info.container_member,
-		tv.tv_sec, tv.tv_usec,
+		(long long)tv.tv_sec, (long long)tv.tv_usec,
 		array_states[a->curr_state],
 		array_states[a->prev_state],
 		sync_actions[a->curr_action],

