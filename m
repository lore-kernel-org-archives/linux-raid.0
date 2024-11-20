Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A33815B111
	for <linux-raid@vger.kernel.org>; Wed, 20 Nov 2024 06:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732085347; cv=none; b=oX5mg9ecUpPRhF1LnattBTzZR1Tqhp6YxV1T3uuROwH1yc4p6UKj+Q/py1hMGe/e52ZjcF2x0WAgokRnBnRc1MBl1mfTCDjJxBgrXkMXCCuJ+SJ4VdSOSHNGs7fHqZNbHSdgCRvbf73RxEg1jLcmDu8JkmC50rWt0Pjha0KROAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732085347; c=relaxed/simple;
	bh=rHR4zISWW2P40nAaXlyKJmveYMqnPJTS4EBXhTcNiT8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lfbLhZlAk3B4FaeEonTtFLZDjLNWD+cAcL4Q7RhC6LI4eHYs97USVKWd2eNTCjOZ2yz42JtPzSw+HDB4zphgd16CIdv7h1fyCs+thTCKUzVFUaQu5rp4yGp0NNGlP2roAD5a3CXYQpMB3y/BPlZmG2pzhMbXYqiN82xFgl23qrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XtX545V8qz4f3lg1
	for <linux-raid@vger.kernel.org>; Wed, 20 Nov 2024 14:48:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3150A1A0194
	for <linux-raid@vger.kernel.org>; Wed, 20 Nov 2024 14:49:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnzoJZhj1nRlQ5CQ--.45081S8;
	Wed, 20 Nov 2024 14:49:00 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v3 4/4] Manage: forbid re-add to the array without metadata
Date: Wed, 20 Nov 2024 14:46:37 +0800
Message-Id: <20241120064637.3657385-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241120064637.3657385-1-yukuai1@huaweicloud.com>
References: <20241120064637.3657385-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnzoJZhj1nRlQ5CQ--.45081S8
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF48KFW8AFWxGF13AFyUGFg_yoW8tFW8pr
	13JFyfJrykJrZIgay7CFWkZF95J3ykXF4xG39xJryIyrsrZFyjvr45Jryvv3y5ZFWruw43
	ZF4fJr4xKFyrKFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvKb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
	WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x07jeVbkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

re-add will not trigger full disk recovery, user should add a new disk
to the array instead. Also update test/05r1-re-add-nosuper to reflect
this.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 Manage.c                  | 12 ++++++++++++
 tests/05r1-re-add-nosuper | 27 +++++----------------------
 2 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/Manage.c b/Manage.c
index b9e55c43..b14a9ab9 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1448,6 +1448,18 @@ int Manage_subdevs(char *devname, int fd,
 		int rv, err = 0;
 		int mj, mn;
 
+		if (tst->ss->external && dv->disposition == 'A') {
+			pr_err("Cannot re-add member device %s to %s, it is not supported for external metadata, aborting.\n",
+			       dv->devname, fd2devnm(fd));
+			goto abort;
+		}
+
+		if (array.not_persistent == 1 && dv->disposition == 'A') {
+			pr_err("Cannot re-add member device %s to %s, array is not persistent, aborting.\n",
+			       dv->devname, fd2devnm(fd));
+			goto abort;
+		}
+
 		raid_slot = -1;
 		if (dv->disposition == 'c') {
 			rv = parse_cluster_confirm_arg(dv->devname, &dv->devname, &raid_slot);
diff --git a/tests/05r1-re-add-nosuper b/tests/05r1-re-add-nosuper
index a3fa9503..750d7c14 100644
--- a/tests/05r1-re-add-nosuper
+++ b/tests/05r1-re-add-nosuper
@@ -1,7 +1,6 @@
 #
-# create a raid1, remove a drive, and readd it.
-# resync should be instant.
-# Then do some IO first.  Resync should still be very fast
+# create a raid1 without superblock, remove a drive, and readd it.
+# readd should fail.
 #
 mdadm -B $md0 -l1 -n2 -d1 $dev1 $dev2
 check resync
@@ -12,24 +11,8 @@ sleep 4
 mdadm $md0 -f $dev2
 sleep 1
 mdadm $md0 -r $dev2
-mdadm $md0 --re-add $dev2
-check nosync
+if mdadm $md0 --re-add $dev2; then
+	err "re-add should fail"
+fi
 
-mdadm $md0 -f $dev2
-sleep 1
-mdadm $md0 -r $dev2
-testdev $md0 1 $size 1
-mdadm $md0 --re-add $dev2
-check wait
-cmp --bytes=$[$mdsize0*1024] $dev1 $dev2
-
-mdadm $md0 -f $dev2; sleep 1
-mdadm $md0 -r $dev2
-if dd if=/dev/zero of=$md0 ; then : ; fi
-blockdev --flushbufs $md0 # make sure writes have been sent
-mdadm $md0 --re-add $dev2
-check recovery
-check wait
-# should BLKFLSBUF and then read $dev1/$dev2...
-cmp --bytes=$[$mdsize0*1024] $file1 $file2
 mdadm -S $md0
-- 
2.39.2

