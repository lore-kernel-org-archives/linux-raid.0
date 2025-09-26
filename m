Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03AD25FA05;
	Fri, 26 Sep 2025 06:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758866992; cv=none; b=nmlH8/k2QOcal5hqo7jk7CpUncaNIJy1pmpPobgR9pncAD3Hoa8NQMVClP7ByBD71cIXFaoFPluMz+a4TvzrnKQQ2cN4fQFJNDMP8T3tpGN0ZuOE6KAMRxbTnmd7l6P9liIVkXryaoRZyhUn9DtORidXJZpPSN10ZWC7XPLCFSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758866992; c=relaxed/simple;
	bh=JhsCsgV3MXdSkbZLj0qcZRiR4yN6rBr+9ptFlSSqjeM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mj6KTzHKpE64qmLahUfkTj72666RCj1oxOWdrvLFh59Q5KB/HrwcoHB1VOdRykGG5HiYgHcGZ/EztenChZAd/7dNKjD3/mnI2wd+SuToZcjH9IHRD7h8AUWy7WsQuf6IaTcCS88LW0Q71pjpJJM8bUZj1UQhG25/ewPBO2iZzoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cY0Xt5K0mzKHLwK;
	Fri, 26 Sep 2025 14:09:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DE0B11A1186;
	Fri, 26 Sep 2025 14:09:43 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgDHjGQfLtZonBJuAw--.28936S4;
	Fri, 26 Sep 2025 14:09:43 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: shinichiro.kawasaki@wdc.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH blktests] md/004: add unmap write zeroes tests
Date: Fri, 26 Sep 2025 14:08:47 +0800
Message-ID: <20250926060847.3003653-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHjGQfLtZonBJuAw--.28936S4
X-Coremail-Antispam: 1UD129KBjvJXoWxCrWUKr1kuF1DJryDKFWkXrb_yoWrGryUpa
	4UWFyFgryxGFnrJwn3ZF129F13Zw4vy3y3uayIyryj934DXr17W3ykKF1Yqw1fGFyfCw48
	Aa15XFWSkr1UKFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUBVbkUUU
	UU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The MD linear and RAID0 drivers in the Linux kernel now support the
unmap write zeroes operation. Test block device unmap write zeroes sysfs
interface with these two stacked devices. The sysfs parameters should
inherit from the underlying SCSI device. We can disable write zeroes
support by setting /sys/block/md<X>/queue/write_zeroes_unmap_max_bytes
to zero.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 tests/md/004     | 97 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/md/004.out |  2 +
 2 files changed, 99 insertions(+)
 create mode 100755 tests/md/004
 create mode 100644 tests/md/004.out

diff --git a/tests/md/004 b/tests/md/004
new file mode 100755
index 0000000..a3d7578
--- /dev/null
+++ b/tests/md/004
@@ -0,0 +1,97 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2025 Huawei.
+#
+# Test block device unmap write zeroes sysfs interface with MD devices.
+
+. tests/dm/rc
+. common/scsi_debug
+
+DESCRIPTION="test unmap write zeroes sysfs interface with MD devices"
+QUICK=1
+
+requires() {
+	_have_program mdadm
+	_have_scsi_debug
+	_have_driver linear
+	_have_driver raid0
+}
+
+setup_test_device() {
+	local dev_0 dev_1 dpath
+	local raid_level=$1
+	local scsi_debug_params=(
+		num_tgts=1
+		add_host=2
+		per_host_store=true
+		"${@:2}"
+	)
+
+	if ! _configure_scsi_debug "${scsi_debug_params[@]}"; then
+		return 1
+	fi
+
+	if [[ ! -f /sys/block/${SCSI_DEBUG_DEVICES[0]}/queue/write_zeroes_unmap_max_hw_bytes ]]; then
+		_exit_scsi_debug
+		return $TO_SKIP
+	fi
+
+	dev_0="/dev/${SCSI_DEBUG_DEVICES[0]}"
+	dev_1="/dev/${SCSI_DEBUG_DEVICES[1]}"
+	mdadm --create /dev/md/blktests_md --level="$raid_level" --raid-devices=2 \
+		--force --run "${dev_0}" "${dev_1}" 2> /dev/null 1>&2
+
+	dpath=$(_real_dev /dev/md/blktests_md)
+	echo "${dpath##*/}"
+}
+
+cleanup_test_device() {
+	mdadm --stop /dev/md/blktests_md 2> /dev/null 1>&2
+	_exit_scsi_debug
+}
+
+test() {
+	echo "Running ${TEST_NAME}"
+
+	local dname
+
+	for raid_level in linear raid0; do
+		# disable WRITE SAME with unmap
+		dname=$(setup_test_device $raid_level lbprz=0)
+		ret=$?
+		if ((ret)); then
+			if ((ret == TO_SKIP)); then
+				SKIP_REASONS+=("kernel does not support unmap write zeroes sysfs interface")
+			fi
+			return 1
+		fi
+
+		umap_hw_bytes="$(cat "/sys/block/$dname/queue/write_zeroes_unmap_max_hw_bytes")"
+		umap_bytes="$(cat "/sys/block/$dname/queue/write_zeroes_unmap_max_bytes")"
+		if [[ $umap_hw_bytes -ne 0 || $umap_bytes -ne 0 ]]; then
+			echo "$raid_level: Test disable WRITE SAME with unmap failed."
+		fi
+		cleanup_test_device
+
+		# enable WRITE SAME with unmap
+		if ! dname=$(setup_test_device $raid_level lbprz=1 lbpws=1); then
+			return 1
+		fi
+
+		zero_bytes="$(cat "/sys/block/$dname/queue/write_zeroes_max_bytes")"
+		umap_hw_bytes="$(cat "/sys/block/$dname/queue/write_zeroes_unmap_max_hw_bytes")"
+		umap_bytes="$(cat "/sys/block/$dname/queue/write_zeroes_unmap_max_bytes")"
+		if [[ $umap_hw_bytes -ne $zero_bytes || $umap_bytes -ne $zero_bytes ]]; then
+			echo "$raid_level: Test enable WRITE SAME with unmap failed."
+		fi
+
+		echo 0 > "/sys/block/$dname/queue/write_zeroes_unmap_max_bytes"
+		umap_bytes="$(cat "/sys/block/$dname/queue/write_zeroes_unmap_max_bytes")"
+		if [[ $umap_bytes -ne 0 ]]; then
+			echo "$raid_level: Test manually disable WRITE SAME with unmap failed."
+		fi
+		cleanup_test_device
+	done
+
+	echo "Test complete"
+}
diff --git a/tests/md/004.out b/tests/md/004.out
new file mode 100644
index 0000000..73cd26a
--- /dev/null
+++ b/tests/md/004.out
@@ -0,0 +1,2 @@
+Running md/004
+Test complete
-- 
2.46.1

