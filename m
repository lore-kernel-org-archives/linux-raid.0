Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFCEC7EE26
	for <linux-raid@archiver.kernel.org>; Tue, 23 May 2023 13:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbjEWNms (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 May 2023 09:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbjEWNmq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 May 2023 09:42:46 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A061A4
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 06:42:30 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QQb8q2jT6z4f3lKK
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 21:42:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP1 (Coremail) with SMTP id cCh0CgAHJzG4wmxkVTLYJQ--.25598S6;
        Tue, 23 May 2023 21:42:21 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de, logang@deltatee.com,
        song@kernel.org
Cc:     yukuai3@huawei.com, yangerkun@huawei.com
Subject: [PATCH tests 2/5] tests: add a new test for rdev lifetime
Date:   Tue, 23 May 2023 21:38:57 +0800
Message-Id: <20230523133900.3149123-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgAHJzG4wmxkVTLYJQ--.25598S6
X-Coremail-Antispam: 1UD129KBjvJXoWxJFW8Gw1DAr45KF47ur1rWFg_yoW5Ar15pr
        4I9F15Gr48Gr12yF4aka1fWF1rAa1kCF47Ars7Xr15ZFyj9w17XFyDKF1UAF9xGrZ5Zw1S
        ya4kJayrKr47GaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvGb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
        A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
        GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
        0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
        JVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
        1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
        IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
        x4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa
        73UjIFyTuYvjxU2GYLDUUUU
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
 tests/23rdev-lifetime | 48 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 tests/23rdev-lifetime

diff --git a/tests/23rdev-lifetime b/tests/23rdev-lifetime
new file mode 100644
index 00000000..df0fcdd9
--- /dev/null
+++ b/tests/23rdev-lifetime
@@ -0,0 +1,48 @@
+devname=${dev0##*/}
+devt=`cat /sys/block/$devname/dev`
+dmesg_marker="run mdadm test 23rdev-lifetime at `date`"
+pid1=0
+pid2=0
+
+stop() {
+        if [[ $1 -ne 0 ]]; then
+                kill -9 $1
+        fi
+}
+
+trap 'stop $pid1; stop $pid2;' EXIT
+
+echo "$dmesg_marker" >> /dev/kmsg
+
+check_dmesg() {
+        dmesg | grep -A 9999 "$dmesg_marker" | grep "sysfs: cannot create duplicate filename"
+
+        if [[ $? -eq 0 ]]; then
+                die "sysfs dumplicate"
+        fi
+}
+
+add_by_sysfs() {
+        while true; do
+                echo $devt > /sys/block/md0/md/new_dev
+                check_dmesg
+        done
+}
+
+remove_by_sysfs(){
+        while true; do
+                echo remove > /sys/block/md0/md/dev-${devname}/state
+                check_dmesg
+        done
+}
+
+echo md0 > /sys/module/md_mod/parameters/new_array || die "create md0 failed"
+
+add_by_sysfs &
+pid1=$!
+
+remove_by_sysfs &
+pid2=$!
+
+sleep 5
+echo clear > /sys/block/md0/md/array_state
-- 
2.39.2

