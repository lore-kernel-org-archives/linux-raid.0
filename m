Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275BFC7EE2F
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 13:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjE2NcP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 09:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjE2NcL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 09:32:11 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730DD90
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 06:32:09 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QVGfF5kl1z4f3pG6
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 21:32:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP4 (Coremail) with SMTP id gCh0CgBH_rFSqXRkMLjoKQ--.57183S7;
        Mon, 29 May 2023 21:32:06 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de, logang@deltatee.com,
        song@kernel.org, guoqing.jiang@linux.dev
Cc:     yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com
Subject: [PATCH v2 3/8] tests: add a regression test for raid10 deadlock
Date:   Mon, 29 May 2023 21:28:21 +0800
Message-Id: <20230529132826.2125392-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230529132826.2125392-1-yukuai1@huaweicloud.com>
References: <20230529132826.2125392-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBH_rFSqXRkMLjoKQ--.57183S7
X-Coremail-Antispam: 1UD129KBjvJXoWxAr1xArW3tryUWryxCF4xXrb_yoW5CFWUpw
        4UuFy5KrWxW3W3Xr13Ga1UJFyFva1DArW3A347u3y3K3y7ZFyvvan7Kry5ZFZ2vr40yw1k
        u3Z0kF48Kr1j9FUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUB2b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
        A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
        Ij6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
        Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij64
        vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF
        04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7
        CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUOlksDUUUU
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
 tests/24raid10deadlock              | 88 +++++++++++++++++++++++++++++
 tests/24raid10deadlock.inject_error |  0
 2 files changed, 88 insertions(+)
 create mode 100644 tests/24raid10deadlock
 create mode 100644 tests/24raid10deadlock.inject_error

diff --git a/tests/24raid10deadlock b/tests/24raid10deadlock
new file mode 100644
index 00000000..ee330aa9
--- /dev/null
+++ b/tests/24raid10deadlock
@@ -0,0 +1,88 @@
+devs="$dev0 $dev1 $dev2 $dev3"
+runtime=120
+pid=""
+action_pid=""
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
+	pkill -9 fio
+	kill -9 $pid
+	kill -9 $action_pid
+
+	sleep 1
+
+	if ps $action_pid | tail -1 | awk '{print $3}' | grep D; then
+		die "thread that is writing sysfs is stuck in D state, deadlock is triggered"
+	fi
+	mdadm -S $md0
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
+action_pid="$!"
+
+sleep $runtime
+
+exit 0
diff --git a/tests/24raid10deadlock.inject_error b/tests/24raid10deadlock.inject_error
new file mode 100644
index 00000000..e69de29b
-- 
2.39.2

