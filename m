Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FAC3C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 26 Oct 2021 09:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E90260C49
	for <linux-raid@archiver.kernel.org>; Tue, 26 Oct 2021 09:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbhJZJ3t (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Oct 2021 05:29:49 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:52770 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234781AbhJZJ3T (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 26 Oct 2021 05:29:19 -0400
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-03 (Coremail) with SMTP id rQCowADnyebAyXdhyEH+BA--.24790S2;
        Tue, 26 Oct 2021 17:26:24 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     song@kernel.org, valentin.schneider@arm.com, peterz@infradead.org,
        mingo@kernel.org, dave.hansen@linux.intel.com, bristot@redhat.com,
        namit@vmware.com
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] cpumask and md/raid5: Fix implicit type conversion
Date:   Tue, 26 Oct 2021 09:26:23 +0000
Message-Id: <1635240383-2568329-1-git-send-email-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: rQCowADnyebAyXdhyEH+BA--.24790S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAF45JF4fCr4kXw1UAF1DJrb_yoW5Cr4fpF
        10grWjg3yxXr48u34DZ3yUur1Y93ykJ3yvk347G3yUuFW7Jw1kZr12kas8XryUCF95KFyI
        vr90k3yDuF15JFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_GFWl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF
        0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
        VjvjDU0xZFpf9x0JUhNVgUUUUU=
X-Originating-IP: [124.16.138.128]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The description of the macro in `include/linux/cpumask.h` says the
variable 'cpu' can be unsigned int.
However in the for_each_cpu(), for_each_cpu_wrap() and
for_each_cpu_and(), its value is assigned to -1.
That doesn't make sense. Moreover in the cpumask_next(),
cpumask_next_zero(), cpumask_next_wrap() and cpumask_next_and(),
'cpu' will be implicitly type conversed to int if the type is
unsigned int.
It is universally accepted that the implicit type conversion is
terrible.
Also, having the good programming custom will set an example for
others.
Thus, it might be better to fix the macro description of 'cpu' that
remove the '(optionally unsigned)' and change the definition of 'cpu'
in `drivers/md/raid5.c` from unsigned long to long.

Fixes: c743f0a ("sched/fair, cpumask: Export for_each_cpu_wrap()")
Fixes: 8bd93a2 ("rcu: Accelerate grace period if last non-dynticked CPU")
Fixes: 984f2f3 ("cpumask: introduce new API, without changing anything, v3")
Fixes: 738a273 ("md/raid5: fix allocation of 'scribble' array.")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/md/raid5.c      | 2 +-
 include/linux/cpumask.h | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7d4ff8a..32ef82b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2425,7 +2425,7 @@ static int scribble_alloc(struct raid5_percpu *percpu,
 
 static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
 {
-	unsigned long cpu;
+	long cpu;
 	int err = 0;
 
 	/*
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index bfc4690..ceaed99 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -232,7 +232,7 @@ int cpumask_any_distribute(const struct cpumask *srcp);
 
 /**
  * for_each_cpu - iterate over every cpu in a mask
- * @cpu: the (optionally unsigned) integer iterator
+ * @cpu: the integer iterator
  * @mask: the cpumask pointer
  *
  * After the loop, cpu is >= nr_cpu_ids.
@@ -244,7 +244,7 @@ int cpumask_any_distribute(const struct cpumask *srcp);
 
 /**
  * for_each_cpu_not - iterate over every cpu in a complemented mask
- * @cpu: the (optionally unsigned) integer iterator
+ * @cpu: the integer iterator
  * @mask: the cpumask pointer
  *
  * After the loop, cpu is >= nr_cpu_ids.
@@ -258,7 +258,7 @@ extern int cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool
 
 /**
  * for_each_cpu_wrap - iterate over every cpu in a mask, starting at a specified location
- * @cpu: the (optionally unsigned) integer iterator
+ * @cpu: the integer iterator
  * @mask: the cpumask poiter
  * @start: the start location
  *
@@ -273,7 +273,7 @@ extern int cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool
 
 /**
  * for_each_cpu_and - iterate over every cpu in both masks
- * @cpu: the (optionally unsigned) integer iterator
+ * @cpu: the integer iterator
  * @mask1: the first cpumask pointer
  * @mask2: the second cpumask pointer
  *
-- 
2.7.4

