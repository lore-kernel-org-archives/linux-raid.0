Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DA1C77B75
	for <linux-raid@archiver.kernel.org>; Tue, 23 May 2023 13:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbjEWNm5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 May 2023 09:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236760AbjEWNms (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 May 2023 09:42:48 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8012BE4C
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 06:42:31 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QQb8r3Bpfz4f3kjQ
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 21:42:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP1 (Coremail) with SMTP id cCh0CgAHJzG4wmxkVTLYJQ--.25598S9;
        Tue, 23 May 2023 21:42:22 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de, logang@deltatee.com,
        song@kernel.org
Cc:     yukuai3@huawei.com, yangerkun@huawei.com
Subject: [PATCH tests 5/5] tests: add a regression test for raid456 deadlock
Date:   Tue, 23 May 2023 21:39:00 +0800
Message-Id: <20230523133900.3149123-6-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgAHJzG4wmxkVTLYJQ--.25598S9
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr1kXFyDGw45Xr17JFyftFb_yoW8ZF4kpa
        15uF1Ykr17Xw13uwsxW34UGa4F9a1kJr43Jry2ga1avFW3ZryxX3Z7Kr1YvFyxtrWSqa4k
        uwn8Ja4xKryjya7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvEb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
        Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
        rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
        AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAF
        wI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
        WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkE
        bVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
        67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42
        IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
        0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWI
        evJa73UjIFyTuYvjxUFgAwUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

The deadlock is described in [1], as the last patch described, it's
fixed first by [2], however this fix will be reverted and the deadlock
is supposed to be fixed by [3].

[1] https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
[2] https://lore.kernel.org/linux-raid/20220621031129.24778-1-guoqing.jiang@linux.dev/
[3] https://lore.kernel.org/linux-raid/20230322064122.2384589-5-yukuai1@huaweicloud.com/

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 tests/24raid456deadlock | 56 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 tests/24raid456deadlock

diff --git a/tests/24raid456deadlock b/tests/24raid456deadlock
new file mode 100644
index 00000000..161c3ab8
--- /dev/null
+++ b/tests/24raid456deadlock
@@ -0,0 +1,56 @@
+devs="$dev0 $dev1 $dev2 $dev3 $dev4 $dev5"
+runtime=120
+pid=""
+old=`cat /proc/sys/vm/dirty_background_ratio`
+
+test_write_action()
+{
+	while true; do
+		echo check > /sys/block/md0/md/sync_action &> /dev/null
+		sleep 0.1
+		echo idle > /sys/block/md0/md/sync_action &> /dev/null
+	done
+}
+
+test_write_back()
+{
+	fio -filename=$md0 -bs=4k -rw=write -numjobs=1 -name=test \
+		-time_based -runtime=$runtime &> /dev/null
+}
+
+set_up_test()
+{
+	fio -h &> /dev/null || die "fio not found"
+
+	# create a simple raid6
+	mdadm -Cv -R -n 6 -l6 $md0 $devs --assume-clean || die "create raid6 failed"
+
+	# trigger dirty pages write back
+	echo 0 > /proc/sys/vm/dirty_background_ratio
+}
+
+clean_up_test()
+{
+	echo $old > /proc/sys/vm/dirty_background_ratio
+
+	kill -9 $pid
+	sync $md0
+
+	if ! mdadm -S $md0; then
+		die "can't stop array, deadlock is probably triggered"
+	fi
+}
+
+trap 'clean_up_test' EXIT
+
+set_up_test || die "set up test failed"
+
+test_write_back &
+pid="$pid $!"
+
+test_write_action &
+pid="$pid $!"
+
+sleep $runtime
+
+exit 0
-- 
2.39.2

