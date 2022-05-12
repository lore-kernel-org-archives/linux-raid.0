Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1A9C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 12 May 2022 09:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351908AbiELJVU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 May 2022 05:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351906AbiELJVS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 May 2022 05:21:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF80C4B852
        for <linux-raid@vger.kernel.org>; Thu, 12 May 2022 02:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652347276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y70sN459QGqWjKfYnQCeqOk4LmumDxe0b5cnMMklBjo=;
        b=LH+LOonVBqtab5wL+V9ZtDA+kXzTUKA27iBEw6RJS2tGjDnoQu2A+w+cgJwWXROFIaBbPW
        nZnN5ac65A7YZeuDEe1kVyG9Bdp9X4IqSSBGINwcA7pB9UbOIvOVehhJaF8AXjI6Mrk5xi
        tdP6Ot1CRJZqmb6cYDHT8fKZon+ySvI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-gJ3eB8hFPHaUmdlgHFaNlg-1; Thu, 12 May 2022 05:21:13 -0400
X-MC-Unique: gJ3eB8hFPHaUmdlgHFaNlg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97138801E80;
        Thu, 12 May 2022 09:21:13 +0000 (UTC)
Received: from localhost.localdomain (ovpn-14-34.pek2.redhat.com [10.72.14.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34D4156C141;
        Thu, 12 May 2022 09:21:10 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, ncroxon@redhat.com, heinzm@redhat.com,
        ffan@redhat.com
Subject: [PATCH 0/2] md: reshape from raid0 to raid10 panic
Date:   Thu, 12 May 2022 17:21:07 +0800
Message-Id: <20220512092109.41606-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It panic when reshaping from raid0 to other raid levels because of NULL
pointer dereference. This problem is introduce by patch
commit 0c031fd37f69 ("md: Move alloc/free acct bioset in to personality") 

Patch2 fixes a doulbe free memory problem introduced by the above patch.

Xiao Ni (2):
  md: Don't set mddev private to NULL in raid0 pers->free
  md: Double free io_acct_set bioset

 drivers/md/md.c    | 4 ----
 drivers/md/raid0.c | 1 -
 2 files changed, 5 deletions(-)

-- 
2.32.0 (Apple Git-132)

