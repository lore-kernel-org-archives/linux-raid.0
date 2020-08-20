Return-Path: <SRS0=xKAG=B6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF85C433DF
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47DF720658
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbgHTNXm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Aug 2020 09:23:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10237 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728320AbgHTNVw (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Aug 2020 09:21:52 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7F1333E67B33E40D2BA2;
        Thu, 20 Aug 2020 21:21:51 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 20 Aug 2020
 21:21:41 +0800
From:   Yufen Yu <yuyufen@huawei.com>
To:     <song@kernel.org>
CC:     <linux-raid@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH v2 00/10] Save memory for stripe_head buffer
Date:   Thu, 20 Aug 2020 09:22:04 -0400
Message-ID: <20200820132214.3749139-1-yuyufen@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, all

 In current implementation, grow_buffers() uses alloc_page() to allocate
 the buffers for each stripe_head, i.e. allocate a page for each dev[i]
 in stripe_head.
 
 After setting stripe_size as a configurable value by writing sysfs entry,
 it means that we always allocate 64K buffers, but just use 4K of them when
 stripe_size is 4K in 64KB arm64.
 
 To save memory, we try to let multiple buffers of stripe_head to share only
 one real page when page size is bigger than stripe_size. Detail can be
 seen in patch 8.
 
 This patch set is subsequent optimization for configurable stripe_size,
 which based on the origin patches[1] but reorganized them.

 Patch 1 is a fixes patch to make sure stripe_size as power of two.

 Patch 2 try to replace current page offset '0' with dev[i].offset.
 Patch 3 ~ 7 let xor compute, syndrome and recovery functions support
 different page offset for raid456. All of these patch are preparing
 for shared page. There is no functional change.

 Patch 8 ~ 10 actually implement shared page between multiple devices of
 stripe_head. But they only make sense for PAGE_SIZE != 4096, likely, 64KB arm64
 system. It doesn't make any difference for PAGE_SIZE == 4096 system, likely x86.

 We have run tests of mdadm for raid456 and test raid6test module. 
 Not found obvious errors.

[1] https://www.spinics.net/lists/raid/msg65018.html

V2:
  * Add a fixes patch for stripe_size.
  * Merge some patch together to avoid building failed. 
  * Pass disks number to init_stripe_shared_pages() rather than
    using conf->raid_disks, which is not correct on resize_stripes().

Yufen Yu (10):
  md/raid5: make sure stripe_size as power of two
  md/raid5: add a new member of offset into r5dev
  md/raid5: make async_copy_data() to support different page offset
  md/raid5: add new xor function to support different page offset
  md/raid5: convert to new xor compution interface
  md/raid6: let syndrome computor support different page offset
  md/raid6: let async recovery function support different page offset
  md/raid5: let multiple devices of stripe_head share page
  md/raid5: resize stripe_head when reshape array
  md/raid5: reallocate page array after setting new stripe_size

 crypto/async_tx/async_pq.c          |  72 ++++---
 crypto/async_tx/async_raid6_recov.c | 163 +++++++++++-----
 crypto/async_tx/async_xor.c         | 120 ++++++++++--
 crypto/async_tx/raid6test.c         |  24 ++-
 drivers/md/raid5.c                  | 281 ++++++++++++++++++++++++----
 drivers/md/raid5.h                  |  29 ++-
 include/linux/async_tx.h            |  23 ++-
 7 files changed, 573 insertions(+), 139 deletions(-)

-- 
2.25.4

