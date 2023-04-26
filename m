Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE2AC77B60
	for <linux-raid@archiver.kernel.org>; Wed, 26 Apr 2023 07:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239463AbjDZHgm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 Apr 2023 03:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239381AbjDZHgl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 26 Apr 2023 03:36:41 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9D430FE
        for <linux-raid@vger.kernel.org>; Wed, 26 Apr 2023 00:36:39 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Q5rKG5Fj2z4f4TMr
        for <linux-raid@vger.kernel.org>; Wed, 26 Apr 2023 15:36:34 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP4 (Coremail) with SMTP id gCh0CgCX_7KA1EhkR5q3IA--.64549S4;
        Wed, 26 Apr 2023 15:36:34 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de, logang@deltatee.com,
        song@kernel.org
Cc:     yangerkun@huawei.com, yukuai3@huawei.com
Subject: [PATCH] tests: add a new test to check if pluged bio is unlimited for raid10
Date:   Wed, 26 Apr 2023 15:34:47 +0800
Message-Id: <20230426073447.1294916-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCX_7KA1EhkR5q3IA--.64549S4
X-Coremail-Antispam: 1UD129KBjvJXoW7WFyUGF17tr1rCFy5Ww4Durg_yoW8Zw45pF
        4fWrWY9r17Aw13twsIq3WxZFyFvrW8JFy2yrWftr17tr9xGryava4fKF4YgrW7Wr4fW34f
        uF4YgFyxKF1jyaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
        c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
        CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
        MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJV
        Cq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIY
        CTnIWIevJa73UjIFyTuYvjxUrR6zUUUUU
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

