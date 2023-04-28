Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D7DC77B60
	for <linux-raid@archiver.kernel.org>; Fri, 28 Apr 2023 06:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjD1Gap (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Apr 2023 02:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjD1Gao (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Apr 2023 02:30:44 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E542711
        for <linux-raid@vger.kernel.org>; Thu, 27 Apr 2023 23:30:42 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Q72mD5zDbz4f3mJB
        for <linux-raid@vger.kernel.org>; Fri, 28 Apr 2023 14:30:36 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP1 (Coremail) with SMTP id cCh0CgAXNzEMaEtkjh9BHw--.12942S4;
        Fri, 28 Apr 2023 14:30:38 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de, logang@deltatee.com,
        song@kernel.org
Cc:     yukuai3@huawei.com, yangerkun@huawei.com
Subject: [PATCH] tests: add a new test for rdev lifetime
Date:   Fri, 28 Apr 2023 14:28:45 +0800
Message-Id: <20230428062845.1975462-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgAXNzEMaEtkjh9BHw--.12942S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJFW8Gw1DAr45KF47ur1rWFg_yoW5Ar15pr
        4I9F15Gr48Gr12yF4aka1fWF1rAa1kCF47Ars7Xr15ZFyj9w17XFyDKF1UAF9xGrZ5Zw1S
        ya4kJayrKr47GaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
        c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
        CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
        MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6r
        W3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUv
        cSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
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

