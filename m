Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235053DCD8D;
	Tue, 13 Oct 2026 09:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791883962; cv=none; b=hQTVJFVHwxG7dLAt5yzIvg+otMAeSZhU09G8nGKHW5jaMH2l8saAFUxiDgjbspJYynhu9UGV9D6xX8q2tqxZNEY8C0IXVp0PQinhvB1z0pvebdClvGWAd3cHPRkRjGJlEHAQ0kklTEFTrKJjP4gwX6SlLEoCsPCoGDeuCbCp22o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791883962; c=relaxed/simple;
	bh=fwURzNl9cH1aK4rmVIu01X1molsNK9DXMme9H5CmUgA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ImL5aT2rnR2p+PrvHk6+xW+zn78ZM4XZ1M5k6dPIesAxz7FGUcRFAko9w66eqKI3TS+T1kEZyXszeIF8aXbiFrZ2HMibh2kzkIieFKSFr1z1QEMfUlUFiSHy9Roe/TFNXsrq4NHlMNAkICt0xUf5pLSK+vT9yfADW1qez14v3a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j3pxl4hxHzYQw1D;
	Tue, 13 Oct 2026 17:31:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A59B34056D;
	Tue, 13 Oct 2026 17:32:30 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgB3tfSt+s1qsMQbAQ--.2543S4;
	Tue, 13 Oct 2026 17:32:30 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wozizhi@huawei.com
Subject: [PATCH] md/raid5: reject raid4/5 with fewer than 2 devices
Date: Tue, 13 Oct 2026 17:25:38 +0800
Message-ID: <20261013092538.636212-1-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3tfSt+s1qsMQbAQ--.2543S4
X-Coremail-Antispam: 1UD129KBjvJXoW7CF1kXw1kCr47uF18Zr48Crg_yoW8tFWUp3
	9akF90vwn5Gr1ayrWkJa4vga4Yqr4xA3ykKrZ3XrZ7Xr15ZF4Uu3y7WFy8Xr10y398Aay5
	Ja4UKrWUCa40grDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UAwIDUUUUU=
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

A raid4/5 array assembled with a single device has data_disks == 0, which
is then used throughout the mapping math:
 1) as a divisor in raid5_compute_sector() (division-by-zero splat);
 2) as a multiplier in roundup_pow_of_two(data_disks * ...) in
    raid5_set_limits(), which makes roundup_pow_of_two(0) shift by 64,
    yielding a shift-out-of-bounds splat.
 ......

I reproduced this issue in my environment as well:

[  294.891435] UBSAN: shift-out-of-bounds in include/linux/log2.h:57:13
[  294.891446] shift exponent 64 is too large for 64-bit type 'long unsigned int'
[  294.891457] CPU: 21 UID: 0 PID: 1351 Comm: sh Not tainted 7.3.0-rc7 #112 PREEMPT(full)
[  294.891477] Call Trace:
[  294.891481]  <TASK>
[  294.891486]  dump_stack_lvl+0x5d/0x80
[  294.891525]  ubsan_epilogue+0x5/0x2b
[  294.891538]  __ubsan_handle_shift_out_of_bounds.cold+0x5e/0x113
[  294.891568]  raid5_set_limits+0x2da/0x497
[  294.891618]  raid5_run.cold+0x635/0xd6e

setup_conf() already rejects raid6 with fewer than 4 devices; only the
initial raid4/5 assembly path never had the check. Add it so a degenerate
single-device raid4/5 is refused before data_disks is used.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 drivers/md/raid5.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b91545ce090d..5a7839542e24 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7660,10 +7660,16 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	if (mddev->new_level == 6 && mddev->raid_disks < 4) {
 		pr_warn("md/raid:%s: not enough configured devices (%d, minimum 4)\n",
 			mdname(mddev), mddev->raid_disks);
 		return ERR_PTR(-EINVAL);
 	}
+	if ((mddev->new_level == 4 || mddev->new_level == 5) &&
+	    mddev->raid_disks < 2) {
+		pr_warn("md/raid:%s: not enough configured devices (%d, minimum 2)\n",
+			mdname(mddev), mddev->raid_disks);
+		return ERR_PTR(-EINVAL);
+	}
 
 	if (!mddev->new_chunk_sectors ||
 	    (mddev->new_chunk_sectors << 9) % PAGE_SIZE ||
 	    !is_power_of_2(mddev->new_chunk_sectors)) {
 		pr_warn("md/raid:%s: invalid chunk size %d\n",
-- 
2.52.0

