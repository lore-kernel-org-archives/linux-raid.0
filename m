Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A09C38142
	for <linux-raid@archiver.kernel.org>; Tue, 31 Jan 2023 05:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjAaFSJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Jan 2023 00:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjAaFSF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Jan 2023 00:18:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79923526E
        for <linux-raid@vger.kernel.org>; Mon, 30 Jan 2023 21:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675142238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fLW8K+hwO/6FRBKx1SZk527JKhZsi4HWcu/EFQuY1yQ=;
        b=AaD2cu90MOPsNZArojWpxNsyzCKyylIi8CpyKwZNlAc8aw0TsLBp5tECp36erjdN9NxYuP
        zMGTvx0gbVKxenDcTn8gml6P8tH17qB4qv32NCTRIr3P80RC/3eW6M1ZAJrdGfMACfRzkZ
        k3djBddQlb5byveUNzx45qR5kpL+fNM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-XpCDKqciP4ukSuue__AVSw-1; Tue, 31 Jan 2023 00:17:16 -0500
X-MC-Unique: XpCDKqciP4ukSuue__AVSw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51EBD3C0E46B;
        Tue, 31 Jan 2023 05:17:16 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-52.pek2.redhat.com [10.72.12.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6552175A2;
        Tue, 31 Jan 2023 05:17:12 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Subject: [PATCH V2 0/2] md: Change active_io to percpu
Date:   Tue, 31 Jan 2023 13:17:08 +0800
Message-Id: <20230131051710.87961-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

This is a optimization for active_io. Now it's atomic type and
added/decreased when io comes, but it's only needed to be checked
when suspending raid. So we can change it to percpu type.

The first patch factors out a helper function which is used in
the second patch.

The patches have been tested by regression test under tests directory.
I did a performance test too. In my environment there is no big change.

Xiao Ni (2):
  Factor out is_md_suspended helper
  md: Change active_io to percpu

 drivers/md/md.c | 50 ++++++++++++++++++++++++++++++-------------------
 drivers/md/md.h |  2 +-
 2 files changed, 32 insertions(+), 20 deletions(-)

-- 
2.32.0 (Apple Git-132)

