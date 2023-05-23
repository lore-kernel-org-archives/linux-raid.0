Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C95C7EE26
	for <linux-raid@archiver.kernel.org>; Tue, 23 May 2023 13:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbjEWNm6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 May 2023 09:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjEWNms (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 May 2023 09:42:48 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D741A8
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 06:42:30 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QQb8r694Kz4f3nKS
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 21:42:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP1 (Coremail) with SMTP id cCh0CgAHJzG4wmxkVTLYJQ--.25598S8;
        Tue, 23 May 2023 21:42:21 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de, logang@deltatee.com,
        song@kernel.org
Cc:     yukuai3@huawei.com, yangerkun@huawei.com
Subject: [PATCH tests 4/5] tests: add a regression test for raid10 deadlock
Date:   Tue, 23 May 2023 21:38:59 +0800
Message-Id: <20230523133900.3149123-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgAHJzG4wmxkVTLYJQ--.25598S8
X-Coremail-Antispam: 1UD129KBjvJXoWxAr1xArW3tryUWryxCF4xXrb_yoW5AFWfpw
        4UCF15Kr4xW3W3Zr13K3WUJFyFva1DArW3Aw47u3yag3y7ZFykZan7Kr1UZFWIvr40v3Wk
        u3Z0yF48Kr1j9FDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvEb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
        Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
        rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
        AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAF
        wI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
        WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkE
        bVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
        67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
        IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
        0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWI
        evJa73UjIFyTuYvjxUFgAwUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

The deadlock is described in [1], it's fixed first by [2], however,
it turns out this commit will trigger other problems[3], hence this
commit will be reverted and the deadlock is supposed to be fixed by [1].

[1] https://lore.kernel.org/linux-raid/20230322064122.2384589-5-yukuai1@huaweicloud.com/
[2] https://lore.kernel.org/linux-raid/20220621031129.24778-1-guoqing.jiang@linux.dev/
[3] https://lore.kernel.org/linux-raid/20230322064122.2384589-2-yukuai1@huaweicloud.com/

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 tests/24raid10deadlock              | 85 +++++++++++++++++++++++++++++
 tests/24raid10deadlock.inject_error |  0
 2 files changed, 85 insertions(+)
 create mode 100644 tests/24raid10deadlock
 create mode 100644 tests/24raid10deadlock.inject_error

diff --git a/tests/24raid10deadlock b/tests/24raid10deadlock
new file mode 100644
index 00000000..27869840
--- /dev/null
+++ b/tests/24raid10deadlock
@@ -0,0 +1,85 @@
+devs="$dev0 $dev1 $dev2 $dev3"
+runtime=120
+pid=""
+
+set_up_injection()
+{
+	echo -1 > /sys/kernel/debug/fail_make_request/times
+	echo 1 > /sys/kernel/debug/fail_make_request/probability
+	echo 0 > /sys/kernel/debug/fail_make_request/verbose
+	echo 1 > /sys/block/${1##*/}/make-it-fail
+}
+
+clean_up_injection()
+{
+	echo 0 > /sys/block/${1##*/}/make-it-fail
+	echo 0 > /sys/kernel/debug/fail_make_request/times
+	echo 0 > /sys/kernel/debug/fail_make_request/probability
+	echo 2 > /sys/kernel/debug/fail_make_request/verbose
+}
+
+test_rdev()
+{
+	while true; do
+		mdadm -f $md0 $1 &> /dev/null
+		mdadm -r $md0 $1 &> /dev/null
+		mdadm --zero-superblock $1 &> /dev/null
+		mdadm -a $md0 $1 &> /dev/null
+		sleep $2
+	done
+}
+
+test_write_action()
+{
+	while true; do
+		echo frozen > /sys/block/md0/md/sync_action
+		echo idle > /sys/block/md0/md/sync_action
+		sleep 0.1
+	done
+}
+
+set_up_test()
+{
+	fio -h &> /dev/null || die "fio not found"
+
+	# create a simple raid10
+	mdadm -Cv -R -n 4 -l10 $md0 $devs || die "create raid10 failed"
+}
+
+clean_up_test()
+{
+	clean_up_injection $dev0
+	kill -9 $pid
+	pkill -9 fio
+
+	sleep 1
+
+	if ! mdadm -S $md0; then
+		die "can't stop array, deadlock is probably triggered"
+	fi
+}
+
+cat /sys/kernel/debug/fail_make_request/times || die "fault injection is not enabled"
+
+trap 'clean_up_test' EXIT
+
+set_up_test || die "set up test failed"
+
+# backgroup io pressure
+fio -filename=$md0 -rw=randwrite -direct=1 -name=test -bs=4k -numjobs=16 -iodepth=16 &
+
+# trigger add/remove device by io failure
+set_up_injection $dev0
+test_rdev $dev0 2 &
+pid="$pid $!"
+
+# add/remove device directly
+test_rdev $dev3 10 &
+pid="$pid $!"
+
+test_write_action &
+pid="$pid $!"
+
+sleep $runtime
+
+exit 0
diff --git a/tests/24raid10deadlock.inject_error b/tests/24raid10deadlock.inject_error
new file mode 100644
index 00000000..e69de29b
-- 
2.39.2

