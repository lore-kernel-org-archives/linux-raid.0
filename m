Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5061514E2F2;
	Thu, 16 Apr 2026 03:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776311432; cv=none; b=L8uqv15XzwIc9eCme2Djls3wOMpE+1vqHOc17l+mOCceFJLQCNmatd/mbUwcp52BeGKpGSH5f19ke8r+cfLMTdKsveBo26UF2kHicM3e0ru6vkUW6culwKyEl6XwIVNZ6E/2DdSuGeH/2r4AzoLUL5KZS8FRiq2bAs/Gi97MT+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776311432; c=relaxed/simple;
	bh=Qd89njNjYPsZli0+xtTaYb0OaBmZ5wu1a99YIpO1V5o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DJI9T+ayM4wZhZcK+j53uPjZgQvHKX0jaqX/xf8WaOyX8sWvbXFMzfNY6jFV1utglEH68iCdjpdbre0peBYLZ39mQTt/Ki9uWpdqTbJklDwpbi+tmM5WMnUqvOEB7suCxSeEyrudicxHRwn4z4V3LQO2852nGVKvyfVR30hpcz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fx3tD0VkfzYQtgH;
	Thu, 16 Apr 2026 11:49:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 29FF540539;
	Thu, 16 Apr 2026 11:50:27 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP3 (Coremail) with SMTP id _Ch0CgCHM72BXOBpn95JAg--.61021S7;
	Thu, 16 Apr 2026 11:50:27 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 3/8] md: introduce safe_put_folio for folio support in RAID
Date: Thu, 16 Apr 2026 11:37:56 +0800
Message-Id: <20260416033801.786415-4-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260416033801.786415-1-linan666@huaweicloud.com>
References: <20260416033801.786415-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCHM72BXOBpn95JAg--.61021S7
X-Coremail-Antispam: 1UD129KBjvdXoWrGF1xZFy8Kr4UKr1fGryxuFg_yoWxXwc_uw
	sYqFyftryUAFn2yr15Jr47ZryYvanY9ryUuF4Igay5Zry2gFn7ursYgr1DX34ruFW8uayU
	AryDtrZ8Cr4jkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbB8FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWwA2048vs2IY02
	0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84
	ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lnxkE
	FVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I
	8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxw
	AKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E
	4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGV
	WUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_
	Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rV
	WUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4U
	JbIYCTnIWIevJa73UjIFyTuYvjfUYGYLDUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

safe_put_page() will be removed after the last reference to it in RAID5
is removed.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 914b992a073b..7c0c38f09cc3 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -888,6 +888,12 @@ struct md_io_clone {
 	rcu_read_unlock();                  \
 } while (0)
 
+static inline void safe_folio_put(struct folio *folio)
+{
+	if (folio)
+		folio_put(folio);
+}
+
 static inline void safe_put_page(struct page *p)
 {
 	if (p) put_page(p);
-- 
2.39.2

