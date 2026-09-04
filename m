Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677EA3F39ED
	for <linux-raid@vger.kernel.org>; Fri,  4 Sep 2026 12:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788526113; cv=none; b=pGVDG31HomDjZOcrx2kBFTdENzg92qGvbX6YdUoIVdNUZlpWyZhoNr79m1W6zfCFxhZWs1duPIBHnTmdTJwFuLPM1IkdkeA6PXvFxl4qx/wnriAjB8QEjUaElWJYewwBcTMPe6yz+4WDNJ5T3dEGh/YDkYCAubiP/FRbAyFIIv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788526113; c=relaxed/simple;
	bh=g9LdAadAtJGK6RqR7HDIfb2VvRgfe6mcHH0mudZfMpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVta+/rky5Wm6odosSiYuisESd5Yor+d8wmAzexeGEPPqQGQM6G26uSxMuFzz/rTl3hyBBSfBYxRh+JW/rqNGdO1jlzuKQYr4rWP9VyFnL11v/4lsKcZE0+SJKBuMikftr4EAuaUljbJ0vm4qF/PkNHGAMA4zPS9oHa39IXFJiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rzo4ugzr; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rzo4ugzr"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7f4e729368fso899157a34.0
        for <linux-raid@vger.kernel.org>; Fri, 04 Sep 2026 05:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788526111; x=1789130911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TWn5zE/4ywVNMIe1WvKfWNKisJcFEJDCvB/UV2P/7NE=;
        b=rzo4ugzrFHswgSDR0U7nO7YzcAnzImSbccbCh4W3BQPrub87F0LKF5Nu7MCiCKtD6Y
         sWwYMWC8s9xhGJNw3UUg3qG2x/lbDqmbo3WtT1EqBp/BSOtNam6rxB8ld3JlL4e/TuV5
         qfEdyivIWZyb+4VAGusNJavIOPPl+yTtL9MUaQxFgxO2hIFw6CXIHJ1rAY7daYwZjSV4
         xWV7uC/NxmWHq+XitSgOuPexFiRwGeuB8Hg8SEJM8ei6jf+pKp32HFNagprqZNzr3q13
         aKBXM5er7zRltjK4Jo0ToX4dmPSh5jP691kEeAGykfxdqmB9xnI7jn345WB7V725MMbb
         s+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788526111; x=1789130911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TWn5zE/4ywVNMIe1WvKfWNKisJcFEJDCvB/UV2P/7NE=;
        b=ErY3fl7bL+VNKdWn2s8PDoYBqP8LX9sFU2sdyXBJYGVjLGlHadHe/K//kLpqZc2xc6
         e/RML1EKDaj+C4GjVuhBzYhVmJ9tgx55UL+RYovr5ONr2xPYuFQeJYLsFqyHJOpOrpmE
         zL6ZoxyK5bDoY8YmWkdglyi0RoALnnhlFEUezw1OVBndAF5A+lqFnJR9ZFoPS/cTjVUl
         lu+RHuBjXjDox6DftA8km4MVEtaX1Y6w22psJ8NRxBCXrL4WlOzF4C8+aLdrhUdnW5cE
         c9zlHGK0yZnP5H9GHXI08GFK9996mjeXq03XkChzmcCoJCXKPXknZduouwgozu2tfeek
         wA5w==
X-Forwarded-Encrypted: i=1; AKwUvBzFpzwI1Rv+ck0GPbQik+NyKPX4u06gb62hPuDjuVkOJLuKLWyPwS5EorP8dRLurAfrSR8G82x/4xFT@vger.kernel.org
X-Gm-Message-State: AFuF++kjFGeB/avxYXdzKB/3/Gcdr5mdUIsQYAgoX4FNMk1T4+jHJSRf
	NPskTqU5FuJi4HaBXCUHKMSKXSITwaWe4Alncao0yZTtWJgN8/rq061uYIac73DjirQ=
X-Gm-Gg: AYBFou1gT/X2QKxuvNqdasWFTko7bvaeItp0XOloi7N2mPfowArQoGWFnJg869f5oVP
	uaUR95gwx/pkhc49RGwqD11KKEZAnfVvFalyQoKncpt2z99TGZlu7vX1cRgjA9o648n4EV8DYOf
	cJFt7NovyKsU0oG7RiKn0MV+til4ZIs1oHohlDX1G+GxBOIAQTAW5BknMjX8gY+v9oRbJX0H4Fc
	unMvqrQyaSlq18tGj33u0bVs+RyQ0RtxWxER5A/GBOYqu2LqT6XENRs44RM/janyYH4Q9SXwtHN
	XXKtYoyBLeXWoxNnnKdjZFLs75u1IDDnfJI47LdZhaEHmDSOeEFvPHK786qnOKEofsIPKQcNb8+
	sDP+t2Yo2UY00oVr2VIbzHq3A4KNl5XnuHPwBzqw5SpnakUjyMYpSL5dHw1GQBTnH0M9LGhu30q
	978kChpJU5+KQqly6fZoAXKzatkzdwOj0eHy3bSdWYiYn29siSEq4j1MvV9zXeXzDFW3vdUkbma
	MwnElaHSFIpLlQ=
X-Received: by 2002:a05:6820:16a6:b0:6b7:8415:d779 with SMTP id 006d021491bc7-6b78415d96fmr1566458eaf.36.1788526111318;
        Fri, 04 Sep 2026 05:48:31 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339befe870sm7322412eec.30.2026.09.04.05.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:48:30 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 1/2] md: fix typos in comments
Date: Fri,  4 Sep 2026 18:18:21 +0530
Message-ID: <20260904124824.9585-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904124824.9585-1-hemanth.selam@gmail.com>
References: <20260904124824.9585-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/md/raid1-10.c | 2 +-
 drivers/md/raid10.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 3b0e230692ba..852346420848 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -87,7 +87,7 @@ static inline struct resync_pages *get_resync_pages(struct bio *bio)
 	return bio->bi_private;
 }
 
-/* generally called after bio_reset() for reseting bvec */
+/* generally called after bio_reset() for resetting bvec */
 static void md_bio_reset_resync_pages(struct bio *bio, struct resync_pages *rp,
 			       int size)
 {
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1093c798d9dd..2ac2dadda19a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1921,7 +1921,7 @@ static void raid10_status(struct seq_file *seq, struct mddev *mddev)
 }
 
 /* check if there are enough drives for
- * every block to appear on atleast one.
+ * every block to appear on at least one.
  * Don't consider the device numbered 'ignore'
  * as we might be about to remove it.
  */
-- 
2.48.1

