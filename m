Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C430EC433E6
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 02:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98659207DF
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 02:03:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=drivescale-com.20150623.gappssmtp.com header.i=@drivescale-com.20150623.gappssmtp.com header.b="kaSyvGuY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgH1CDd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Aug 2020 22:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgH1CDc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 Aug 2020 22:03:32 -0400
Received: from mail-ot1-x361.google.com (mail-ot1-x361.google.com [IPv6:2607:f8b0:4864:20::361])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4598C061264
        for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2020 19:03:32 -0700 (PDT)
Received: by mail-ot1-x361.google.com with SMTP id i11so6173163otr.5
        for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2020 19:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=drivescale-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g9nFnjYAZDlXNDkTfFbOPrXxXNOHzyFlElzh3U9lug0=;
        b=kaSyvGuYm/YBTAAm3MNDAhO0xt3BXMy7RXgyeB0IZhM+P9JIS0pfnkFvrHnV+pc7kF
         5HKr2MYvWvfqeLjzUO+T+bbysnmHK0TEToPv+iFTOz41IRON4Hm0xlxrJeY2/gENiPGd
         ClgFnHf0+/YF0PowdakFyQt4h+nQFaYSVb69C4VDz1TO60KM3JGC85zXVPeHaMwgDp1r
         n94Ip5rZsm+sTVRmpzux6RaKATNmA9KfawKEAgsNYhKGviAo6Y0fNRpGsm8m63jZ8Omm
         Nc23SINnJlVUYqgXh+ug7G+7kZfaEE1OBtOHy91UQEtNRu4b0xqwnGP1bw9IlJnGERLW
         ikgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g9nFnjYAZDlXNDkTfFbOPrXxXNOHzyFlElzh3U9lug0=;
        b=IEcs2VCA5noyr6jJ+rYLN8sPLESB37zKDKQuwmpS9/KIUowPXaFvty16yjHxbpgZHz
         tKCEeSTJw/kKSGbo5JO3NQUJMSPWr5LrBB2G11Wxtx5BbqAhACVUiVCtiFiGEzzfFTU/
         gXr1oRIlyXMiAZYWfzUWY4PXDFkJY0oQ1TN7wS2/y0613+97Cz+G4HSh274dVHO6Sj7t
         bRs7DwxV53UgTLVC3BNZFD7tMmLxdpVi5PXDa9AXam0z07pAN+mZYhubaJdpO8JF3VNr
         9ngYvgsXIiYdTyVGsdfhen6x0jLPMMvc+f5orvXghwdgyo42Pb65CY2hxQ7VX+HAr9C7
         N0cA==
X-Gm-Message-State: AOAM533sh/jqrRoJt/LL+Cghao+kSG+BfAmoSbyc+rGMIMsddnmc3wMs
        cjIEohtBA5L36PdV3re7CkyI1tTmX0krHLCYlU54kl/xQmj3YA==
X-Google-Smtp-Source: ABdhPJzB6HF/9sDh+7RytLSEAtUV7EPozw4K8yTcFAllV7+hbl6Xwb9OY8B32O60MAkO+tqUxKM7JVppFhTJ
X-Received: by 2002:a05:6830:1c7c:: with SMTP id s28mr11049552otg.335.1598580210574;
        Thu, 27 Aug 2020 19:03:30 -0700 (PDT)
Received: from dcs.hq.drivescale.com ([68.74.115.3])
        by smtp-relay.gmail.com with ESMTP id g7sm766412ooe.11.2020.08.27.19.03.30;
        Thu, 27 Aug 2020 19:03:30 -0700 (PDT)
X-Relaying-Domain: drivescale.com
Received: from cunkel.drivescale.com (cunkel.drivescale.com [192.168.33.80])
        by dcs.hq.drivescale.com (Postfix) with ESMTP id 15838420AC;
        Fri, 28 Aug 2020 02:03:30 +0000 (UTC)
From:   Christopher Unkel <cunkel@drivescale.com>
To:     Jiri Kosina <trivial@kernel.org>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Christopher Unkel <cunkel@drivescale.com>
Subject: [PATCH] md: trivial comment typo fix
Date:   Thu, 27 Aug 2020 19:03:05 -0700
Message-Id: <20200828020305.3698463-1-cunkel@drivescale.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

"predicted", not "predicated".

Signed-off-by: Christopher Unkel <cunkel@drivescale.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 607278207023..9e5755549eb1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -29,7 +29,7 @@
      pr_crit() for error conditions that risk data loss
      pr_err() for error conditions that are unexpected, like an IO error
          or internal inconsistency
-     pr_warn() for error conditions that could have been predicated, like
+     pr_warn() for error conditions that could have been predicted, like
          adding a device to an array when it has incompatible metadata
      pr_info() for every interesting, very rare events, like an array starting
          or stopping, or resync starting or stopping
-- 
2.24.1

