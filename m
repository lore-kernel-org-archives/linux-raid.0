Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE18C43331
	for <linux-raid@archiver.kernel.org>; Tue, 29 Dec 2020 09:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15272207D1
	for <linux-raid@archiver.kernel.org>; Tue, 29 Dec 2020 09:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgL2J3O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Dec 2020 04:29:14 -0500
Received: from mail.synology.com ([211.23.38.101]:43864 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726166AbgL2J3K (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 29 Dec 2020 04:29:10 -0500
Received: from localhost.localdomain (unknown [10.17.198.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id 07179CE781A0;
        Tue, 29 Dec 2020 17:21:11 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1609233671; bh=32wEpt+o16XR2yhAXOPLZ3KuX9QlbNXlE2s9KIpvWw0=;
        h=From:To:Cc:Subject:Date;
        b=aOOBj8S8ahSnLersQy/26iOI8ZK9ENJzkcAMrTMfZgqH5vaVMbxkLXpXM4e7WwR9s
         RSRMeVP8CjKwYktRrOiS0IuXBdjfuQiUxq/8BDn6NUp+rrcqbVvCkT+43sbxef36x2
         cbBH174IR9/bloHwqZEE9d/Rp71+N7MKy0jFtcg0=
From:   dannyshih <dannyshih@synology.com>
To:     axboe@kernel.dk
Cc:     agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        song@kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, Danny Shih <dannyshih@synology.com>
Subject: [PATCH 0/4] Fix order when split bio and send remaining back to itself
Date:   Tue, 29 Dec 2020 17:18:38 +0800
Message-Id: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
X-Mailer: git-send-email 2.7.4
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Danny Shih <dannyshih@synology.com>

We found out that split bios might handle not in order when a big bio
had split by blk_queue_split() and also split in stacking block device,
such as md device because chunk size boundary limit.

Stacking block device normally use submit_bio_noacct() add the remaining
bio to current->bio_list's tail after they split original bio. Therefore,
when bio split first time, the last part of bio was add to bio_list.
After then, when bio split second time, the middle part of bio was add to
bio_list. Results that the middle part is now behind the last part of bio.

For example:
	There is a RAID0 md device, with max_sectors_kb = 2 KB,
	and chunk_size = 1 KB

	1. a read bio come to md device wants to read 0-7 KB
	2. In blk_queue_split(), bio split into (0-1), (2-7),
	   and send (2-7) back to md device

	   current->bio_list = bio_list_on_stack[0]: (md 2-7)
	3. RAID0 split bio (0-1) into (0) and (1), since chunk size is 1 KB
	   and send (1) back to md device

	   bio_list_on_stack[0]: (md 2-7) -> (md 1)
	4. remap and send (0) to lower layer device

	   bio_list_on_stack[0]: (md 2-7) -> (md 1) -> (lower 0)
	5. __submit_bio_noacct() sorting bio let lower bio handle firstly
	   bio_list_on_stack[0]: (lower 0) -> (md 2-7) -> (md 1)
	   pop (lower 0)
	   move bio_list_on_stack[0] to bio_list_on_stack[1]

	   bio_list_on_stack[1]: (md 2-7) -> (md 1)
	6. after handle lower bio, it handle (md 2-7) firstly, and split
	   in blk_queue_split() into (2-3), (4-7), send (4-7) back

	   bio_list_on_stack[0]: (md 4-7)
	   bio_list_on_stack[1]: (md 1)
	7. RAID0 split bio (2-3) into (2) and (3) and send (3) back

	   bio_list_on_stack[0]: (md 4-7) -> (md 3)
	   bio_list_on_stack[1]: (md 1)
	...
	In the end, the split bio handle's order will become
	0 -> 2 -> 4 -> 6 -> 7 -> 5 -> 3 -> 1

Reverse the order of same queue bio when sorting bio in
__submit_bio_noacct() can solve this issue, but it might influence
too much. So we provide alternative version of submit_bio_noacct(),
named submit_bio_noacct_add_head(), for the case which need to add bio
to the head of current->bio_list. And replace submit_bio_noacct() with
submit_bio_noacct_add_head() in block device layer when we want to
split bio and send remaining back to itself.

Danny Shih (4):
  block: introduce submit_bio_noacct_add_head
  block: use submit_bio_noacct_add_head for split bio sending back
  dm: use submit_bio_noacct_add_head for split bio sending back
  md: use submit_bio_noacct_add_head for split bio sending back

 block/blk-core.c       | 44 +++++++++++++++++++++++++++++++++-----------
 block/blk-merge.c      |  2 +-
 block/bounce.c         |  2 +-
 drivers/md/dm.c        |  2 +-
 drivers/md/md-linear.c |  2 +-
 drivers/md/raid0.c     |  4 ++--
 drivers/md/raid1.c     |  4 ++--
 drivers/md/raid10.c    |  4 ++--
 drivers/md/raid5.c     |  2 +-
 include/linux/blkdev.h |  1 +
 10 files changed, 45 insertions(+), 22 deletions(-)

-- 
2.7.4

