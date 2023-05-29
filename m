Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365F8C77B7E
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 13:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjE2NcN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 09:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjE2NcJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 09:32:09 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B31B7
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 06:32:08 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QVGfC6B0kz4f3nJc
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 21:32:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP4 (Coremail) with SMTP id gCh0CgBH_rFSqXRkMLjoKQ--.57183S4;
        Mon, 29 May 2023 21:32:04 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de, logang@deltatee.com,
        song@kernel.org, guoqing.jiang@linux.dev
Cc:     yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com
Subject: [PATCH tests v2 0/8] tests: add some regression tests
Date:   Mon, 29 May 2023 21:28:18 +0800
Message-Id: <20230529132826.2125392-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBH_rFSqXRkMLjoKQ--.57183S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw4rKrW3Jw4UtFW8WFyUJrb_yoW8CF1kp3
        95XFnxKw4xA3W2vanxJr1kXa4Fg3y8Gry5CwnFqa1xZ34jvr1UA3W2gr1jqrZ3Wr4DX34U
        Z3s5WFyrKr1UKa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkSb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28I
        cxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
        IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI
        42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIx
        AIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUOyCJDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

Total 7 regression test is added:

 - 23rdev-lifetime
 - 25raid456-recovery-while-reshape
 - 25raid456-reshape-corrupt-data
 - 25raid456-reshape-deadlock
fixed patches is applied for above tests.

 - 25raid456-reshape-while-recovery
 - 24raid10deadlock
 - 24raid456deadlock
fixed patches is not merged yet, and they're still in maillist.

Changes in v2:
 - use new way to judge if test failed for patch 1,34
 - add four new tests, patch 5-8

Yu Kuai (8):
  tests: add a new test for rdev lifetime
  tests: support to skip checking dmesg
  tests: add a regression test for raid10 deadlock
  tests: add a regression test for raid456 deadlock
  tests: add a regression test that raid456 can't assemble
  tests: add a regression test that raid456 can't assemble again
  tests: add a regression test that reshape can corrupt data
  tests: add a regression test for raid456 deadlock again

 test                                   |  8 ++-
 tests/23rdev-lifetime                  | 34 ++++++++++
 tests/24raid10deadlock                 | 88 ++++++++++++++++++++++++++
 tests/24raid10deadlock.inject_error    |  0
 tests/24raid456deadlock                | 58 +++++++++++++++++
 tests/25raid456-recovery-while-reshape | 33 ++++++++++
 tests/25raid456-reshape-corrupt-data   | 35 ++++++++++
 tests/25raid456-reshape-deadlock       | 34 ++++++++++
 tests/25raid456-reshape-while-recovery | 32 ++++++++++
 9 files changed, 320 insertions(+), 2 deletions(-)
 create mode 100644 tests/23rdev-lifetime
 create mode 100644 tests/24raid10deadlock
 create mode 100644 tests/24raid10deadlock.inject_error
 create mode 100644 tests/24raid456deadlock
 create mode 100644 tests/25raid456-recovery-while-reshape
 create mode 100644 tests/25raid456-reshape-corrupt-data
 create mode 100644 tests/25raid456-reshape-deadlock
 create mode 100644 tests/25raid456-reshape-while-recovery

-- 
2.39.2

