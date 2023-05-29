Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBEA3C7EE2E
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 13:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjE2NcQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 09:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjE2NcM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 09:32:12 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E04C9
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 06:32:09 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QVGfD5Dqfz4f3pFk
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 21:32:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP4 (Coremail) with SMTP id gCh0CgBH_rFSqXRkMLjoKQ--.57183S6;
        Mon, 29 May 2023 21:32:05 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de, logang@deltatee.com,
        song@kernel.org, guoqing.jiang@linux.dev
Cc:     yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com
Subject: [PATCH v2 2/8] tests: support to skip checking dmesg
Date:   Mon, 29 May 2023 21:28:20 +0800
Message-Id: <20230529132826.2125392-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230529132826.2125392-1-yukuai1@huaweicloud.com>
References: <20230529132826.2125392-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBH_rFSqXRkMLjoKQ--.57183S6
X-Coremail-Antispam: 1UD129KBjvdXoW7XFykJFyDtFyrKw4kuF4kWFg_yoWDXrc_tr
        yS9as7Wr45GFnrKw1avF1qvFsYk3y3Wr1xuryqkFy5XF15uF18GaykKFWrZa1furZ0y39a
        kw1IgrsxJr129jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbS8YFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r15M2
        8IrcIa0xkI8VCY1x0267AKxVW8JVW5JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
        021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r
        4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
        GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
        0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
        JVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCF04k20xvY0x0EwI
        xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x
        0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07jbF4iUUUUU=
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
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
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

