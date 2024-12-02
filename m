Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8CB1CF96
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 02:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733104926; cv=none; b=ahaWzU2gYqoLbcz6ISP6iCas/NGfkG7JxTh4z+G9cLVj3zWvDOsy0zXrEGM5TIMzVHshjhorynDnXXKz3H5lMauMMvO343y68PjkGdL0vi+ZHkxdLPlXnWeusT4qLEV3Fbne0Zx9nJNozGP/+oHLXEtvM/uWXZnbIBB4wTbE13Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733104926; c=relaxed/simple;
	bh=TA7ADkZxYsQW05DbEhfy5MSqD6loSqEIXug7+cYsHck=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=efCx28/WPxKi86U/hDTBw1FqN75XdeGoR6UISwCQ5TuJzw9LBvbA2fBOuwXDJ9OkBQUjB6GiXmlr5e2gotb+HPuxgL1RKYRDTCLH0QJoJ4esVi3n9hhGGFf6SmiQBGa8JfymFkKm6g8Ypd+K4ACqz5biaVOOyEWAfduAT678dHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Y1n8J2dXsz4f3jJ5
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 10:01:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4C8E11A0359
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 10:01:55 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHo4cQFU1ngWmkDQ--.17049S7;
	Mon, 02 Dec 2024 10:01:55 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v4 mdadm 3/5] Manage: forbid re-add to the array without metadata
Date: Mon,  2 Dec 2024 09:59:11 +0800
Message-Id: <20241202015913.3815936-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241202015913.3815936-1-yukuai1@huaweicloud.com>
References: <20241202015913.3815936-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHo4cQFU1ngWmkDQ--.17049S7
X-Coremail-Antispam: 1UD129KBjvJXoW7Kry7Xw1UZr1fZF18CryrXrb_yoW8Krykpr
	13GFyfJrykJrZIgay7CFWkZF95J3ykXF4xG39xJry2krsrZFyjvr45JrykZ345ZFWrCw43
	ZF4fJF48KFyrKFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvGb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjxU2ApnDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

For the build mode or external metadata, re-add is not supported,
because it will not trigger full disk recovery, user should add a new disk
to the array instead.

Also update test/05r1-re-add-nosuper to reflect this.

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

