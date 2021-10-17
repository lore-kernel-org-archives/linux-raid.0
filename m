Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5BB5C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 17 Oct 2021 13:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3A2A61078
	for <linux-raid@archiver.kernel.org>; Sun, 17 Oct 2021 13:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343772AbhJQNw7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 17 Oct 2021 09:52:59 -0400
Received: from out2.migadu.com ([188.165.223.204]:45928 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230400AbhJQNw6 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 17 Oct 2021 09:52:58 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1634478647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6nGv7NctthI/NWFYstPCCtcHKnQSXPvjCQCKjE74sdE=;
        b=VJ/frogUQvM/uDtd1IiS+obzprAb/qlWzIoVNvbDS8oZJ0gySIoZFpzosrlZ12GY8phUho
        e9aR0U+/D01Jyj7RpILkUZ9tGeToylXF2DQGr8avCbPY0N4dAr0TGWW2A3cUOEsIa2fJ/h
        qEf9TNoaz44A/QqL3nvfDxwAF8iEPLg=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 0/3] Misc changes for md again
Date:   Sun, 17 Oct 2021 21:50:16 +0800
Message-Id: <20211017135019.27346-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

This patchset addresses previous comment, please review.

Thanks,
Guoqing

Guoqing Jiang (3):
  md/bitmap: don't set max_write_behind if there is no write mostly
    device
  md/raid10: add 'read_err' to raid10_read_request
  md/raid10: factor out a get_error_dev helper

 drivers/md/md-bitmap.c | 18 +++++++++++++++
 drivers/md/raid10.c    | 52 ++++++++++++++++++++++--------------------
 2 files changed, 45 insertions(+), 25 deletions(-)

-- 
2.31.1

