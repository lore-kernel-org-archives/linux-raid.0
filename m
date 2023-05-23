Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F8EC7EE23
	for <linux-raid@archiver.kernel.org>; Tue, 23 May 2023 13:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbjEWNmu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 May 2023 09:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236491AbjEWNmr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 May 2023 09:42:47 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E53E47
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 06:42:31 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QQb8r3gymz4f3mJM
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 21:42:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP1 (Coremail) with SMTP id cCh0CgAHJzG4wmxkVTLYJQ--.25598S7;
        Tue, 23 May 2023 21:42:21 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de, logang@deltatee.com,
        song@kernel.org
Cc:     yukuai3@huawei.com, yangerkun@huawei.com
Subject: [PATCH tests 3/5] tests: support to skip checking dmesg
Date:   Tue, 23 May 2023 21:38:58 +0800
Message-Id: <20230523133900.3149123-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgAHJzG4wmxkVTLYJQ--.25598S7
X-Coremail-Antispam: 1UD129KBjvdXoW7XFykJFyDtFyrKw4kuF4kWFg_yoWfZFc_tF
        yS9a4kWr45CFnrKw1avF1qvFsYk3y3Wr1xuryqkFy5XFy5uF18KFWkKFWrZF4fuFZ8t39a
        kw1IgrsrAr129jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbV8YFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r1rM2
        8IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
        021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F
        4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0
        oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7V
        C0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j
        6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
        z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvj
        DU0xZFpf9x07UAkuxUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

Prepare to add a regression test for raid10 that require error injection
to trigger error path, and kernel will complain about io error, checking
dmesg for error log will make it impossible to pass this test.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 test | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/test b/test
index 61d9ee83..b244453b 100755
--- a/test
+++ b/test
@@ -107,8 +107,12 @@ do_test() {
 		echo -ne "$_script... "
 		if ( set -ex ; . $_script ) &> $targetdir/log
 		then
-			dmesg | grep -iq "error\|call trace\|segfault" &&
-				die "dmesg prints errors when testing $_basename!"
+			if [ -f "${_script}.inject_error" ]; then
+				echo "dmesg checking is skipped because test inject error"
+			else
+				dmesg | grep -iq "error\|call trace\|segfault" &&
+					die "dmesg prints errors when testing $_basename!"
+			fi
 			echo "succeeded"
 			_fail=0
 		else
-- 
2.39.2

