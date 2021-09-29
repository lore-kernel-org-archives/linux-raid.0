Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC78DC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 30 Sep 2021 07:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5457615E1
	for <linux-raid@archiver.kernel.org>; Thu, 30 Sep 2021 07:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348462AbhI3HGE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 30 Sep 2021 03:06:04 -0400
Received: from f1.1azy.net ([104.244.74.192]:49916 "EHLO
        home.thecybershadow.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233661AbhI3HGD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 30 Sep 2021 03:06:03 -0400
X-Greylist: delayed 81779 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Sep 2021 03:06:03 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=home.thecybershadow.net; s=home; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CSg3qcUoUV34e9hqCIHB3KWfzLPdTdxdjadKcL6YrWE=; b=tGbx9m4IKyJ69tqp56057r1Y3A
        5aAzWrMsIM5FVjHiJGlGn4Gb9AVuG4ufH8G0XZ2JhsFspEIdqkeqL2/kK6xqxW6IS0uLlZIs8wRZI
        qIJElqiKKG3aXSFpNYbWNndCPiTysy63gGW7oo55xVPGCKOS87KUvo6+rltIqcXBN5ZU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cy.md;
        s=home; h=Sender:Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CSg3qcUoUV34e9hqCIHB3KWfzLPdTdxdjadKcL6YrWE=; b=wkcRZMLRdbAqkBDnhA/E1Xu6yb
        P8Baaw8RhOmzwd8NUz5LOpvhakvEqs0797rBG7j9Ynbb+KXmgnOMuueGGdrbwWrsOqDjgZUUZgdqI
        srXjOG4OpUnWgKrN8CJy/taJvXf1BjXTBvMg2pr7RTIgDi4yCjbM/0fHPF1xXNa9dUQ0=;
Received: from vladimir by home.thecybershadow.net with local (Exim 4.94.2)
        (envelope-from <vladimir@home.thecybershadow.net>)
        id 1mVUq9-006Ekc-1L; Wed, 29 Sep 2021 08:21:21 +0000
From:   Vladimir Panteleev <git@cy.md>
To:     linux-raid@vger.kernel.org
Cc:     Vladimir Panteleev <git@cy.md>
Subject: [PATCH] mdadm.8: Copy --no-degraded clarification from --help output
Date:   Wed, 29 Sep 2021 08:21:13 +0000
Message-Id: <20210929082113.1486453-1-git@cy.md>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender:  <vladimir@home.thecybershadow.net>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Make it easier to discover this POLA violation.
---
 mdadm.8.in | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mdadm.8.in b/mdadm.8.in
index 96846035..74cca534 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1159,6 +1159,12 @@ are present.  This is only needed with
 and can be used if the physical connections to devices are
 not as reliable as you would like.
 
+Note that "all expected drives" means as many as were present the last
+time the array was running as recorded in the superblock.  If the
+array was already degraded, and the missing device is not a new
+problem, it will still be assembled.  It is only newly missing devices
+that cause the array not to be started.
+
 .TP
 .BR \-a ", " "\-\-auto{=no,yes,md,mdp,part}"
 See this option under Create and Build options.
-- 
2.33.0

