Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351631DE3B5;
	Wed,  3 Sep 2025 01:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756864245; cv=none; b=KuZQHF+7HgNXbGvIoOl/TezEOfZaeD+9wpWBfj5hsGft8ert1zMjcnokohmKy3IEDAlgGidma2Btz5A2KCSOrEoDOIyuErWSZpMxO3VophezgfSYCk6wfsdeST82LxTKqVllzuImoT5qWZYtBaxy8RzUAiQgI+iqZ0ENsfjFjIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756864245; c=relaxed/simple;
	bh=gZiiJH7bGejDNfXwhzC0duNXb0jV5sEDNANNbURvh6w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ROYCVBsSFwneu7xI55eOQ0ob1HOtzDiQ9UvElptxB7ljtxppA8Vnl4f45dkyPTsAG4URLvnREnoVvwDDxAG6CeScf/ZlNAXboUd+/v/QhJ/EWQ79ZFzHxZC22RdIF8Zcgr/eQwa6t9KJmJ3zVwhs27bjuwt9Dv/kHz0Upc7W4ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cGltn001lzKHMgn;
	Wed,  3 Sep 2025 09:50:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D92481A109E;
	Wed,  3 Sep 2025 09:50:40 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCX4o7tnrdozdjRBA--.43837S4;
	Wed, 03 Sep 2025 09:50:39 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	ian@beware.dropbear.id.au
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH] md/raid1: fix data lost for writemostly rdev
Date: Wed,  3 Sep 2025 09:41:40 +0800
Message-Id: <20250903014140.3690499-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCX4o7tnrdozdjRBA--.43837S4
X-Coremail-Antispam: 1UD129KBjvJXoWrKry8Kw4fXF48Cw17XF1DWrg_yoW8JrWrpa
	1kWryY9ry8Gry7CFyqyFZruFyrA3WUXryfurW3Z3yj9ry7XFy5W3yFgayFgrykZFWrCa4U
	Xr1qy34UXFW5Ja7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

If writemostly is enabled, alloc_behind_master_bio() will allocate a new
bio for rdev, with bi_opf set to 0. Later, raid1_write_request() will
clone from this bio, hence bi_opf is still 0 for the cloned bio. Submit
this cloned bio will end up to be read, causing write data lost.

Fix this problem by inheriting bi_opf from original bio for
behind_mast_bio.

Fixes: e879a0d9cb08 ("md/raid1,raid10: don't ignore IO flags")
Reported-and-tested-by: Ian Dall <ian@beware.dropbear.id.au>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220507
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f8434049f9b1..f391fd56d67f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1225,7 +1225,7 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
 	int i = 0;
 	struct bio *behind_bio = NULL;
 
-	behind_bio = bio_alloc_bioset(NULL, vcnt, 0, GFP_NOIO,
+	behind_bio = bio_alloc_bioset(NULL, vcnt, bio->bi_opf, GFP_NOIO,
 				      &r1_bio->mddev->bio_set);
 
 	/* discard op, we don't support writezero/writesame yet */
-- 
2.39.2

