Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09AE0C77B7A
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 13:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjE2NcM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 09:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjE2NcJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 09:32:09 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98A08E
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 06:32:07 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QVGfD1Dyvz4f3lXL
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 21:32:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP4 (Coremail) with SMTP id gCh0CgBH_rFSqXRkMLjoKQ--.57183S5;
        Mon, 29 May 2023 21:32:05 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de, logang@deltatee.com,
        song@kernel.org, guoqing.jiang@linux.dev
Cc:     yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com
Subject: [PATCH v2 1/8] tests: add a new test for rdev lifetime
Date:   Mon, 29 May 2023 21:28:19 +0800
Message-Id: <20230529132826.2125392-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230529132826.2125392-1-yukuai1@huaweicloud.com>
References: <20230529132826.2125392-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBH_rFSqXRkMLjoKQ--.57183S5
X-Coremail-Antispam: 1UD129KBjvJXoWxJFW8Gw1DAr45KF47ur1rWFg_yoW5GFyUpr
        4I9F15Gr48Gw17AF43WF4fGF1rAa1kCF47Ars7Xr1DZF1jvw47JFyUKF1jvFnxGrZ5ZF1x
        ta4kJa1rKw17GaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
        A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
        Ij6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
        Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij64
        vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x
        0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07UC0PfUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

This test add and remove a underlying disk to raid concurretly, verify
that the following problem is fixed:

run mdadm test 23rdev-lifetime at Fri Apr 28 03:25:30 UTC 2023
md: could not open device unknown-block(1,0).
sysfs: cannot create duplicate filename '/devices/virtual/block/md0/md/dev-ram0'
CPU: 26 PID: 10521 Comm: test Not tainted 6.3.0-rc2-00134-g7b3a8828043c #115
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc37 04/014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe7/0x180
 dump_stack+0x18/0x30
 sysfs_warn_dup+0xa2/0xd0
 sysfs_create_dir_ns+0x119/0x140
 kobject_add_internal+0x143/0x4d0
 kobject_add_varg+0x35/0x70
 kobject_add+0x64/0xd0
 bind_rdev_to_array+0x254/0x840 [md_mod]
 new_dev_store+0x14d/0x350 [md_mod]
 md_attr_store+0xc1/0x1a0 [md_mod]
 sysfs_kf_write+0x51/0x70
 kernfs_fop_write_iter+0x188/0x270
 vfs_write+0x27e/0x460
 ksys_write+0x85/0x180
 __x64_sys_write+0x21/0x30
 do_syscall_64+0x6c/0xe0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f26bacf5387
Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 84
RSP: 002b:00007ffe98d79e68 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f26bacf5387
RDX: 0000000000000004 RSI: 000055bd10282bf0 RDI: 0000000000000001
RBP: 000055bd10282bf0 R08: 000000000000000a R09: 00007f26bad8b4e0
R10: 00007f26bad8b3e0 R11: 0000000000000246 R12: 0000000000000004
R13: 00007f26badc8520 R14: 0000000000000004 R15: 00007f26badc8700
 </TASK>

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 tests/23rdev-lifetime | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 tests/23rdev-lifetime

diff --git a/tests/23rdev-lifetime b/tests/23rdev-lifetime
new file mode 100644
index 00000000..1750b0db
--- /dev/null
+++ b/tests/23rdev-lifetime
@@ -0,0 +1,34 @@
+devname=${dev0##*/}
+devt=`cat /sys/block/$devname/dev`
+pid=""
+runtime=2
+
+clean_up_test() {
+	pill -9 $pid
+	echo clear > /sys/block/md0/md/array_state
+}
+
+trap 'clean_up_test' EXIT
+
+add_by_sysfs() {
+        while true; do
+                echo $devt > /sys/block/md0/md/new_dev
+        done
+}
+
+remove_by_sysfs(){
+        while true; do
+                echo remove > /sys/block/md0/md/dev-${devname}/state
+        done
+}
+
+echo md0 > /sys/module/md_mod/parameters/new_array || die "create md0 failed"
+
+add_by_sysfs &
+pid="$pid $!"
+
+remove_by_sysfs &
+pid="$pid $!"
+
+sleep $runtime
+exit 0
-- 
2.39.2

