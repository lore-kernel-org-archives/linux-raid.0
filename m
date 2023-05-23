Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC864C77B75
	for <linux-raid@archiver.kernel.org>; Tue, 23 May 2023 13:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbjEWNm7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 May 2023 09:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236858AbjEWNms (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 May 2023 09:42:48 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158CCE4F
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 06:42:32 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QQb8q0jrWz4f3kjV
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 21:42:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP1 (Coremail) with SMTP id cCh0CgAHJzG4wmxkVTLYJQ--.25598S5;
        Tue, 23 May 2023 21:42:18 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de, logang@deltatee.com,
        song@kernel.org
Cc:     yukuai3@huawei.com, yangerkun@huawei.com
Subject: [PATCH tests 1/5] tests: add a new test to check if pluged bio is unlimited for raid10
Date:   Tue, 23 May 2023 21:38:56 +0800
Message-Id: <20230523133900.3149123-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgAHJzG4wmxkVTLYJQ--.25598S5
X-Coremail-Antispam: 1UD129KBjvJXoW7WFyUGF17tr1rCFy5Ww4Durg_yoW8Zw45pF
        4fWrWY9r17Aw13twsIq3WxZFyFvrW8JFy2yrWftr17tr9xGryava4fKF4YgrW7Wr4fW34f
        uF4YgFyxKF1jyaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvlb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
        A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
        GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
        0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
        JVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
        1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
        IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
        x4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
        DU0xZFpf9x07UiAwxUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

Pluged bio is unlimited means that all submitted bio will be pluged, and
those bio won't be issued to underlaying disks until blk_finish_plug() or
blk_flush_plug(). In this case, a lot memory will be used for
raid10_bio and io latency will be very bad.

This test do some dirty pages writeback for raid10, where plug is used, and
check if device inflight counter exceed threshold.

This problem is supposed to be fixed by [1].

[1] https://lore.kernel.org/linux-raid/20230420112946.2869956-9-yukuai1@huaweicloud.com/

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 tests/22raid10plug | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 tests/22raid10plug

diff --git a/tests/22raid10plug b/tests/22raid10plug
new file mode 100644
index 00000000..fde4ce80
--- /dev/null
+++ b/tests/22raid10plug
@@ -0,0 +1,41 @@
+devs="$dev0 $dev1 $dev2 $dev3 $dev4 $dev5"
+
+# test will fail if inflight is observed to be greater
+threshold=4096
+
+# create a simple raid10
+mdadm --create --run --level=raid10 --raid-disks 6 $md0 $devs --bitmap=internal --assume-clean
+if [ $? -ne 0 ]; then
+        die "create raid10 failed"
+fi
+
+old_background=`cat /proc/sys/vm/dirty_background_ratio`
+old=`cat /proc/sys/vm/dirty_ratio`
+
+# trigger background writeback
+echo 0 > /proc/sys/vm/dirty_background_ratio
+echo 60 > /proc/sys/vm/dirty_ratio
+
+# io pressure with buffer write
+fio -filename=$md0 -ioengine=libaio -rw=write -bs=4k -numjobs=1 -iodepth=128 -name=test -runtime=10 &
+
+pid=$!
+
+sleep 2
+
+# check if inflight exceed threshold
+while true; do
+        tmp=`cat /sys/block/md0/inflight | awk '{printf("%d\n", $1 + $2);}'`
+        if [ $tmp -gt $threshold ]; then
+                die "inflight is greater than 4096"
+                break
+        elif [ $tmp -eq 0 ]; then
+                break
+        fi
+        sleep 0.1
+done
+
+kill -9 $pid
+mdadm -S $md0
+echo $old_background > /proc/sys/vm/dirty_background_ratio
+echo $old > /proc/sys/vm/dirty_ratio
-- 
2.39.2

