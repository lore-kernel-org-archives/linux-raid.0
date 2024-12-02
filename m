Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BC31C6BE
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 02:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733104926; cv=none; b=JXlE0W00/ttknY6ANtgkgeD8X+pOQisPMawuAYO8TXrOW/9IZ0e8QHBkobPsD+pkntMBsH49Og0JC1KN5JtfBANGYXtXABs57K9TDCsF8itYtiTRgQfK3+2GjkLJPrc5gIMDzLsHCzlxDbZZ1rycGB3U0ev9USDDUPdQ130Gpnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733104926; c=relaxed/simple;
	bh=ULHRvj1mA85MBsF/WtPDojfv1rE6ZTRkKC/05hi8kkQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a1dT3ePM3apev+ZlaahnNSPwblavwhHP4b+QIA7FD88A0362MI0+quZqE4DUhPdVOSjcGURftq2vl9YF1rAxsEX3s5ZhBXXyTh8BnbNaHu5QSH9Vkpj6MuyoN67COmrIbPS2ocu3kAf6ey4UQst2diQo66aPkeftckdWaeTd+/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Y1n8N5hDrz4f3jq4
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 10:01:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AB3C31A0359
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 10:01:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHo4cQFU1ngWmkDQ--.17049S5;
	Mon, 02 Dec 2024 10:01:54 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v4 mdadm 1/5] tests/04update-uuid: remove bitmap file test
Date: Mon,  2 Dec 2024 09:59:09 +0800
Message-Id: <20241202015913.3815936-2-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHo4cQFU1ngWmkDQ--.17049S5
X-Coremail-Antispam: 1UD129KBjvJXoWxJr4fJr45Cw17WF17AFyUtrb_yoW8uw4fpF
	43AFna9r1UG3yUXFyUA34kGFnxJFyDXr48A34SgFyfGas8urZYvry8uF1Sqw4UtrWvkw1k
	Z3WvyFWrXrW09wUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Jrv_JF4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjxUFzV1UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Prepare to remove the bitmap file support.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 tests/04update-uuid | 34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/tests/04update-uuid b/tests/04update-uuid
index 25314ab5..ce5a958c 100644
--- a/tests/04update-uuid
+++ b/tests/04update-uuid
@@ -22,40 +22,6 @@ mdadm -D /dev/md0 | grep -s > /dev/null 01234567:89abcdef:fedcba98:76543210 || {
 }
 mdadm -S /dev/md0
 
-
-# now if we have a bitmap, that needs updating too.
-rm -f $targetdir/bitmap
-yes | mdadm -CR --assume-clean -b $targetdir/bitmap $md0 -l5 -n3 $dev0 $dev1 $dev2
-mdadm -S /dev/md0
-mdadm -A /dev/md0 -b $targetdir/bitmap --update=uuid --uuid=0123456789abcdef:fedcba9876543210 $dev0 $dev1 $dev2
-no_errors
-mdadm -D /dev/md0 | grep -s > /dev/null 01234567:89abcdef:fedcba98:76543210 || {
-   echo Wrong uuid; mdadm -D /dev/md0 ; exit 2;
-}
-if mdadm -X $targetdir/bitmap | grep -s > /dev/null 01234567:89abcdef:fedcba98:76543210 ||
-   mdadm -X $targetdir/bitmap | grep -s > /dev/null 67452301:efcdab89:98badcfe:10325476
-then : ; else
-   echo Wrong uuid; mdadm -X $targetdir/bitmap ; exit 2;
-fi
-mdadm -S /dev/md0
-
-# and bitmap for version1
-rm -f $targetdir/bitmap
-yes | mdadm -CR --assume-clean -e1.1 -b $targetdir/bitmap $md0 -l5 -n3 $dev0 $dev1 $dev2
-mdadm -S /dev/md0
-mdadm -A /dev/md0 -b $targetdir/bitmap --update=uuid --uuid=0123456789abcdef:fedcba9876543210 $dev0 $dev1 $dev2
-no_errors
-mdadm -D /dev/md0 | grep -s > /dev/null 01234567:89abcdef:fedcba98:76543210 || {
-   echo Wrong uuid; mdadm -D /dev/md0 ; exit 2;
-}
-# -X cannot tell which byteorder to use for the UUID, so allow both.
-if mdadm -X $targetdir/bitmap | grep -s > /dev/null 01234567:89abcdef:fedcba98:76543210 ||
-   mdadm -X $targetdir/bitmap | grep -s > /dev/null 67452301:efcdab89:98badcfe:10325476
-then : ; else
-   echo Wrong uuid; mdadm -X $targetdir/bitmap ; exit 2;
-fi
-mdadm -S /dev/md0
-
 # Internal bitmaps too.
 mdadm -CR --assume-clean  -b internal --bitmap-chunk 4 $md0 -l5 -n3 $dev0 $dev1 $dev2
 mdadm -S /dev/md0
-- 
2.39.2

