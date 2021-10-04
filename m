Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3736C4332F
	for <linux-raid@archiver.kernel.org>; Mon,  4 Oct 2021 15:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D9CE61354
	for <linux-raid@archiver.kernel.org>; Mon,  4 Oct 2021 15:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235778AbhJDPmU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Oct 2021 11:42:20 -0400
Received: from out10.migadu.com ([46.105.121.227]:56757 "EHLO out10.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235763AbhJDPmP (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 4 Oct 2021 11:42:15 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1633361700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NpQ4WIx80G4vytKQ2YqQk9VHOc0qh2s6K8RIHmjWaOE=;
        b=oF/hfWK0mKBzjcT1r8XGq163LhpfN4Nwsp0wrveqma10GBAxSyBuyt4BsFxkku/FMcEeBG
        njfIxSp/l7u3t/vgWi0OxdckaUMw+McUlP7gv19U7LyBtBKYXkP1B5+TBnmaH6Kn5Rpacz
        /4CL27duDj5AhD7g4glCMiNiVYZE0ko=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 0/6] Misc changes for md
Date:   Mon,  4 Oct 2021 23:34:47 +0800
Message-Id: <20211004153453.14051-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

The first patch fixes the same calltrace as commit 6607cd319b6b ("raid1:
ensure write behind bio has less than BIO_MAX_VECS sectors") tried 
before, but unfortunately the calltrace still could happen if array
without write mostly device is configured with write-behind enabled.
So the first patch is suitable for fix branch which others are materials
for next branch.

Pls review.

Thanks,
Guoqing

Guoqing Jiang (6):
  md/raid1: only allocate write behind bio for WriteMostly device
  md/bitmap: don't set max_write_behind if there is no write mostly
    device
  md/raid1: use rdev in raid1_write_request directly
  md/raid10: add 'read_err' to raid10_read_request
  md/raid5: call roundup_pow_of_two in raid5_run
  md: remove unused argument from md_new_event

 drivers/md/md-bitmap.c | 17 +++++++++++++++++
 drivers/md/md.c        | 30 +++++++++++++++---------------
 drivers/md/md.h        |  2 +-
 drivers/md/raid1.c     | 13 ++++++-------
 drivers/md/raid10.c    | 10 +++++-----
 drivers/md/raid5.c     |  7 ++-----
 6 files changed, 46 insertions(+), 33 deletions(-)

-- 
2.31.1

