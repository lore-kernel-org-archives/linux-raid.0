Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEE039B4B2
	for <linux-raid@vger.kernel.org>; Tue, 14 Apr 2026 10:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776163117; cv=none; b=pndv2I74nLnEvfbfwsmjNDOM9cJYV8HdZr3GN2HUciCtDjlztucQ/oUOAjkMWsmCaLbRvGRJ0Ja/AKZcNzh+pF4F+4UPW1EPWnx0k6ilf/w7tjPpkRiWlfCVpJo5G2wIW3u7F4SHo4Yj634y75F6qT47A9hiiQ3mLdUYA6QCMBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776163117; c=relaxed/simple;
	bh=FBG469TLXvpWlGEioFdFWVwzauHrAXQ8pqMZFjLRj78=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Bqj4HTysrC8Bq3fQlPlTw8TgMjNpwqJFz8ZKCyyLDRBIUxwJTy6ngjsO2AqAtZ4p0qdspquOQHJiLAX1pwE1AsaQX0PEqUK5xlrmoEoATMGWBmf5NMxsSUqTCI3FaSi49W0zNsV9ApxMoT1TcSzoIcim+fIWnhJMjw8PiDLRgrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r4R5/tqb; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r4R5/tqb"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43cfde3c3f3so5442453f8f.3
        for <linux-raid@vger.kernel.org>; Tue, 14 Apr 2026 03:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776163110; x=1776767910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/JQelBlxLiHpG/8eD2AusHYxLA7U3BNLmOfB4Xptskg=;
        b=r4R5/tqbejTg3pBZ7sxcS6Yt4kblfRnVj7+gxVP+HeMjKUOIRuN+bzHfzb/L3ySGuQ
         a1r+vRai/EyFnFhnBoAV9VdtsiRxKbFkUTtX7CRfV+aky5qFXrHW/lln8Qezdj6OhttR
         E88WFd6cCefMNFkoeQ4Pa2Afyn9rPIsNSUMbFFvvVBdSfhBa9AT2nclUbheYeJZn/4Lr
         tfy3sJBjl5TwGnhr3ja0kvXnLki9W2oRnOaigcma/R3d2qoTpWYSRwi+85uEZNAI3fn1
         t7tl6L5jwu6XHG6gwLYVg+zdSujcPFMQiC53oHTS1rBAAPY1Fnb/uJqZmJ2wQxD/gD6n
         D+SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776163110; x=1776767910;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/JQelBlxLiHpG/8eD2AusHYxLA7U3BNLmOfB4Xptskg=;
        b=mBY8G3QCVQm2TCVBEDrhmSog4spXgX3Vj7McHvZX/05DixeGQXmfS8WBNwRhPsTUdO
         zQoIUaZsZDt4ATqWolD/G96sfok/ozinoa3rfVpV6/h1zGMmLC0VCjteY/GRuzMsxhBq
         eBnB7Y6EeqD0/Sd0xShPJ0MgWKspyCnl0tCexLY0EhqoiRBLFYbfLcUJI7BOhH45maBQ
         YXyOXhbhR8239Fi/MOdHmATrFVCzUZZbBFHQ/2RsD1uKfUzzNx8pVm8KmidvWAZxDaPI
         0wQwPQj7MFHgGF1fMfc0yKmPzLN/yYSODf1KFBeEql5+El1pw9fAkqAot0BepTk2YQsp
         jnSQ==
X-Gm-Message-State: AOJu0YzofTGqDJvaKvgubf6Q7BmD4Inev1Z6z8bZoHhDENPkWzaOcIjs
	so53IcKKPNy03RzDttjGB5JKxAk/nuZMDTaZaaSitViRgVNRMLZiJrNtImjSFw==
X-Gm-Gg: AeBDietIBQvHffm+w4Q4cDMtr0RaI22Yj18JU5f4IT+MluxWgVwW87tichMwyp6luKS
	NGAxOGtGOb75SfEwXjAL67GY1Ns+9lq1bbyWTkhU72x6vy60rIS9deCLeT77WkqauAicmuTvBQQ
	t8bU6IKhfL7mkU30lTDCduQuI/MFjkfnOG2viArBwl6bimC0XL0HbTK4nTtIwXcImxztEIO7iMy
	x6CWTsrZ8/4AbVOdwhF4//mzxmD+4OehMpgOOGoGlUn7sJESNex0aqTSNqUR5OK1sXFTt0yM8/J
	dMv0gPyYvT88ImT9VVp14OhiGXyKnQkToflpiK4VRk5xRpH/Q37viMhbv21JG1GOQj0ZstkVDAH
	Z72GcD1gN1iaDencn0rZ74CL9w08tMjEehL/3/3STg8TCnLkQb33FcJcuUW5nxrH64eV2rMgBh2
	Nzlx7pDnd6Kgn0kl2yXTM1rNc=
X-Received: by 2002:a05:6000:1786:b0:43d:7722:ec05 with SMTP id ffacd0b85a97d-43d7722f1bdmr12815864f8f.8.1776163110093;
        Tue, 14 Apr 2026 03:38:30 -0700 (PDT)
Received: from yocto.. ([2a02:3037:60a:6445:7190:8290:c993:38ad])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63e5c981sm41725769f8f.33.2026.04.14.03.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 03:38:29 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH] md: factor out cloned bio cleanup into md_free_bio()
Date: Tue, 14 Apr 2026 12:38:13 +0200
Message-ID: <20260414103813.307601-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Refactor duplicated cloned bio completion and cleanup logic into
a new helper, md_free_bio().

md_end_clone_io() and md_free_cloned_bio() previously shared nearly
identical teardown code, differing only in whether the original
bio’s endio callback was invoked. Introduce a boolean parameter
orig_endio to control this behavior and consolidate the logic.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac71640ff3a8..707d605fee61 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9208,7 +9208,7 @@ static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
 	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
 }
 
-static void md_end_clone_io(struct bio *bio)
+static void md_free_bio(struct bio *bio, bool orig_endio)
 {
 	struct md_io_clone *md_io_clone = bio->bi_private;
 	struct bio *orig_bio = md_io_clone->orig_bio;
@@ -9224,10 +9224,16 @@ static void md_end_clone_io(struct bio *bio)
 		bio_end_io_acct(orig_bio, md_io_clone->start_time);
 
 	bio_put(bio);
-	bio_endio(orig_bio);
+	if (orig_endio)
+		bio_endio(orig_bio);
 	percpu_ref_put(&mddev->active_io);
 }
 
+static void md_end_clone_io(struct bio *bio)
+{
+	md_free_bio(bio, true);
+}
+
 static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 {
 	struct block_device *bdev = (*bio)->bi_bdev;
@@ -9262,21 +9268,7 @@ EXPORT_SYMBOL_GPL(md_account_bio);
 
 void md_free_cloned_bio(struct bio *bio)
 {
-	struct md_io_clone *md_io_clone = bio->bi_private;
-	struct bio *orig_bio = md_io_clone->orig_bio;
-	struct mddev *mddev = md_io_clone->mddev;
-
-	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
-		md_bitmap_end(mddev, md_io_clone);
-
-	if (bio->bi_status && !orig_bio->bi_status)
-		orig_bio->bi_status = bio->bi_status;
-
-	if (md_io_clone->start_time)
-		bio_end_io_acct(orig_bio, md_io_clone->start_time);
-
-	bio_put(bio);
-	percpu_ref_put(&mddev->active_io);
+	md_free_bio(bio, false);
 }
 EXPORT_SYMBOL_GPL(md_free_cloned_bio);
 
-- 
2.43.0

