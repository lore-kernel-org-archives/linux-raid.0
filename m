Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED02C7EE2F
	for <linux-raid@archiver.kernel.org>; Tue, 23 May 2023 13:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbjEWNmw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 May 2023 09:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235740AbjEWNmr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 May 2023 09:42:47 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699D61AC
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 06:42:31 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QQb8n24RQz4f3k6S
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 21:42:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP1 (Coremail) with SMTP id cCh0CgAHJzG4wmxkVTLYJQ--.25598S4;
        Tue, 23 May 2023 21:42:18 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        jes@trained-monkey.org, pmenzel@molgen.mpg.de, logang@deltatee.com,
        song@kernel.org
Cc:     yukuai3@huawei.com, yangerkun@huawei.com
Subject: [PATCH tests 0/5] tests: add some regression tests
Date:   Tue, 23 May 2023 21:38:55 +0800
Message-Id: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgAHJzG4wmxkVTLYJQ--.25598S4
X-Coremail-Antispam: 1UD129KBjvdXoWrKFWkWw4xuw4rJry3KrWruFg_yoWfGFbEgw
        48Z34ktF47AF13ta45t3WjqrZ0krW8Gr1xtFn0kFy3XFsxZryjy3WkJr15Way5Gw13Xr13
        t3yxCrWvyrn5ZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUboxYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267
        AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80
        ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4
        AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
        6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
        CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
        0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3w
        CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
        WIevJa73UjIFyTuYvjxUrR6zUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

Yu Kuai (5):
  tests: add a new test to check if pluged bio is unlimited for raid10
  tests: add a new test for rdev lifetime
  tests: support to skip checking dmesg
  tests: add a regression test for raid10 deadlock
  tests: add a regression test for raid456 deadlock

 test                                |  8 ++-
 tests/22raid10plug                  | 41 ++++++++++++++
 tests/23rdev-lifetime               | 48 ++++++++++++++++
 tests/24raid10deadlock              | 85 +++++++++++++++++++++++++++++
 tests/24raid10deadlock.inject_error |  0
 tests/24raid456deadlock             | 56 +++++++++++++++++++
 6 files changed, 236 insertions(+), 2 deletions(-)
 create mode 100644 tests/22raid10plug
 create mode 100644 tests/23rdev-lifetime
 create mode 100644 tests/24raid10deadlock
 create mode 100644 tests/24raid10deadlock.inject_error
 create mode 100644 tests/24raid456deadlock

-- 
2.39.2

