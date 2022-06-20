Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04632C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 16:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239169AbiFTQLW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 12:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiFTQLV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 12:11:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366EE205D6
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 09:11:21 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DCCF71F74D;
        Mon, 20 Jun 2022 16:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655741479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=mrcE5xGna+WC7f3ZNxxmDTuk4A+Bl7I28JZMYCyJmDs=;
        b=Ceh7Vc8gQrWc1IrLsbA6AiQkcn2xu62H3X9C3lZFzXmMP2yYWOyrEz8AMh2ZDb8FfTyct+
        34uSL7wqgENehEX8vdqo0aZ+25reb1rDtRvQ2sJIq3uCFzgNChIu6MSGpDkGNKyVSYbuFA
        U4uOPm7BE1o+puOlQ6Hsq+pkSF/XBd8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655741479;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=mrcE5xGna+WC7f3ZNxxmDTuk4A+Bl7I28JZMYCyJmDs=;
        b=h6BCogXSnxlCg/ElhjMcq8MjZf74XH6JWXjtvkX4kd61nIVnHJgjEia6sFzXEfc7aeEFZ3
        cooho4D+MncM1TCw==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 67A642C141;
        Mon, 20 Jun 2022 16:11:16 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 0/6] mdadm-CI for-jes/20220620: patches for merge
Date:   Tue, 21 Jun 2022 00:10:37 +0800
Message-Id: <20220620161043.3661-1-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,

The following patches are reviewed by me, and pass roughly testing by
imsm array creation/stop/failure.

I post all the patches to mailing list, so that they may appear on
patchwork list.

Please consider to take them to mdadm upstream.

Thanks.

Coly Li
---

Heming Zhao (1):
  mdadm/super1: restore commit 45a87c2f31335 to fix clustered slot issue

Kinga Tanska (1):
  util: replace ioctl use with function

Mariusz Tkaczyk (3):
  imsm: introduce get_disk_slot_in_dev()
  imsm: use same slot across container
  imsm: block changing slots during creation

Nigel Croxon (1):
  Revert "mdadm: fix coredump of mdadm --monitor -r"

 ReadMe.c             |   6 +-
 super-intel.c        | 249 ++++++++++++++++++++++++++++---------------
 super1.c             |  12 ++-
 tests/09imsm-overlap |  28 -----
 util.c               |   2 +-
 5 files changed, 181 insertions(+), 116 deletions(-)
 delete mode 100644 tests/09imsm-overlap

-- 
2.35.3

