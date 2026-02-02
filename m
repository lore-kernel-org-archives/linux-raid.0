Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9541F192E;
	Mon,  2 Feb 2026 08:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770021698; cv=none; b=eKmJQHZw+n7aCmeZEydQSqLNUKejev5sMp1t8lsdsFKmYGjyKNSXMI120Fyknx+dEvxTTP19W9tH2k0kbD5mHad/GjGdx0bn6zOGIRl3R94Nz6XwoKVALSRSvrgCxPsIfduZGBc9Q9P5embyE1QCQaAdhzV5nDlRA8P1Geaw4rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770021698; c=relaxed/simple;
	bh=yplGPMEvBSDfGaLhPoDSJw1t8BGoYvl1gsHwxLBYuMM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PK2Vuo9z+CEOC5P09v91rl1t2ttMei0TRzzM0CbuQbdtr2zprAOIKmJKAQUAiu+wAl70lpSL38R94IyUGOkOY+3FNjt+0cuSyHa1aJnxYJPOJ6vPh942YSaOZABzORYXJreexf0sGMdVB/ejPd6GKhCY6vqSGqRvtrrqNbNatbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f4Knn3YWFzYQv2g;
	Mon,  2 Feb 2026 16:40:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E038840575;
	Mon,  2 Feb 2026 16:41:30 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXePg3Y4BptdTvFw--.4867S4;
	Mon, 02 Feb 2026 16:41:29 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	wanghai38@huawei.com
Subject: [PATCH RESEND] MAINTAINERS: Add Li Nan as md/raid reviewer
Date: Mon,  2 Feb 2026 16:32:03 +0800
Message-Id: <20260202083203.3017096-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXePg3Y4BptdTvFw--.4867S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Wry5JrWDAw1rZr1rCF1UAwb_yoW3AFbEk3
	yxJrW8XFWkJF42g348AFZFvr4Fyr4fJr1rX3ZIq345Xa48t3s5KrZ5K3s5Zr43Gry8Wr43
	X3WfJFZa9ws0qjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbTxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F
	4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI2
	0VAGYxC7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbhL05UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

I've long contributed to and reviewed the md/raid subsystem. I've fixed
many bugs and done code refactors, with dozens of patches merged.
I now volunteer to work as a reviewer for this subsystem.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 67db88b04537..3262c74b93b4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24260,6 +24260,7 @@ F:	include/linux/property.h
 SOFTWARE RAID (Multiple Disks) SUPPORT
 M:	Song Liu <song@kernel.org>
 M:	Yu Kuai <yukuai@fnnas.com>
+R:	Li Nan <linan122@huawei.com>
 L:	linux-raid@vger.kernel.org
 S:	Supported
 Q:	https://patchwork.kernel.org/project/linux-raid/list/
-- 
2.39.2

