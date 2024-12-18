Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0911B4234;
	Wed, 18 Dec 2024 12:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734524442; cv=none; b=m7FKQ27s4Acna1YDhJCwXdIvYKtG8XREHb+rH4nyXhG3vAKR47m2p/N0BoPEHJusxW25WT2JGjh/qXZAZDMCvsRwLycYfFx71wJYvqr6VVfZsikgnmqjqCSCpKI9tfHx0D6WKQLQ0GOnyQ/l674izOlu7UuEz19Bechp0EslL/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734524442; c=relaxed/simple;
	bh=/CRGbS3cTOaaJ24sDmm/wiZMOgwhBkQhh51M1O4Ofjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3OQlTM/vU8V2VFkb1YIt+zUv5HpE55Po6kCz9+nDcMPRbf/+scY7+soTyajJ90JgBQgpO9mkU84PyewtSuSBhR+cuiJHz09RUeFaG/PHaSWBg4n20WVxehsaTKeO1GIJqtZIdiFu7RDM7nQ/Qkp7sEJYQIXk4kwS/mx8QDyr5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SaOZGgaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SaOZGgaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62D9C4CED7;
	Wed, 18 Dec 2024 12:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734524441;
	bh=/CRGbS3cTOaaJ24sDmm/wiZMOgwhBkQhh51M1O4Ofjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SaOZGgaHnGuZIZziRENP8MulAMiTHnk2tj4+lafr/FP1ooptZFbfqXfnjQ65p7MjL
	 fD1/NhDzpdDBgn7ttRTej1wJs9TsJUMl8b9x4sXysKsgonG7jN6O2bUy5iTknwNV4R
	 z164AAOIK3se0JKWKbwmhJLzcTKMO2K6MqWo/Ib7nx9pTc+i2FPxSHfLXdbWLSCN6D
	 XwyMJXqgXB9E72utMfX6TXLJv78N5sJSmqpham8oQd5SXXg/ogAsPafzwQpnw1UePI
	 9xQyNnSu5Vepe4G5KPMNWIp7PzfdL6C4jdD7Q57oRI5QrYyDXTvfr8IlGsaqa5SkMd
	 sNcXWazio4lug==
From: yukuai@kernel.org
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@hauwei.com,
	yangerkun@huawei.com,
	Yu Kuai <yukuai@kernel.org>
Subject: [PATCH v2 md-6.14 4/5] md/raid5: implement pers->bitmap_sector()
Date: Wed, 18 Dec 2024 20:17:44 +0800
Message-ID: <20241218121745.2459-5-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241218121745.2459-1-yukuai@kernel.org>
References: <20241218121745.2459-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

Bitmap is used for the whole array for raid1/raid10, hence IO for the
array can be used directly for bitmap. However, bitmap is used for
underlying disks for raid5, hence IO for the array can't be used
directly for bitmap.

Implement pers->bitmap_sector() for raid5 to convert IO ranges from the
array to the underlying disks.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Yu Kuai <yukuai@kernel.org>
---
 drivers/md/raid5.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6eb2841ce28c..b2fe201b599d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2950,6 +2950,23 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 	r5c_update_on_rdev_error(mddev, rdev);
 }
 
+static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
+				unsigned long *sectors)
+{
+	struct r5conf *conf = mddev->private;
+	int sectors_per_chunk = conf->chunk_sectors * (conf->raid_disks -
+						       conf->max_degraded);
+	sector_t start = *offset;
+	sector_t end = start + *sectors;
+	int dd_idx;
+
+	start = round_down(start, sectors_per_chunk);
+	end = round_up(end, sectors_per_chunk);
+
+	*offset = raid5_compute_sector(conf, start, 0, &dd_idx, NULL);
+	*sectors = raid5_compute_sector(conf, end, 0, &dd_idx, NULL) - *offset;
+}
+
 /*
  * Input: a 'big' sector number,
  * Output: index of the data and parity disk, and the sector # in them.
@@ -8972,6 +8989,7 @@ static struct md_personality raid6_personality =
 	.takeover	= raid6_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
+	.bitmap_sector	= raid5_bitmap_sector,
 };
 static struct md_personality raid5_personality =
 {
@@ -8997,6 +9015,7 @@ static struct md_personality raid5_personality =
 	.takeover	= raid5_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
+	.bitmap_sector	= raid5_bitmap_sector,
 };
 
 static struct md_personality raid4_personality =
@@ -9023,6 +9042,7 @@ static struct md_personality raid4_personality =
 	.takeover	= raid4_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
+	.bitmap_sector	= raid5_bitmap_sector,
 };
 
 static int __init raid5_init(void)
-- 
2.43.0

