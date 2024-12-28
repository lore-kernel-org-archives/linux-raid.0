Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E33E17580;
	Sat, 28 Dec 2024 02:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735352171; cv=none; b=Rz9hpERG0CY98b7U9he1KKwvAB+mXuFJvvqomBzP4pFEhhj7sDYKAv7kUDNbAYpS6jPtLInkXIWQfU754I03Qdj6sNNlUj2yM5XfHOTLqWpovB2nJgrqFhfJtxM5ZXrcUY6O9x+1kDhToQPhLaelKkJdqnHx9LNe1fkOOphEhzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735352171; c=relaxed/simple;
	bh=RlfvahRwSRu9RwmaClNiJ7+fsT2ht0UKNUYNPdvfbeY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qUI8q9DRWPBmKuM4d19C7BIQW5avOYbBwiKmF1SxCarQp6++HR9+7eF/O2kCQLLkL9jDpquD2pdDfXwbSxt94kclGUfvygOIDFkzLQBkqR58FONCFZJMPes4ukOOOc6qEsTxTQBCES8McGvZ7NPy8eCEnhq2mXajghkzgeQgwN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=VFG+vWaA; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="VFG+vWaA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=qtZ9p
	JZxUct98KGlVQ+CgWjFcYyX6W25e6+AfqWqRGE=; b=VFG+vWaAjBbRPETRHlHnH
	puZK4VBl7ObiaEpdLRJNj5QjCbWGUR8c3DwpuvATuRMpjInhD7LfRKDdDceFXh7V
	gWZ/sCULQGbFtG1zGNJgjTYG6zSeXTshTHY9i0j3PewkxxvxhohzDysA6Qc6+Faq
	OtoTYfuXBur+zF2wmue6zU=
Received: from wdhh6.sugon.cn (unknown [60.29.3.194])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDnD7tRX29nVZagHA--.29296S2;
	Sat, 28 Dec 2024 10:15:46 +0800 (CST)
From: Chaohai Chen <wdhh66@163.com>
To: song@kernel.org
Cc: yukuai3@huawei.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chaohai Chen <wdhh66@163.com>
Subject: [PATCH] md: fix NULL point access
Date: Sat, 28 Dec 2024 10:15:43 +0800
Message-Id: <20241228021543.216542-1-wdhh66@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDnD7tRX29nVZagHA--.29296S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xr4kXrW3ZFyxAr1kGF4fGrg_yoWxArg_Ka
	95ZFyfWFyUCr1qka1avw4SvryFya1DWw1kuFyft39xu345Aw10kr95WwsxJ34fCFWxuFyU
	J34Utw1Svr15GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1g4SPUUUUU==
X-CM-SenderInfo: hzgkxlqw6rljoofrz/xtbBMQTD1mdvXwgF4wAAsZ

bio_alloc_bioset may return NULL, we need to judge it before
assign value to members of "new".

Signed-off-by: Chaohai Chen <wdhh66@163.com>
---
 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aebe12b0ee27..a23419ad3dd8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -585,6 +585,8 @@ bool md_flush_request(struct mddev *mddev, struct bio *bio)
 		new = bio_alloc_bioset(rdev->bdev, 0,
 				       REQ_OP_WRITE | REQ_PREFLUSH, GFP_NOIO,
 				       &mddev->bio_set);
+		if (!new)
+			continue;
 		new->bi_private = bio;
 		new->bi_end_io = md_end_flush;
 		bio_inc_remaining(bio);
-- 
2.34.1

