Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68AF2C77B7A
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 13:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjE2NcU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 09:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjE2NcN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 09:32:13 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8239BDF
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 06:32:11 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QVGfH0swbz4f3nxN
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 21:32:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP4 (Coremail) with SMTP id gCh0CgBH_rFSqXRkMLjoKQ--.57183S12;
        Mon, 29 May 2023 21:32:08 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de, logang@deltatee.com,
        song@kernel.org, guoqing.jiang@linux.dev
Cc:     yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com
Subject: [PATCH v2 8/8] tests: add a regression test for raid456 deadlock again
Date:   Mon, 29 May 2023 21:28:26 +0800
Message-Id: <20230529132826.2125392-9-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230529132826.2125392-1-yukuai1@huaweicloud.com>
References: <20230529132826.2125392-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBH_rFSqXRkMLjoKQ--.57183S12
X-Coremail-Antispam: 1UD129KBjvJXoW7tw43Ar1xCF13uw13Zr1DZFb_yoW8JFy5pa
        y3CF9Ikr48ZFnIv39xW3W8JFyrCa4kGrW5J3srJw1IvFW7Zr1xXw13Kr15Xry3Jr4xAayD
        u3s5Ga4fKw109aUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBSb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
        Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
        rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267
        AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
        14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
        xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
        z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2
        Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
        6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0x
        vE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAI
        cVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2js
        IEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUoeOJUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

This is a regression test for commit ("md/raid5: fix a deadlock in the
case that reshape is interrupted").

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 tests/25raid456-reshape-deadlock | 34 ++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 tests/25raid456-reshape-deadlock

diff --git a/tests/25raid456-reshape-deadlock b/tests/25raid456-reshape-deadlock
new file mode 100644
index 00000000..bfa0cc56
--- /dev/null
+++ b/tests/25raid456-reshape-deadlock
@@ -0,0 +1,34 @@
+devs="$dev0 $dev1 $dev2"
+
+set_up_test()
+{
+	mdadm -Cv -R -n 3 -l5 $md0 $devs --size=50M || die "create array failed"
+	mdadm -a $md0 $dev3 || die "failed to bind new disk to array"
+	echo 1000 > /sys/block/md0/md/sync_speed_max
+}
+
+clean_up_test()
+{
+	echo idle > /sys/block/md0/md/sync_action
+	mdadm -S $md0
+}
+
+trap 'clean_up_test' EXIT
+
+set_up_test || die "set up test failed"
+
+# trigger reshape
+mdadm --grow -l 6 $md0
+sleep 1
+
+# stop reshape
+echo frozen > /sys/block/md0/md/sync_action
+
+# read accross reshape
+dd if=$md0 of=/dev/NULL bs=1m count=100 iflag=direct &> /dev/null &
+sleep 2
+
+# suspend array
+echo 1 > /sys/block/md0/md/suspend_lo
+
+exit 0
-- 
2.39.2

