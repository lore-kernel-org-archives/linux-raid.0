Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9805C7E792
	for <linux-raid@vger.kernel.org>; Fri, 29 May 2026 05:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780033400; cv=none; b=VuH15k5SNNEHxk34nb26nKSrGK+OWtecVmXGL+HJXCa3oG28AilDcmfYsSbWeziBeHx7GTznWgz1BylIop0K/y0W7Vr9zG6ndZYFojf0xhrjg4qKzO1rx+XK41giZXoIplO6Z3tJ05ETgpCJOH23+S8oFkKsOfmbtPbfNURZaSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780033400; c=relaxed/simple;
	bh=w21t7Vgv6a/EfzYwbdXNh42FT1m7LA/Z9uUyXTBuXlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1hk/IiFgkzDGxMXHYWeDdagljK/ZnNIPjQf6/cabhVg76h+JeBdib9qhXuur2Bbz1NQWtZvw2pwLTeGq8dPIq2iL+CMyscPEO6JtjEirQmep3qn9Jr2zP5IEYNBOMnEwfjcCWP8/Sz5UpTsO77/0C5ODCtmBrSL3jJuHg1hi0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JVMWl1Ro; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JVMWl1Ro"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jz1e4P85IX9e2QjclqPE6uQ5ed7SoSf8gVbLmG+vHB0=; b=JVMWl1Ro/U/Q1zMqsJQIQ8OiAF
	IAhDa33EZjC+uONt0ivwkBFHaz4ntbRZM2CaR6P7f/TL5PWhrxXMeQhtpM2LD+VNI0aVsbmEUtEKG
	Ly3ycaC7UuSLFSh/LA6uAon/3iaEVzjWYOsaApzqZsvZcdoytVmuFmZ/Nz0lCz4URTesL4LfXeAPC
	I+bQqKIaVnqoaeuXLTAKvxvv+SZoL5vKMzVNJo0X1268vHyKWmy5xHzTTO329s6C5hcp3dnlRYwRX
	Y0DMHjfo6usYk90smhHM7oPf1YSr+bx3y2fQjonNuMf2wdqNnCStkkFDYGeyauvIyPR1HDnslqipr
	GJ/HdOnQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSq06-00000006lua-3Nbp;
	Fri, 29 May 2026 05:43:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>
Cc: Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org
Subject: [PATCH 2/2] md/raid1: move the exceed_read_errors condition out of fix_read_error
Date: Fri, 29 May 2026 07:43:00 +0200
Message-ID: <20260529054308.2720300-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529054308.2720300-1-hch@lst.de>
References: <20260529054308.2720300-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This condition much better fits into the only caller, limiting
fix_read_error to actually fix up data devices after a read error.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid1.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8fad1692cf66..e510ad7eef32 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2411,11 +2411,6 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	struct mddev *mddev = conf->mddev;
 	struct md_rdev *rdev = conf->mirrors[read_disk].rdev;
 
-	if (exceed_read_errors(mddev, rdev)) {
-		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
-		return;
-	}
-
 	while(sectors) {
 		int s = sectors;
 		int d = read_disk;
@@ -2652,7 +2647,10 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 		md_error(mddev, rdev);
 	} else {
 		freeze_array(conf, 1);
-		fix_read_error(conf, r1_bio);
+		if (exceed_read_errors(mddev, rdev))
+			r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
+		else
+			fix_read_error(conf, r1_bio);
 		unfreeze_array(conf);
 	}
 
-- 
2.53.0

