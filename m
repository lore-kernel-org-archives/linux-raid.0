Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82054C2B9F8
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C0F961284
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhEYJsc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 May 2021 05:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbhEYJsc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 May 2021 05:48:32 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD8CC061574
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:46:56 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 29so11197543pgu.11
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kPRHGaKo+1TUehcmhBygW/BiSKjHi9fG/yzuVWo2vm4=;
        b=T7eMUca4fXyM3AhY3kmIiVtj9Fd3wrn9xHRDKstJ4m5YnH97pgc1doYGLwEWYRCfIB
         /2IhFBq0rzdvSi0H3AJ/SGdv6h+259r1E6Mz1gOa0WKIDOcf1ski0kY6fRcqYf66OtTM
         DvX5suI1ckayPjqvXWQppgn3WJwqFjAplg6FtIZdjNq6AruIZuuXAB61HJ8VqBNGwHtH
         9Z2TFLu0Z/mJn+xCD2Adrur7VOYLXLbBk4H80PbIxHJfwGkLv7h4FlGmNzDHAQRyK/gy
         Z4QSFKMgYyK90WCA1ohCk7G2ACbkSum7I/IeNO0ju+TQwAVQ26JU/pGS+i0zivk1naqe
         dCYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kPRHGaKo+1TUehcmhBygW/BiSKjHi9fG/yzuVWo2vm4=;
        b=dvpFTUZ5bhc1aU/iP7SWwYjfnnoGh758sNo8uhJHBbvHYQ6j6FvJlcc0dVCsChKjAR
         JnNtVjig216ZRraUHKoYazoi89oKON+eIlRs6RufbZTVEedBO0IW9Bj+OcVqN67sWByy
         W9qj0HQNJdOkTkuIMWgIIdA+zGFHuS4d04lRNK6Bp8DTBlBxq3Q/Hz15/UyediWlyh5m
         uEprU69uUFHFyE+OT/yVqWx9B0cfjWgx3xsOBTa5jkGf+XOwmxto5im7aV6uSeTvTwWs
         jia3iOCFsHAuIs5bLeAEGa0Qv2/E+LFRD/OsLnerxgEF5kxvpQeSJi0nxASSPNnWY/0k
         1vlA==
X-Gm-Message-State: AOAM533qRYjwbE0x3Y93s6Jq/bvZf8gEOs61CaospE3M75dtuMcV7SOQ
        OkgnPkB39hPucV8bMGWa/TY=
X-Google-Smtp-Source: ABdhPJwpy3Q2ABxUj+noKsh3X4lvW9jcdbwGIau7E3I+RFgmbIXMyeHMg2CV6WsNp8+v7NbcEU+HVQ==
X-Received: by 2002:a63:5205:: with SMTP id g5mr13654977pgb.49.1621936015985;
        Tue, 25 May 2021 02:46:55 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id r10sm13114437pfl.159.2021.05.25.02.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 02:46:55 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com,
        hch@infradead.org
Subject: [PATCH V3 0/6] md: io stats accounting
Date:   Tue, 25 May 2021 17:46:15 +0800
Message-Id: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

V3 changes:

1. For raid0 and raid5, move clone bio into personality layers.
2. add two patches for raid5 to avoid copy chunk read bio twice.

V2 changes:

1. add accounting_bio to md_personality.
2. cleanup in case bioset_integrity_create fails.
3. use bio_end_io_acct.
4. remove patch for enable io accounting for multipath.
5. add one patch to rename print_msg.
6. add one patch to deprecate linear, multipath and faulty.

Guoqing Jiang (8):
  md: revert io stats accounting
  md: add io accounting for raid0 and raid5
  md/raid5: move checking badblock before clone bio in
    raid5_read_one_chunk
  md/raid5: avoid redundant bio clone in raid5_read_one_chunk
  md/raid1: rename print_msg with r1bio_existed
  md/raid1: enable io accounting
  md/raid10: enable io accounting
  md: mark some personalities as deprecated

 drivers/md/Kconfig        |  6 +--
 drivers/md/md-faulty.c    |  2 +-
 drivers/md/md-linear.c    |  2 +-
 drivers/md/md-multipath.c |  2 +-
 drivers/md/md.c           | 89 +++++++++++++++++++--------------------
 drivers/md/md.h           |  9 +++-
 drivers/md/raid0.c        |  3 ++
 drivers/md/raid1.c        | 15 +++++--
 drivers/md/raid1.h        |  1 +
 drivers/md/raid10.c       |  6 +++
 drivers/md/raid10.h       |  1 +
 drivers/md/raid5.c        | 34 +++++++++------
 12 files changed, 101 insertions(+), 69 deletions(-)

-- 
2.25.1

