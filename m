Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7196E7E62B
	for <linux-raid@archiver.kernel.org>; Wed, 27 Sep 2023 04:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjI0EQO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Sep 2023 00:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjI0EPF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Sep 2023 00:15:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B02A46A4
        for <linux-raid@vger.kernel.org>; Tue, 26 Sep 2023 19:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695783146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=T+b1Tyz7Ht1YD5JsR9O73FfMsju1fzTy6rbQamZFMfI=;
        b=hKm/Z5Q1gGxZf7uwq72j7gtkWXFYMOCxrHM+lsvTB6bKg4/AeayiSh2skENzEVz9QmLlnS
        Q5NLn5J2Air4qPkY3rElv/OYfCE4HR+lx9dzqLl4nf9HzPowZ66urCg5hrLKnBWXmL4UCm
        n2i2wX0j80r9CFRT/WWPUu0+feV3ETM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-6rR7UKznNTm61IwDiKIKHA-1; Tue, 26 Sep 2023 22:52:22 -0400
X-MC-Unique: 6rR7UKznNTm61IwDiKIKHA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99188811E7D;
        Wed, 27 Sep 2023 02:52:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28E6A2156702;
        Wed, 27 Sep 2023 02:52:20 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 0/4] mdadm: Fix some errors for regression tests and building
Date:   Wed, 27 Sep 2023 10:52:15 +0800
Message-Id: <20230927025219.49915-1-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The first two patches are for test cases.
The thrid is a fix for building error.
The forth fixes an output problem.

Xiao Ni (4):
  Fix regular expression failure
  mdadm/tests: Don't run mknod before losetup
  Avoid array bounds check of gcc
  Print version to stdout

 Makefile      | 2 +-
 mdadm.c       | 2 +-
 tests/06name  | 4 ++--
 tests/func.sh | 1 -
 4 files changed, 4 insertions(+), 5 deletions(-)

-- 
2.32.0 (Apple Git-132)

