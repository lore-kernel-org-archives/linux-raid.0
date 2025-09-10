Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4797230E825;
	Wed, 10 Sep 2025 09:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757496326; cv=none; b=mvd3PyGKHf1PuF0QgjDOGCMD4G8r1bYVESMDB1wwuoO1JXqU2IfabOIg+4N+xISyPGbTNCEih9P0Q+NYajKCN1ByTUs0VAwypoQytomW7empjc2wNWdRiIxR/1K/ccXYZmSaGl7gJLPn1OyZI6enwf/UuxHI9yyaMNZb2ELcS3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757496326; c=relaxed/simple;
	bh=Q8c0GjagujKviMNyQz5UIevv6OVt+I6lIU8B905+diA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Rs3MgJwtdVICnbaaXe3tkG0HEjnkGXnuuIPovTzkFmmodSTVQOQftTJTE/sVOxZvIwSJ2OkCQeeTlIdGxjtfrYKyYn5dkHW9hwotloRlPsF2rIvqm7opl2RHnb6w1b7jir5fGQirr7W5yG9vGHR9dvCGKovOELyjQdH09WTyI3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowAAnyBGwQsFobHwUAg--.13377S2;
	Wed, 10 Sep 2025 17:19:44 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] md/md-llbitmap: Remove unneeded semicolon
Date: Wed, 10 Sep 2025 17:19:12 +0800
Message-Id: <20250910091912.25624-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAnyBGwQsFobHwUAg--.13377S2
X-Coremail-Antispam: 1UD129KBjvdXoWrWr1ktw4xGr1rWF48CFyfWFg_yoWxXrg_uF
	1FgrZ7ZryUJrZ0kr15XF43ZFyq9w1DWa1kuay2grWfAry7u34UGrW8uF4UJw1rArWUA347
	G34vg34rAw43GjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbs8FF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxkIecxEwVAFwVW8uwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
	C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
	wI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
	v20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2
	jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43
	ZEXa7VUjByIUUUUUU==
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Remove unnecessary semicolons reported by Coccinelle/coccicheck and the
semantic patch at scripts/coccinelle/misc/semicolon.cocci.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 drivers/md/md-llbitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 3337d5c7e7e5..0f15428b2403 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -378,7 +378,7 @@ static void llbitmap_infect_dirty_bits(struct llbitmap *llbitmap,
 		case BitClean:
 			pctl->state[pos] = BitDirty;
 			break;
-		};
+		}
 	}
 }
 
-- 
2.25.1

