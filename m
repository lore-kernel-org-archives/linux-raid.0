Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374DCA920
	for <linux-raid@vger.kernel.org>; Fri, 27 Dec 2024 06:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735279884; cv=none; b=GfEhs3p38YMYTaOg0IkKsK8EqDoc9k5IkrNgWofGkiNxvJc69s21t+toDSYjBkGgyQE5NKx1BG1K5j6yn+ARbJt6hbqlX5IY22CvSjckcfNXj8jARN7sg9mq+Uzv+AhQGRrKZf3SaMkN2IVw1CUeR0QljaLisooSNfz3IRtekxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735279884; c=relaxed/simple;
	bh=xr6fN1nu2XXojlgNgjexmszl+x/Go51K5yVaKxEn3kY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YiuTnmWp5GRkKufLwYYIi1ddOqTkuR2BvIvq3Wkq3E+D78C1rjPUzP2joDRZX5277OCHX7Za8pgTXEAHwoWNKOivtutiE+xjJwccpqcNU5syw6GGBJre9uxLzse75fP2i5W9D/7nEj8R/hsNRBxmvHOBhZHemZsPFuS0t8OAlxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YKFVP2KKjz4f3jYJ
	for <linux-raid@vger.kernel.org>; Fri, 27 Dec 2024 14:10:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1E3481A018D
	for <linux-raid@vger.kernel.org>; Fri, 27 Dec 2024 14:11:13 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCXcYX_RG5nC7EJFw--.31810S4;
	Fri, 27 Dec 2024 14:11:13 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mtkaczyk@kernel.org,
	song@kernel.org
Cc: linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH] mdadm: fix --grow with --add for linear
Date: Fri, 27 Dec 2024 14:07:02 +0800
Message-Id: <20241227060702.730184-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXcYX_RG5nC7EJFw--.31810S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtryUJF47GFy5Gr4fur4rKrg_yoWDXwb_Ca
	93KrWxZw4fG3Wav3W5ZFyY9a40qw4rCFW7Za98AFyUJFW8XrnIgrWFkFZ3WrZ8GFZFgr93
	J3W3KFna9rsxAjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbzkYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2NtUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

For the case mdadm --grow with --add, the s.btype should not be
initialized yet, hence BitmapUnknown should be checked instead of
BitmapNone.

Noted that this behaviour should only support by md-linear, which is
removed from kernel, howerver, it turns out md-linear is used widely
in home NAS and we're planning to reintroduce it soon.

Fixes: 581ba1341017 ("mdadm: remove bitmap file support")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 mdadm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdadm.c b/mdadm.c
index 7d3b656b..1fd4dcba 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1625,7 +1625,7 @@ int main(int argc, char *argv[])
 		if (devs_found > 1 && s.raiddisks == 0 && s.level == UnSet) {
 			/* must be '-a'. */
 			if (s.size > 0 || s.chunk ||
-			    s.layout_str || s.btype != BitmapNone) {
+			    s.layout_str || s.btype != BitmapUnknown) {
 				pr_err("--add cannot be used with other geometry changes in --grow mode\n");
 				rv = 1;
 				break;
-- 
2.39.2

