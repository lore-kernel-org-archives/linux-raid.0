Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122C6C05027
	for <linux-raid@archiver.kernel.org>; Sat, 21 Jan 2023 01:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjAUBk3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjAUBk2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 Jan 2023 20:40:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17626F333
        for <linux-raid@vger.kernel.org>; Fri, 20 Jan 2023 17:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674265185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gf+W2jEYupQblroKI+0Tcnk125B0ljYuL3J0IOfrMLI=;
        b=fgITizDN/1Xm4rQP5F3el8zEjoAevJGXjT2Gz3inO2ySolsR2WkV77m2dFsLnc8QdDqHIZ
        aA3PbOr295YDItQcMyAYh2xVYCvcu4qgZE/iT57/pQ36+sUgZoi3a3Zwi2f0GPPzkG1F9/
        28HGA+EgK78PiptBwxKX/psumEEuQ7c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-exSSwsTONA2ytq1l1qsOjw-1; Fri, 20 Jan 2023 20:39:44 -0500
X-MC-Unique: exSSwsTONA2ytq1l1qsOjw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCC4629AB434;
        Sat, 21 Jan 2023 01:39:43 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-10.pek2.redhat.com [10.72.13.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2E782166B2A;
        Sat, 21 Jan 2023 01:39:40 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Subject: [PATCH 0/2] md: Change active_io to percpu
Date:   Sat, 21 Jan 2023 09:39:35 +0800
Message-Id: <20230121013937.97576-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
  Change active_io to percpu

 drivers/md/md.c | 46 ++++++++++++++++++++++++++++++----------------
 drivers/md/md.h |  2 +-
 2 files changed, 31 insertions(+), 17 deletions(-)

-- 
2.32.0 (Apple Git-132)

